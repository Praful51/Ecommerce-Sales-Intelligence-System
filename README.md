# Ecommerce-Sales-Intelligence-System

An end-to-end data analytics project combining Python, SQL, Statistics, Machine Learning, and Power BI to extract actionable business insights from e-commerce transaction data.
---

**Project Overview**

This project simulates a real-world e-commerce analytics pipeline built on a synthetic dataset of 5,000 customer transactions. The goal is to understand customer purchase behavior, validate business hypotheses statistically, and predict future purchases using machine learning — all presented through an interactive Power BI dashboard.

**Tech Stack**

Data Wrangling & EDA =	Python, Pandas, NumPy, Matplotlib, Seaborn
Statistical Testing = SciPy, Statsmodels
Database & Querying	= MYSQL
Machine Learning = Scikit-learn (LogisticRegression & Random Forest)
Dashboard	= Power BI
Version Control	= Git, GitHub
---

**Key Steps**

1. Date Cleaning & Preprocessing

Started with quick understanding of the data by viewing few of the first columns, checked for the datatypes looked for duplicate & missing values where payment method had null values which i imputed with **None** as to preserve those rows and maintain business logic consistency, since customers who did not complete a purchase would not have an associated payment method.

3. Exploratory Data Analysis (EDA)
   
Analyzed revenue distribution across categories and regions

Plotted a correlation heatmap in order to look for the correlation across all numeric features

Analysed the return rate across categories for understanding which category had the most return rate

Checked for the discount impact on orders to know if promotional(discounted) pricing played a major role in customer purchasing behavior 


5. Hypothesis Testing (Statistics Layer)

## 📊 Hypothesis Testing (Statistics Layer)

Two statistical tests were performed to validate key business assumptions.

---

### Test 1 — Does revenue differ across customer segments?
**Method:** One-Way ANOVA (`f_oneway`)

| | |
|---|---|
| **H0** | Revenue is equal and does not differ across customer segments |
| **H1** | Revenue is not equal and differs across customer segments |
| **F-statistic** | *(your f_stat value)* |
| **p-value** | 1.14e-18 |
| **Decision** | **Fail to Reject H0** (p > 0.05) |

**Interpretation:**
There is no statistical evidence that revenue differs across customer segments.
This is validated by the average revenue per segment being nearly identical:

| Segment | Avg Revenue |
|---|---|
| Loyal | ₹8,257.79 |
| Returning | ₹8,265.98 |
| New | ₹8,007.62 |

The difference between segments is too small to be statistically significant.

---

### Test 2 — Does discount affect revenue?
**Method:** Independent t-test (`ttest_ind`)

| | |
|---|---|
| **H0** | There is no difference in revenue after discount is applied |
| **H1** | There is a difference in revenue after discount is applied |
| **p-value** | 3.67e-09 |
| **Decision** | **Reject H0** (p < 0.05) |

**Interpretation:**
Statistical evidence confirms that applying a discount significantly affects revenue.
Orders **without** discount generated higher average revenue than orders **with** discount:

| Group | Avg Revenue |
|---|---|
| No Discount Applied | ₹9,465 |
| Discount Applied | ₹7,764 |


8. Power BI Dashboard

Built a 4-page interactive dashboard:
Page 1 — Sales Overview: KPIs, monthly trend, revenue by category
Page 2 — Customer Intelligence: segment analysis, channel performance, return rates
Page 3 — ML Predictions: purchase probability by segment, high-value customer table
Page 4 — Hypothesis Test Summary: results and plain-English interpretations
---

**Insights & Recommendations**

1. [Category X] generated the highest average revenue at ₹[value], while [Category Y] had the lowest
2. Loyal customers drove ₹[value] more revenue on average compared to New customers
3. Revenue peaked in Q[X], suggesting seasonal demand patterns
4. Applying a discount [did / did not] significantly affect purchase likelihood (p = [value])

5.[Channel X] had the highest purchase rate at [value]%
Recommendation: Increase marketing spend on top-performing channel and reduce investment in underperforming ones
6. Returns
[Region X] had the highest return rate at [value]%
Recommendation: Investigate product quality or delivery issues in that region


**Machine Learning Model**

Objective
Predict whether a customer will make a purchase (`purchase_made`: 0 or 1)

### Features Used
age, gender, region, customer_segment, category,
discount_offered, marketing_channel, review_score,
discount_pct, month, quarter

### Preprocessing
- Categorical encoding via `pd.get_dummies` with `drop_first=True`
- Leakage-free feature selection — all transaction-derived columns excluded
- Train / Test split: **80% / 20%**

---

### Models Trained & Compared

| Model | Accuracy | Precision | Recall | F1-Score |
|---|---|---|---|---|
| Logistic Regression | 62.4% | 0.62 | 0.62 | 0.62 |
| Random Forest (default) | 56.9% | 0.57 | 0.57 | 0.57 |
| Random Forest (tuned) | 61.5% | 0.62 | 0.61 | 0.61 |
| RF + Threshold (0.3) | 54.4% | 0.62 | 0.54 | 0.54 |

---

### Model Selection & Business Reasoning

> *"This is a synthetic dataset designed to simulate real-world behavior with controlled relationships. Instead of maximizing accuracy, the model was optimized for business impact."*

Three approaches were evaluated:

**Logistic Regression** performed best on raw accuracy (62.4%) and served as a strong, interpretable baseline.

**Random Forest tuned** (`n_estimators=200, max_depth=8, min_samples_split=10, class_weight='balanced'`) improved recall on purchasers (Class 1) to **0.69**, making it better at capturing actual buyers.

**Threshold Lowering (0.3)** pushed recall on Class 1 to **0.94** — meaning the model captures **9 out of 10 potential buyers**, at the cost of precision. This is the most valuable configuration in a **marketing context** where missing a real buyer is costlier than over-targeting.

---

### Final Chosen Strategy — Threshold Optimized RF

| Metric | Class 0 (No Purchase) | Class 1 (Purchase) |
|---|---|---|
| Precision | 0.73 | 0.52 |
| Recall | 0.16 | **0.94** |
| F1-Score | 0.26 | 0.67 |

**Confusion Matrix:**
Predicted →      0     1
Actual 0   [  82   425 ]
Actual 1   [  31   462 ]

**Business Insight:** The model correctly identifies 462 out of 493 actual buyers.
> In a marketing campaign, it is far more costly to miss a potential buyer than to
> send an extra promotional message — making high recall on Class 1 the right objective.
