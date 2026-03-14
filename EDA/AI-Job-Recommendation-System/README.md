# AI Career Navigator

### Data-Driven Career Intelligence for the AI Job Market (2025–2026)

This project builds a **complete data analytics pipeline and interactive career intelligence application** for the Artificial Intelligence job market.

It combines:

* Exploratory Data Analysis (EDA)
* Data engineering to create a **structured career intelligence dataset**
* A **Streamlit web application** that helps users analyze their career readiness and skill gaps.

The project transforms **raw job market data into an actionable career decision tool**.

---

# Project Objectives

The AI job market is evolving rapidly, with new roles, skills, and salary structures emerging every year. Many professionals struggle with questions such as:

* Which AI roles match my current skills?
* What skills am I missing?
* How prepared am I for a specific AI career path?

This project solves these problems by building a **career analytics system powered by job market data**.

The system enables users to:

1. Discover suitable AI roles based on their skills
2. Identify missing skills required for those roles
3. Measure their readiness for entering the role
4. Understand the skill requirements in the AI job market

---

# Project Architecture

The project consists of three main stages.

```
Raw Dataset (Kaggle)
        │
        ▼
Exploratory Data Analysis
        │
        ▼
Processed Career Intelligence Dataset
        │
        ▼
Streamlit AI Career Navigator Application
```

Each stage plays a critical role in transforming raw job postings into **actionable career insights**.

---

# Dataset

Source dataset:

AI Jobs Market Dataset (2025–2026)

Dataset properties:

| Property         | Value                         |
| ---------------- | ----------------------------- |
| Source           | Kaggle AI Jobs Market dataset |
| Records          | 1,500 job postings            |
| Countries        | 14                            |
| AI roles         | 25                            |
| Raw columns      | 25                            |
| Extracted skills | 93 unique skills              |

The dataset contains information on:

* job titles
* salaries
* industries
* locations
* company size
* required skills
* experience levels
* education requirements

---

# Exploratory Data Analysis (EDA)

The first stage of the project involved performing extensive EDA to understand the AI job market.

---

# 1 Salary Distribution Analysis

The salary distribution reveals the overall compensation structure for AI professionals.

### Key Insights

**$200K Salary Sweet Spot**

The largest group of professionals falls into the **$200K–$300K salary tier**.
This tier represents experienced AI engineers and senior data scientists.

Median salary across the dataset is approximately **$180,000**.

---

**Elite Salary Tier**

Approximately **9% of professionals earn more than $300K**.

These high-paying roles include:

* AI Solutions Architect
* LLM Engineer
* Senior ML Engineers
* AI Research Scientists

These roles typically require advanced technical expertise.

---

# 2 Salary vs Experience

Salary growth is not strictly tied to years of experience.

### Key Observations

The largest salary jump occurs when moving from:

Senior (6–9 years) → Lead (10+ years)

Median salary increases from roughly:

$210K → $240K

However, correlation between salary and years of experience is relatively weak.

Some professionals with **2–3 years experience earn more than $300K** when working on high-value technologies like:

* Large Language Models
* AI infrastructure
* distributed systems

---

# 3 Highest Paying AI Roles

Top paying roles include:

| Role                   | Avg Salary |
| ---------------------- | ---------- |
| AI Solutions Architect | $251K      |
| LLM Engineer           | $240K      |
| AI Research Scientist  | $231K      |
| MLOps Engineer         | $222K      |

These roles command higher salaries because they involve **system-level AI architecture or infrastructure development**.

---

# 4 AI Job Category Demand

AI Engineering dominates the job market.

| Category        | Job Postings |
| --------------- | ------------ |
| AI Engineering  | 736          |
| AI Research     | 212          |
| AI Architecture | 52           |

AI Architecture roles have the **highest salaries but lowest job availability**, making them highly specialized.

---

# 5 LLM vs Non-LLM Roles

Large Language Model roles command a salary premium.

Median salary:

| Role Type     | Median Salary |
| ------------- | ------------- |
| LLM Roles     | $192K         |
| Non-LLM Roles | $181K         |

Average premium: **10.9%**

Expert LLM engineers may earn **15–18% higher salaries**.

---

# 6 Geographic Salary Differences

Top paying countries:

* UAE
* Switzerland
* United States

Cities with highest salaries:

* New York
* San Francisco
* Zurich
* Dubai

Remote jobs ranked **4th globally in salary levels**, highlighting the increasing normalization of remote AI work.

---

# 7 Industry Salary Comparison

Highest paying industries:

* Automotive
* Consulting
* Finance
* Healthcare

Automotive leads due to heavy investment in:

* Autonomous vehicles
* robotics
* embedded AI systems

---

# 8 Fastest Growing AI Roles

Roles with highest demand growth:

* RAG Engineer
* NLP Engineer
* MLOps Engineer

These roles reflect the **industry shift toward production AI systems and generative AI infrastructure**.

---

# 9 Skill Demand Analysis

Top high-value skills include:

* Fine-tuning LLMs
* Distributed systems
* MLOps
* PyTorch

