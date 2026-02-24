Drop table Orders;

CREATE TABLE Orders (
    Order_ID INT PRIMARY KEY,
    Order_Date DATE,
    Customer_ID VARCHAR(10),
    Customer_Name VARCHAR(100),
    Product_Category VARCHAR(100),
    Product_Name VARCHAR(150),
    Quantity INT,
    Unit_Price DECIMAL(10,2),
    Payment_Mode VARCHAR(50),
    Store_Location VARCHAR(100)
);

INSERT INTO Orders
(Order_ID, Order_Date, Customer_ID, Customer_Name, Product_Category, Product_Name, Quantity, Unit_Price, Payment_Mode, Store_Location)
VALUES
(1001, TO_DATE('2026-02-01','YYYY-MM-DD'), 'C001', 'Ravi Kumar', 'Electronics', 'Wireless Mouse', 2, 799.00, 'UPI', 'Bangalore'),
(1002, TO_DATE('2026-02-02','YYYY-MM-DD'), 'C002', 'Sneha Reddy', 'Grocery', 'Basmati Rice 5kg', 1, 650.00, 'Credit Card', 'Hyderabad'),
(1003, TO_DATE('2026-02-03','YYYY-MM-DD'), 'C003', 'Arjun Mehta', 'Fashion', 'Men''s T-Shirt', 3, 499.00, 'Cash', 'Chennai'),
(1004, TO_DATE('2026-02-04','YYYY-MM-DD'), 'C004', 'Priya Sharma', 'Electronics', 'Bluetooth Speaker', 1, 1499.00, 'Debit Card', 'Mumbai'),
(1005, TO_DATE('2026-02-05','YYYY-MM-DD'), 'C005', 'Kiran Rao', 'Home ''&'' Kitchen', 'Mixer Grinder', 1, 2499.00, 'UPI', 'Bangalore'),
(1006, TO_DATE('2026-02-06','YYYY-MM-DD'), 'C006', 'Neha Verma', 'Beauty', 'Face Cream', 4, 299.00, 'Credit Card', 'Delhi'),
(1007, TO_DATE('2026-02-07','YYYY-MM-DD'), 'C007', 'Rahul Das', 'Grocery', 'Cooking Oil 1L', 5, 180.00, 'Cash', 'Kolkata'),
(1008, TO_DATE('2026-02-08','YYYY-MM-DD'), 'C008', 'Anjali Nair', 'Fashion', 'Women''s Jeans', 2, 1199.00, 'UPI', 'Kochi'),
(1009, TO_DATE('2026-02-09','YYYY-MM-DD'), 'C009', 'Suresh Patel', 'Electronics', 'Smartphone', 1, 15999.00, 'Debit Card', 'Ahmedabad'),
(1010, TO_DATE('2026-02-10','YYYY-MM-DD'), 'C010', 'Meena Iyer', 'Home ''&'' Kitchen', 'Pressure Cooker', 1, 1899.00, 'Credit Card', 'Pune');

-- -- STRING FUNCTIONS – 20 Questions

-- 1. Write a query to convert all customer names to uppercase.
select upper(Customer_Name) from ORDERS;

-- 2. Extract the first 5 characters from Product_Name.
select substr(PRODUCT_NAME,1,3) from ORDERS;

-- 3. Find the length of each Customer_Name.
select length(Customer_Name) from ORDERS;

-- 4. Replace the word "Rice" with "Premium Rice" in Product_Name.
select replace(PRODUCT_NAME,'Rice','Premium Rice') from ORDERS;

-- 5. Remove leading and trailing spaces from Customer_Name.
select trim(Customer_Name) from ORDERS;

-- 6. Concatenate First_Name and Last_Name as Full_Name.
select first_name||' '||last_name as Full_name from hr.employees;

-- 7. Find customers whose names start with 'A'.
select Customer_Name from ORDERS where Customer_Name like 'A%';

-- 8. Extract the domain name from Email_ID.
select substr(email,instr(email,'@'),length(email)) as "Domain Name" from hr.employees;

-- 9. Find the position of '@' in Email_ID.
select instr(email,'@') as "Domain start position" from hr.employees;

-- 10. Reverse the Product_Name.
select reverse(PRODUCT_NAME) from ORDERS;

-- 11. Convert the first letter of each word in Product_Name to uppercase.
select initcap(PRODUCT_NAME) from ORDERS;

-- 12. Extract the last 3 characters from Order_ID.
select substr(to_char(order_id),length(to_char(order_id))-2) from orders;

