# Week 4 Day 1 - Load Superstore data into MySQL
import pandas as pd
import mysql.connector

# Load the Superstore data from the CSV file
df = pd.read_csv(r"D:\Nikhil\DataAnalytics\Week2\archive\SampleSuperstore.csv")

# Connect to the MySQL database
conn = mysql.connector.connect(
    host="localhost",
    user="root",
     password="Admin@1234",
    database="superstore"    )

cursor = conn.cursor()
 # insert each row of the DataFrame into the MySQL table
for _, row in df.iterrows():
    cursor.execute("""
        INSERT INTO orders 
        (ship_mode, segment, country, city, state, postal_code, 
         region, category, sub_category, sales, quantity, discount, profit)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    """, tuple(row))

conn.commit()
print("Data loaded successfully! Rows inserted:", len(df))
conn.close()




