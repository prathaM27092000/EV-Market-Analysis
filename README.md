# Electric_Vehicles_Market_Analysis_MySQL
MySQL analysis of the Indian electric vehicle market, highlighting sales patterns and growth trends from 2022 to 2024.

# Electronic_Vehicles Sales Data Analysis

## Overview

This project involves a comprehensive analysis of the electric vehicle (EV) market in India, conducted by the data analytics team of G Motors, an automotive giant from the USA. Over the last 5 years, G Motors has grown its market share to 25% in the electric and hybrid vehicles segment in North America. As part of their global expansion strategy, G Motors is planning to launch its bestselling EV models in India, where the company's current market share is less than 2%.

Rahul Tendulkar, the chief of G Motors India, tasked the data analytics team with performing a detailed market study of the existing EV/Hybrid market in India to inform their expansion decisions. Yuzi Pandey, a data analyst at G Motors, is responsible for carrying out this analysis.

## Task Description

Imagine yourself as Yuzi Pandey, and perform the following tasks:

- **Objective:** Conduct a detailed analysis of the EV/Hybrid market in India using the provided datasets.
- **Tools:** You may use any tool of your choice, including Python, SQL, PowerBI, Tableau, Excel, and PowerPoint, to analyze and answer the questions.
- **Deliverables:** Create a Word document that includes your questions, SQL queries, and the corresponding answers. The document should be easy to understand and may include Excel charts to visually represent the data for specific questions.
- **Presentation:** The insights will be presented to Rahul Tendulkar, who values good storytelling and concise presentations.

## Dataset

The dataset used in this project is available via [Google Drive](https://drive.google.com/drive/folders/1ZYwIYYyu0DKmhXqIx9mJ-ARLa15tig2i?usp=sharing). It contains detailed records of EV sales by manufacturers and regions, along with information on overall vehicle sales, enabling a comprehensive analysis of the EV market in India.

## SQL Concepts and Techniques Used

### 1. Common Table Expressions (CTEs)
CTEs are utilized to simplify complex queries and improve readability. Defined using the `WITH` clause, CTEs allow the creation of temporary result sets that can be referenced within the main SQL query, making the logic more manageable.

### 2. Temporary Tables
Temporary tables store intermediate results that are reused in subsequent queries. This approach optimizes the execution of complex queries by reducing redundant calculations.

### 3. Window Functions
Window functions like `ROW_NUMBER()` and `RANK()` perform calculations across sets of table rows related to the current row, useful for tasks such as ranking manufacturers and identifying top-performing states.

### 4. Aggregate Functions
Functions like `SUM()` and `AVG()` summarize data across multiple records, essential for calculating total sales, penetration rates, and other key metrics.

### 5. Joins and Subqueries
Joins and subqueries combine data from different tables and filter results based on specific conditions, enabling comprehensive insights from the dataset.

## Project Structure

### 1. SQL Queries and Analysis
The core of the project consists of 14 SQL queries designed to answer specific business questions related to the EV market. Topics include:

- Identifying the top and bottom EV manufacturers.
- Calculating overall and regional EV penetration rates.
- Analyzing sales trends across fiscal years and quarters.
- Estimating revenue growth rates.

### 2. Key Findings
The results of each query provide insights into the EV market in India, including:

- **Top and Bottom Performers:** Identification of leading and lagging EV manufacturers.
- **Regional Penetration:** Insights into states with the highest EV adoption rates.
- **Sales Trends:** Analysis of sales trends, identifying peak and low seasons.
- **Growth Rates:** Estimation of revenue and sales growth rates.

## Conclusion

The "Electronic_Vehicles Sales Data Analysis" project provides a detailed examination of the EV market in India, using advanced SQL techniques to derive actionable insights. The findings are intended to support G Motors' strategic decision-making as they expand their presence in the Indian market.

## How to Use This Repository

1. Access the dataset via the provided [Google Drive link](https://drive.google.com/drive/folders/1ZYwIYYyu0DKmhXqIx9mJ-ARLa15tig2i?usp=sharing).
2. Review the SQL queries used in the analysis to understand the methodology.
3. Run the queries against the dataset to replicate results and explore additional insights.

