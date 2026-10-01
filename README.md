Vehicle Theft Analysis — New Zealand

Project Overview
Vehicle theft in New Zealand affects communities and creates operational challenges for police. In this project,  historical vehicle theft data was analyzed to identify patterns in where, when, and what types of vehicles were being stolen.
The main goal was to understand the patterns in the data and identify findings that could be useful for prevention planning, investigation, and resource allocation.
MySQL was used for the data analysis and Tableau for visualization and further analysis.

Business Problem
The analysis focuses on three main questions:
•	Where are vehicle thefts most concentrated?
•	When does vehicle theft activity increase or decrease?
•	Which vehicle makes and types are most frequently stolen?
I also looked at whether the patterns were different across regions and compared raw theft numbers with population-adjusted theft rates.

Stakeholders
The main identified stakeholders for this analysis are:
•	Police leadership — to understand overall vehicle theft patterns and where resources may be needed.
•	District commanders — to understand theft patterns within their regions.
•	Police intelligence and analysts — to investigate geographic, time-based, and vehicle-level patterns.

Dataset
The project uses three tables:
•	stolen_vehicles - contains the vehicle theft records and vehicle information.
•	locations - contains region and population information.
•	make_details - contains vehicle make and make classification information.
The dataset contains 4,707 vehicle theft records.
The records cover October 2021 to April 2022. April 2022 only contains the first few days of the month, so I excluded it when interpreting the monthly trend.

Data Quality Checks
Before starting the analysis, some basic data-quality checks were carried out.
These included:
•	Checking the total number of records
•	Checking for missing vehicle IDs
•	Checking for duplicate vehicle IDs
•	Checking for missing vehicle types
•	Checking for missing theft dates
•	Checking for missing location IDs
•	Checking for missing make IDs
•	Checking the date range of the data
•	Checking the relationships between the tables
•	Reviewing unexpected or inconsistent values

Methodology
The project followed this process:
Raw Data
   ↓
Data Quality Checks
   ↓
SQL Analysis
   ↓
Export Analysis Results to CSV
   ↓
Tableau
   ↓
Visualizations and Additional Calculations
   ↓
Findings and Recommendations

SQL
I used MySQL to:
•	Explore the data
•	Check data quality
•	Join the three tables
•	Calculate theft counts
•	Analyze theft by month and day of the week
•	Calculate month-over-month changes
•	Analyze vehicle makes and vehicle types
•	Rank vehicle types and makes within regions
•	Compare Standard and Luxury vehicle classifications
•	Prepare tables for Tableau
SQL window functions such as LAG() and ROW_NUMBER() were used for the month-over-month and ranking analysis.

Tableau
The SQL results were exported as CSV files and used in Tableau.
In Tableau, visualizations were created and some additional analysis were carried out, including:
•	Population-adjusted theft rates
•	Aggregating vehicle-make theft counts across regions
•	Top-N filtering
•	Calculated fields
•	Selecting the most useful results for the final visualizations
For example, the regional vehicle-make data was exported from SQL and then aggregated in Tableau to look at the leading vehicle makes nationally.
I initially used a Top 10 filter and then displayed the leading seven makes because the remaining makes had relatively small 
and similar values and made the visualization more crowded.

Key KPIs
The main KPIs and measures used in the analysis were:

Theft
•	Total vehicle thefts
•	Theft by region
•	Theft by vehicle type
•	Theft by vehicle make

Time
•	Monthly theft volume
•	Month-over-month theft change
•	Theft by day of the week

Vehicle
•	Top stolen vehicle makes
•	Top stolen vehicle types
•	Top makes within vehicle types
•	Average vehicle age
•	Standard vs Luxury classification

Geography
•	Regional theft volume
•	Theft rate per 1,000 residents

Key Findings
1. Vehicle theft is not evenly distributed across the country
Auckland recorded the highest number of vehicle thefts, with 1,638 recorded thefts, representing around 36% of the total thefts in the dataset.
Southland recorded the lowest raw number of thefts.
However, raw theft numbers do not take population size into account. When I adjusted the figures for population, Gisborne had the highest theft rate at 3.38 thefts per 1,000 residents.
This shows why it is useful to look at both total theft volume and population-adjusted rates.

2. Three regions account for almost 60% of recorded thefts
Auckland, Bay of Plenty, and Canterbury together account for almost 60% of the recorded vehicle thefts.
This is a large share considering these are only three of the 13 regions in the analysis.
The result is based on the number of recorded thefts and does not mean that people or vehicles in these regions necessarily have a higher individual risk of theft.

3. Theft activity increased sharply in March 2022
Vehicle thefts increased during much of the period analyzed.
The month-over-month increase slowed from 20.7% in November to 3.1% in February, before increasing sharply to 38.0% in March.
April was not included in the trend analysis because the data only covers 1–6 April 2022. This was important because using April as a normal month would have given a misleading picture of the trend.

4. The week starts with higher theft activity
Monday and Tuesday had the highest recorded theft activity. Saturday had the lowest number of recorded thefts. This shows a clear pattern in the dataset, although more data would be needed to determine whether the same pattern continues over a longer period.

5. A small group of vehicle makes accounts for a large share of thefts
Toyota recorded the highest number of stolen vehicles by make.
I initially used a Top 10 filter in Tableau and then focused the final visualization on the leading seven makes. The remaining makes had much smaller and relatively similar numbers, so including all of them made the visualization harder to read.
The combined percentage of the selected leading makes was also calculated during the Tableau analysis.
This analysis shows the composition of the recorded thefts. It does not show the likelihood of a particular make being stolen because the dataset does not contain the number of vehicles of each make that were available to be stolen.

