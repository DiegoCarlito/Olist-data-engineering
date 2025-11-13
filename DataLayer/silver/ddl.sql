CREATE SCHEMA IF NOT EXISTS public;

DROP TABLE IF EXISTS public.orders;

CREATE TABLE public.orders (
    order_item_id VARCHAR(255) NOT NULL PRIMARY KEY,
    order_id VARCHAR(255) NOT NULL,
    customer_unique_id VARCHAR(255) NOT NULL,
    product_id VARCHAR(255) NOT NULL,
    seller_id VARCHAR(255) NOT NULL,
    order_status VARCHAR(255),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,
    price NUMERIC(10, 2),
    freight_value NUMERIC(10, 2),
    product_category_name VARCHAR(255),
    customer_city VARCHAR(255),
    customer_state VARCHAR(255),
    seller_city VARCHAR(255),
    seller_state VARCHAR(255),
    payment_type VARCHAR(255),
    payment_installments INTEGER,
    payment_value NUMERIC(10, 2),
    review_score INTEGER,
    delivery_days INTEGER,
    is_delivery_late BOOLEAN
);