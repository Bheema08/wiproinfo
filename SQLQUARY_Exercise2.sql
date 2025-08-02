use EmpSample_#OK;

--1. Total PresentBasic by DepartmentCode > 30000, sorted
 SELECT DepartmentCode, SUM(PresentBasic)  'TotalPresentBasic'
FROM dbo.tblEmployees
GROUP BY DepartmentCode
HAVING SUM(PresentBasic) > 30000
ORDER BY DepartmentCode;

---2. Max, Min, Avg Age (in Years & Months) by ServiceType, ServiceStatus, CentreCode
SELECT 
  CentreCode,
  ServiceType,
  ServiceStatus,
  MAX(DATEDIFF(MONTH, DOB, GETDATE()) / 12) 'MaxAgeYears',
  MIN(DATEDIFF(MONTH, DOB, GETDATE()) / 12)  'MinAgeYears',
  AVG(DATEDIFF(MONTH, DOB, GETDATE())) / 12.0 'AvgAgeYears'
FROM dbo.tblEmployees
GROUP BY CentreCode, ServiceType, ServiceStatus;

--- 3. Max, Min, Avg Service by ServiceType, ServiceStatus, CentreCode (in Years & Months)
SELECT 
  CentreCode,
  ServiceType,
  ServiceStatus,
  MAX(DATEDIFF(MONTH, DOJ, GETDATE()) / 12)  'MaxServiceYears',
  MIN(DATEDIFF(MONTH, DOJ, GETDATE()) / 12)  'MinServiceYears',
  AVG(DATEDIFF(MONTH, DOJ, GETDATE())) / 12.0  'AvgServiceYears'
FROM dbo.tblEmployees
GROUP BY CentreCode, ServiceType, ServiceStatus;

---4. Departments where Total Salary > 3 × Avg Salary

select departmentcode from tblemployees group by departmentcode having sum(presentBasic)>3 * Avg(presentBasic);

---5. Departments where Total Salary > 2 × Avg AND Max >= 3 × Min
SELECT DepartmentCode
FROM dbo.tblEmployees
GROUP BY DepartmentCode
HAVING 
  SUM(PresentBasic) > 2 * AVG(PresentBasic) AND
  MAX(PresentBasic) >= 3 * MIN(PresentBasic);

  ---6. Centers where Max Name Length ? 2 × Min Name Length
 SELECT CentreCode
FROM dbo.tblEmployees
GROUP BY CentreCode
HAVING MAX(LEN(Name)) >= 2 * MIN(LEN(Name));


---7. Max, Min, Avg Service in Milliseconds by Centre, ServiceType, Status
SELECT 
  CentreCode,
  ServiceType,
  ServiceStatus,
  MAX(DATEDIFF_BIG(MILLISECOND, DOJ, GETDATE())) AS MaxServiceMS,
  MIN(DATEDIFF_BIG(MILLISECOND, DOJ, GETDATE())) AS MinServiceMS,
  AVG(CAST(DATEDIFF_BIG(MILLISECOND, DOJ, GETDATE()) AS BIGINT)) AS AvgServiceMS
FROM dbo.tblEmployees
GROUP BY CentreCode, ServiceType, ServiceStatus;

---8. Employees with Leading or Trailing Spaces in Name
SELECT *
FROM dbo.tblEmployees
WHERE Name <> LTRIM(RTRIM(Name));

---9. Employees with More Than One Space Between Name Parts
SELECT *
FROM dbo.tblEmployees
WHERE Name LIKE '%  %';  -- Two consecutive spaces

---10. Cleaned-up Employee Names (Trim + Single Space Only)
SELECT 
  REPLACE(
    REPLACE(
      LTRIM(RTRIM(Name)), 
      '  ', ' '
    ), 
    '.', ''
  ) AS CleanedName
FROM dbo.tblEmployees;


WITH CleanNames AS (
  SELECT
    *,
    REPLACE(
      REPLACE(
        LTRIM(RTRIM(Name)),
        '  ', ' '
      ),
      '.', ''
    ) AS CleanName
  FROM dbo.tblEmployees
)
SELECT TOP 10 *
FROM CleanNames;

---11. Max Number of Words in Employee Names
WITH CleanNames AS (
  SELECT *, 
    REPLACE(REPLACE(LTRIM(RTRIM(Name)), '  ', ' '), '.', '') AS CleanName
  FROM dbo.tblEmployees
),
WordCounts AS (
  SELECT 
    CleanName,
    LEN(CleanName) - LEN(REPLACE(CleanName, ' ', '')) + 1 AS WordCount
  FROM CleanNames
)
SELECT MAX(WordCount) AS MaxWordsInName
FROM WordCounts;


