# Creating a Superstore Business Analysis Report
import pandas as pd
# Load the dataset
df = pd.read_csv(r"D:\Nikhil\DataAnalytics\Week2\archive\SampleSuperstore.csv")

# Add Profit Margin column 
df["Profit_Margin"] = round(df["Profit"] / df["Sales"] * 100, 2)

# Top 5 and bottom 5 Sub-Categories by profit margin
print("---Top 5 Sub-Categories by Profit Margin---")
print(df.groupby("Sub-Category")["Profit_Margin"].mean().sort_values(ascending=False).head(5))
print("\n---Bottom 5 Sub-Categories by Profit Margin---")
print(df.groupby("Sub-Category")["Profit_Margin"].mean().sort_values(ascending=False).tail(5))

# Regional sales and profit summary using groupby
print("\n---Regional Sales and Profit Summary---")
print(df.groupby("Region")[["Sales", "Profit"]].sum()) 

# A pivot table of your choice that tells an interesting story
print("\n---Pivot Table: Average Profit Margin by Segment and Category---")
pivot_profit_margin = pd.pivot_table(df,
     values="Profit_Margin",
      index="Segment",
        columns="Category",
          aggfunc="mean",
            fill_value=0)
print(round(pivot_profit_margin, 2))

#
print("\n---Business Insights---")
print("1. The Technology category has the highest average profit margin, while Furniture has the lowest.")
print("2. The West region generates the highest total sales and profit, indicating a strong market  presence there.")
print("3. Home Office segment has the highest profit margins across all categories, suggesting premium pricing works better with home office customers.")