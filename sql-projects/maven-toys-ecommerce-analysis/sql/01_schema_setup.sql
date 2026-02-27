/* 
   Maven Fuzzy Factory Core Schema 
   Version: 2026.1
*/

-- 1. Product Master Data
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Traffic & Session Data
CREATE TABLE website_sessions (
    website_session_id INT PRIMARY KEY,
    created_at TIMESTAMP NOT NULL,
    user_id INT,
    is_repeat_session INT DEFAULT 0, 
    utm_source VARCHAR(50),
    utm_campaign VARCHAR(50),
    utm_content VARCHAR(50),
    device_type VARCHAR(20),
    http_referer VARCHAR(255)
);

-- 3. Pageview Tracking
CREATE TABLE website_pageviews (
    website_pageview_id INT PRIMARY KEY,
    created_at TIMESTAMP NOT NULL,      
    website_session_id INT REFERENCES website_sessions(website_session_id),   
    pageview_url VARCHAR(100)
);

-- 4. Order Headers
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    created_at TIMESTAMP NOT NULL,
    website_session_id INT REFERENCES website_sessions(website_session_id),
    user_id INT,
    primary_product_id INT REFERENCES products(product_id),
    items_purchased INT DEFAULT 1,
    price_usd DECIMAL(10,2),
    cogs_usd DECIMAL(10,2)
);

-- 5. Individual Order Line Items
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    created_at TIMESTAMP NOT NULL,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    is_primary_item BOOLEAN,
    price_usd DECIMAL(10,2),
    cogs_usd DECIMAL(10,2)
);

-- 6. Returns & Financial Adjustments
CREATE TABLE order_item_refunds (
    order_item_refund_id INT PRIMARY KEY,
    created_at TIMESTAMP NOT NULL,
    order_item_id INT REFERENCES order_items(order_item_id),
    order_id INT REFERENCES orders(order_id),
    refund_amount_usd DECIMAL(10,2)
);

-- Optional: Performance Indexes for 2026 Analytics
CREATE INDEX idx_sessions_created_at ON website_sessions(created_at);
CREATE INDEX idx_orders_session ON orders(website_session_id);
