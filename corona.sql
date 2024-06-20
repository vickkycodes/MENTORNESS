

 --  Q1. Write a code to check NULL values
 SELECT * FROM [corona].[dbo].[Corona Virus Dataset] WHERE [Latitude] IS NULL;
SELECT * FROM [corona].[dbo].[Corona Virus Dataset] WHERE [Longitude]  IS NULL;
SELECT * FROM [corona].[dbo].[Corona Virus Dataset] WHERE [Date] IS NULL;
SELECT * FROM  [testing].[dbo].[Corona] WHERE [Recovered]  IS NULL;
SELECT * FROM  [testing].[dbo].[Corona] WHERE  [Deaths]  IS NULL;
SELECT * FROM  [testing].[dbo].[Corona] WHERE   [Confirmed]   IS NULL; 

-- Q3. check total number of rows
select count(*) AS TOTAL_ROWS
FROM  [testing].[dbo].[Corona];

-- Q4. Check what is start_date and end_date
SELECT 
    MIN([Date]) AS StartDate,
    MAX([Date]) AS EndDate
FROM 
   [testing].[dbo].[Corona];

   -- Q5. Number of month present in dataset
 SELECT COUNT(DISTINCT CAST(YEAR(DATE) AS VARCHAR) 
 + '-' + CAST(MONTH(DATE) AS VARCHAR)) AS Months
FROM [testing].[dbo].[Corona]
WHERE DATE IS NOT NULL;

-- Q6. Find monthly average for confirmed, deaths, recovered
SELECT 
    FORMAT(CAST([DATE] AS DATE), 'yyyy-MM') AS YearMonth,
    avg(CAST(Confirmed AS FLOAT)) AS Confrimed_Avg, 
	avg(CAST(Recovered AS FLOAT)) AS Recovered_Avg, 
	avg(CAST(Deaths AS FLOAT)) AS Deaths_Avg 
FROM  [testing].[dbo].[Corona]
GROUP BY FORMAT(CAST([DATE] AS DATE), 'yyyy-MM')
ORDER BY YearMonth;

-- Q7. Find most frequent value for confirmed, deaths, recovered each month 
WITH ConfirmedMonthly AS (
    SELECT  FORMAT(CAST([DATE] AS DATE), 'yyyy-MM') AS YearMonth, 
	confirmed, COUNT(*) AS ConfirmedCount FROM  [testing].[dbo].[Corona]
    GROUP BY   FORMAT(CAST([DATE] AS DATE), 'yyyy-MM'),  confirmed),
RankedConfirmed AS (
    SELECT  YearMonth,confirmed, ConfirmedCount, ROW_NUMBER() OVER (PARTITION BY YearMonth ORDER BY ConfirmedCount DESC) AS Rank
    FROM   ConfirmedMonthly),
DeathsMonthly AS (
    SELECT  FORMAT(CAST([DATE] AS DATE), 'yyyy-MM') AS YearMonth, deaths, COUNT(*) AS DeathsCount
    FROM  [testing].[dbo].[Corona] GROUP BY FORMAT(CAST([DATE] AS DATE), 'yyyy-MM'),  deaths),
RankedDeaths AS (
    SELECT   YearMonth,  deaths,  DeathsCount, ROW_NUMBER() OVER (PARTITION BY YearMonth ORDER BY DeathsCount DESC) AS Rank
    FROM  DeathsMonthly),
RecoveredMonthly AS (
    SELECT   FORMAT(CAST([DATE] AS DATE), 'yyyy-MM') AS YearMonth,  recovered,  COUNT(*) AS RecoveredCount
    FROM [testing].[dbo].[Corona]  GROUP BY    FORMAT(CAST([DATE] AS DATE), 'yyyy-MM'),recovered),
RankedRecovered AS (
    SELECt    YearMonth, recovered, RecoveredCount, ROW_NUMBER() OVER (PARTITION BY YearMonth ORDER BY RecoveredCount DESC) AS Rank
    FROM  RecoveredMonthly)
SELECT 
    c.YearMonth,  c.confirmed AS MostFrequentConfirmed,  d.deaths AS MostFrequentDeaths,  r.recovered AS MostFrequentRecovered
FROM 
    RankedConfirmed c
    LEFT JOIN RankedDeaths d ON c.YearMonth = d.YearMonth AND d.Rank = 1
    LEFT JOIN RankedRecovered r ON c.YearMonth = r.YearMonth AND r.Rank = 1
