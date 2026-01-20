# Movie-Rating-Recommendation-Insight
A complete end-to-end data analysis project using Python, SQL, and Power BI, built on the Movie Lens Dataset.

##  Project Overview
This project analyzes user movie ratings to generate meaningful insights such as:

-  Top-rated movies  
-  Popular genres  
-  User behavior patterns  
-  Genre preferences by age & gender  
-  Movie popularity trends  
-  Recommendation-based metrics  

The workflow includes:
- **Data Cleaning** (Python)
- **Data Modeling** (SQL + Star Schema)
- **Exploratory Analysis** (Jupyter Notebook)
- **Interactive Dashboard** (Power BI)

##  Project Files
| File | Description |
|------|-------------|
| movies.csv | Movie details dataset |
| users.csv | User demographics |
| ratings.csv | User ratings |
| links.csv | Movie external IDs |
| user_occupations.csv | Occupation mapping |
| MovieRating.ipynb | Python data analysis notebook |
| operations.sql | All SQL queries & table transformations |
| project.pbxi.pbix | Power BI Dashboard |

##  Tech Stack
- **Python** (Pandas, Matplotlib, Seaborn)
- **MySQL**
- **Power BI**
- **DAX**
- **Data Modeling (Dimension & Fact tables)**

##  Data Preparation (Python Notebook)  
Tasks performed:
✔ Loading CSV datasets  
✔ Handling missing values  
✔ Extracting release year from movie titles  
✔ Transforming genres  
✔ Descriptive statistics  
✔ Data visualization  

##  SQL Operations
All SQL scripts are stored inside operations.sql.

### Key SQL Tasks:
- Split genre column into movie_genres table  
- Top-rated genres by age groups  
- Top 10 highest-rated movies (min 50 ratings)  
- Most active users  
- Popular genre combinations  
- Movies above 4.5 rating (last 12 months)  
- User rating distribution  
- Average rating per movie  

##  Power BI Dashboard
The dashboard includes KPIs, charts, trends, heatmaps, and filters for deep analysis.

##  Important DAX Measures
### Total Movies  
```
Total Movies = DISTINCTCOUNT(Movies[movieId])
```

### Average Rating  
```
Average Rating = AVERAGE(Ratings[rating])
```

### Total Users  
```
Total Users = DISTINCTCOUNT(Users[userId])
```

##  How to Run the Project
###  Load Data in MySQL  
Import CSVs and run:
```
SOURCE operations.sql;
```

###  Run Jupyter Notebook  
Open MovieRating.ipynb and run all cells.

###  Open Power BI Dashboard  
Open project.pbxi.pbix and reconnect data sources.

##  Future Improvements
- ML recommendation system  
- NLP genre extraction  
- Time-series rating prediction 
