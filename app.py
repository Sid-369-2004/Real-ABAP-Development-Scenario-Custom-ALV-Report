import streamlit as st
import pandas as pd
import numpy as np
from datetime import datetime, timedelta

# Page Configuration for Wide layout matching Reference Screenshot
st.set_page_config(
    page_title="SAP MM Vendor Purchase UI",
    layout="wide",
    initial_sidebar_state="expanded"
)

# Custom Styling to Match SAP Fiori/O2C Blue Theme 
st.markdown("""
    <style>
    .css-1d391kg { /* Target default Streamlit Sidebar */
        background-color: #0b4a8e; 
    }
    .sb-nav-link {
        font-size: 16px;
        color: white !important;
        margin-bottom: 12px;
        font-family: Arial, sans-serif;
    }
    .flow-box {
        border: 2px solid #0b4a8e;
        border-radius: 8px;
        padding: 20px;
        text-align: center;
        background-color: white;
        margin: 10px;
        box-shadow: 2px 2px 5px rgba(0,0,0,0.1);
        width: 140px;
        height: 90px;
        display: inline-block;
    }
    .flow-title {font-weight: bold; font-size: 14px; color: #0b4a8e;}
    .flow-sub {font-size: 11px; color: #666;}
    .big-title {
        color: #0b4a8e;
        border-bottom: 2px solid #eaeaea;
        padding-bottom: 10px;
        margin-bottom: 30px;
    }
    </style>
""", unsafe_allow_html=True)

# ----------------- DB SIMULATION -----------------
def generate_dummy_data():
    if 'db_vendors' not in st.session_state:
        # LFA1
        st.session_state.db_vendors = pd.DataFrame({
            'LIFNR': ['V001', 'V002', 'V003', 'V004', 'V005'],
            'NAME1': ['Tech Solutions Ltd', 'Global Office Supplies', 'Industrial Mfg', 'Cloud Services Inc', 'Green Energy Co']
        })
        
        # EKKO & EKPO (Aggregated for simulation)
        num_records = 150
        np.random.seed(42)
        dates = [datetime.today() - timedelta(days=np.random.randint(1, 365)) for _ in range(num_records)]
        
        st.session_state.db_purchases = pd.DataFrame({
            'EBELN': [f'PO260{np.random.randint(100, 999)}' for _ in range(num_records)],
            'BUKRS': np.random.choice(['1000', '2000', '3000'], num_records),
            'LIFNR': np.random.choice(['V001', 'V002', 'V003', 'V004', 'V005'], num_records),
            'BEDAT': dates,
            'NETWR': np.round(np.random.uniform(500, 50000), 2),
            'WAERS': ['USD'] * num_records
        })

generate_dummy_data()

# Initialize Session State Variables that user will fill
if 'sel_bukrs' not in st.session_state:
    st.session_state.sel_bukrs = '1000'
if 'sel_vendor' not in st.session_state:
    st.session_state.sel_vendor = 'ALL'
if 'sel_date_start' not in st.session_state:
    st.session_state.sel_date_start = datetime.today() - timedelta(days=365)
if 'sel_date_end' not in st.session_state:
    st.session_state.sel_date_end = datetime.today()


# ----------------- SIDEBAR -----------------
st.sidebar.title("💼 SAP MM Simulator")
st.sidebar.markdown("---")

menu = st.sidebar.radio(
    "Navigate",
    [
        "🏠 Dashboard", 
        "1️⃣ Step 1: Selection (ZMMV_SEL)", 
        "2️⃣ Step 2: Extract & Join (F01)", 
        "3️⃣ Step 3: ALV Output (CL_SALV_TABLE)"
    ]
)

st.sidebar.markdown("<br><br><br><br><br>", unsafe_allow_html=True)
st.sidebar.info("**Capstone Context:**\nThis interactive Streamlit model simulates the ABAP program `ZMM_VENDOR_ALV` without needing SAP GUI.")


# ----------------- PAGE LOGIC -----------------

if menu == "🏠 Dashboard":
    st.markdown("<h2 class='big-title'>🔄 Vendor Purchase Analysis Flow</h2>", unsafe_allow_html=True)
    
    st.write("This diagram mirrors your ABAP logical execution. Navigate through the sidebar steps to process and interact with the data.")
    
    flow_html = """
    <div style='display: flex; flex-direction: row; align-items: center; justify-content: flex-start; flex-wrap: wrap;'>
        <div class='flow-box'><div class='flow-sub'>EKKO / LFA1</div><div class='flow-title'>Database</div></div>
        <div style='font-size:24px; color:#0b4a8e;'>&#8594;</div>
        <div class='flow-box'><div class='flow-sub'>ZMM_VENDOR_SEL</div><div class='flow-title'>Selection Screen</div></div>
        <div style='font-size:24px; color:#0b4a8e;'>&#8594;</div>
        <div class='flow-box'><div class='flow-sub'>INNER JOIN</div><div class='flow-title'>Data Extraction</div></div>
        <div style='font-size:24px; color:#0b4a8e;'>&#8594;</div>
        <div class='flow-box'><div class='flow-sub'>COLLECT</div><div class='flow-title'>Aggregation</div></div>
        <div style='font-size:24px; color:#0b4a8e;'>&#8594;</div>
        <div class='flow-box'><div class='flow-sub'>CL_SALV_TABLE</div><div class='flow-title'>ALV Output</div></div>
    </div>
    """
    st.markdown(flow_html, unsafe_allow_html=True)
    
    st.markdown("---")
    col1, col2 = st.columns(2)
    with col1:
        st.subheader("Welcome to the MM Interactive UI!")
        st.info("Head over to **Step 1** to input parameters just like you would in a SAP development sandbox.")
    with col2:
        st.subheader("Raw Backend Metrics")
        st.metric("Total Simulated POs Available", len(st.session_state.db_purchases))

