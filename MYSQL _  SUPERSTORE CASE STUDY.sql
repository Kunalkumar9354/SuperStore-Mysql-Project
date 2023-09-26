-- Case Study SuperStore



select * from tr_orderdetails;
-- q1) Find the maximum quantity sold in a transaction?
select
max(quantity) as maximum_quantity 
from tr_orderdetails;
-- q2) Find unique products in all the transactions?
 select distinct productname as unique_product 
 from tr_products;
-- q3) Find the uniqe properties?
 select distinct(Prop_ID) as unique_property 
 from tr_propertyinfo; 
 -- Find The category that has maximum products 
with Max_Product_Category as(select ProductCategory , max(ProductID) as MaxProducts , Rank() over(order by max(ProductID) desc)as rnk
 from tr_products
 group by ProductCategory
 order by MaxProducts Desc)
 Select ProductCategory , MaxProducts 
 from  Max_Product_Category
 where rnk = 1;
 select * from tr_orderdetails;
-- Find the state where Most stores are present ?
select PropertyState,City_Count from(select PropertyState, Count(*) as City_Count, 
Rank() over(order by count(*) desc) as rnk
from tr_propertyinfo
group by PropertyState
order by City_Count Desc) t
where t.rnk <2 ;
 -- Find the top 5 product ids that did maximum sales in terms of quantity?
 With Top5_Product_id as(Select ProductID  , count(Quantity) as Total_Quantity, 
 Dense_Rank() Over(Order by Count(Quantity) Desc) as rnk 
 from tr_orderdetails
 group by ProductID
 order by Total_Quantity Desc )
 select ProductID,Total_Quantity 
 from Top5_Product_id
 where rnk < 6
 order  by ProductID asc ;
 -- Top 5 Propery_ID that did maximum sales in terms of quantity?
with top5_property as(select PropertyID , count(Quantity) as Max_Quantity ,
Dense_Rank() Over(order by count(Quantity) desc) as rnk
from tr_orderdetails
group by PropertyID
order by Max_Quantity desc)
select PropertyID , Max_Quantity
from top5_Property
where rnk<6
order by Max_Quantity desc;
-- Find Top5 product names that did max sales in terms of quantity
with Top5_ProductName as (select ProductName,count(Quantity) as Total_Quantity, 
Dense_Rank() over(order by count(Quantity) desc) as rnk from tr_products p 
join tr_orderdetails o 
on p.ProductID = o.ProductID
group by ProductName)
select ProductName , total_Quantity 
from Top5_ProductName
where rnk<6;
-- Fing top5 products that did maximum Sales
with Top5_Product as(select ProductName,sum(Price*Quantity) as Sales
,Rank() Over(Order by sum(Price*Quantity) desc) as rnk  from tr_orderdetails o 
join tr_Products p 
on o.ProductId = p.ProductID
group by ProductName)
select ProductName,Sales from Top5_Product 
where rnk<6;
-- Top 5 cities that did maximum sales
with Top5_Cities as(select PropertyCity, (concat(sum(Price * Quantity),"$")) as Sales,
rank() over(order by Sum(Price * Quantity) desc ) as rnk  
from tr_propertyinfo p 
join tr_orderdetails o 
on p.Prop_ID = o.PropertyID
join tr_Products as pr 
on o.ProductID = pr.ProductID
group by PropertyCity)
select PropertyCity , Sales
from Top5_Cities
where rnk<6 ;
-- Top5 Product in Each of the city 
WITH product_total_quantity AS (
  SELECT
    p.ProductName,
    pf.PropertyCity,
    SUM(o.Price * o.Quantity) AS total_quantity
  FROM
    tr_orderdetails o
    JOIN tr_products p ON o.ProductID = p.ProductID
    JOIN tr_propertyinfo pf ON o.PropertyID = pf.Prop_ID
  GROUP BY
    p.ProductName, pf.PropertyCity)
SELECT
  ProductName,
  PropertyCity,
  total_quantity,
  RANK() OVER (PARTITION BY PropertyCity ORDER BY total_quantity DESC) AS rnk
FROM
  product_total_quantity
ORDER BY
  PropertyCity, rnk;




