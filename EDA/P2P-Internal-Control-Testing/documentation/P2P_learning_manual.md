# Purchase-to-Pay (P2P) Cycle - Internal Controls Learning Manual

## Introduction
The Purchase-to-Pay cycle is a critical business process that encompasses all activities from requesting goods/services to making payment to vendors. Strong internal controls in this cycle prevent fraud, errors, and financial misstatements.

---

## The P2P Cycle - 7 Key Stages

### 1. Purchase Requisition
An internal request is raised by a department identifying a need for goods or services. This initiates the procurement process.

### 2. Purchase Order (PO) Creation
After approval, a formal PO is issued to the vendor specifying quantities, prices, terms, and delivery details. The PO represents a legal commitment.

### 3. Goods Receipt/Service Delivery
The organization receives the goods or services and verifies them against the PO specifications. A Goods Receipt Note (GRN) is generated.

### 4. Invoice Receipt
The vendor submits an invoice requesting payment. This document should match the PO and GRN details.

### 5. Three-Way Matching (Critical Control Point)
The system/auditor compares three documents:
- **Purchase Order** (what was ordered)
- **Goods Receipt Note** (what was received)
- **Vendor Invoice** (what is being billed)

All three must match in terms of quantities, prices, and terms before payment is authorized.

### 6. Payment Authorization
Once matching is confirmed, the payment is approved by an authorized individual who should be independent from those who created the PO or received the goods.

### 7. Payment Execution
The approved payment is processed through the banking system and recorded in the general ledger.

---

## Three-Way Matching: The Cornerstone of P2P Controls

### What is Three-Way Matching?

Three-Way Matching is an accounts payable control that verifies three critical documents align before authorizing payment:

**Document 1: Purchase Order (PO)**
- Expected quantity and price
- Authorized commitment to purchase

**Document 2: Goods Receipt Note (GRN)**
- Actual quantity received
- Confirmation of receipt quality

**Document 3: Vendor Invoice**
- Amount being claimed
- Payment terms

### Why It Matters

**Prevents Overpayment:** Ensures you only pay for what was actually received, not what was invoiced.

**Detects Fraud:** Identifies fictitious invoices where goods were never ordered or received.

**Ensures Accuracy:** Catches pricing errors, quantity discrepancies, and calculation mistakes.

**Compliance:** Demonstrates due diligence in financial controls for regulatory and audit purposes.

### Tolerance Levels

Organizations typically allow small variances (e.g., 5% or ₹1,000) to account for legitimate differences like shipping costs or rounding. Anything beyond tolerance requires investigation.

---

## Segregation of Duties (SOD): The Foundation of Fraud Prevention

### Core Principle

No single individual should have control over all phases of a transaction. By distributing responsibilities, organizations create natural checks and balances that deter and detect errors or fraud.

### Key SOD Requirements in P2P

**Separate Functions:**

1. **Requisitioning** ≠ **Purchasing** ≠ **Receiving** ≠ **Payment Authorization**

**Examples of Proper Segregation:**
- The person who requests goods should not approve the PO
- The person who approves the PO should not receive the goods
- The person who receives goods should not approve payment
- The person who approves payment should not execute payment

### Why SOD Matters in Audit

**Fraud Prevention:** Makes collusion necessary, significantly raising the barrier for fraudulent activities. A single person cannot create a fake vendor, order from them, approve payment, and pocket the money.

**Error Detection:** Multiple people reviewing transactions increases the likelihood of catching mistakes.

**Accountability:** Clear ownership of each process step enables better tracking when issues arise.

**Regulatory Compliance:** SOX Section 404, Companies Act 2013, and various industry regulations mandate proper SOD.

### Common SOD Violations to Flag

- Same person creating and approving POs above their authority level
- Payment approvers with vendor master data access
- Individual with both check signing and bank reconciliation duties
- Concentrated approval authority without compensating controls

---

## Key Internal Control Red Flags in P2P Testing

### 1. **Timing Anomalies**
- Invoices dated before PO dates (suggests PO created retroactively)
- Payments made before goods receipt
- Unusually fast processing (same-day PO to payment)

### 2. **Duplicate Transactions**
- Same invoice number paid multiple times
- Identical amounts to same vendor on same date
- Similar invoice numbers with slight variations (INV001, INV0001)

### 3. **Amount Discrepancies**
- Invoice amount exceeds PO amount beyond tolerance
- Round numbers (₹100,000 exactly) which are statistically rare
- Sequential invoice amounts (suggests fabrication)

### 4. **Vendor Issues**
- Payments to vendors not in the approved vendor master
- New vendors with immediate large transactions
- Vendor names similar to employees
- Multiple vendor addresses matching employee addresses

### 5. **Authorization Weaknesses**
- Approvals below required authority levels
- Missing approval signatures/digital approvals
- Approval after payment date

### 6. **Process Bypasses**
- Missing PO numbers (maverick spending)
- Emergency purchase justifications without follow-up
- Split purchases to avoid approval thresholds

---

## Audit Testing Procedures

### Substantive Testing
Test a sample of transactions for compliance with the three-way match and proper authorization.

### Control Testing
Evaluate the design and operating effectiveness of automated and manual controls within the P2P system.

### Data Analytics
Use data interrogation techniques (Excel, Python, ACL, IDEA) to identify anomalies across the entire population rather than just a sample.

### Risk-Based Approach
Focus testing on high-risk areas such as new vendors, large transactions, manual overrides, and rush orders.

---

## Recommended Control Framework

### Preventive Controls
- System-enforced three-way matching with defined tolerances
- Maker-checker workflows embedded in ERP
- Vendor master data change controls
- Mandatory PO for all purchases above threshold

### Detective Controls
- Exception reports for unmatched items
- Duplicate payment detection algorithms
- Periodic SOD violation reports
- Vendor statement reconciliation

### Compensating Controls
When ideal SOD cannot be achieved (small organizations), implement additional oversight such as:
- Management review of exception reports
- Periodic surprise audits
- Mandatory vacation policy for key personnel
- Increased transaction logging and monitoring

---

## Conclusion

Effective P2P internal controls protect organizational assets, ensure accurate financial reporting, and demonstrate governance maturity. As an auditor, your role is to understand the process, identify control weaknesses, test their effectiveness, and provide actionable recommendations for improvement.

**Key Takeaways:**
- Three-Way Matching prevents unauthorized payments
- Segregation of Duties prevents fraud and errors
- Data analytics enhance audit efficiency and coverage
- Risk-based testing focuses resources on high-impact areas

---

**References for Further Learning:**
- COSO Internal Control Framework
- COBIT 5 for Process Management
- IIA Practice Guides on IT Auditing
- Big 4 Audit Methodology Guides (available through firm portals)