6. Trailers were the most frequently stolen vehicle type
Trailers recorded the highest number of thefts among the vehicle types analyzed.
Other frequently recorded vehicle types included:
•	Saloon
•	Stationwagon
•	Hatchback
•	Roadbike
•	Moped
•	Utility
The same vehicle types generally appeared among the leading categories across different regions.

7. The leading vehicle types are broadly consistent across regions
I compared the top vehicle types within each region.
For example, Auckland's leading vehicle types included:
•	Saloon
•	Stationwagon
•	Hatchback
•	Roadbike
•	Trailer
In Bay of Plenty, the leading types included:
•	Utility
•	Saloon
•	Stationwagon
The order and volume changed between regions, but many of the same vehicle types appeared across the analysis.
This suggests that the main regional difference is more noticeable in the amount of theft rather than completely different types of vehicles being stolen.

8. The leading makes differ between vehicle types
I also looked at the most frequently recorded makes within individual vehicle types.
Some examples from the analysis were:
Vehicle Type	Top Make	Second Make
Hatchback	Toyota	Mazda
Saloon	Nissan	Toyota
Boat Trailer	Trailer	Homebuilt
This provided another level of detail beyond simply looking at the overall top vehicle makes.

9. Standard vehicles account for most recorded thefts
Standard vehicles made up the majority of recorded thefts across most vehicle types.
For example:
Vehicle Type	Standard	Luxury
Trailer	100.0%	0.0%
Boat Trailer	100.0%	0.0%
Roadbike	98.7%	1.3%
Hatchback	96.7%	3.3%
Saloon	87.1%	12.9%
Some categories, such as sports cars and convertibles, also had notable recorded theft volumes.
However, these results show the composition of the stolen vehicles in this dataset. They do not tell us whether Standard or Luxury vehicles are more likely to be stolen.

Recommendations
Based on the patterns found in the analysis:

Regional prevention
The concentration of recorded thefts in Auckland, Bay of Plenty, and Canterbury suggests that these regions could be considered when planning prevention and investigation activities.
At the same time, population-adjusted rates provide another perspective. Regions such as Gisborne and Nelson could be investigated further because their rates are different from what their raw theft numbers alone would suggest.

Beginning of the week
The higher theft activity recorded on Monday and Tuesday could be considered when planning prevention activities or awareness messaging.

Trailer security
Because trailers recorded the highest theft volume among the vehicle types analyzed, targeted security advice and awareness campaigns for trailer owners could be considered.

Vehicle-specific messaging
Security messaging could also be targeted toward vehicle categories and makes that appear frequently in the theft records.
However, the results should not be interpreted as showing which vehicles are most likely to be stolen because the dataset does not contain the total number of vehicles in circulation.

Limitations
There are several limitations to this analysis.

Theft volume is not the same as theft risk
The dataset tells us how many thefts were recorded, but it does not tell us how many vehicles of each make or type were available to be stolen.
For example, Toyota appearing frequently among stolen vehicles does not automatically mean Toyota vehicles have a higher probability of being stolen.

Population differences
Regions have different population sizes, so comparing raw theft counts alone can be misleading.
This is why I also included the theft rate per 1,000 residents.

Incomplete April data
April 2022 only contains records for the first six days of the month, so I excluded it when interpreting the monthly trend.

Historical data
The analysis covers October 2021 to April 2022 and therefore represents a historical period rather than current vehicle theft activity.

Descriptive analysis
This project identifies patterns in the recorded data. It does not establish that one factor caused another.

Project Structure
vehicle-theft-analysis/
│
├── README.md
│
├── sql/
│   └── vehicle_theft_analysis.sql
│
├── data/
│   └── analysis_outputs/
│       ├── MoM_change.csv
│       ├── monthly_theft.csv
│       ├── num_stolen_eachdayofweek.csv
│       ├── regional_theft.csv
│       ├── regional_theft_by_vehicle_make.csv
│       ├── regional_type_theft.csv
│       ├── top2_regionaltheft_by_vehicle_make.csv
│       ├── top5_regional_theft_by_vehicle_type.csv
│       ├── vehicle_type_by_make_and_num_stolen_top2.csv
│       └── vehicle_type_standard_vs_luxury.csv
│
├── tableau/
│   └── dashboard_screenshot.png
│
└── screenshots/
    ├── regional_analysis.png
    ├── monthly_trends.png
    ├── vehicle_analysis.png
    └── day_of_week.png

Skills Demonstrated
SQL
•	MySQL
•	Data exploration
•	Data-quality checks
•	Joins
•	Aggregations
•	CTEs
•	Window functions
•	Conditional aggregation
•	Ranking
•	Date functions
•	Percentage calculations

Tableau
•	Calculated fields
•	Aggregation
•	Top-N filtering
•	Dashboard development
•	Interactive analysis
•	Regional analysis
•	KPI development
•	Data visualization

Data Analysis
•	Exploratory data analysis
•	Trend analysis
•	Geographic analysis
•	Vehicle segmentation
•	Population-adjusted comparisons
•	Identifying patterns
•	Translating findings into recommendations
•	Recognizing analytical limitations

Conclusion
This project gave me the opportunity to work through a complete data-analysis process, from checking and exploring the raw data to building SQL queries, exporting analysis-ready tables, and creating visualizations in Tableau.
The analysis identified patterns in where vehicle thefts were recorded, when theft activity was highest, and which vehicle makes and types appeared most frequently.
One of the main analytic takeaways from the project was the importance of looking beyond raw numbers. For example, regional theft counts and population-adjusted rates can give different perspectives, while high theft counts for a particular vehicle make do not necessarily mean that make has a higher theft risk.
Overall, the project combines SQL analysis, Tableau visualization, and business-focused interpretation to turn the raw vehicle theft records into a more useful set of findings.