-- 13. Count how many times letter 'a' appears in Customer_Name.
select REGEXP_COUNT(lower(customer_name),'a') from orders;

-- 14. Mask the last 4 digits of a phone number.
select substr(phone_number,1,length(PHONE_NUMBER)-4)||'****' from hr.employees;

-- 15. Split Full_Name into First_Name and Last_Name.
select substr(customer_name,1,instr(customer_name,' ')) First_name, substr(customer_name,instr(customer_name,' ')+1) Last_name from orders;

-- 16. Remove all special characters from Product_Code.
select replace(product_category,'&','') as product_category from orders;

-- 17. Compare two columns ignoring case sensitivity.
select * from orders where upper(customer_name) = upper(product_name);

-- 18. Find customers whose name contains 'kumar'.
select customer_name from orders where lower(customer_name) like '%kumar%';

-- 19. Pad Order_ID with leading zeros to make it 6 digits.
select LPAD(order_id,6,0) order_id from orders;

-- 20. Extract substring between two characters.
select substr(customer_name, instr(lower(customer_name),'a'),instr(lower(customer_name),'e')) as sub_string from orders;

-- -- NUMERICAL FUNCTIONS – 20 Questions

-- 1. Round Unit_Price to 2 decimal places.
select round(unit_price,2) as unit_price from orders;

-- 2. Find total sales per order.
select ord.*, quantity * unit_price as Total_sales from Orders ord;

-- 3. Calculate average order value.
select avg(quantity * unit_price) average_sales from Orders;

-- 4. Find highest product price.
select * from orders 
where unit_price = (select max(unit_price) from orders);

-- 5. Find lowest product price.
select * from orders 
where unit_price = (select min(unit_price) from orders);

-- 6. Calculate percentage discount applied.


-- 7. Find modulus of Quantity divided by 2.
select * from orders where mod(quantity,2) = 0;

-- 8. Convert negative values to positive.
select abs(-25);

-- 9. Truncate price without rounding.
select Trunc(unit_price) as unit_price from orders;

-- 10. Find square root of total sales.
select SQRT(sum(quantity * unit_price)) as SQRT_Total_sales from Orders;

-- 11. Calculate exponential value of a number.
select EXP(2) ;

-- 12. Calculate power of 2^5.
select power(2,5); 

-- 13. Find absolute difference between two prices.
select abs(12-20);

-- 14. Calculate sales growth percentage.
select to_char(to_char(year_order ||'-'|| lead(year_order,1,0) over(order by Year_order))), ROUND(((lead(order_count,1,0) over(order by Year_order) - order_count) / order_count) * 100, 2)
from (select extract(YEAR from order_date) Year_order, count(order_id) order_count from oe.orders
group by Year_order order by year_order);

-- 15. Find random number between 1 and 100.
SELECT TRUNC(DBMS_RANDOM.VALUE(1, 101)) AS random_number;

-- 16. Divide total sales by number of orders.
select sum(quantity * unit_price)/count(*) as Total_sales_by_orders from Orders;

-- 17. Find ceiling value of price.
select CEIL(unit_price) ceil_unit_price from orders;

-- 18. Find floor value of price.
select floor(unit_price) floor_unit_price from orders;

-- 19. Convert decimal to integer.
select trunc(23.50);

-- 20. Calculate compound interest.
select  50000 * POWER(1 + (12 / 100) / 4, 4 * 5) - 50000 as compound_interest;

--formula: principal * POWER(1 + (annual_rate / 100) / comp_per_year, comp_per_year * years) - principal


-- -- DATE FUNCTIONS – 20 Questions

-- 1. Extract year from Order_Date.
select distinct extract(year from order_date) as order_year from orders;

-- 2. Extract month from Order_Date.
select distinct extract(month from order_date) as order_year from orders;

-- 3. Extract day from Order_Date.
select distinct extract(day from order_date) as order_year from orders;

-- 4. Find current date.
select sysdate;

-- 5. Find current timestamp.
SELECT CURRENT_TIMESTAMP;

-- 6. Add 7 days to Order_Date.
SELECT SYSDATE + 7 AS new_date;

-- 7. Subtract 30 days from Order_Date.
SELECT SYSDATE - 30 AS new_date;

-- 8. Find difference between two dates.
select TO_DATE('2026/02/24','YYYY/MM/DD') - to_date('2026/02/20','YYYY/MM/DD') days_diff;

