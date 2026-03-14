import streamlit as st
import pandas as pd

from utils.data_loader import (
    load_skill_master,
    load_role_skill_mapping,
    load_salary,
    load_country_demand
)

from utils.recommender import compute_role_scores
from utils.skill_gap import compute_skill_gap


# --------------------------------------------------
# PAGE CONFIG
# --------------------------------------------------

st.set_page_config(
    page_title="AI Career Navigator",
    layout="wide"
)

st.title("🚀 AI Career Navigator")


# --------------------------------------------------
# LOAD DATA
# --------------------------------------------------

skills_df = load_skill_master()
role_skill_df = load_role_skill_mapping()
salary_df = load_salary()
country_df = load_country_demand()

skills_df["skill"] = skills_df["skill"].astype(str).str.strip()
role_skill_df["skill"] = role_skill_df["skill"].astype(str).str.strip()

salary_df = salary_df.groupby(
    "job_title",
    as_index=False
)["salary_median"].mean()


# --------------------------------------------------
# SESSION STATE INITIALIZATION
# --------------------------------------------------

if "user_skills" not in st.session_state:
    st.session_state.user_skills = []

if "career_goal" not in st.session_state:
    st.session_state.career_goal = None

if "recommended_roles" not in st.session_state:
    st.session_state.recommended_roles = None

if "skill_widget_state" not in st.session_state:
    st.session_state.skill_widget_state = []


# --------------------------------------------------
# FIX: KEEP WIDGET + STORED SKILLS IN SYNC
# --------------------------------------------------

if (
    len(st.session_state.user_skills) > 0
    and len(st.session_state.skill_widget_state) == 0
):
    st.session_state.skill_widget_state = (
        st.session_state.user_skills.copy()
    )


# --------------------------------------------------
# SIDEBAR
# --------------------------------------------------

st.sidebar.title("Navigation")

page = st.sidebar.radio(
    "Modules",
    [
        "Role Recommendation",
        "Skill Gap Analyzer",
        "Career Readiness Score"
    ]
)

countries = sorted(country_df["country"].unique())

selected_country = st.sidebar.selectbox(
    "Country",
    countries
)

st.sidebar.divider()

st.sidebar.subheader("🎯 Career Goal")

if st.session_state.career_goal:
    st.sidebar.success(st.session_state.career_goal)
else:
    st.sidebar.info("Not selected")


# ==================================================
# MODULE 1 — ROLE RECOMMENDATION
# ==================================================

if page == "Role Recommendation":

    st.header("Find Your AI Career")

    skill_options = sorted(skills_df["skill"].unique())

    st.multiselect(
        "Select your skills",
        skill_options,
        key="skill_widget_state"
    )

    if st.session_state.user_skills:

        st.info(
            "Stored Skills: "
            + ", ".join(st.session_state.user_skills)
        )

    col1, col2 = st.columns(2)

    with col1:

        if st.button("Recommend Roles"):

            selected = st.session_state.skill_widget_state

            if len(selected) == 0:
                st.warning("Please select skills first.")
                st.stop()

            # STORE SKILLS PERMANENTLY
            st.session_state.user_skills = selected.copy()

            scores = compute_role_scores(
                role_skill_df,
                st.session_state.user_skills
            )

            results = scores.merge(
                salary_df,
                on="job_title",
                how="left"
            )

            results = results.merge(
                country_df,
                on="job_title",
                how="left"
            )

            results = results[
                results["country"] == selected_country
            ]

            results = results.drop_duplicates("job_title")

            top_roles = results.sort_values(
                "match_score",
                ascending=False
            ).head(6)

            st.session_state.recommended_roles = top_roles


    with col2:

        if st.button("Reset Skills"):

            st.session_state.user_skills = []
            st.session_state.skill_widget_state = []
            st.session_state.career_goal = None
            st.session_state.recommended_roles = None

            st.rerun()


    # DISPLAY ROLE CARDS

    if st.session_state.recommended_roles is not None:

        st.subheader("Top Career Matches")

        cols = st.columns(3)

        for i, row in enumerate(
            st.session_state.recommended_roles.itertuples()
        ):

            with cols[i % 3]:

                st.markdown(f"### {row.job_title}")

                st.progress(row.match_score / 100)

                st.metric(
                    "Skill Match",
                    f"{row.match_score:.0f}%"
                )

                st.metric(
                    "Matched Skills",
                    f"{row.matched_skills}/{row.total_skills}"
                )

                if not pd.isna(row.salary_median):

                    st.metric(
                        "Median Salary",
                        f"${int(row.salary_median):,}"
                    )

                matched = getattr(
                    row,
                    "matched_skill_list",
                    []
                )

                if matched:

                    st.caption(
                        "Matched Skills: "
                        + ", ".join(matched)
                    )

                if st.button(
                    "Set Career Goal",
                    key=row.job_title
                ):

                    st.session_state.career_goal = row.job_title
                    st.rerun()


# ==================================================
# MODULE 2 — SKILL GAP ANALYZER
# ==================================================

elif page == "Skill Gap Analyzer":

    st.header("Skill Gap Analyzer")

    if not st.session_state.career_goal:

        st.warning("Please select a career goal first.")
        st.stop()

    role = st.session_state.career_goal

    st.success(f"Target Role: {role}")

    st.subheader("Your Skills")

    if len(st.session_state.user_skills) == 0:

        st.warning("No stored skills found.")

    else:

        st.write(", ".join(st.session_state.user_skills))

    missing = compute_skill_gap(
        role_skill_df,
        role,
        st.session_state.user_skills
    )

    if len(missing) == 0:

        st.success("You already have all required skills!")

    else:

        st.info(
            f"You are **{len(missing)} skills away** from becoming **{role}**"
        )

        cols = st.columns(3)

        for i, skill in enumerate(missing):

            with cols[i % 3]:

                st.warning(skill.title())


# ==================================================
# MODULE 3 — CAREER READINESS
# ==================================================

elif page == "Career Readiness Score":

    st.header("Career Readiness Score")

    if not st.session_state.career_goal:

        st.warning("Select a career goal first.")
        st.stop()

    if len(st.session_state.user_skills) == 0:

        st.warning("No stored skills found. Go to Role Recommendation.")
        st.stop()

    role = st.session_state.career_goal

    scores = compute_role_scores(
        role_skill_df,
        st.session_state.user_skills
    )

    role_score = scores[
        scores["job_title"] == role
    ]

    if role_score.empty:

        st.warning("Score unavailable. Recompute recommendations.")
        st.stop()

    skill_match = float(role_score.iloc[0]["match_score"])

    st.metric(
        "Skill Match",
        f"{skill_match:.0f}%"
    )

    st.progress(skill_match / 100)

    missing = compute_skill_gap(
        role_skill_df,
        role,
        st.session_state.user_skills
    )

    st.info(
        f"You are **{len(missing)} skills away** from {role}"
    )