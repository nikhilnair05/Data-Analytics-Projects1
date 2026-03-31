# Week 3 Day 3 - Subplots & Multi-Chart Dashboards
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Load the dataset
df = pd.read_csv(r"D:\Nikhil\DataAnalytics\Week2\archive\SampleSuperstore.csv")
df["Profit_Margin"] = round(df["Profit"] / df["Sales"] * 100, 2)

# Prepare Data
region_sales = df.groupby("Region")["Sales"].sum().sort_values(ascending=False)
category_profit = df.groupby("Category")["Profit"].sum().sort_values(ascending=False)
sub_margin = df.groupby("Sub-Category")["Profit_Margin"].mean().sort_values()
pivot_table = df.pivot_table(values="Profit_Margin", index="Region", columns="Category", aggfunc="mean")

# Create 2x2 dashboard
fig, axes = plt.subplots(2, 2, figsize=(14, 9))
fig.suptitle("Superstore Sales & Profit Analysis", fontsize=16, fontweight="bold", y=1)

# Chart 1 — Top left: Sales by Region
axes[0, 0].bar(region_sales.index, region_sales.values, color="steelblue")
axes[0, 0].set_title("Total Sales by Region")
axes[0, 0].set_xlabel("Region")
axes[0, 0].set_ylabel("Total Sales ($)")

# Chart 2 — Top right: Profit by Category
axes[0, 1].bar(category_profit.index, category_profit.values, color=["green", "orange", "red"])
axes[0, 1].set_title("Total Profit by Category")
axes[0, 1].set_xlabel("Category")
axes[0, 1].set_ylabel("Total Profit ($)")

# Chart 3 — Bottom left: Profit Margin by Sub-Category
axes[1, 0].barh(sub_margin.index, sub_margin.values, color="coral")
axes[1, 0].set_title("Average Profit Margin by Sub-Category")
axes[1, 0].set_xlabel("Profit Margin (%)")
axes[1, 0].axvline(x=0, color="black", linewidth=0.8)

# Chart 4 — Bottom right: Heatmap of Profit Margin by Region & Category
sns.heatmap(pivot_table, annot=True, fmt=".1f", cmap="RdYlGn", ax=axes[1, 1])
axes[1, 1].set_title("Average Profit Margin by Region and Category)")
plt.tight_layout()
plt.show()
