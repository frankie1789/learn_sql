# Commercial Database Analysis Using SQL

## Project Overview

This project uses SQL to answer ten questions about a commercial
database containing employee, product, supplier, customer, and
order information.

The exercises explore employee salaries, product characteristics,
customer purchasing activity, order discounts, and yearly order
statistics.

## Questions Explored

1. Employee salaries and seniority
   Identify male employees whose salary plus commission is at
   least 8,000. Display their employee number, full name, age,
   and seniority, sorted by seniority in descending order.

2. Product filtering
   Find bottled products whose third name character is “t” or “T”,
   supplied by suppliers 1, 2, or 3, priced between 70 and 200,
   and with a non-null value for units ordered.

3. Customers and supplier locations
   Find customers sharing supplier 1’s country, city, and last
   three postal-code digits, using a single subquery.

4. Order discount rules
   For orders 10998–11003, calculate a new discount rate based
   on the total amount before discount. Display whether the
   old or new discount rate should apply.

5. Beverage suppliers
   Identify suppliers of beverage products and display their
   company names and contact details.

6. Dessert purchases
   Find customers in Berlin who have ordered at most one
   dessert product, including those who ordered none.

7. Monday orders in April 1998
   Calculate order totals for French customers who placed
   orders on Mondays in April 1998, while retaining customers
   without matching orders.

8. Customers who ordered every product
   Identify customers who have ordered all products in
   the database.

9. Order counts for French customers
   Count the orders placed by each customer from France.

10. Yearly order comparison
    Count orders placed in 1996 and 1997 and calculate the
    difference between the two totals.

## SQL Topics Covered

- Filtering and sorting records
- Text patterns and character positions
- Working with dates
- Handling NULL values
- Subqueries
- Conditional discount calculations
- Counting records and calculating totals
- Working with related business data

## Tools Used

- SQL
- Visual Studio Code
- Git and GitHub
