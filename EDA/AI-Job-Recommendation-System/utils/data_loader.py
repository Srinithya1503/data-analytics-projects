import pandas as pd

DATA_PATH = "data/ai_career_intelligence_dataset_clean.xlsx"

def load_skill_master():
    return pd.read_excel(DATA_PATH, sheet_name="skill_master")

def load_role_skill_mapping():
    return pd.read_excel(DATA_PATH, sheet_name="role_skill_mapping")

def load_salary():
    return pd.read_excel(DATA_PATH, sheet_name="role_salary_benchmarks")

def load_country_demand():
    return pd.read_excel(DATA_PATH, sheet_name="country_role_demand")