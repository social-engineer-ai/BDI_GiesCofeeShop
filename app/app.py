"""
Gies Coffee Shop - Streamlit Dashboard
BADM 558/358 Week 3 EC2 Demo

This application demonstrates EC2 as both a web server and database server.
"""

import streamlit as st
import pymysql
import pandas as pd
import os
from decimal import Decimal

# Database configuration
DB_CONFIG = {
    'host': os.environ.get('DB_HOST', 'localhost'),
    'user': os.environ.get('DB_USER', 'admin'),
    'password': os.environ.get('DB_PASSWORD', 'GiesCoffee2026!'),
    'database': os.environ.get('DB_NAME', 'gies_coffee_shop'),
    'cursorclass': pymysql.cursors.DictCursor,
    'connect_timeout': 5,
}


def get_connection():
    """Create a database connection."""
    return pymysql.connect(**DB_CONFIG)


def run_query(sql, params=None):
    """Execute a SELECT query and return results as DataFrame."""
    conn = get_connection()
    try:
        df = pd.read_sql(sql, conn, params=params)
        return df
    finally:
        conn.close()


def run_insert(sql, params=None):
    """Execute an INSERT query."""
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(sql, params)
        conn.commit()
    finally:
        conn.close()


def safe_float(value, default=0.0):
    """Safely convert a value to float, handling Decimal and None."""
    if value is None:
        return default
    if isinstance(value, Decimal):
        return float(value)
    try:
        return float(value)
    except (ValueError, TypeError):
        return default


def safe_int(value, default=0):
    """Safely convert a value to int, handling None."""
    if value is None:
        return default
    try:
        return int(value)
    except (ValueError, TypeError):
        return default


# Page configuration
st.set_page_config(
    page_title="Gies Coffee Shop",
    page_icon="☕",
    layout="wide"
)

st.title("☕ Gies Coffee Shop Dashboard")
st.caption("BADM 558/358 - EC2 Demo Platform")

# Create tabs
tab1, tab2, tab3, tab4, tab5 = st.tabs([
    "📊 Dashboard",
    "📋 Menu",
    "📈 Sales Analytics",
    "🛒 Place Order",
    "📝 Recent Orders"
])

# Tab 1: Dashboard
with tab1:
    st.header("Business Overview")

    try:
        # Metrics row
        col1, col2, col3, col4 = st.columns(4)

        # Total Revenue
        rev_df = run_query("SELECT SUM(total_amount) as rev FROM daily_sales")
        total_rev = safe_float(rev_df.iloc[0]['rev']) if not rev_df.empty else 0.0
        col1.metric("Total Revenue", f"${total_rev:,.2f}")

        # Total Transactions
        trans_df = run_query("SELECT COUNT(*) as cnt FROM daily_sales")
        total_trans = safe_int(trans_df.iloc[0]['cnt']) if not trans_df.empty else 0
        col2.metric("Total Transactions", f"{total_trans:,}")

        # Average Order Value
        avg_order = total_rev / total_trans if total_trans > 0 else 0
        col3.metric("Avg Order Value", f"${avg_order:.2f}")

        # Menu Item Count
        menu_df = run_query("SELECT COUNT(*) as cnt FROM menu_items")
        menu_count = safe_int(menu_df.iloc[0]['cnt']) if not menu_df.empty else 0
        col4.metric("Menu Items", f"{menu_count}")

        st.divider()

        # Architecture info
        st.subheader("How This Works")
        arch_data = {
            "Component": ["Web Server", "Database Server", "Web App Port", "Database Port"],
            "Technology": ["EC2 + Streamlit", "EC2 + MariaDB (MySQL)", "8501", "3306"],
            "Purpose": [
                "Serves this dashboard to your browser",
                "Stores all coffee shop data",
                "HTTP traffic for the web app",
                "MySQL connections from CloudShell"
            ]
        }
        st.table(pd.DataFrame(arch_data))

        # Connection info for students
        st.subheader("Student Connection Info")
        st.info("""
**From AWS CloudShell:**
```
mysql -h <THIS_SERVER_IP> -u student -p gies_coffee_shop
```
Password: `coffee123`
        """)

    except Exception as e:
        st.error(f"Database connection error: {e}")
        st.info("Make sure the database server is running and accessible.")

