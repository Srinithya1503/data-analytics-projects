# Purchase-to-Pay (P2P) Internal Control Testing Project

## 📋 Project Overview

This is a comprehensive, portfolio-ready internal audit project that demonstrates proficiency in:
- Data analytics for audit testing
- Risk assessment and business communication
- Python automation for continuous auditing

**Purpose:** Build hands-on experience in internal controls testing to support applications for Analyst positions.
---

## 🎯 Project Objectives

1. **Demonstrate Technical Competence:** Apply data analytics (Python) to automate audit testing procedures
2. **Showcase Business Acumen:** Understand Purchase-to-Pay business processes and inherent risks
3. **Exhibit Communication Skills:** Translate technical findings into executive-level recommendations
4. **Build Portfolio Evidence:** Create tangible work product that differentiates from other entry-level candidates

---

## 📁 Repository Structure

```
P2P-Internal-Control-Testing/
│
├── data/
│   ├── P2P_Transactions_Mock_Data.csv          # 50 mock transactions with embedded red flags
│   └── P2P_Audit_Exceptions.csv                # Output: Identified exceptions
│
├── scripts/
│   ├── generate_data.py                        # Data generation script with control failures
│   └── audit_testing.py                        # Automated exception testing script
│
├── documentation/
│   ├── P2P_Learning_Manual.md                  # Educational guide on P2P controls
│
│
└── README.md                                    # This file
```

---

## 🚀 Getting Started

### Prerequisites

- Python 3.8 or higher
- Required libraries: `pandas`, `numpy`

### Installation

```bash
# Clone or download this repository
cd P2P-Internal-Control-Testing

# Install required packages
pip install pandas numpy

# Verify installation
python --version
```

### Running the Project

**Step 1: Generate Mock Data**

```bash
python scripts/generate_data.py
```

This creates `P2P_Transactions_Mock_Data.csv` with 50 transactions including 7 intentionally embedded control failures.

**Step 2: Run Audit Tests**

```bash
python scripts/audit_testing.py
```

This executes 7 automated control tests and generates:
- Console output with test results
- `P2P_Audit_Exceptions.csv` with detailed exception listing

**Step 3: Review Findings**

Open the generated `P2P_Audit_Exceptions.csv` to see:
- Exception type and risk level
- Financial impact
- Root cause analysis
- Recommended controls

---

## 🧪 Testing Procedures Implemented

| Test ID | Test Name | Control Objective | Risk if Failed |
|---------|-----------|-------------------|----------------|
TEST_001	Duplicate Invoice Detection	4 duplicate invoice entries detected
TEST_002	Payment Before PO	1 exception
TEST_003	Invoice Before PO	1 exception
TEST_004	Three-Way Match Variance	5 exceptions (>5% tolerance)
TEST_005	Segregation of Duties	Approver concentration risk detected
TEST_006	Same-Day Processing	1 exception
TEST_007	Round Amount Analysis	PASS (within normal range)

---

## 📊 Key Project Outcomes

**Quantitative Results

50 transactions tested
Date range: 14-Jan-2024 to 12-Oct-2024
Total transaction value: ₹13,856,958.69
Total exceptions identified: 14
High-Risk exceptions: 10
Medium-Risk exceptions: 4
Total financial exposure: ₹7,370,186.48
Exposure as % of total value: 53.19%
Automation benefit: ~75% reduction in manual audit effort

### Qualitative Deliverables
- Automated Python testing suite reusable for continuous auditing
- Executive audit memo with risk-rated findings and recommendations
- Educational manual explaining P2P controls and audit concepts
- Interview preparation materials aligned with Big 4 expectations

---

## 🎓 Learning Outcomes

Through this project, I developed expertise in:

**Technical Skills:**
- Python programming for data analysis (pandas, datetime libraries)
- CSV data manipulation and exception detection algorithms
- Statistical analysis and pattern recognition
- Audit automation and continuous monitoring concepts

**Business Skills:**
- Purchase-to-Pay cycle understanding
- Three-way matching and segregation of duties principles
- Risk assessment frameworks (High/Medium/Low classification)
- COSO internal control framework application

**Professional Skills:**
- Executive communication and memo writing
- Root cause analysis and recommendation development
- Stakeholder management and persuasive documentation
- Translating technical findings into business language

---

## 🔍 Embedded Control Failures (Red Flags)

The mock dataset intentionally includes these exceptions for testing

1. **Duplicate Invoices** - Rows 6 & 7, Rows 33 & 34
2. **Payment Before PO Date** - Row 11
3. **Invoice Before PO Date** - Row 16
4. **Three way matching failure**: Rows 21, 26, 27, 28, 34
4. **Amount Exceeds PO Limit** - Row 21
5. **SOD Violation** - Rows 26-28
6. **Same-Day Processing** - Row 41

These simulate real-world control failures auditors encounter in practice.

---

## 📈 Future Enhancements

Potential expansions of this project:

- [ ] Integration with Tableau/Power BI for visual dashboards
- [ ] Machine learning models for predictive fraud detection
- [ ] Vendor risk scoring algorithms
- [ ] Blockchain-based three-way matching simulation
- [ ] Real-time alerting system for high-risk transactions
- [ ] Comparative analysis across multiple periods


---

## 📚 Additional Resources

**Documentation Included:**
- `P2P_Learning_Manual.md` - Comprehensive guide to P2P controls, three-way matching, and SOD
- `Audit_Memo_Template.md` - Professional audit deliverable with findings and recommendations


---

## 📄 License & Usage

This project was created for educational and portfolio purposes. The data is entirely fictional, and any resemblance to real vendors, transactions, or organizations is coincidental.

**Usage Rights:** Feel free to use this as a template for your own learning, but please credit the original creator and avoid direct plagiarism in portfolio submissions.

---

## ⭐ Acknowledgments

- **Inspiration:** Big 4 audit methodologies and internal control frameworks
- **Technical Resources:** Python documentation, pandas library, Stack Overflow community
- **Professional Guidance:** COSO framework, IIA standards, audit best practices

---

## 📞 Contact Information

**Project Creator:** Sri Nithya S  
**Background:** Aspiring Data Analyst  
**Email:** [venkatsri1503@gmail.com]    

---

**Last Updated:** January 2026  
**Version:** 1.0  
**Status:** Portfolio-Ready ✅