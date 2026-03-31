# Week 3 Day 1 - Introduction to Matplotlib
import pandas as pd
import matplotlib.pyplot as plt

# Load the dataset
df = pd.read_csv(r"D:\Nikhil\DataAnalytics\Week2\archive\SampleSuperstore.csv")
df["Profit_Margin"] = round(df["Profit"] / df["Sales"] * 100, 2)

# 1. Bar chart of total sales by region
sales_by_region = df.groupby("Region")["Sales"].sum()
plt.bar(sales_by_region.index, sales_by_region.values)
plt.xlabel("Region")
plt.ylabel("Total Sales")
plt.title("Sales by Region")
plt.show()

# 2. Horizontal Bar Chart — Average Profit Margin by Sub-Category
sub_margin = df.groupby("Sub-Category")["Profit_Margin"].mean().sort_values()

plt.figure(figsize=(8, 8))
plt.barh(sub_margin.index, sub_margin.values, color = "coral")
plt.title("Average Profit Margin by Sub-Category")
plt.xlabel("Profit Margin (%)")
plt.axvline(x=0, color="black", linewidth="0.8")
plt.tight_layout()
plt.show()