# Tab 2: Menu
with tab2:
    st.header("Menu Items")

    try:
        menu_items = run_query("""
            SELECT product_name, category, price,
                   CASE WHEN available = 1 THEN 'Available' ELSE 'Unavailable' END as status
            FROM menu_items
            ORDER BY category, product_name
        """)

        if menu_items.empty:
            st.warning("No menu items found.")
        else:
            # Convert price column to float
            menu_items['price'] = menu_items['price'].apply(safe_float)

            # Group by category
            categories = menu_items['category'].unique()
            for category in sorted(categories):
                st.subheader(f"{category}")
                cat_items = menu_items[menu_items['category'] == category].copy()
                cat_items['price_display'] = cat_items['price'].apply(lambda x: f"${x:.2f}")
                st.dataframe(
                    cat_items[['product_name', 'price_display', 'status']].rename(columns={
                        'product_name': 'Product',
                        'price_display': 'Price',
                        'status': 'Status'
                    }),
                    hide_index=True,
                    use_container_width=True
                )

    except Exception as e:
        st.error(f"Error loading menu: {e}")

# Tab 3: Sales Analytics
with tab3:
    st.header("Sales Analytics")

    try:
        # Daily revenue chart
        st.subheader("Daily Revenue")
        daily_rev = run_query("""
            SELECT sale_date, SUM(total_amount) as revenue
            FROM daily_sales
            GROUP BY sale_date
            ORDER BY sale_date
        """)

        if not daily_rev.empty:
            daily_rev['revenue'] = daily_rev['revenue'].apply(safe_float)
            st.bar_chart(daily_rev.set_index('sale_date')['revenue'])
        else:
            st.info("No sales data available.")

        st.divider()

        col1, col2 = st.columns(2)

        with col1:
            # Top products
            st.subheader("Top 10 Products by Revenue")
            top_products = run_query("""
                SELECT product_name, SUM(total_amount) as revenue, SUM(quantity) as units_sold
                FROM daily_sales
                GROUP BY product_name
                ORDER BY revenue DESC
                LIMIT 10
            """)
            if not top_products.empty:
                top_products['revenue'] = top_products['revenue'].apply(safe_float)
                top_products['units_sold'] = top_products['units_sold'].apply(safe_int)
                display_df = top_products.copy()
                display_df['revenue'] = display_df['revenue'].apply(lambda x: f"${x:.2f}")
                st.dataframe(
                    display_df.rename(columns={
                        'product_name': 'Product',
                        'revenue': 'Revenue',
                        'units_sold': 'Units Sold'
                    }),
                    hide_index=True,
                    use_container_width=True
                )

        with col2:
            # Payment methods
            st.subheader("Payment Method Breakdown")
            payment_df = run_query("""
                SELECT payment_method, COUNT(*) as transactions, SUM(total_amount) as revenue
                FROM daily_sales
                GROUP BY payment_method
                ORDER BY revenue DESC
            """)
            if not payment_df.empty:
                payment_df['revenue'] = payment_df['revenue'].apply(safe_float)
                payment_df['transactions'] = payment_df['transactions'].apply(safe_int)
                display_df = payment_df.copy()
                display_df['revenue'] = display_df['revenue'].apply(lambda x: f"${x:.2f}")
                st.dataframe(
                    display_df.rename(columns={
                        'payment_method': 'Payment Method',
                        'transactions': 'Transactions',
                        'revenue': 'Revenue'
                    }),
                    hide_index=True,
                    use_container_width=True
                )

        st.divider()

        # Customer type analysis
        st.subheader("Customer Type Analysis")
        customer_df = run_query("""
            SELECT customer_type, COUNT(*) as transactions, SUM(total_amount) as revenue,
                   AVG(total_amount) as avg_order
            FROM daily_sales
            GROUP BY customer_type
            ORDER BY revenue DESC
        """)
        if not customer_df.empty:
            customer_df['revenue'] = customer_df['revenue'].apply(safe_float)
            customer_df['transactions'] = customer_df['transactions'].apply(safe_int)
            customer_df['avg_order'] = customer_df['avg_order'].apply(safe_float)
            display_df = customer_df.copy()
            display_df['revenue'] = display_df['revenue'].apply(lambda x: f"${x:.2f}")
            display_df['avg_order'] = display_df['avg_order'].apply(lambda x: f"${x:.2f}")
            st.dataframe(
                display_df.rename(columns={
                    'customer_type': 'Customer Type',
                    'transactions': 'Transactions',
                    'revenue': 'Total Revenue',
                    'avg_order': 'Avg Order'
                }),
                hide_index=True,
                use_container_width=True
            )

    except Exception as e:
        st.error(f"Error loading analytics: {e}")

