# Week 3 Day2  Seaborn
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
# Load the dataset
df = pd.read_csv(r"D:\Nikhil\DataAnalytics\Week2\archive\SampleSuperstore.csv")
df["Profit_Margin"] = round((df["Profit"] / df["Sales"]) * 100, 2)

#1. Bar Plot: Average Sales by region and segment
plt.figure(figsize=(10, 6))
sns.barplot(data=df, x="Region", y="Sales", hue="Segment", estimator="sum")
plt.title("Total Sales by Region and Segment")
plt.ylabel("Total Sales")
plt.show()
plt.close()

#2. Heatmap - Pivot table of profit margin
pivot  = df.pivot_table(values="Profit_Margin"
                        , index="Region", columns="Category", aggfunc="mean")

plt.figure(figsize=(10, 6))
sns.heatmap(pivot , annot=True, fmt=".1f", cmap="RdYlGn", linewidths=0.5)
plt.title("Average Profit Margin (%) by Region and Category")
plt.tight_layout()
plt.show()
plt.close()

#3. Boxplot — Profit distribution by Category
plt.figure(figsize=(10, 6))
sns.boxplot(data=df, x="Category", y="Profit")
plt.title("Profit Distribution by Category")
plt.ylabel("Profit ($)")
plt.show()
plt.close()
