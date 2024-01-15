# Walmart's Sales Analysis 

## Project Overview

The data analysis projects aims to provide insights into the performance of Walmart's top branches and products, sales trends for various products, and understanding how different factors affect the sales of products.

## Data Source 

The dataset used for this analysis was sourced from the [Kaggle Walmart Sales Forecasting Competition](https://www.kaggle.com/c/walmart-recruiting-store-sales-forecasting).

This dataset contains anonymized sales transactions from three different branches of Walmart, respectively located in Mandalay, Yangon and Naypyitaw. 

Below is a data dictionary that provides details aobout the database and the data within it. The data contains 17 columns and 1000 rows:

| Column                  | Description                             | Data Type      |
| :---------------------- | :-------------------------------------- | :------------- |
| invoice_id              | Invoice of the sales made               | VARCHAR(30)    |
| branch                  | Branch at which sales were made         | VARCHAR(5)     |
| city                    | The location of the branch              | VARCHAR(30)    |
| customer_type           | The type of the customer                | VARCHAR(30)    |
| gender                  | Gender of the customer making purchase  | VARCHAR(10)    |
| product_line            | Product line of the product solf        | VARCHAR(100)   |
| unit_price              | The price of each product               | DECIMAL(10, 2) |
| quantity                | The amount of the product sold          | INT            |
| VAT                 | The amount of tax on the purchase       | FLOAT(6, 4)    |
| total                   | The total cost of the purchase          | DECIMAL(10, 2) |
| date                    | The date on which the purchase was made | DATE           |
| time                    | The time at which the purchase was made | TIMESTAMP      |
| payment_method                 | The total amount paid                   | DECIMAL(10, 2) |
| cogs                    | Cost Of Goods sold                      | DECIMAL(10, 2) |
| gross_margin_percentage | Gross margin percentage                 | FLOAT(11, 9)   |
| gross_income            | Gross Income                            | DECIMAL(10, 2) |
| rating                  | Rating                                  | FLOAT(2, 1)    |

## Tools 
- MySQL Server - Data Analysis

## Data Cleaning/Preparation 

In the inital data prepration phase, we performed the following tasks:

1. Data Wrangling 
2. Feature Engineering 

### Data Wrangling 

During this first step, the data was inspected to identify and address NULL values. 

1. Build a database.
2. Create the table and insert the data. 
3. Choose columns containing null values. Our database does not have any null values because during the table creation, we specified NOT NULL for each field, ensuring that null values are excluded.

```sql
-- Create database
create database if not exists salesDataWalmart;

use salesDataWalmart;

-- Create table
create table if not exists sales (
    invoice_id varchar(30) not null primary key,
    branch varchar(5) not null, 
    city varchar (30) not null,
    customer_type varchar(30) not null,
    gender varchar(10) not null,
    product_line varchar(100) not null, 
    unit_price decimal(10,2) not null,
    quantity int not null, 
    VAT float (6,4) not null,
    total decimal(12,4) not null,
    date datetime not null,
    time time not null, 
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9) NOT NULL,
    gross_income DECIMAL(12, 4) NOT NULL,
    rating FLOAT(2, 1) NOT NULL
    );
```

### Feature Engineering 

During this, we created new columns from existing columns to help answer analysis questions (below). 

1. Added a new colmun called "time_of_day" to provide insights into sales during the Morning, Afternoon, and Evening. This addition will facilitate answering questions regarding the peak times for sales.
2. Added a new column named "day_name" that captures the days of the week (Mon, Tue, Wed, Thur, and Fri) on which each day a transaction occurred. This column aims to address inquiries about the busiest days of the week for each branch.
3. Added a new column named "month_name" that extracts the months of the year from the transaction dates (Jan, Feb, Mar). This column will assist in determining the month with the highest sales and profit.

## Exploratory Data Analysis (EDA)

EDA involved exploring the sales data to answer key analysis regarding the Product, Sales, and Customer: 

1. Product: Conduct analysis on the data to understand the different product lines, identify the top-performing product lines, and pinpoint areas where improvement is needed for certain product lines.
2. Sales: Conduct analysis to explore the sales trends of products. The outcomes of this analysis will assist in evaluating the effectiveness of each applied sales strategy and determining necessary modifications to enhance sales performance.
3. Customer: Conduct analssyiss to uncover the various customer segments, analyze purchase trends within these segments, and assess the profitability associated with each customer segment.

### Specific Business Questions Regarding the Product, Sales, and Customer Analysis: 

#### General Overview Questions: 

1. How many unique cities does the data have?
2. In which city is each branch?

#### Product Questions: 

1. How many unique product lines does the data have?
2. What is the most common payment method?
3. What is the most selling product line?
4. What is the total revenue by month?
5. What month had the largest COGS?
6. What product line had the largest revenue?
5. What is the city with the largest revenue?
6. What product line had the largest VAT?
7. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
8. Which branch sold more products than average product sold?
9. What is the most common product line by gender?
12. What is the average rating of each product line?

#### Sales: 

1. Number of sales made in each time of the day per weekday
2. Which of the customer types brings the most revenue?
3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?
4. Which customer type pays the most in VAT?

#### Customer:

1. How many unique customer types does the data have?
2. How many unique payment methods does the data have?
3. What is the most common customer type?
4. Which customer type buys the most?
5. What is the gender of most of the customers?
6. What is the gender distribution per branch?
7. Which time of the day do customers give most ratings?
8. Which time of the day do customers give most ratings per branch?
9. Which day of the week has the best avg ratings?
10. Which day of the week has the best average ratings per branch?

## Code

The SQL queries can be found at [here](https://github.com/indu-sen/Portfolio-Projects/blob/main/SQL/Walmart's%20Sales/walmart_sale.sql). 









   