-- 9. Find number of months between two dates.
select months_between(TO_DATE('2026/02/24','YYYY/MM/DD'), to_date('2026/01/20','YYYY/MM/DD')) months_diff;

-- 10. Find last day of the month.
select last_day(TO_DATE('2026/02/24','YYYY/MM/DD'));

-- 11. Get first day of the year.
select TRUNC(TO_DATE('2026/02/24','YYYY/mm/dd'),'YYYY') as first_day;

-- 12. Format date as 'DD-MM-YYYY'.
select To_char(TO_DATE('2026/02/20','YYYY/MM/DD'),'DD-MM-YYYY') new_date_formate;

-- 13. Convert string to date.
select To_date('2026/02/20','YYYY/MM/DD') string_to_date;

-- 14. Convert date to string.
select To_char(sysdate,'DD-MM-YYYY') date_to_string;

-- 15. Find week number of the year.
select TO_CHAR(SYSDATE, 'WW') week_number;

-- 16. Find day name from date.
select to_char(sysdate, 'DAY');

-- 17. Find quarter of the year.
select to_char(sysdate, 'Q');

-- 18. Calculate age from DOB.
select MONTHS_BETWEEN(sysdate, to_date('1986/09/23','YYYY/MM/DD'))/12 as age_years;

-- 19. Check if date is weekend.
select order_date, 
case when to_char(order_date,'D') in ('1','7') then 'Weekend' else 'Weekday' end as date_week
from orders;

-- 20. Find next Monday after a given date.
select order_date, next_day(order_date,'MONDAY') as Next_Monday
from orders;


-- -- MATHEMATIC FUNCTIONS – 20 Questions

-- 1. Find sine value of an angle.
-- 2. Find cosine value of an angle.
-- 3. Find tangent value.
-- 4. Convert degrees to radians.
-- 5. Convert radians to degrees.
-- 6. Find logarithm (base 10) of a number.
-- 7. Find natural log of a number.
-- 8. Find square of a number.
-- 9. Find cube of a number.
-- 10. Calculate factorial of a number.
-- 11. Find greatest value among three numbers.
-- 12. Find least value among three numbers.
-- 13. Calculate variance of sales.
-- 14. Calculate standard deviation of sales.
-- 15. Find average deviation.
-- 16. Calculate geometric mean.
-- 17. Calculate harmonic mean.
-- 18. Find sum of squares.
-- 19. Calculate correlation between two columns.
-- 20. Calculate regression slope.


-- -- NULL VALUE FUNCTIONS – 20 Questions

-- 1. Replace NULL price with 0.
-- 2. Replace NULL Customer_Name with 'Unknown'.
-- 3. Count NULL values in Product_Name.
-- 4. Find rows where Order_Date is NULL.
-- 5. Use COALESCE to return first non-null value.
-- 6. Use NVL to replace NULL values.
-- 7. Use IFNULL function.
-- 8. Check if column is NULL.
-- 9. Check if column is NOT NULL.
-- 10. Use NULLIF between two columns.
-- 11. Replace blank values with NULL.
-- 12. Count non-null values.
-- 13. Filter records where price is NULL or 0.
-- 14. Use CASE to handle NULL values.
-- 15. Compare NULL values properly.
-- 16. Handle NULL in aggregation.
-- 17. Find average excluding NULL values.
-- 18. Find sum ignoring NULL values.
-- 19. Identify columns containing NULL using metadata.
-- 20. Convert NULL to default system date.


-- -- ANALYTICAL FUNCTIONS (WINDOW FUNCTIONS) – 20 Questions

-- 1. Assign row numbers to each order.
-- 2. Rank products by price.
-- 3. Dense rank products by sales.
-- 4. Find running total of sales.
-- 5. Calculate cumulative sum by month.
-- 6. Find moving average of last 3 days.
-- 7. Calculate lag of previous day sales.
-- 8. Calculate lead of next day sales.
-- 9. Find difference between current and previous sale.
-- 10. Partition sales by region.
-- 11. Find top 3 products per category.
-- 12. Find bottom 2 customers by sales.
-- 13. Calculate percentage of total sales.
-- 14. Calculate NTILE distribution of customers.
-- 15. Find first order per customer.
-- 16. Find last order per customer.
-- 17. Calculate average salary within department.
-- 18. Compare current row with max value in partition.
-- 19. Identify duplicate records using ROW_NUMBER.
-- 20. Find cumulative distinct count.