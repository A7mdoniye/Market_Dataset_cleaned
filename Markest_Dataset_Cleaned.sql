SELECT * 
FROM test_backup;

SELECT * 
FROM train_backup;

CREATE TABLE train_backup
LIKE train;

INSERT INTO train_backup TABLE
train;



CREATE TABLE test_backup
LIKE test.test;

ALTER TABLE test_backup;



INSERT INTO test_backup TABLE 
test.test;


SELECT DISTINCT  Item_Fat_Content
FROM train_backup;

ALTER TABLE test_backup;

SELECT REPLACE(Item_Fat_Content,'reg','Regular'),
	   REPLACE(Item_Fat_Content,'LF','Low Fat') AS fixed
FROM test_backup;

UPDATE train_backup
SET Item_Fat_Content = REPLACE(REPLACE(Item_Fat_Content,'reg','Regular'),'LF','Low Fat');


SELECT Item_Fat_Content, AVG(Item_Weight) AS average
FROM test_backup
GROUP BY Item_Fat_Content;


SELECT DISTINCT Outlet_Establishment_Year, ROUND(AVG(Item_MRP)) AS average, COUNT(*) AS count
FROM test_backup
GROUP BY Outlet_Establishment_Year
ORDER BY 3 DESC;

SELECT TRIM(Outlet_Establishment_Year)
FROM test_backup;

UPDATE test_backup
SET Outlet_Establishment_Year = TRIM(Outlet_Establishment_Year);


SELECT DISTINCT Item_Type, COUNT(*) AS count
FROM test_backup
GROUP BY Item_Type
ORDER BY 2 DESC;


SELECT ts.Item_Fat_Content, tr.Item_Fat_Content, COUNT(*) AS count
FROM test_backup ts
	JOIN train_backup tr
    ON ts.Item_Identifier = tr.Item_Identifier
GROUP BY ts.Item_Fat_Content, tr.Item_Fat_Content;

SELECT MAX(Item_MRP), MIN(Item_MRP)
FROM train_backup;


SELECT Item_Fat_Content, COUNT(Item_Visibility)
FROM test_backup
GROUP BY Item_Fat_Content;

SELECT Item_Fat_Content, COUNT(Item_Visibility)
FROM train_backup
GROUP BY Item_Fat_Content;



#1. What factors most strongly influence item sales?

SELECT tr.Item_Type ,tr.Item_Visibility, tr.Item_MRP, tr.Outlet_Type, tr.Outlet_Location_Type, AVG(Item_Outlet_Sales) AS average
FROM train_backup tr 
	JOIN test_backup ts
    ON tr.Item_Identifier = ts.Item_Identifier
GROUP BY tr.Item_Type ,tr.Item_Visibility, tr.Item_MRP, tr.Outlet_Type, tr.Outlet_Location_Type
ORDER BY 6 DESC;  

#2. How does the Outlet_Type impact item sales? 

SELECT tr.Outlet_Type, ts.Outlet_Type, COUNT(tr.Item_Outlet_Sales) AS total , AVG(tr.Item_Outlet_Sales) AS average
FROM train_backup tr
	JOIN test_backup ts
    ON tr.Item_Identifier = ts.Item_Identifier
GROUP BY tr.Outlet_Type, ts.Outlet_Type
ORDER BY 3 DESC;   

#3. Is there a relationship between Outlet_Establishment_Year and sales performance?

SELECT tr.Outlet_Establishment_Year,  COUNT(tr.Item_Outlet_Sales) AS total , AVG(tr.Item_Outlet_Sales) AS average
FROM train_backup tr
	JOIN test_backup ts
    ON tr.Item_Identifier = ts.Item_Identifier
GROUP BY tr.Outlet_Establishment_Year
ORDER BY 3 DESC;

#4. How does the Item_Fat_Content relate to sales across item types?

SELECT tr.Item_Fat_Content, ts.Item_Fat_Content, COUNT(tr.Item_Outlet_Sales) AS total , AVG(tr.Item_Outlet_Sales) AS average
FROM train_backup tr
	JOIN test_backup ts
    ON tr.Item_Identifier = ts.Item_Identifier
GROUP BY tr.Item_Fat_Content, ts.Item_Fat_Content
ORDER BY 3 DESC; 

#5. What is the impact of outlet location (Outlet_Location_Type) on sales?

SELECT tr.Outlet_Location_Type, COUNT(tr.Item_Outlet_Sales) AS total , AVG(tr.Item_Outlet_Sales) AS average
FROM train_backup tr
	JOIN test_backup ts
    ON tr.Item_Identifier = ts.Item_Identifier
GROUP BY tr.Outlet_Location_Type
ORDER BY 3 DESC;   

#6. Does Item_Visibility correlate with sales?

SELECT tr.Item_Visibility, COUNT(tr.Item_Outlet_Sales) AS total , 
CASE
    WHEN tr.Item_Visibility >= 0.20168772 THEN 'High'
    WHEN tr.Item_Visibility <= 0.20168772 THEN 'Low'
END AS Visibility
FROM train_backup tr
	JOIN test_backup ts
    ON tr.Item_Identifier = ts.Item_Identifier
GROUP BY tr.Item_Visibility
ORDER BY 1 DESC;

#7. How do outlet characteristics (Outlet_Size, Outlet_Type, Outlet_Location_Type) affect average item sales?

SELECT tr.Outlet_Type, ts.Outlet_Type, tr.Outlet_Size, ts.Outlet_Size, tr.Outlet_Location_Type, ts.Outlet_Location_Type, COUNT(tr.Item_Outlet_Sales) AS total , AVG(tr.Item_Outlet_Sales) AS average
FROM train_backup tr
	JOIN test_backup ts
    ON tr.Item_Identifier = ts.Item_Identifier
GROUP BY tr.Outlet_Type, ts.Outlet_Type, tr.Outlet_Size, ts.Outlet_Size, tr.Outlet_Location_Type, ts.Outlet_Location_Type
ORDER BY 3 DESC;

#8. Are there patterns in item pricing (Item_MRP) among different outlet types?

SELECT tr.Outlet_Type, tr.Outlet_Location_Type, AVG(tr.Item_MRP) AS avg_mrp, AVG(ts.Item_MRP) AS avg_mrp2 , AVG(tr.Item_Outlet_Sales) AS avg_sales
FROM train_backup tr
	JOIN test_backup ts
    ON tr.Item_Identifier = ts.Item_Identifier
GROUP BY tr.Outlet_Type, tr.Outlet_Location_Type
ORDER BY 3 DESC;