---12.Names That Start and End With Same Character
WITH CleanNames AS (
  SELECT *, 
    REPLACE(REPLACE(LTRIM(RTRIM(Name)), '  ', ' '), '.', '') AS CleanName
  FROM dbo.tblEmployees
)
SELECT *
FROM CleanNames
WHERE LEFT(CleanName, 1) = RIGHT(CleanName, 1);

---13.First and Second Word Start With Same Character
WITH CleanNames AS (
  SELECT *, 
    REPLACE(REPLACE(LTRIM(RTRIM(Name)), '  ', ' '), '.', '') AS CleanName
  FROM dbo.tblEmployees
)
SELECT *
FROM CleanNames
WHERE 
  CHARINDEX(' ', CleanName) > 0 AND
  LEFT(CleanName, 1) = SUBSTRING(CleanName, CHARINDEX(' ', CleanName) + 1, 1);


  ---14. All Words in Name Start With Same Character
WITH CleanNames AS (
  SELECT 
    *,
    REPLACE(REPLACE(LTRIM(RTRIM(Name)), '  ', ' '), '.', '') AS CleanName
  FROM dbo.tblEmployees
),
SplitWords AS (
  SELECT 
    e.CleanName,
    LTRIM(RTRIM(m.n.value('.', 'VARCHAR(100)'))) AS Word
  FROM CleanNames e
  CROSS APPLY (
    SELECT CAST('<x>' + 
      REPLACE(e.CleanName, ' ', '</x><x>') + 
    '</x>' AS XML) AS parts
  ) AS t
  CROSS APPLY parts.nodes('/x') AS m(n)
),
Initials AS (
  SELECT CleanName, LEFT(Word, 1) AS Initial
  FROM SplitWords
),
CheckInitials AS (
  SELECT CleanName, COUNT(DISTINCT Initial) AS UniqueInitials
  FROM Initials
  GROUP BY CleanName
)
SELECT cn.*
FROM CleanNames cn
JOIN CheckInitials ci ON cn.CleanName = ci.CleanName
WHERE ci.UniqueInitials = 1;



---15.Any Word (Excl. Initials) Starts and Ends With Same Character
WITH CleanNames AS (
  SELECT *, 
    REPLACE(REPLACE(LTRIM(RTRIM(Name)), '  ', ' '), '.', '') AS CleanName
  FROM dbo.tblEmployees
)
SELECT DISTINCT CleanName
FROM CleanNames
CROSS APPLY STRING_SPLIT(CleanName, ' ') AS Parts
WHERE LEN(Parts.value) > 1 AND LEFT(Parts.value, 1) = RIGHT(Parts.value, 1);


---1?6. Employees Whose PresentBasic is Rounded to 100
---a) Using ROUND:
SELECT Name, PresentBasic
FROM dbo.tblEmployees
WHERE ROUND(PresentBasic, -2) = PresentBasic;

---b) Using FLOOR:
SELECT Name, PresentBasic
FROM dbo.tblEmployees
WHERE FLOOR(PresentBasic / 100.0) * 100 = PresentBasic;

---c) Using MOD:
SELECT Name, PresentBasic
FROM dbo.tblEmployees
WHERE PresentBasic % 100 = 0;

---d)Using CEILING:
SELECT Name, PresentBasic
FROM dbo.tblEmployees
WHERE CEILING(PresentBasic / 100.0) * 100 = PresentBasic;

---17.Departments Where ALL Employees Have Salary Rounded to 100
SELECT DepartmentCode
FROM dbo.tblEmployees
GROUP BY DepartmentCode
HAVING MIN(PresentBasic % 100) = 0;

---18.Departments Where NO Employee Has Salary Rounded to 100
SELECT DepartmentCode
FROM dbo.tblEmployees
GROUP BY DepartmentCode
HAVING MAX(PresentBasic % 100) <> 0;

