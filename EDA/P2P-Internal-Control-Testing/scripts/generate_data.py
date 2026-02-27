import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import random

# Set seed for reproducibility
np.random.seed(42)
random.seed(42)

# Generate base data
vendors = ['Tech Solutions Pvt Ltd', 'Office Supplies Corp', 'Infrastructure Ltd', 
           'Consulting Services Inc', 'Hardware Vendors Ltd', 'Software Systems',
           'Maintenance Services', 'Logistics Partners', 'Security Solutions']

approvers = ['APP001', 'APP002', 'APP003', 'APP004', 'APP005']

transactions = []
base_date = datetime(2024, 1, 1)

for i in range(50):
    po_number = f'PO2024{str(i+1).zfill(4)}'
    po_date = base_date + timedelta(days=random.randint(0, 300))
    
    # Normal invoice date (after PO)
    invoice_date = po_date + timedelta(days=random.randint(1, 30))
    
    # Normal payment date (after invoice)
    payment_date = invoice_date + timedelta(days=random.randint(5, 45))
    
    amount = round(random.uniform(5000, 500000), 2)
    vendor = random.choice(vendors)
    approver = random.choice(approvers)
    invoice_number = f'INV{str(random.randint(10000, 99999))}'
    
    transactions.append({
        'PO_Number': po_number,
        'PO_Date': po_date.strftime('%Y-%m-%d'),
        'Invoice_Number': invoice_number,
        'Invoice_Date': invoice_date.strftime('%Y-%m-%d'),
        'Payment_Date': payment_date.strftime('%Y-%m-%d'),
        'Amount': amount,
        'Vendor_Name': vendor,
        'Approver_ID': approver,
        'PO_Amount_Limit': round(amount * random.uniform(0.95, 1.15), 2)
    })

# Embed RED FLAGS

# Red Flag 1: Duplicate Invoice (transactions 5 and 6)
transactions[6]['Invoice_Number'] = transactions[5]['Invoice_Number']
transactions[6]['Vendor_Name'] = transactions[5]['Vendor_Name']

# Red Flag 2: Payment before PO date (transaction 10)
transactions[10]['Payment_Date'] = (datetime.strptime(transactions[10]['PO_Date'], '%Y-%m-%d') - timedelta(days=5)).strftime('%Y-%m-%d')

# Red Flag 3: Invoice before PO date (transaction 15)
transactions[15]['Invoice_Date'] = (datetime.strptime(transactions[15]['PO_Date'], '%Y-%m-%d') - timedelta(days=3)).strftime('%Y-%m-%d')

# Red Flag 4: Amount exceeds PO limit (transaction 20)
transactions[20]['Amount'] = transactions[20]['PO_Amount_Limit'] * 1.25

# Red Flag 5: Same approver for large sequential transactions - SOD violation (transactions 25-27)
transactions[25]['Approver_ID'] = 'APP001'
transactions[25]['Amount'] = 450000
transactions[26]['Approver_ID'] = 'APP001'
transactions[26]['Amount'] = 480000
transactions[27]['Approver_ID'] = 'APP001'
transactions[27]['Amount'] = 495000

# Red Flag 6: Duplicate invoice with different amounts (transactions 32 and 33)
transactions[33]['Invoice_Number'] = transactions[32]['Invoice_Number']
transactions[33]['Vendor_Name'] = transactions[32]['Vendor_Name']
transactions[33]['Amount'] = transactions[32]['Amount'] * 0.85

# Red Flag 7: Payment made on same day as PO (transaction 40)
transactions[40]['Payment_Date'] = transactions[40]['PO_Date']
transactions[40]['Invoice_Date'] = transactions[40]['PO_Date']

# Create DataFrame
df = pd.DataFrame(transactions)

# Save to CSV
df.to_csv('P2P_Transactions_Mock_Data.csv', index=False)

print("Mock P2P Transaction Data Generated Successfully!")
print(f"\nTotal Transactions: {len(df)}")
print("\n=== EMBEDDED RED FLAGS ===")
print("1. Duplicate Invoice: Check Invoice Numbers for rows 6 & 7")
print("2. Payment Before PO: Row 11 (Payment before PO date)")
print("3. Invoice Before PO: Row 16 (Invoice before PO date)")
print("4. Amount Exceeds Limit: Row 21 (Amount > PO Limit)")
print("5. SOD Violation: Rows 26-28 (Same approver, high amounts)")
print("6. Duplicate Invoice Different Amount: Rows 33 & 34")
print("7. Same-Day Payment: Row 41 (PO, Invoice, Payment same day)")

print("\n" + "="*60)
print(df.head(10).to_string())
print("\nFile saved as: P2P_Transactions_Mock_Data.csv")