# Tab 4: Place Order
with tab4:
    st.header("Place a New Order")

    try:
        # Get available products
        products = run_query("""
            SELECT product_name, price
            FROM menu_items
            WHERE available = 1
            ORDER BY product_name
        """)

        if products.empty:
            st.warning("No products available.")
        else:
            # Convert price to float
            products['price'] = products['price'].apply(safe_float)

            # Create product options
            product_names = products['product_name'].tolist()

            # Order form
            with st.form("order_form", clear_on_submit=True):
                selected_product = st.selectbox("Choose a Product", product_names)

                # Get price for selected product
                price_row = products[products['product_name'] == selected_product]
                selected_price = safe_float(price_row['price'].iloc[0]) if not price_row.empty else 0.0
                st.write(f"Price: **${selected_price:.2f}**")

                quantity = st.number_input("Quantity", min_value=1, max_value=20, value=1)
                customer_name = st.text_input("Your Name", placeholder="Enter your name")

                # Calculate total
                total = selected_price * quantity
                st.write(f"**Order Total: ${total:.2f}**")

                # Submit button MUST be inside the form
                submitted = st.form_submit_button("Place Order", type="primary")

            # Handle submission outside the form context
            if submitted:
                if not customer_name or not customer_name.strip():
                    st.error("Please enter your name.")
                else:
                    try:
                        run_insert(
                            "INSERT INTO customer_orders (customer_name, product_name, quantity) VALUES (%s, %s, %s)",
                            (customer_name.strip(), selected_product, quantity)
                        )
                        st.success(f"Order placed successfully! {quantity}x {selected_product} for {customer_name}")
                        st.balloons()
                    except Exception as insert_err:
                        st.error(f"Failed to place order: {insert_err}")

    except Exception as e:
        st.error(f"Error with order form: {e}")

# Tab 5: Recent Orders
with tab5:
    st.header("Recent Orders")

    try:
        if st.button("🔄 Refresh Orders"):
            st.rerun()

        # Get recent orders with product prices
        orders = run_query("""
            SELECT
                co.order_id,
                co.customer_name,
                co.product_name,
                co.quantity,
                mi.price as unit_price,
                (co.quantity * mi.price) as total,
                co.order_time
            FROM customer_orders co
            LEFT JOIN menu_items mi ON co.product_name = mi.product_name
            ORDER BY co.order_time DESC
            LIMIT 20
        """)

        if orders.empty:
            st.info("No orders yet. Be the first to place an order!")
        else:
            # Cast numeric columns safely
            orders['quantity'] = orders['quantity'].apply(safe_int)
            orders['unit_price'] = orders['unit_price'].apply(safe_float)
            orders['total'] = orders['total'].apply(safe_float)

            # Format for display
            display_orders = orders.copy()
            display_orders['unit_price'] = display_orders['unit_price'].apply(lambda x: f"${x:.2f}")
            display_orders['total'] = display_orders['total'].apply(lambda x: f"${x:.2f}")

            st.dataframe(
                display_orders.rename(columns={
                    'order_id': 'Order ID',
                    'customer_name': 'Customer',
                    'product_name': 'Product',
                    'quantity': 'Qty',
                    'unit_price': 'Unit Price',
                    'total': 'Total',
                    'order_time': 'Order Time'
                }),
                hide_index=True,
                use_container_width=True
            )

    except Exception as e:
        st.error(f"Error loading orders: {e}")

# Footer
st.divider()
st.caption("Gies Coffee Shop - BADM 558/358 Week 3 Demo | Built with Streamlit + MySQL on EC2")
