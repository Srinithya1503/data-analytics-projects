import pandas as pd
import numpy as np
from datetime import datetime
import warnings
warnings.filterwarnings('ignore')

# Load the P2P transaction data
# Make sure the CSV file is in the same directory
df = pd.read_csv('P2P_Transactions_Mock_Data.csv')

# Convert date columns to datetime
df['PO_Date'] = pd.to_datetime(df['PO_Date'])
df['Invoice_Date'] = pd.to_datetime(df['Invoice_Date'])
df['Payment_Date'] = pd.to_datetime(df['Payment_Date'])

print("="*80)
print("PURCHASE-TO-PAY INTERNAL CONTROL TESTING SCRIPT")
print("="*80)
print(f"\nTotal Transactions Loaded: {len(df)}")
print(f"Date Range: {df['PO_Date'].min().date()} to {df['PO_Date'].max().date()}")
print(f"Total Value: ₹{df['Amount'].sum():,.2f}")
print("\n" + "="*80)

# Initialize exceptions list
exceptions = []

# TEST 1: Duplicate Invoice Detection
print("\n[TEST 1] DUPLICATE INVOICE DETECTION")
print("-" * 80)
duplicate_invoices = df[df.duplicated(subset=['Invoice_Number'], keep=False)].sort_values('Invoice_Number')

if len(duplicate_invoices) > 0:
    print(f"⚠️  EXCEPTION FOUND: {len(duplicate_invoices)} duplicate invoice entries detected")
    print("\nDetails:")
    print(duplicate_invoices[['PO_Number', 'Invoice_Number', 'Vendor_Name', 'Amount', 'Payment_Date']].to_string(index=False))
    
    for idx, row in duplicate_invoices.iterrows():
        exceptions.append({
            'Test_ID': 'TEST_001',
            'Test_Name': 'Duplicate Invoice',
            'Exception_Type': 'Duplicate Transaction',
            'PO_Number': row['PO_Number'],
            'Invoice_Number': row['Invoice_Number'],
            'Risk_Level': 'HIGH',
            'Details': f"Invoice {row['Invoice_Number']} appears multiple times",
            'Amount_Impact': row['Amount']
        })
else:
    print("✓ PASS: No duplicate invoices found")

# TEST 2: Payment Before PO Date
print("\n[TEST 2] PAYMENT TIMING VALIDATION - Payment Before PO")
print("-" * 80)
payment_before_po = df[df['Payment_Date'] < df['PO_Date']]

if len(payment_before_po) > 0:
    print(f"⚠️  EXCEPTION FOUND: {len(payment_before_po)} payment(s) made before PO date")
    print("\nDetails:")
    print(payment_before_po[['PO_Number', 'PO_Date', 'Payment_Date', 'Amount', 'Vendor_Name']].to_string(index=False))
    
    for idx, row in payment_before_po.iterrows():
        days_diff = (row['PO_Date'] - row['Payment_Date']).days
        exceptions.append({
            'Test_ID': 'TEST_002',
            'Test_Name': 'Payment Timing',
            'Exception_Type': 'Payment Before PO',
            'PO_Number': row['PO_Number'],
            'Invoice_Number': row['Invoice_Number'],
            'Risk_Level': 'HIGH',
            'Details': f"Payment made {days_diff} days before PO date",
            'Amount_Impact': row['Amount']
        })
else:
    print("✓ PASS: All payments made after PO dates")

# TEST 3: Invoice Before PO Date
print("\n[TEST 3] INVOICE TIMING VALIDATION - Invoice Before PO")
print("-" * 80)
invoice_before_po = df[df['Invoice_Date'] < df['PO_Date']]

if len(invoice_before_po) > 0:
    print(f"⚠️  EXCEPTION FOUND: {len(invoice_before_po)} invoice(s) dated before PO date")
    print("\nDetails:")
    print(invoice_before_po[['PO_Number', 'PO_Date', 'Invoice_Date', 'Amount', 'Vendor_Name']].to_string(index=False))
    
    for idx, row in invoice_before_po.iterrows():
        days_diff = (row['PO_Date'] - row['Invoice_Date']).days
        exceptions.append({
            'Test_ID': 'TEST_003',
            'Test_Name': 'Invoice Timing',
            'Exception_Type': 'Invoice Before PO',
            'PO_Number': row['PO_Number'],
            'Invoice_Number': row['Invoice_Number'],
            'Risk_Level': 'MEDIUM',
            'Details': f"Invoice dated {days_diff} days before PO",
            'Amount_Impact': row['Amount']
        })
else:
    print("✓ PASS: All invoices dated after PO dates")

# TEST 4: Amount Exceeds PO Limit (Three-Way Match Failure)
print("\n[TEST 4] THREE-WAY MATCH - Amount Variance Check")
print("-" * 80)
TOLERANCE_PERCENT = 5  # 5% tolerance

df['Variance_Percent'] = ((df['Amount'] - df['PO_Amount_Limit']) / df['PO_Amount_Limit'] * 100).abs()
amount_exceeds = df[df['Amount'] > (df['PO_Amount_Limit'] * (1 + TOLERANCE_PERCENT/100))]

if len(amount_exceeds) > 0:
    print(f"⚠️  EXCEPTION FOUND: {len(amount_exceeds)} transaction(s) exceed PO limit (>{TOLERANCE_PERCENT}% tolerance)")
    print("\nDetails:")
    print(amount_exceeds[['PO_Number', 'Amount', 'PO_Amount_Limit', 'Variance_Percent', 'Vendor_Name']].to_string(index=False))
    
    for idx, row in amount_exceeds.iterrows():
        variance = row['Amount'] - row['PO_Amount_Limit']
        exceptions.append({
            'Test_ID': 'TEST_004',
            'Test_Name': 'Three-Way Match',
            'Exception_Type': 'Amount Exceeds PO Limit',
            'PO_Number': row['PO_Number'],
            'Invoice_Number': row['Invoice_Number'],
            'Risk_Level': 'HIGH',
            'Details': f"Amount exceeds PO limit by ₹{variance:,.2f} ({row['Variance_Percent']:.1f}%)",
            'Amount_Impact': variance
        })
