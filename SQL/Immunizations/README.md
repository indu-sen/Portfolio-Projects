# Immunizations Analysis 

### Background

The data analysis projects aim to create a comprehensive flu shots dashbard for the year 2022. 

The dashboards provides insights into the distribution of flu shots among patients, categorizing them by age, race, county, and providing overall statistics. 

It also features a dynamic display of the cumulative flu shots administered throughout the year, the overall count of flu shots given, and a roster of patients who have received the flu shots.

### Data Source
The dataset used for this analysis was sourced from Synthea. 

Synthea is an open source program that was developed by the MITRE corporation. It is programmed to randomly generate patient data. In other words, it is a simulation modeled after the data that a hospital might generate into an electronic medical record system.

Two main tables, patients and immunization, from Synthea were used. The patients table contains patient demographics, and the immunizations table includes information about immunization events. 

The two tables are included in this respiratory. 

## Tools 
- MySQL Server - Data Analysis
- Tableau - Dashboard

## Process

Step 1- **Identifying Active Patients:** To ensure that we only include patients who were active at our hospitals, we created a common table expression (CTE) named active_patients. This CTE filters patients who had encounters between January 1, 2020, and December 31, 2022, were not deceased, and were at least 6 months old by December 31, 2022.

```sql
with active_patients as
(
	select distinct patient
	from encounters as e
	join patients as pat
	  on e.patient = pat.id
	where start between '2020-01-01 00:00' and '2022-12-31 23:59'
	  and pat.deathdate is null
	  and extract(month from age('2022-12-31',pat.birthdate)) >= 6
),
```
Step 2 - **Identifying Flu Shots in 2022:** We created another CTE to gather information about flu shots administered in 2022. We select patients who received a flu shot with the code '5302' within the specified date range (January 1, 2022, to December 31, 2022) and aggregate their data to find the earliest flu shot date.

```sql
flu_shot_2022 as
(
select patient, min(date) as earliest_flu_shot_2022 
from immunizations
where code = '5302'
  and date between '2022-01-01 00:00' and '2022-12-31 23:59'
group by patient
)
```
Step 3 - **Building the Dashboard:** We created the main query to generate the ful shots dashboard. We retrieved various patient attributes such as birthdate, race, county, first name, last name, and unique identifiers. We also join the flu_shot_2022 CTE to indicate whether each patient received a flu shot in 2022 ('Yes' or 'No') and provide the earliest flu shot date if applicable.

The query filters out patients who are not in the list of active patients obtained from the active_patients CTE.

```sql
select pat.birthdate
      ,pat.race
	  ,pat.county
	  ,pat.id
	  ,pat.first
	  ,pat.last
	  ,pat.gender
	  ,extract(YEAR FROM age('12-31-2022', birthdate)) as age
	  ,flu.earliest_flu_shot_2022
	  ,flu.patient
	  ,case when flu.patient is not null then 1 
	   else 0
	   end as flu_shot_2022
from patients as pat
left join flu_shot_2022 as flu
  on pat.id = flu.patient
where 1=1
  and pat.id in (select patient from active_patients)
```


## Dashboard Components

The dashboard consits of the following compoenents: 

1. Total percentage of patients getting Flu Shots stratified by age, race, county, and overall. These percentages will be calculated based on the total number of patients who received flu shots and the total number of active patients.
2. Running total of Flu Shots that shows the cumulative number of flu shots administered throughout 2022. It will show the trend of flu shot administration over time.
3. List of patients and Flu Shot status. A table listing patients' attributes and indicating whether they received a flu shot in 2022. Patients will be categorized as 'Yes' or 'No' based on their flu shot status.

The dasboard can be viewed [here](https://public.tableau.com/app/profile/indu.sen1237/viz/ImmunizationDashboard_17032121398330/Dashboard1?publish=yes).

The 2022 flu shots dashboard delivers a thorough analysis of flu shot administration among active patients.

It provides insights into the distribution of flu shots, considering factors such as age, race, and county, while also providing an overall perspective. 

The dynamic graph illustrating the running total and the cumulative count of flu shots presents a clear picture of vaccination trends over the course of the year. 

Furthermore, the patient list, indicating flu shot status, aids in the identification of individuals who have undergone vaccination. This dashboard serves as a valuable tool for data-driven decision-making and enriches comprehension of flu shot distribution patterns.





