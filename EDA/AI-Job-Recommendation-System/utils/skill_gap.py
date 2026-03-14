def compute_skill_gap(role_skill_df, role, user_skills):

    user_skills = set(
        [s.lower().strip() for s in user_skills]
    )

    role_data = role_skill_df[
        role_skill_df["job_title"] == role
    ]

    role_skills = set(
        role_data["skill"]
        .astype(str)
        .str.lower()
        .str.strip()
    )

    missing = role_skills - user_skills

    return sorted(list(missing))