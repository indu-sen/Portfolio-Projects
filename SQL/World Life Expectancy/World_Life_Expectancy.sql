#World Life Expectancy Project (Data Cleaning)

SET SQL_SAFE_UPDATES = 0; 

select * from world_life_expectancy;

select Country, 
		Year, 
        concat(Country, Year), 
        count(concat(Country,Year))
from world_life_expectancy
group by Country, Year, concat(Country, Year)
having count(concat(Country, Year)) > 1;

select *
from(
	select Row_ID, 
			concat(Country, Year),
			row_number() over(partition by concat(Country, Year) Order By Concat(Country, Year)) as Row_Num
	from world_life_expectancy
) as Row_Table
where Row_Num > 1;

delete from world_life_expectancy
where 
	Row_ID IN (
    Select Row_ID
from (
	select Row_ID, 
			concat(Country, Year),
			row_number() over(partition by concat(Country, Year) Order By Concat(Country, Year)) as Row_Num
	from world_life_expectancy
) as Row_Table
where Row_Num > 1
);

select * from world_life_expectancy
where Status = '';

select * from world_life_expectancy
where Status is null;

select distinct(Status)
from world_life_expectancy
where Status <> '';

select distinct(Country)
from world_life_expectancy
where Status = "Developing";

update world_life_expectancy
set Status = "Developing"
where Country IN (select distinct(Country)
	from world_life_expectancy
	where Status = "Developing"
    );
    
update world_life_expectancy t1
	join world_life_expectancy t2
		on t1.Country = t2.Country
set t1.Status = 'Developing'
where t1.Status = ''
and t2.Status <> ''
and t2.Status = "Developing" 
;

select *
from world_life_expectancy
where Country = 'United States of America';

update world_life_expectancy t1
	join world_life_expectancy t2
		on t1.Country = t2.Country
set t1.Status = 'Developed'
where t1.Status = ''
and t2.Status <> ''
and t2.Status = "Developed" 
;

select * from world_life_expectancy
where `Life expectancy` = '';

select Country, Year, `Life expectancy`
from world_life_expectancy;
#where `Life expectancy` = ''

select 
t1.Country, t1.Year, t1.`Life expectancy`, 
t2.Country, t2.Year, t2.`Life expectancy`,
t3.Country, t3.Year, t3.`Life expectancy`,
round((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
from world_life_expectancy t1
join world_life_expectancy t2
	on t1.Country = t2.Country
    and t1.Year = t2.Year - 1
join world_life_expectancy t3
	on t1.Country = t3.Country
    and t1.Year = t3.Year + 1
where t1.`Life expectancy` = ""
;

update  world_life_expectancy t1
join world_life_expectancy t2
	on t1.Country = t2.Country
    and t1.Year = t2.Year - 1
join world_life_expectancy t3
	on t1.Country = t3.Country
    and t1.Year = t3.Year + 1
set t1.`Life expectancy`  = round((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
where t1.`Life expectancy` = ""
; 

select Country, 
	min(`Life expectancy`), 
    max(`Life expectancy`),
    round(max(`Life expectancy`) - min(`Life expectancy`),1) as Life_increase_15_Years
from world_life_expectancy
group by Country
having min(`Life expectancy`) <> 0 and max(`Life expectancy`) <> 0 
order by Life_increase_15_Years asc;

select Year, round(avg(`Life expectancy`),2)
from world_life_expectancy
where `Life expectancy` <> 0 and `Life expectancy` <> 0 
group by Year
order by Year;

select *
from world_life_expectancy;

select Country, round(avg(`Life expectancy`),1) as Life_Exp, round(avg(GDP),1) as GDP
from world_life_expectancy
group by Country
having Life_Exp > 0 and GDP > 0
order by GDP asc;

select Country, round(avg(`Life expectancy`),1) as Life_Exp, round(avg(GDP),1) as GDP
from world_life_expectancy
group by Country
having Life_Exp > 0 and GDP > 0
order by GDP desc;

select 
sum(case 
	when GDP >= 1500  THEN 1 
    ELSE 0
end) High_GDP_Count
from world_life_expectancy;

select
sum(case when GDP >= 1500 THEN 1 ELSE 0 END) High_GDP_Count,
avg(case when GDP >=1500 THEN `Life expectancy` else null end) High_GDP_Life_Expectancy,
sum(case when GDP <= 1500 THEN 1 ELSE 0 END) Low_GDP_Count,
avg(case when GDP <=1500 THEN `Life expectancy` else null end) Low_GDP_Life_Expectancy
from world_life_expectancy;

select Status, round(avg(`Life expectancy`),1)
from world_life_expectancy
group by Status;

select Status, round(avg(`Life expectancy`),1)
from world_life_expectancy
group by Status;

select Status, count(distinct Country), round(avg(`Life expectancy`),1)
from world_life_expectancy
group by Status;

select Country, round(avg(`Life expectancy`),1) as Life_Exp, round(avg(BMI),1) as BMI
from world_life_expectancy
group by Country
having Life_Exp > 0 and BMI > 0
order by BMI desc;

select Country, round(avg(`Life expectancy`),1) as Life_Exp, round(avg(BMI),1) as BMI
from world_life_expectancy
group by Country
having Life_Exp > 0 and BMI > 0
order by BMI asc;

select Country, 
		Year, 
        `Life expectancy`,
        `Adult Mortality`,
        sum(`Adult Mortality`) over (partition by Country Order by Year) as Rolling_Total 
from world_life_expectancy
where Country = "United States of America";



        
        




    