else:
    print(f"✓ PASS: All amounts within {TOLERANCE_PERCENT}% tolerance of PO limits")

# TEST 5: Segregation of Duties - Same Approver Pattern
print("\n[TEST 5] SEGREGATION OF DUTIES - Approver Concentration Analysis")
print("-" * 80)
HIGH_AMOUNT_THRESHOLD = 400000
approver_analysis = df[df['Amount'] >= HIGH_AMOUNT_THRESHOLD].groupby('Approver_ID').agg({
    'PO_Number': 'count',
    'Amount': 'sum'
}).rename(columns={'PO_Number': 'Transaction_Count', 'Amount': 'Total_Amount'})

approver_analysis = approver_analysis[approver_analysis['Transaction_Count'] >= 3]

if len(approver_analysis) > 0:
    print(f"⚠️  EXCEPTION FOUND: Approver concentration risk detected")
    print(f"\nApprovers with 3+ high-value transactions (>₹{HIGH_AMOUNT_THRESHOLD:,}):")
    print(approver_analysis.to_string())
    
    for approver_id in approver_analysis.index:
        sod_violations = df[(df['Approver_ID'] == approver_id) & (df['Amount'] >= HIGH_AMOUNT_THRESHOLD)]
        
        exceptions.append({
            'Test_ID': 'TEST_005',
            'Test_Name': 'Segregation of Duties',
            'Exception_Type': 'Approver Concentration',
            'PO_Number': f"Multiple POs by {approver_id}",
            'Invoice_Number': 'N/A',
            'Risk_Level': 'MEDIUM',
            'Details': f"Approver {approver_id} approved {len(sod_violations)} high-value transactions totaling ₹{sod_violations['Amount'].sum():,.2f}",
            'Amount_Impact': sod_violations['Amount'].sum()
        })
else:
    print(f"✓ PASS: No concerning approver concentration patterns")

# TEST 6: Same-Day Processing (PO to Payment)
print("\n[TEST 6] PROCESS TIMELINE - Same-Day PO to Payment")
print("-" * 80)
same_day_processing = df[df['PO_Date'] == df['Payment_Date']]

if len(same_day_processing) > 0:
    print(f"⚠️  EXCEPTION FOUND: {len(same_day_processing)} transaction(s) with same-day PO and payment")
    print("\nDetails:")
    print(same_day_processing[['PO_Number', 'PO_Date', 'Payment_Date', 'Amount', 'Vendor_Name']].to_string(index=False))
    
    for idx, row in same_day_processing.iterrows():
        exceptions.append({
            'Test_ID': 'TEST_006',
            'Test_Name': 'Process Timeline',
            'Exception_Type': 'Same-Day Processing',
            'PO_Number': row['PO_Number'],
            'Invoice_Number': row['Invoice_Number'],
            'Risk_Level': 'MEDIUM',
            'Details': 'PO and payment occurred on same day - insufficient review time',
            'Amount_Impact': row['Amount']
        })
else:
    print("✓ PASS: Adequate processing time between PO and payment")

# TEST 7: Round Amount Analysis (Potential Fabrication)
print("\n[TEST 7] STATISTICAL ANALYSIS - Round Amount Detection")
print("-" * 80)
# Check for amounts that are exact multiples of 10,000
round_amounts = df[df['Amount'] % 10000 == 0]

if len(round_amounts) > 5:  # More than 5 is suspicious
    print(f"⚠️  CAUTION: {len(round_amounts)} transactions with round amounts (multiples of ₹10,000)")
    print("This pattern may warrant further investigation")
    print("\nSample:")
    print(round_amounts[['PO_Number', 'Amount', 'Vendor_Name']].head().to_string(index=False))
else:
    print(f"✓ PASS: Round amount frequency ({len(round_amounts)}) is within normal range")

# SUMMARY REPORT
print("\n" + "="*80)
print("AUDIT TESTING SUMMARY")
print("="*80)

if len(exceptions) > 0:
    exceptions_df = pd.DataFrame(exceptions)
    
    # Risk Level Summary
    print("\nException Summary by Risk Level:")
    risk_summary = exceptions_df.groupby('Risk_Level').agg({
        'Test_ID': 'count',
        'Amount_Impact': 'sum'
    }).rename(columns={'Test_ID': 'Count'})
    print(risk_summary.to_string())
    
    # Total Financial Impact
    total_impact = exceptions_df['Amount_Impact'].sum()
    print(f"\nTotal Financial Impact of Exceptions: ₹{total_impact:,.2f}")
    print(f"Percentage of Total Transaction Value: {(total_impact/df['Amount'].sum())*100:.2f}%")
    
    # Export exceptions to CSV
    exceptions_df.to_csv('P2P_Audit_Exceptions.csv', index=False)
    print("\n✓ Detailed exceptions exported to: P2P_Audit_Exceptions.csv")
    
    # High Risk Alert
    high_risk = exceptions_df[exceptions_df['Risk_Level'] == 'HIGH']
    if len(high_risk) > 0:
        print(f"\n⚠️  CRITICAL: {len(high_risk)} HIGH RISK exceptions require immediate management attention")
else:
    print("\n✓ No exceptions found - Controls appear to be operating effectively")

print("\n" + "="*80)
print("TESTING COMPLETED")
print("="*80)