SELECT * FROM blinkit_data;

SELECT COUNT(*) from blinkit_data;

-- Changing Item fat content  data for LF or low fat to Low Fat and reg to Regular
UPDATE blinkit_data 
SET Item_Fat_Content = 
CASE
	WHEN Item_Fat_Content IN ('LF', 'low fat') THEN 'Low Fat'
	WHEN Item_Fat_Content = 'Reg' THEN 'Regular'
	ELSE Item_Fat_Content
END;	


SELECT DISTINCT(Item_Fat_Content) FROM blinkit_data;


-- 1. Total Sales
SELECT SUM(Sales) AS 'Total Sales' FROM blinkit_data; 

SELECT CONCAT('$', 
			CAST(SUM(Sales)/1000000 AS decimal(10,2)),
			' million') 
		AS 'Total Sales In Millions' 
FROM blinkit_data; 


-- Total sales of Low Fat Items
SELECT CONCAT('$', 
			CAST(SUM(Sales)/1000000 AS decimal(10,2)),
			' million') 
		AS 'Total Sales In Millions' 
FROM blinkit_data
WHERE Item_Fat_Content = 'Low Fat';


-- Total Sales of Regular Fat Items
SELECT CONCAT('$', 
			CAST(SUM(Sales)/1000000 AS decimal(10,2)),
			' million') 
		AS 'Total Sales In Millions' 
FROM blinkit_data
Where Item_Fat_Content = 'Regular'; 





-- 2. Average Sales
SELECT CAST(AVG(Sales) AS Decimal(10,2)) AS 'Average Sales' from blinkit_data;

-- Avg Sales of establishment year 2022
SELECT CAST(AVG(Sales) AS Decimal(10,2)) AS 'Average Sales' 
from blinkit_data
WHERE Outlet_Establishment_Year = 2022;

--3.No Of Items Sold
SELECT COUNT(*) AS 'No Of Items Sold' FROM blinkit_data;

-- Total Canned Items sold 
SELECT COUNT(*) AS 'No Of Canned Items Sold' 
FROM blinkit_data
WHERE Item_Type= 'Canned';

-- 4. Average Rating
SELECT CAST(AVG(Rating) AS DECIMAL(10,2)) from blinkit_data;

-- Average Rating Per Item Type
SELECT CAST(AVG(Rating) AS DECIMAL(10,2)) AS 'Average Rating', Item_Type
from blinkit_data
GROUP BY Item_Type
ORDER BY 'Average Rating';


--1. Total Sales by Item Fat Content
SELECT Item_Fat_Content,
CAST(SUM(Sales)/1000 AS DECIMAL(10,2)) AS Total_Sales_Thousands,
CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_Sales,
COUNT(*) AS No_Of_Items,
CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
From blinkit_data
GROUP BY Item_Fat_Content
ORDER BY Total_Sales_Thousands DESC;


--2. Total Sales by Item Type
SELECT Item_Type,
CAST(SUM(Sales)/1000 AS DECIMAL(10,2)) AS Total_Sales_Thousands,
CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_Sales,
COUNT(*) AS No_Of_Items,
CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
From blinkit_data
GROUP BY Item_Type
ORDER BY Total_Sales_Thousands DESC;


--3. Fat Content by Outlet For Total Sales
SELECT Outlet_Location_Type, Item_Fat_Content,
CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_Sales,
COUNT(*) AS No_Of_Items,
CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
From blinkit_data
GROUP BY Outlet_Location_Type, Item_Fat_Content
ORDER BY Total_Sales DESC;

-- Using Pivot to create Low fat and Regular column
SELECT Outlet_Location_Type,
	ISNULL([Low Fat], 0) AS Low_Fat,
	ISNULL([Regular],0) AS Regular
FROM
(
	SELECT Outlet_Location_Type, Item_Fat_Content,
		CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales
	FROM blinkit_data
	GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS SOURCETABLE
PIVOT
(
	SUM(Total_Sales)
	FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type;


--4. Total Sales by Outlet Establishment
SELECT Outlet_Establishment_Year,
CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_Sales,
COUNT(*) AS No_Of_Items,
CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
From blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY Total_Sales DESC;



--5. Percentage of Sales by Outlet Size
SELECT Outlet_Size,
	CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
	CAST((SUM(Sales)*100 / SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage
FROM blinkit_data
GROUP BY Outlet_Size
ORDER BY Total_Sales;


--6. Sales By Outlet Location
SELECT Outlet_Location_Type,
	CAST(SUM(Sales) AS DECIMAL(10,2)) AS TOTAL_SALES,
	CONCAT(CAST((SUM(Sales)*100 / SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)),'%') AS Sales_Percentage,
	CAST(AVG(Sales) AS DECIMAL(10,1)) AS AVG_SALES,
	COUNT(*) AS NO_OF_ITEMS_SOLD,
	CAST(AVG(Rating) AS DECIMAL(10,2)) AS AVG_Rating
from blinkit_data
group by Outlet_Location_Type
ORDER BY TOTAL_SALES DESC;


-- All Metrics by Outlet Type
SELECT Outlet_Type,
	CAST(SUM(Sales) AS DECIMAL(10,2)) AS TOTAL_SALES,
	CONCAT(CAST((SUM(Sales)*100 / SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)),'%') AS Sales_Percentage,
	CAST(AVG(Sales) AS DECIMAL(10,1)) AS AVG_SALES,
	COUNT(*) AS NO_OF_ITEMS_SOLD,
	CAST(AVG(Rating) AS DECIMAL(10,2)) AS AVG_Rating
from blinkit_data
WHERE Outlet_Establishment_Year = 2020
group by Outlet_Type
ORDER BY TOTAL_SALES DESC; 