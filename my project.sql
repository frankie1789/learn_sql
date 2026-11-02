SELECT * FROM EMPLOYEES
-- descending order employees whose net salary is greater than or equal to 8000

SELECT EMPLOYEE_NUMBER, 
    FIRST_NAME,
    LAST_NAME, 
    2026 - YEAR(BIRTH_DATE) AS AGE ,
    2026 -YEAR(HIRE_DATE) AS SENIORITY ,
    ( SALARY + COALESCE(COMMISSION, 0)) AS NET_SALARY 
FROM EMPLOYEES
WHERE TITLE IN ('Mr.' , 'Dr.') AND ( SALARY + COALESCE(COMMISSION, 0)) >= 8000
ORDER BY SENIORITY DESC;

--Display products that meet the following criteria: (C1) quantity is packaged in bottle(s), (C2) the third character in the product name is 't' or 'T',
-- (C3) supplied by suppliers 1, 2, or 3, (C4) unit price ranges between 70 and 200, and (C5) units ordered are specified (not null).
-- The resulting table should include the following columns: product number, product name, supplier number, units ordered, and unit price


SELECT * FROM PRODUCTS
SELECT PRODUCT_REF,PRODUCT_NAME,SUPPLIER_NUMBER,UNITS_ON_ORDER,UNIT_PRICE
   FROM Products
WHERE LOWER(QUANTITY) LIKE '%bottle%'
  AND LOWER(PRODUCT_NAME) LIKE '__t%'
  AND SUPPLIER_NUMBER IN (1, 2, 3)
  AND UNIT_PRICE BETWEEN 70 AND 200
  AND UNITS_ON_ORDER IS NOT NULL;

  --Display customers who reside in the same region as supplier 1, meaning they share the same country, city, and the last three digits of the postal code.
  --The query should utilize a single subquery. 
  --The resulting table should include all columns from the customer table

  SELECT * FROM CUSTOMERS 
  SELECT* FROM SUPPLIERS 

  SELECT * FROM CUSTOMERS
  WHERE EXISTS ( SELECT 1 
  FROM SUPPLIERS 
   WHERE SUPPLIERS.SUPPLIER_NUMBER = 1
  AND CUSTOMERS.CITY = SUPPLIERS.CITY
AND CUSTOMERS.COUNTRY = SUPPLIERS.COUNTRY
AND RIGHT (POSTAL_CODE,3) = RIGHT(POSTAL_CODE,3));


--For each order number between 10998 and 11003, do the following:  
--Display the new discount rate, which should be 0% if the total order amount before discount (unit price * quantity) is between 0 and 2000, 
--5% if between 2001 and 10000, 10% if between 10001 and 40000, 15% if between 40001 and 80000, and 20% otherwise


SELECT * FROM ORDER_DETAILS

SELECT ORDER_NUMBER,
    CASE
        WHEN SUM(UNIT_PRICE * QUANTITY) BETWEEN 0 AND 2000
            THEN '0%'
        WHEN SUM(UNIT_PRICE * QUANTITY) BETWEEN 2001 AND 10000
            THEN '5%'
        WHEN SUM(UNIT_PRICE * QUANTITY) BETWEEN 10001 AND 40000
            THEN '10%'
        WHEN SUM(UNIT_PRICE * QUANTITY) BETWEEN 40001 AND 80000
            THEN '15%'
        ELSE '20%'
    END AS NEW_DISCOUNT_RATE,
    CASE
        WHEN ORDER_NUMBER BETWEEN 10000 AND 10999
            THEN 'apply old discount rate'
        ELSE 'apply new discount rate'
    END AS discount_rate_application_note
FROM ORDER_DETAILS
WHERE ORDER_NUMBER BETWEEN 10998 AND 11003
GROUP BY ORDER_NUMBER
ORDER BY ORDER_NUMBER;

--Display suppliers of beverage products. The resulting table should display the columns: supplier number, company, address, and phone number
SELECT * FROM SUPPLIERS
SELECT * FROM PRODUCTS 
SELECT * FROM CATEGORIES 
SELECT * FROM ORDERS 
SELECT * FROM ORDER_DETAILS

SELECT DISTINCT SUPPLIERS.SUPPLIER_NUMBER, SUPPLIERS.COMPANY, SUPPLIERS.ADDRESS,SUPPLIERS.PHONE
FROM SUPPLIERS
INNER JOIN PRODUCTS ON SUPPLIERS.SUPPLIER_NUMBER = PRODUCTS.SUPPLIER_NUMBER
INNER JOIN CATEGORIES ON PRODUCTS.CATEGORY_CODE = CATEGORIES.CATEGORY_CODE
WHERE CATEGORY_NAME = 'Beverages' 


--Display customers from Berlin who have ordered at most 1 (0 or 1) dessert product. The resulting table should display the column: customer code.
SELECT * FROM CUSTOMERS