---19.As per the companies rule if an employee has put up service of  1 Year 3 Months and 15 days in office, Then He/She would be eligible for  Bonus. the Bonus would be Paid on first of the Next month after which  a person has attained eligibility.  Find out the eligibility date for all the employees. And also find out the age of the  Employee On the date of Payment of First bonus. Display the  Age in Years, Months and Days.  Also Display the week day Name , week of the year , Day of the year and  week of the month of the date on which the person has attained the eligibility. 
WITH Eligibility AS (
  SELECT
    *,
    DATEADD(
      MONTH,
      1,
      DATEFROMPARTS(
        YEAR(DATEADD(DAY, 15,
                     DATEADD(MONTH, 3,
                              DATEADD(YEAR, 1, DOJ)))),
        MONTH(DATEADD(DAY, 15,
                     DATEADD(MONTH, 3,
                              DATEADD(YEAR, 1, DOJ)))),
        1
      )
    ) AS BonusEligibleDate
  FROM dbo.tblEmployees
),
AgeOnBonus AS (
  SELECT
    *,
    DATEDIFF(YEAR, DOB, BonusEligibleDate)
      - CASE
          WHEN (MONTH(BonusEligibleDate) < MONTH(DOB))
            OR (MONTH(BonusEligibleDate) = MONTH(DOB)
                AND DAY(BonusEligibleDate) < DAY(DOB))
          THEN 1 ELSE 0 END AS AgeYears,
    DATEDIFF(MONTH, DOB, BonusEligibleDate)
      % 12 AS AgeMonths,
    DATEDIFF(DAY,
             DATEADD(YEAR,
                     DATEDIFF(YEAR, DOB, BonusEligibleDate)
                       - CASE WHEN (MONTH(BonusEligibleDate) < MONTH(DOB)
                                   OR (MONTH(BonusEligibleDate)=MONTH(DOB)
                                       AND DAY(BonusEligibleDate)<DAY(DOB)))
                              THEN 1 ELSE 0 END,
                     DOB),
             BonusEligibleDate) AS AgeDays,
    DATENAME(WEEKDAY, BonusEligibleDate) AS WeekdayName,
    DATEPART(WEEK, BonusEligibleDate) AS WeekOfYear,
    DATEPART(DAYOFYEAR, BonusEligibleDate) AS DayOfYear,
    -- week-of-month: calculate by weekdays since first of month
    ((DATEPART(DAY, BonusEligibleDate) + DATEPART(WEEKDAY, DATEFROMPARTS(YEAR(BonusEligibleDate), MONTH(BonusEligibleDate), 1)) - 1)
     / 7) + 1 AS WeekOfMonth
  FROM Eligibility
)
SELECT Name, DOJ, BonusEligibleDate,
       AgeYears, AgeMonths, AgeDays,
       WeekdayName, WeekOfYear, DayOfYear, WeekOfMonth
FROM AgeOnBonus;

---20.Query 20: Bonus Eligibility Based on ServiceType, EmployeeType & Retirement Rules
WITH ServiceInfo AS (
  SELECT *,
         DATEDIFF(YEAR, DOJ, GETDATE()) AS ServiceYears,
         60 - DATEDIFF(YEAR, DOB, GETDATE()) AS YearsLeft60,
         55 - DATEDIFF(YEAR, DOB, GETDATE()) AS YearsLeft55,
         65 - DATEDIFF(YEAR, DOB, GETDATE()) AS YearsLeft65
  FROM dbo.tblEmployees
)
SELECT *
FROM ServiceInfo
WHERE
  (
    ServiceType = 1 AND EmployeeType = 1
    AND ServiceYears >= 10 AND YearsLeft60 >= 15
  )
  OR (
    ServiceType = 1 AND EmployeeType = 2
    AND ServiceYears >= 12 AND YearsLeft55 >= 14
  )
  OR (
    ServiceType = 1 AND EmployeeType = 3
    AND ServiceYears >= 12 AND YearsLeft55 >= 12
  )
  OR (
    ServiceType IN (2,3,4)
    AND ServiceYears >= 15 AND YearsLeft65 >= 20
  );

---21. 
SELECT 
  GETDATE() AS SQLServerFormat,
  CONVERT(varchar, GETDATE(), 1) AS USA_MMDDYY,
  CONVERT(varchar, GETDATE(), 3) AS British_DDMMYY,
  CONVERT(varchar, GETDATE(), 112) AS ISO_YYYYMMDD,
  CONVERT(varchar, GETDATE(), 101) AS USA_MM_DD_YYYY,
  CONVERT(varchar, GETDATE(), 23) AS [ISO_YYYY-MM-DD], -- Fixed with brackets
  CONVERT(varchar, GETDATE(), 100) AS MonDDYYYY;

--22. Query 22: Identify Payments Where NetPay < Expected Basic Pay
SELECT
  p.EmployeeNumber,
  p.ParamCode,
  p.Amount AS NetPay,
  p.[ActualAmount] AS ExpectedBasic,
  p.[EffectiveFrom]
FROM dbo.tblPayEmployeeparamDetails p
JOIN dbo.tblEmployees e
  ON p.EmployeeNumber = e.EmployeeNumber
WHERE
  p.ParamCode = 'GrossSalary'
  AND p.Amount < p.[ActualAmount];


select *from dbo.tblPayEmployeeparamDetails;