Generative AI skills consistently show **higher salary floors**.

---

# 10 Education vs Salary

Education still influences salary levels.

| Education  | Median Salary |
| ---------- | ------------- |
| PhD        | $200K+        |
| Master's   | $195K         |
| Bachelor's | $175K         |

However, many self-taught professionals still reach salaries above $300K.

This confirms that **skills outweigh degrees at senior levels**.

---

# Processed Career Intelligence Dataset

After completing the EDA, the raw dataset was transformed into a **structured data library used by the application**.

The final dataset is stored as:

```
ai_career_intelligence_dataset.xlsx
```

It contains **14 structured sheets**.

---

# Dataset Sheets

| Sheet                      | Purpose                              |
| -------------------------- | ------------------------------------ |
| Overview                   | Documentation and navigation         |
| skill_master               | Master list of 93 skills             |
| role_skill_mapping         | Skills required per role             |
| experience_skill_mapping   | Skills required per experience level |
| llm_vs_nonllm_skills       | Skill prevalence in LLM roles        |
| skill_demand               | Skill frequency and demand score     |
| industry_skill_demand      | Skills across industries             |
| career_transition_paths    | Skill roadmaps between roles         |
| role_salary_benchmarks     | Salary distribution per role         |
| skill_salary_impact        | Salary premium for specific skills   |
| country_role_demand        | Salary by country                    |
| skill_co_occurrence        | Skill relationships                  |
| emerging_skills_radar      | Skill growth trends                  |
| company_profile_benchmarks | Salary by company size               |

This dataset acts as the **data backend for the AI Career Navigator application**.

---

# Dataset Creation Tools

Two approaches were used to build the dataset.

### Excel Approach

Used to prototype and validate calculations.

Features used:

* Pivot tables
* Power Query
* Excel formulas
* manual skill mapping

---

### Python Automation

Dataset was then automated using:

* pandas
* openpyxl

Benefits:

* reproducibility
* scalability
* automated dataset generation

---

# AI Career Navigator Application

The final stage of the project is a **Streamlit web application** that uses the processed dataset to provide career insights.

The application acts as a **personalized AI career advisor**.

---

# Application Modules

The application contains three main modules.

---

# 1 Role Recommendation Engine

Users input their current skills.

The system compares them with role skill requirements and recommends the most suitable AI roles.

Matching is calculated using **skill overlap scoring**.

Output includes:

* recommended roles
* match percentage
* missing skills

---

# 2 Skill Gap Analyzer

This module identifies the **skills required for the selected role that the user does not currently possess**.

It helps users plan:

* learning paths
* skill upgrades
* certification goals

---

# 3 Career Readiness Score

This module calculates a **career readiness score** based on:

* matched skills
* missing skills
* demand weight of each skill

The result gives a quantitative estimate of how prepared the user is for the role.

---

# Application Technology Stack

| Layer           | Technology |
| --------------- | ---------- |
| UI              | Streamlit  |
| Data Processing | Pandas     |
| Visualization   | Plotly     |
| Dataset         | Excel      |
| Language        | Python     |

---

# Project Folder Structure

```
ai_job_market_predictor
│
├── app.py
├── EDA.ipynb
│
├── data
│   ├── ai_jobs_market_2025_2026.csv
│   └── ai_career_intelligence_dataset.xlsx
│
├── utils
│   ├── data_loader.py
│   ├── recommender.py
│   └── skill_gap.py
│
└── README.md
```

---

# Key Features of the App

* Role recommendation based on user skills
* Skill gap detection
* Career readiness scoring
* Interactive UI using Streamlit
* Data-driven insights from real job market data

---

# Example Use Case

A user enters the following skills:

```
Python
Machine Learning
TensorFlow
SQL
```

The application may recommend roles such as:

* Machine Learning Engineer
* AI Engineer
* NLP Engineer

It will then highlight missing skills such as:

* MLOps
* Distributed systems
* LLM fine-tuning

---

# Future Improvements

This project is designed to evolve into a **complete AI career intelligence platform**.

Planned improvements include:

---

### Learning Resource Library

A curated database of:

* courses
* certifications
* tutorials

mapped to each missing skill.

---

### Career Path Visualizer

Interactive roadmap showing:

```
Current Role → Target Role → Required Skills
```

---

### AI Career Chatbot

A chatbot that can answer career questions such as:

* What skills should I learn for AI engineering?
* How long does it take to become an ML engineer?
* Which roles pay the most?

---

### Salary Prediction Model

Machine learning model to predict salary based on:

* skills
* experience
* location
* role

---

### Real-Time Job Market Integration

Integrate APIs from:

* LinkedIn
* Indeed
* Glassdoor

to track live demand for skills.

---

# Conclusion

The **AI Career Navigator** project transforms raw AI job market data into a **career intelligence platform**.

It provides professionals with a structured way to:

* identify suitable AI roles
* understand skill requirements
* plan career growth

The project showcases how **data analytics can directly power career decision tools**.



