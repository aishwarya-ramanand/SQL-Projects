# 🍕 Pizza Runner – SQL Case Study  
### **By Aishwarya Maiya**

![SQL Badge](https://img.shields.io/badge/SQL-MySQL-blue)  
![Data Cleaning](https://img.shields.io/badge/Data%20Cleaning-CTEs%20%7C%20Joins-green)  
![Case Study](https://img.shields.io/badge/Case%20Study-Pizza%20Runner-orange)  
![Portfolio Project](https://img.shields.io/badge/Project-Portfolio-purple)

---

## 📌 Overview

Pizza Runner is a delivery-based SQL case study where Danny (the owner) needs help analyzing his pizza delivery business.  
However, before analyzing the data, the dataset must be **cleaned, standardized, and validated**, as it contains missing values, formatting problems, and inconsistencies.

This project highlights:
- SQL Data Cleaning  
- Data Transformation  
- Business Analysis  
- Performance Metrics  
- Customer/runner behavior insights  

---

## 📊 Datasets Used

The case study includes **6 datasets**:

### 1️⃣ `runners`
Runner details such as registration dates.

### 2️⃣ `customer_orders`
Raw order data containing customer IDs, pizza IDs, and exclusions/extras.

### 3️⃣ `runner_orders`
Delivery data including pickup times, distances, and durations.

### 4️⃣ `pizza_names`
List of pizza names.

### 5️⃣ `pizza_recipes`
Ingredient list for each pizza.

### 6️⃣ `pizza_toppings`
List of toppings.

---

## 🎯 Case Study Questions

### **A. Pizza Metrics**
1. How many pizzas were ordered?  
2. How many unique customers made orders?  
3. How many successful orders were delivered?  
4. What are the most common order exclusions/extras?  
5. What is the most popular pizza size/type?  

### **B. Runner & Customer Experience**
6. How long does it take each runner to pick up an order?  
7. What is the average speed of runners?  
8. What was the cancellation rate per runner?  
9. What is the average delivery distance and time?  

### **C. Ingredient Analysis**
10. What are the most commonly used toppings?  
11. Which pizzas require the most ingredients?  

### **D. Pricing & Ratings**
12. How much revenue did the business generate?  
13. What is the average rating per runner?  
14. What is the compensation per delivery?

---

## 🛠️ SQL Concepts & Techniques Used

✔️ **Data Cleaning and Normalization**  
✔️ **Common Table Expressions (CTEs)**  
✔️ **String manipulation (SPLIT, TRIM, REPLACE)**  
✔️ **JOINs (INNER, LEFT)**  
✔️ **CASE WHEN logic**  
✔️ **Aggregations (COUNT, SUM, AVG)**  
✔️ **Window Functions**  
✔️ **Derived tables & subqueries**  
✔️ **NULL handling and data formatting**  

---

## 🧠 Approach

1. Cleaned and standardized all raw tables (`customer_orders`, `runner_orders`).  
2. Normalized exclusions/extras into separate rows.  
3. Converted distance/time values into consistent numeric formats.  
4. Combined cleaned tables using JOINs.  
5. Built metrics for orders, deliveries, speeds, and revenue.  
6. Analyzed toppings and pizza composition.  
7. Generated insights to improve operational efficiency.

---

## ✨ Insights Summary

📌 Most pizzas ordered: **Meatlovers & Vegetarian**  
📌 Runner performance varies significantly — pickup times are inconsistent  
📌 Majority of cancellations happen due to runner availability  
📌 Customer behavior shows preference for weekend orders  
📌 Toppings analysis helps identify popular ingredients for menu optimization  
📌 Delivery time and distance strongly influence customer satisfaction  



---

## 📂 Project Structure


---


Pizza_Runner/
│── Pizza_Runner.sql
│── README.md


---

---

## ▶️ How to Use This Repository

1. Open **Pizza_Runner.sql**  
2. Run each CTE step-by-step  
3. Review intermediate cleaned tables  
4. Execute analysis queries  
5. Summarize insights in your README or portfolio  

---

## 🚀 Future Enhancements

- Build a dashboard (Tableau / Power BI)  
- Add geospatial analysis for delivery optimization  
- Create a delivery time prediction model  
- Perform customer segmentation  

---

## 🙌 Acknowledgements

Case study by **Danny Ma**  
Part of the **8 Week SQL Challenge**

---

### ⭐ If this project helped you, feel free to star the repository!