SELECT CUSTOMERS.CUSTOMER_CODE AS customer_code
FROM CUSTOMERS
LEFT JOIN ORDERS ON CUSTOMERS.CUSTOMER_CODE = ORDERS.CUSTOMER_CODE
LEFT JOIN ORDER_DETAILS ON ORDERS.ORDER_NUMBER = ORDER_DETAILS.ORDER_NUMBER
LEFT JOIN PRODUCTS ON ORDER_DETAILS.PRODUCT_REF = PRODUCTS.PRODUCT_REF
LEFT JOIN CATEGORIES ON PRODUCTS.CATEGORY_CODE = CATEGORIES.CATEGORY_CODE
WHERE CUSTOMERS.CITY = 'Berlin'
GROUP BY CUSTOMERS.CUSTOMER_CODE
HAVING COUNT(DISTINCT CASE
    WHEN CATEGORIES.CATEGORY_NAME = 'Desserts' THEN PRODUCTS.PRODUCT_REF
END) <= 1

--Display customers who reside in France and the total amount of orders they placed every Monday in April 1998 (considering customers who haven't placed any orders yet). 
--The resulting table should display the columns: customer number, company name, phone number, total amount, and countrY

SELECT * FROM CUSTOMERS

SELECT
CUSTOMERS.CUSTOMER_CODE AS CUSTOMER_NUMBER, CUSTOMERS.COMPANY, CUSTOMERS.PHONE, CUSTOMERS.COUNTRY,  
COALESCE(
        SUM(ORDER_DETAILS.UNIT_PRICE * ORDER_DETAILS.QUANTITY *
            (1 - COALESCE(ORDER_DETAILS.DISCOUNT, 0))),
        0
    ) AS total_amount
FROM CUSTOMERS
LEFT JOIN ORDERS ON CUSTOMERS.CUSTOMER_CODE = ORDERS.CUSTOMER_CODE
LEFT JOIN ORDER_DETAILS ON ORDERS.ORDER_NUMBER = ORDER_DETAILS.ORDER_NUMBER
AND  CONVERT(DATE, ORDERS.ORDER_DATE ,3) >= '19980401'
AND   CONVERT(DATE,ORDERS.ORDER_DATE, 3) <= '19980501'
AND DATEPART(WEEKDAY, CONVERT(DATE, ORDERS.ORDER_DATE, 3)) = 1
WHERE CUSTOMERS.COUNTRY = 'France'
GROUP BY  CUSTOMERS.CUSTOMER_CODE,CUSTOMERS.COMPANY,CUSTOMERS.PHONE,CUSTOMERS.COUNTRY;




--Display customers who have ordered all products. The resulting table should display the columns: customer code, company name, and telephone number

SELECT CUSTOMERS.CUSTOMER_CODE, CUSTOMERS.COMPANY, CUSTOMERS.PHONE
FROM CUSTOMERS
 WHERE NOT EXISTS (
    SELECT 1
    FROM PRODUCTS 
    WHERE NOT EXISTS (
        SELECT 1
        FROM ORDERS
        INNER JOIN ORDER_DETAILS
            ON ORDERS.ORDER_NUMBER = ORDER_DETAILS.ORDER_NUMBER
        WHERE ORDERS.CUSTOMER_CODE = CUSTOMERS.CUSTOMER_CODE
          AND ORDER_DETAILS.PRODUCT_REF = PRODUCTS.PRODUCT_REF
    ))


-- Display for each customer from France the number of orders they have placed. The resulting table should display the columns: customer code and number of orders

SELECT CUSTOMERS.CUSTOMER_CODE , COUNT(ORDERS.ORDER_NUMBER) AS TOTAL_ORDERS 
FROM CUSTOMERS 
LEFT JOIN ORDERS ON CUSTOMERS.CUSTOMER_CODE = ORDERS.CUSTOMER_CODE
WHERE CUSTOMERS.COUNTRY ='France'
GROUP BY CUSTOMERS.CUSTOMER_CODE;


-- Display the number of orders placed in 1996, the number of orders placed in 1997, and the difference between these two numbers. 
--The resulting table should display the columns: orders in 1996, orders in 1997, and Difference.

SELECT
    COUNT(CASE
        WHEN YEAR(CONVERT(date, ORDER_DATE, 3)) = 1996 THEN 1
    END) AS [orders in 1996],

    COUNT(CASE
        WHEN YEAR(CONVERT(date, ORDER_DATE, 3)) = 1997 THEN 1
    END) AS [orders in 1997],

    COUNT(CASE
        WHEN YEAR(CONVERT(date, ORDER_DATE, 3)) = 1997 THEN 1
    END)
    -
    COUNT(CASE
        WHEN YEAR(CONVERT(date, ORDER_DATE, 3)) = 1996 THEN 1
    END) AS [Difference]
FROM ORDERS;