elif menu == "1️⃣ Step 1: Selection (ZMMV_SEL)":
    st.markdown("<h2 class='big-title'>⚙️ Selection Parameters (SE38 User Input)</h2>", unsafe_allow_html=True)
    st.write("These inputs simulate standard ABAP `SELECT-OPTIONS` and `PARAMETERS`.")
    
    with st.form("selection_screen"):
        col1, col2 = st.columns(2)
        
        with col1:
            st.session_state.sel_bukrs = st.selectbox(
                "Company Code (BUKRS)", 
                ['1000', '2000', '3000'],
                index=['1000', '2000', '3000'].index(st.session_state.sel_bukrs) 
            )
            
            vendors = ['ALL'] + list(st.session_state.db_vendors['LIFNR'])
            sel_v = 'ALL' if st.session_state.sel_vendor not in vendors else st.session_state.sel_vendor
            st.session_state.sel_vendor = st.selectbox("Vendor ID (LIFNR)", vendors, index=vendors.index(sel_v))
            
        with col2:
            st.session_state.sel_date_start = st.date_input("From Date (BEDAT)", st.session_state.sel_date_start)
            st.session_state.sel_date_end = st.date_input("To Date (BEDAT)", st.session_state.sel_date_end)
        
        submitted = st.form_submit_button("Execute Selection")
        if submitted:
            st.success(f"Context saved! Selected Company Code: {st.session_state.sel_bukrs}")
            st.info("Proceed to Step 2 to simulate query execution.")

elif menu == "2️⃣ Step 2: Extract & Join (F01)":
    st.markdown("<h2 class='big-title'>🔍 Data Extraction (Simulating Open SQL)</h2>", unsafe_allow_html=True)
    
    st.write("Executing `INNER JOIN` on EKKO and LFA1 using selections provided...")
    
    df_po = st.session_state.db_purchases.copy()
    vendor_df = st.session_state.db_vendors.copy()
    
    # Filter Company Code
    df_po = df_po[df_po['BUKRS'] == st.session_state.sel_bukrs]
    
    # Filter Vendor
    if st.session_state.sel_vendor != 'ALL':
         df_po = df_po[df_po['LIFNR'] == st.session_state.sel_vendor]
         
    # Filter Dates
    df_po = df_po[(df_po['BEDAT'].dt.date >= st.session_state.sel_date_start) & 
                  (df_po['BEDAT'].dt.date <= st.session_state.sel_date_end)]
    
    # Join (Equivalent to INNER JOIN in ABAP)
    extracted = pd.merge(df_po, vendor_df, on='LIFNR', how='inner')
    
    # Save the filtered results globally to be passed to ALV Step
    st.session_state.current_extracted = extracted
    
    st.success(f"Database Query Completed! Retrieved {len(extracted)} valid records.")
    
    with st.expander("View Raw Extracted Table (Before ABAP Collect/Aggregation)"):
        st.dataframe(extracted)

elif menu == "3️⃣ Step 3: ALV Output (CL_SALV_TABLE)":
    st.markdown("<h2 class='big-title'>📊 Custom ALV Report Generated Output</h2>", unsafe_allow_html=True)
    
    if 'current_extracted' not in st.session_state:
        st.error("⚠️ No data extracted yet! Please run Step 2 first.")
    else:
        df = st.session_state.current_extracted
        
        if len(df) == 0:
            st.warning("No records match your selection criteria.")
        else:
            with st.spinner("Simulating ABAP `COLLECT` Aggregation Array..."):
                
                # Logic replicating ABAP 'COLLECT' operation grouping by vendor
                alv_df = df.groupby(['LIFNR', 'NAME1', 'WAERS']).agg(
                    PO_COUNT=('EBELN', 'count'),
                    TOTAL_AMT=('NETWR', 'sum'),
                    LAST_PDATE=('BEDAT', 'max')
                ).reset_index()
                
                # Sorting ALV specifically mimicking SAP typical SORT functions
                alv_df = alv_df.sort_values(by='TOTAL_AMT', ascending=False)
                
                # Reformatting
                alv_df['LAST_PDATE'] = alv_df['LAST_PDATE'].dt.strftime('%d.%m.%Y')
                alv_df['TOTAL_AMT'] = alv_df['TOTAL_AMT'].apply(lambda x: f"{x:,.2f}")
                
                # Column Naming mimicking SAP Data Elements
                alv_df.columns = [
                    'Vendor Code', 'Vendor Name', 'Currency', 
                    'PO Count', 'Total Monetary Spend', 'Last Interacted Date'
                ]
                
                st.write("#### `CL_SALV_TABLE` Web Representation")
                # Showing dataframe matching SAP Grid formatting
                st.dataframe(alv_df, use_container_width=True, height=350)
                
                st.caption(f"Showing aggregated spend analysis for Company Code: **{st.session_state.sel_bukrs}**")
