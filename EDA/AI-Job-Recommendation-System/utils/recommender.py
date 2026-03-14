import pandas as pd


def compute_role_scores(role_skill_df, user_skills):

    if len(user_skills) == 0:
        return pd.DataFrame()

    # normalize user skills
    user_skills = set(
        [s.lower().strip() for s in user_skills]
    )

    df = role_skill_df.copy()

    df["skill"] = (
        df["skill"]
        .astype(str)
        .str.lower()
        .str.strip()
    )

    # default importance weight
    if "importance" not in df.columns:
        df["importance"] = 1

    roles = df["job_title"].unique()

    results = []

    for role in roles:

        role_data = df[df["job_title"] == role]

        role_skills = set(role_data["skill"])

        if len(role_skills) == 0:
            continue

        total_weight = role_data["importance"].sum()

        matched_df = role_data[
            role_data["skill"].isin(user_skills)
        ]

        matched_weight = matched_df["importance"].sum()

        match_score = (matched_weight / total_weight) * 100

        matched_skill_list = matched_df["skill"].tolist()

        results.append(
            {
                "job_title": role,
                "match_score": round(match_score, 2),
                "matched_skills": len(matched_skill_list),
                "total_skills": len(role_skills),
                "matched_skill_list": matched_skill_list
            }
        )

    return pd.DataFrame(results)