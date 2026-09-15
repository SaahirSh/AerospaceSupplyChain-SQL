
-- 1. Orders Handled by Supplier
-- Counts total purchase orders for each supplier
SELECT 
    supplier_id,
    COUNT(po_id) AS total_orders
FROM dbo.purchase_orders
GROUP BY supplier_id;

-- 2. Inventory On-Hand for High-Risk Suppliers
-- Shows parts and stock quantity for suppliers flagged as High risk
SELECT 
    p.supplier_id_primary,
    p.part_id,
    h.on_hand_qty
FROM dbo.parts_master p
JOIN dbo.supply_chain_history h ON p.part_id = h.part_id
WHERE p.supplier_risk_class = 'High';

-- 3. Defect Incidents and Scrapped Units by Supplier
-- Shows total quality incidents and total scrapped units per supplier
SELECT 
    q.supplier_id,
    COUNT(q.incident_id) AS total_incidents,
    SUM(q.scrap_qty) AS total_scrapped_units
FROM dbo.quality_incidents q
GROUP BY q.supplier_id;

-- 4. Simple Stockout List
-- Finds the records where backorders are higher than current inventory
SELECT 
    site_id,
    part_id,
    on_hand_qty,
    backorder_qty
FROM dbo.supply_chain_history
WHERE backorder_qty > on_hand_qty;

-- 5. Orders Received with Missing Items
-- Lists orders where received quantity was less than ordered quantity
SELECT 
    po_id,
    supplier_id,
    ordered_qty,
    received_qty
FROM dbo.purchase_orders
WHERE received_qty < ordered_qty;

-- 6. Late Delivery Check
-- The comparison between order date and receipt date vs standard lead time
SELECT 
    po.po_id,
    po.supplier_id,
    p.lead_time_days,
    po.order_date,
    po.receipt_date
FROM dbo.purchase_orders po
JOIN dbo.parts_master p ON po.part_id = p.part_id;

-- 7. Inventory Stock Count by Site
-- Shows the total physical inventory stored at each warehouse site
SELECT 
    site_id,
    SUM(on_hand_qty) AS total_parts_on_hand
FROM dbo.supply_chain_history
GROUP BY site_id;

-- 8. Quality Incidents by Part Category
-- Counts defect incidents for each part family
SELECT 
    p.part_family,
    COUNT(q.incident_id) AS total_defects
FROM dbo.quality_incidents q
JOIN dbo.parts_master p ON q.part_id = p.part_id
GROUP BY p.part_family;
