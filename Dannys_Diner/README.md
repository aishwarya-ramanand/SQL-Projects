# 🍽️ Danny’s Diner — SQL Case Study  
### **By Aishwarya Maiya**

![SQL Badge](https://img.shields.io/badge/SQL-MySQL-blue)  
![Data Analysis](https://img.shields.io/badge/Data%20Analysis-SQL%20Queries-green)  
![Beginners Case Study](https://img.shields.io/badge/Case%20Study-Danny's%20Diner-orange)  
![Portfolio Project](https://img.shields.io/badge/Project-Portfolio-purple)

---

## 📌 **Overview**

Danny’s Diner is a popular introductory SQL case study designed to test business analytics skills using real-world restaurant data.  
The goal is to help Danny understand customer behavior, spending patterns, and menu performance so he can improve his business.

This project demonstrates strong SQL skills including joins, aggregations, window functions, CTEs, ranking, subqueries, and date logic.

---

## 📊 **Datasets Used**

The case study consists of **3 tables**:

### 🧾 `sales`
| customer_id | order_date | product_id |
|-------------|------------|------------|

### 🍱 `menu`
| product_id | product_name | price |

### 🎖️ `members`
| customer_id | join_date |

---

## 🎯 **Business Questions Answered**

Below are the 10 key questions from the case study:

1️⃣ What is the total amount each customer spent at the restaurant?  
2️⃣ How many days has each customer visited the restaurant?  
3️⃣ What was the first item purchased by each customer?  
4️⃣ What is the most purchased item on the menu?  
5️⃣ Which item was purchased first after becoming a member?  
6️⃣ Which item was purchased just before becoming a member?  
7️⃣ What is the total items + amount spent before a customer became a member?  
8️⃣ What is the loyalty score / ranking of each member?  
9️⃣ What is the cumulative spend per customer?  
🔟 What is the points-based reward system output?

---

## 🛠️ **Skills & SQL Concepts Used**

This case study covers a wide range of SQL techniques, including:

✔️ JOINs (INNER, LEFT, RIGHT)  
✔️ GROUP BY + Aggregations  
✔️ Window Functions  
✔️ Ranking Functions (`ROW_NUMBER`, `RANK`)  
✔️ Common Table Expressions (CTEs)  
✔️ Subqueries  
✔️ Date Comparisons  
✔️ CASE WHEN logic  
✔️ Calculating Points and Membership Rewards  

---

## 🧠 **Approach**

The analysis was performed step-by-step:

1. Explored and validated each dataset  
2. Joined tables to create a unified customer-order dataset  
3. Used window functions to identify first purchases and ranking behavior  
4. Computed total revenue, customer visits, and menu preferences  
5. Analyzed pre-membership vs post-membership behavior  
6. Calculated loyalty metrics and reward points  
7. Summarized final insights for Danny

---

## ✨ **Insights (Summary)**

📌 Customers **A & B** are the highest spenders  
📌 The most popular item is **ramen**  
📌 Customers tend to spend **more after joining** the membership  
📌 Loyalty points strongly correlate with **high-value items**  
📌 Purchases before joining membership reveal interesting behavioral patterns  

*(You can update this section based on your actual outputs.)*

---

## 📂 **Project Structure**


---


Dannys_Diner/
│── Danny’s Diner.sql
│── README.md



---

## ▶️ **How to Use This Repository**

1. Open the SQL file: `Danny's Diner.sql`  
2. Run each query step-by-step  
3. Review outputs and insights  
4. Modify queries as needed to explore deeper customer patterns  

---

## 🚀 **Future Enhancements**

🔹 Convert SQL results into a dashboard (Tableau / Power BI)  
🔹 Build a customer segmentation model  
🔹 Perform menu profitability analysis  
🔹 Visualize loyalty patterns  

---

## 🙌 **Acknowledgements**

Case study by **Danny Ma**  
Part of the **8 Week SQL Challenge**

---

### ⭐ If you found this helpful, feel free to star the repo!
