-- Select stock inventory by product and date for Power BI report 
SELECT 
    p.product_name,
    d.date,
    fi.stock_quantity,
    fi.restock_quantity
FROM fact_inventory fi
JOIN dim_product p ON fi.product_id = p.product_id
JOIN dim_date d ON fi.date_id = d.date_id
ORDER BY d.date, p.product_name;