WHERE    c.Rank = 1
ORDER BY    c.YearMonth;

--Q8 Find minimum values for confirmed, deaths, recovered per year
SELECT 
    FORMAT(CAST([DATE] AS DATE), 'yyyy') AS YearMonth,
    min(CAST(Confirmed AS FLOAT)) AS Confrimed_min, 
	min(CAST(Recovered AS FLOAT)) AS Recovered_min,
	min(CAST(Deaths AS FLOAT)) AS Deaths_min
FROM  [testing].[dbo].[Corona]
GROUP BY FORMAT(CAST([DATE] AS DATE), 'yyyy')
ORDER BY YearMonth;

-- Q9. Find maximum values of confirmed, deaths, recovered per year
SELECT 
    FORMAT(CAST([DATE] AS DATE), 'yyyy') AS YearMonth,
    MAX(CAST(Confirmed AS FLOAT)) AS Confrimed_max, MAX(CAST(Recovered AS FLOAT)) AS Recovered_max, MAX(CAST(Deaths AS FLOAT)) AS Deaths_max
FROM  [testing].[dbo].[Corona]
GROUP BY FORMAT(CAST([DATE] AS DATE), 'yyyy')
ORDER BY YearMonth;

-- Q10. The total number of case of confirmed, deaths, recovered each month
SELECT 
    FORMAT(CAST([DATE] AS DATE), 'yyyy-MM') AS YearMonth,
    sum(CAST(Confirmed AS FLOAT)) AS Confrimed_Total, 
	sum(CAST(Recovered AS FLOAT)) AS Recovered_Total, 
	sum(CAST(Deaths AS FLOAT)) AS Deaths_Total
FROM  [testing].[dbo].[Corona]
GROUP BY FORMAT(CAST([DATE] AS DATE), 'yyyy-MM')
ORDER BY YearMonth;

-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT
    sum(CAST(Confirmed AS FLOAT)) AS Confrimed_sum,
    STDEV(CAST(Confirmed AS FLOAT)) AS Confrimed_stdev,
    MIN(CAST(Confirmed AS FLOAT)) AS Confrimed_min,
    MAX(CAST(Confirmed AS FLOAT)) AS Confrimed_max,
    AVG(CAST(Confirmed AS FLOAT)) AS Confrimed_Avg
FROM [testing].[dbo].[Corona];

-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
    FORMAT(CAST([DATE] AS DATE), 'yyyy-MM') AS YearMonth,
    sum(CAST(deaths AS FLOAT)) AS death_sum, 
	avg(CAST(Deaths AS FLOAT)) AS death_Avg, 
	min(CAST(Deaths AS FLOAT)) AS Deaths_min, 
	max(CAST(Deaths AS FLOAT)) AS Deaths_max,
	stdev(CAST(Deaths AS FLOAT)) AS Deaths_Avg  
FROM  [testing].[dbo].[Corona]
GROUP BY FORMAT(CAST([DATE] AS DATE), 'yyyy-MM')
ORDER BY YearMonth;

-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
    sum(CAST(Recovered AS FLOAT))AS Recovered_sum, 
	avg(CAST(Recovered AS FLOAT)) AS Recovered_Avg, 
   min(CAST(Recovered AS FLOAT)) AS Recovered_min, 
   max(CAST(Recovered AS FLOAT)) AS Recovered_max,
  stdev(CAST(Recovered AS FLOAT)) AS Recovered_stdev
FROM  [testing].[dbo].[Corona];

-- Q14. Find Country having highest number of the Confirmed case
select  ([country region]),sum(CAST([confirmed] AS FLOAT)) AS  confrimed_sum
FROM  [testing].[dbo].[Corona]
group by [country region]
order by  confrimed_sum desc

-- Q15. Find Country having lowest number of the death case
select  ([country region]),sum(CAST([Deaths] AS FLOAT)) AS  death_min
FROM  [testing].[dbo].[Corona]
group by [country region]
order by  death_min asc

-- Q16. Find top 5 countries having highest recovered case
select top 5 ([country region]),
sum(CAST([Recovered] AS FLOAT)) AS Recovered_sum
FROM  [testing].[dbo].[Corona]
group by [country region]
order by  Recovered_sum desc

