USE HRAnalysis
GO

-- Begin a transaction to ensure data integrity across multiple operations
BEGIN TRANSACTION;

BEGIN TRY
    -- Create the Department table
    CREATE TABLE Department (
        Depart_ID INT PRIMARY KEY,
        Department VARCHAR(100)
    );

    -- Insert data into the Department table
    BULK INSERT Department
    FROM 'D:\DBs\HR Data Analysis\New folder\Department.csv'
    WITH (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2
    );

    -- Create the Education table
    CREATE TABLE Education (
        Edu_ID INT PRIMARY KEY,
        Edu_Field VARCHAR(100)
    );

    -- Insert data into the Education table
    BULK INSERT Education
    FROM 'D:\DBs\HR Data Analysis\New folder\Education.csv'
    WITH (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2
    );

    -- Create the Employee_Data table
    CREATE TABLE Employee_Data (
        Employee_ID INT PRIMARY KEY,
        Environment_Satisfaction INT,
        Job_Satisfaction INT,
        Work_Life_Balance INT
    );

    -- Insert data into the Employee_Data table
    BULK INSERT Employee_Data
    FROM 'D:\DBs\HR Data Analysis\New folder\Employee_Data.csv'
    WITH (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2
    );

    -- Create the Gender table
    CREATE TABLE Gender (
        Gender_ID INT PRIMARY KEY,
        Gender VARCHAR(100)
    );

    -- Insert data into the Gender table
    BULK INSERT Gender
    FROM 'D:\DBs\HR Data Analysis\New folder\Gender.csv'
    WITH (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2
    );

    -- Create the JobRole table
    CREATE TABLE JobRole (
        Role_ID INT PRIMARY KEY,
        JobRole VARCHAR(100)
    );

    -- Insert data into the JobRole table
    BULK INSERT JobRole
    FROM 'D:\DBs\HR Data Analysis\New folder\JobRole.csv'
    WITH (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2
    );

    -- Create the Manager_Data table
    CREATE TABLE Manager_Data (
        Employee_ID INT PRIMARY KEY,
        Job_Involvment INT,
        Performance_Rating INT
    );

    -- Insert data into the Manager_Data table
    BULK INSERT Manager_Data
    FROM 'D:\DBs\HR Data Analysis\New folder\Manager_Data.csv'
    WITH (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2
    );

    -- Create the Status table
    CREATE TABLE Status (
        Status_ID INT PRIMARY KEY,
        Marital_Status VARCHAR(100)
    );

    -- Insert data into the Status table
    BULK INSERT Status
    FROM 'D:\DBs\HR Data Analysis\New folder\Status.csv'
    WITH (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2
    );

    -- Create the General_Data table
    CREATE TABLE General_Data (
        Employee_ID INT,
        EmP_Name VARCHAR(100),
        Age INT,
        Attrition VARCHAR(50),
        Business_Travel VARCHAR(100),
        Depart_ID INT,
        Distance_From_Home INT,
        Education INT,
        Edu_ID INT,
        Employee_Count INT,
        Gender_ID INT,
        Job_Level INT,
        Role_ID INT,
        Status_ID INT,
        Monthly_Income INT,
        Num_Companies_Worked INT,
        Over_18 VARCHAR(50),
        Percent_Salary_Hike INT,
        Standard_Hours INT,
        Stock_Option_Level INT,
        Total_Working_Years INT,
        Training_Times_Last_Year INT,
        Years_At_Company INT,
        Years_Since_Last_Promotion INT,
        Years_With_Current_Manager INT,
        CONSTRAINT FK_Department FOREIGN KEY (Depart_ID) REFERENCES Department(Depart_ID),
        CONSTRAINT FK_Education FOREIGN KEY (Edu_ID) REFERENCES Education(Edu_ID),
        CONSTRAINT FK_Gender FOREIGN KEY (Gender_ID) REFERENCES Gender(Gender_ID),
        CONSTRAINT FK_Job_Role FOREIGN KEY (Role_ID) REFERENCES JobRole(Role_ID),
        CONSTRAINT FK_Status FOREIGN KEY (Status_ID) REFERENCES Status(Status_ID),
        CONSTRAINT FK_Manager FOREIGN KEY (Employee_ID) REFERENCES Manager_Data(Employee_ID),
        CONSTRAINT FK_EMP_DATA FOREIGN KEY (Employee_ID) REFERENCES Employee_Data(Employee_ID)
    );

    -- Insert data into the General_Data table
    BULK INSERT General_Data
    FROM 'D:\DBs\HR Data Analysis\New folder\General_Data.csv'
    WITH (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2,
        KEEPNULLS
    );

    COMMIT TRANSACTION;
	 PRINT 'Transaction committed successfully.';	
END TRY
BEGIN CATCH
    -- Rollback the transaction if an error occurs
    ROLLBACK TRANSACTION;
    PRINT 'Transaction committed successfully.';
END CATCH;
--------------------------------------------------------------------------------------
--Extract All Data Related to Employees Who Have Duplicate:

SELECT 
    EmP_Name, 
    Age, 
    COUNT(*) AS CountName, 
    Business_Travel, 
    Attrition, 
    Gender_ID, 
    Monthly_Income
FROM 
    General_Data
GROUP BY 
    EmP_Name, 
    Age, 
    Business_Travel, 
    Attrition, 
    Gender_ID, 
    Monthly_Income
HAVING 
    COUNT(*) > 1;

--Exploratory Data Analysis (EDA)
--DISCRIPTIVE STATISTICS

SELECT 
    'max' AS metric,
    MAX(age) AS age, 
    MAX(distance_from_home) AS distance_from_home, 
    MAX(monthly_income) AS monthly_income, 
    MAX(num_companies_worked) AS num_companies_worked, 
    MAX(percent_salary_hike) AS percent_salary_hike, 
    MAX(stock_option_level) AS stock_option_level, 
    MAX(total_working_years) AS total_working_years, 
    MAX(training_times_last_year) AS training_times_last_year, 
    MAX(years_at_company) AS years_at_company, 
    MAX(years_since_last_promotion) AS years_since_last_promotion, 
    MAX(years_with_current_manager) AS years_with_current_manager
FROM General_Data

UNION ALL

SELECT 
    'min' AS metric,
    MIN(age) AS age, 
    MIN(distance_from_home) AS distance_from_home, 
    MIN(monthly_income) AS monthly_income, 
    MIN(num_companies_worked) AS num_companies_worked, 
    MIN(percent_salary_hike) AS percent_salary_hike, 
    MIN(stock_option_level) AS stock_option_level, 
    MIN(total_working_years) AS total_working_years, 
    MIN(training_times_last_year) AS training_times_last_year, 
    MIN(years_at_company) AS years_at_company, 
    MIN(years_since_last_promotion) AS years_since_last_promotion, 
    MIN(years_with_current_manager) AS years_with_current_manager
FROM General_Data

UNION ALL

SELECT 
    'avg' AS metric,
    AVG(age) AS age, 
    AVG(distance_from_home) AS distance_from_home, 
    AVG(monthly_income) AS monthly_income, 
    AVG(num_companies_worked) AS num_companies_worked, 
    AVG(percent_salary_hike) AS percent_salary_hike, 
    AVG(stock_option_level) AS stock_option_level, 
    AVG(total_working_years) AS total_working_years, 
    AVG(training_times_last_year) AS training_times_last_year, 
    AVG(years_at_company) AS years_at_company, 
    AVG(years_since_last_promotion) AS years_since_last_promotion, 
    AVG(years_with_current_manager) AS years_with_current_manager
FROM General_Data

UNION ALL

SELECT 
    'stddev' AS metric,
    STDEV(age) AS age, 
    STDEV(distance_from_home) AS distance_from_home, 
    STDEV(monthly_income) AS monthly_income, 
    STDEV(num_companies_worked) AS num_companies_worked, 
    STDEV(percent_salary_hike) AS percent_salary_hike, 
    STDEV(stock_option_level) AS stock_option_level, 
    STDEV(total_working_years) AS total_working_years, 
    STDEV(training_times_last_year) AS training_times_last_year, 
    STDEV(years_at_company) AS years_at_company, 
    STDEV(years_since_last_promotion) AS years_since_last_promotion, 
    STDEV(years_with_current_manager) AS years_with_current_manager
FROM General_Data;

--Data Validating:
SELECT * 
FROM
	General_Data
WHERE 
	Age <18 OR Age >60
----------------------------------------------------------
--The average performance rating by gender.
SELECT 
    Gender, 
    AVG(m.Performance_Rating) AS AveragePerformanceRating
FROM 
    general_data g
INNER JOIN 
    manager_data m ON g.Employee_ID = m.Employee_ID
INNER JOIN 
    gender ge ON g.Gender_ID = ge.Gender_ID
GROUP BY 
    Gender

--The average performance rating by gender and job role.
	SELECT 
    ge.Gender, 
    j.JobRole,
    AVG(m.Performance_Rating) AS AveragePerformanceRating
FROM 
    general_data g
INNER JOIN 
    manager_data m ON g.Employee_ID = m.Employee_ID
INNER JOIN 
    JobRole j ON j.Role_ID = g.Role_ID 
INNER JOIN 
    gender ge ON g.Gender_ID = ge.Gender_ID
GROUP BY 
    ge.Gender, j.JobRole;

-- Summary of employee attrition based on job satisfaction levels.
SELECT 
    Job_Satisfaction,
    COUNT(*) AS NumberOfEmployees,
    SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS EmployeesStayed,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS EmployeesLeft
FROM 
    general_data g
INNER JOIN 
    Employee_Data d ON g.Employee_ID = d.Employee_ID
GROUP BY 
    Job_Satisfaction
ORDER BY 
    Job_Satisfaction;

--This Shows you how the average performance rating varies depending on the number of training sessions employees attended in the last year.
SELECT 
    Training_Times_Last_Year,
    AVG(Performance_Rating) AS AveragePerformanceRating
FROM 
    general_data g
INNER JOIN 
    manager_data m ON g.Employee_ID = m.Employee_ID
GROUP BY	
    Training_Times_Last_Year;

--Analyzing the distribution of age groups.
SELECT 
    CASE 
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55 and above'
    END AS AgeGroup, 
    COUNT(*) AS EmployeeCount
FROM 
    general_data
GROUP BY 
    CASE 
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55 and above'
    END
ORDER BY 
    AgeGroup;

--Calculating the average percentage salary hike for each department. 
SELECT 
    d.Department, 
    AVG(g.Percent_Salary_Hike) AS AverageSalaryHike
FROM 
    general_data g
JOIN 
    Department d ON g.Depart_ID = d.Depart_ID
GROUP BY 
    d.Department;

--Understanding the distribution of employees across different education levels and fields.
SELECT 
    e.Edu_Field, 
    g.Education, 
    COUNT(g.Employee_ID) AS EmployeeCount
FROM 
    general_data g
JOIN 
    education e ON g.Edu_ID = e.Edu_ID
WHERE 
    g.Attrition = 'No'
GROUP BY 
    e.Edu_Field, 
    g.Education;

--Understanding the impact of personal life on work satisfaction and productivity.
SELECT 
    s.Marital_Status, 
    AVG(e.Work_Life_Balance) AS AverageWorkLifeBalance
FROM 
    general_data g
JOIN 
    employee_data e ON g.Employee_ID = e.Employee_ID
JOIN 
    status s ON g.Status_ID = s.Status_ID
GROUP BY 
    s.Marital_Status;

--how the number of companies worked at impacts employee retention.
SELECT 
    g.Num_Companies_Worked, 
    COUNT(g.Employee_ID) AS EmployeeCount
FROM 
    general_data g
GROUP BY 
    g.Num_Companies_Worked
ORDER BY 
    g.Num_Companies_Worked;

--The distribution of employees across different job levels.
SELECT 
    g.Job_Level, 
    COUNT(g.Employee_ID) AS EmployeeCount
FROM 
    general_data g
GROUP BY 
    g.Job_Level
ORDER BY 
    g.Job_Level;

--This query helps assess how much training is provided across different departments for employees.
SELECT 
    d.Department, 
    AVG(g.Training_Times_Last_Year) AS AverageTrainingTimes
FROM 
    general_data g
JOIN 
    Department d ON g.Depart_ID = d.Depart_ID
GROUP BY 
    d.Department;

--Understand how monthly income varies across different marital statuses among employees.
SELECT 
    s.Marital_Status, 
    AVG(g.Monthly_Income) AS AverageMonthlyIncome
FROM 
    general_data g
JOIN 
    status s ON g.Status_ID = s.Status_ID
GROUP BY 
    s.Marital_Status;

--This approach ensures that if there are multiple employees with the same highest monthly income, all of them will be included in the result.
SELECT 
    EmP_Name, 
    Monthly_Income, 
    Attrition
FROM 
    general_data
WHERE 
    Monthly_Income = (
        SELECT MAX(Monthly_Income)
        FROM general_data
    );

--This approach ensures that if there are multiple employees with the same lowest monthly income, all of them will be included in the result.
SELECT 
    EmP_Name, 
    Monthly_Income, 
    Attrition
FROM 
    general_data
WHERE 
    Monthly_Income = (
        SELECT	MIN(Monthly_Income)
        FROM general_data
    );

--The average number of years employees have been with their current manager for each job role.
SELECT 
    j.JobRole, 
    AVG(g.Years_With_Current_Manager) AS AverageYearsWithCurrentManager
FROM 
    general_data g
JOIN 
    jobrole j ON g.Role_ID = j.Role_ID
GROUP BY 
    j.JobRole;

--This Query aims to categorize employees into "High" and "Low" job satisfaction levels and count how many employees fall into each category.
SELECT 
    COUNT(EmP_Name) AS EmployeeCount,
    CASE 
        WHEN E.Job_Satisfaction > 2 THEN 'High'
        ELSE 'Low'
    END AS Job_Satisfaction_Level
FROM
    Employee_Data E 
INNER JOIN 
    General_Data G ON E.Employee_ID = G.Employee_ID
GROUP BY
    CASE 
        WHEN E.Job_Satisfaction > 2 THEN 'High'
        ELSE 'Low'
    END;


--Distribution of Employee Age Groups Among Non-Attrited Employees

SELECT 
    CASE 
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55 and above'
    END AS AgeGroup, 
    COUNT(*) AS EmployeeCount
FROM 
    general_data
WHERE 
    Attrition = 'No'
GROUP BY 
    CASE 
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55 and above'
    END
ORDER BY 
    AgeGroup;

--Average Percentage Salary Hike by Department for Employees Who Stayed
SELECT 
    d.Department, 
    AVG(g.Percent_Salary_Hike) AS AverageSalaryHike
FROM 
    general_data g
JOIN 
    Department d ON g.Depart_ID = d.Depart_ID
WHERE 
    g.Attrition = 'No'
GROUP BY 
    d.Department;

--Distribution of Employees by Education Level and Field for Employees Who Stayed
SELECT 
    e.Edu_Field, 
    g.Education, 
    COUNT(g.Employee_ID) AS EmployeeCount
FROM 
    general_data g
JOIN 
    education e ON g.Edu_ID = e.Edu_ID
WHERE 
    g.Attrition = 'No'
GROUP BY 
    e.Edu_Field, 
    g.Education;

-- Average Work-Life Balance by Marital Status for Employees Who Stayed
SELECT 
    s.Marital_Status, 
    AVG(e.Work_Life_Balance) AS AverageWorkLifeBalance
FROM 
    general_data g
JOIN 
    employee_data e ON g.Employee_ID = e.Employee_ID
JOIN 
    status s ON g.Status_ID = s.Status_ID
WHERE 
    g.Attrition = 'No'
GROUP BY 
    s.Marital_Status;

--Distribution of Employees by Number of Companies Worked (Attrition = 'No')
SELECT 
    g.Num_Companies_Worked, 
    COUNT(g.Employee_ID) AS EmployeeCount
FROM 
    general_data g
WHERE 
    g.Attrition = 'No'
GROUP BY 
    g.Num_Companies_Worked
ORDER BY 
    g.Num_Companies_Worked;

--Employee Count by Job Level (Attrition = 'No')
SELECT 
    g.Job_Level, 
    COUNT(g.Employee_ID) AS EmployeeCount
FROM 
    general_data g
WHERE 
    g.Attrition = 'No'
GROUP BY 
    g.Job_Level
ORDER BY 
    g.Job_Level;

--Employee Count by Gender and Marital Status (Attrition = 'No')
SELECT 
    ge.Gender, 
    s.Marital_Status, 
    COUNT(g.Employee_ID) AS EmployeeCount
FROM 
    general_data g
JOIN 
    gender ge ON g.Gender_ID = ge.Gender_ID
JOIN 
    status s ON g.Status_ID = s.Status_ID
WHERE 
    g.Attrition = 'No'
GROUP BY 
    ge.Gender, 
    s.Marital_Status
ORDER BY 
    ge.Gender, 
    s.Marital_Status;

--Average Environment Satisfaction by Job Role (Attrition = 'No')
SELECT 
    j.JobRole, 
    AVG(e.Environment_Satisfaction) AS AverageEnvironmentSatisfaction
FROM 
    general_data g
JOIN 
    employee_data e ON g.Employee_ID = e.Employee_ID
JOIN 
    jobrole j ON g.Role_ID = j.Role_ID
WHERE 
    g.Attrition = 'No'
GROUP BY 
    j.JobRole;

--Average Training Times Last Year by Department (Attrition = 'No')
SELECT 
    d.Department, 
    AVG(g.Training_Times_Last_Year) AS AverageTrainingTimes
FROM 
    general_data g
JOIN 
    Department d ON g.Depart_ID = d.Depart_ID
WHERE 
    g.Attrition = 'No'
GROUP BY 
    d.Department;

--Average Monthly Income by Marital Status (Attrition = 'No')
SELECT 
    s.Marital_Status, 
    AVG(g.Monthly_Income) AS AverageMonthlyIncome
FROM 
    general_data g
JOIN 
    status s ON g.Status_ID = s.Status_ID
WHERE 
    g.Attrition = 'No'
GROUP BY 
    s.Marital_Status;

--Average Years with Current Manager by Job Role (Attrition = 'No')
SELECT 
    j.JobRole, 
    AVG(g.Years_With_Current_Manager) AS AverageYearsWithCurrentManager
FROM 
    general_data g
JOIN 
    jobrole j ON g.Role_ID = j.Role_ID
WHERE 
    g.Attrition = 'No'
GROUP BY 
    j.JobRole;

--Average Performance Rating by Gender (Attrition = 'No')
SELECT 
    ge.Gender, 
    AVG(m.Performance_Rating) AS AveragePerformanceRating
FROM 
    general_data g
INNER JOIN 
    manager_data m ON g.Employee_ID = m.Employee_ID
INNER JOIN 
    gender ge ON g.Gender_ID = ge.Gender_ID
WHERE 
    g.Attrition = 'No'
GROUP BY 
    ge.Gender;

--Average Job Satisfaction by Distance from Home (Attrition = 'No')
SELECT 
    CASE 
        WHEN Distance_From_Home < 5 THEN '0-5 km'
        WHEN Distance_From_Home BETWEEN 5 AND 10 THEN '5-10 km'
        WHEN Distance_From_Home BETWEEN 10 AND 20 THEN '10-20 km'
        ELSE '20+ km'
    END AS DistanceGroup, 
    AVG(e.Job_Satisfaction) AS AverageJobSatisfaction
FROM 
    general_data g
JOIN 
    employee_data e ON g.Employee_ID = e.Employee_ID
WHERE 
    g.Attrition = 'No'
GROUP BY 
    CASE 
        WHEN Distance_From_Home < 5 THEN '0-5 km'
        WHEN Distance_From_Home BETWEEN 5 AND 10 THEN '5-10 km'
        WHEN Distance_From_Home BETWEEN 10 AND 20 THEN '10-20 km'
        ELSE '20+ km'
    END;

--Distribution of Job Satisfaction Levels Among Employees Who Have Stayed.
SELECT 
    COUNT(EmP_Name) AS EmployeeCount,
    CASE 
        WHEN E.Job_Satisfaction > 2 THEN 'High'
        ELSE 'Low'
    END AS Job_Satisfaction_Level
FROM
    Employee_Data E 
INNER JOIN 
    General_Data G ON E.Employee_ID = G.Employee_ID
WHERE
    G.Attrition = 'No'
GROUP BY
    CASE 
        WHEN E.Job_Satisfaction > 2 THEN 'High'
        ELSE 'Low'
    END;
	
--percentage of each gender for in the same gender 
	WITH CTE AS (
		SELECT 
			g.Gender, 
			d.Attrition,
			COUNT(*) AS CountGender
		FROM 
			General_Data d 
		INNER JOIN 
			Gender g 
		ON 
			d.Gender_ID = g.Gender_ID
		GROUP BY 
			g.Gender, 
			d.Attrition
	)
	SELECT 
		Gender,
		Attrition,
		CountGender,
		(CountGender * 100.0) / SUM(CountGender) OVER (PARTITION BY Gender) AS Percentage
	FROM 
		CTE;

--perecntage of attrition for each gender based on total 
	WITH CTE AS (
		SELECT 
			g.Gender, 
			d.Attrition,
			COUNT(*) AS CountGender
		FROM 
			General_Data d 
		INNER JOIN 
			Gender g 
		ON 
			d.Gender_ID = g.Gender_ID
		GROUP BY 
			g.Gender, 
			d.Attrition
	)
	SELECT 
		Gender,
		Attrition,
		CountGender,
		(CountGender * 100.0) / SUM(CountGender) OVER () AS Percentage
	FROM 
		CTE;

--percentage of attrition generally
	WITH CTE AS (
    SELECT  
        Attrition,
        COUNT(*) AS CountAll
    FROM 
        General_Data 
    GROUP BY  
        Attrition
)
SELECT 
    Attrition,
    CountAll,
    (CountAll * 100.0) / SUM(CountAll) OVER () AS Percentage
FROM 
    CTE;



--CORRELATIONS
--Correlaions based on Age
CREATE PROC CalculateCorrelation_Attrition_Age
AS 
BEGIN 
    DECLARE @meanX FLOAT, @meanY FLOAT;
    DECLARE @sumX2 FLOAT, @sumY2 FLOAT, @sumXY FLOAT;
    SELECT 
        @meanX = AVG(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END),
        @meanY = AVG(CAST(age AS FLOAT))
    FROM General_Data;
    SELECT 
        @sumXY = SUM((CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END - @meanX) * (age - @meanY)),
        @sumX2 = SUM(POWER(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END - @meanX, 2)),
        @sumY2 = SUM(POWER(age - @meanY, 2))
    FROM General_Data;
    SELECT @sumXY / SQRT(@sumX2 * @sumY2) AS CorrelationAttritionAge;
END;

EXEC CalculateCorrelation_Attrition_Age

--Correlaions based on Age Group
CREATE PROC CalculateCorrelation_Attrition_Age_By_AgeGroup
AS 
BEGIN 
    WITH AgeGroupData AS (
        SELECT 
            CASE 
                WHEN age BETWEEN 18 AND 24 THEN '18-24'
                WHEN age BETWEEN 25 AND 34 THEN '25-34'
                WHEN age BETWEEN 35 AND 44 THEN '35-44'
                WHEN age BETWEEN 45 AND 54 THEN '45-54'
                WHEN age BETWEEN 55 AND 60 THEN '55-60'
                ELSE 'Other' 
            END AS AgeGroup,
            CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END AS attrition_numeric,
            CAST(age AS FLOAT) AS age_numeric
        FROM General_Data
    ),
    MeanValues AS (
        SELECT 
            AgeGroup,
            AVG(attrition_numeric) AS meanX,
            AVG(age_numeric) AS meanY
        FROM AgeGroupData
        GROUP BY AgeGroup
    ),
    Stats AS (
        SELECT 
            d.AgeGroup,
            SUM((d.attrition_numeric - m.meanX) * (d.age_numeric - m.meanY)) AS sumXY,
            SUM(POWER(d.attrition_numeric - m.meanX, 2)) AS sumX2,
            SUM(POWER(d.age_numeric - m.meanY, 2)) AS sumY2
        FROM AgeGroupData d
        JOIN MeanValues m ON d.AgeGroup = m.AgeGroup
        GROUP BY d.AgeGroup, m.meanX, m.meanY
    )
    SELECT 
        AgeGroup,
        CASE 
            WHEN SUM(sumX2) = 0 OR SUM(sumY2) = 0 THEN NULL
            ELSE SUM(sumXY) / SQRT(SUM(sumX2) * SUM(sumY2))
        END AS CorrelationAttritionAge
    FROM Stats
    GROUP BY AgeGroup;
END;

EXEC CalculateCorrelation_Attrition_Age_By_AgeGroup

--Correlaions based on travel
CREATE PROC CalculateCorrelation_Attrition_Business_Travel
AS 
BEGIN 
    DECLARE @meanX FLOAT, @meanY FLOAT;
    DECLARE @sumX2 FLOAT, @sumY2 FLOAT, @sumXY FLOAT;
    SELECT 
        @meanX = AVG(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END),
        @meanY = AVG(CASE WHEN business_travel='Non-Travel' THEN 0
						WHEN Business_Travel='Travel-Rarely' THEN 1
						ELSE 2
					END)
    FROM General_Data;
    SELECT 
        @sumXY = SUM((CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END - @meanX) * (CASE WHEN business_travel='Non-Travel' THEN 0
						WHEN Business_Travel='Travel-Rarely' THEN 1
						ELSE 2
					END - @meanY)),
        @sumX2 = SUM(POWER(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END - @meanX, 2)),
        @sumY2 = SUM(POWER(CASE WHEN business_travel='Non-Travel' THEN 0
						WHEN Business_Travel='Travel-Rarely' THEN 1
						ELSE 2
					END - @meanY, 2))
    FROM General_Data;
    SELECT @sumXY / SQRT(@sumX2 * @sumY2) AS CorrelationAttritioBusinessTravel;
END;;

EXEC CalculateCorrelation_Attrition_Business_Travel

--Correlaions based on Income
CREATE PROC CalculateCorrelation_Attrition_Income
AS 
BEGIN 
    DECLARE @meanX FLOAT, @meanY FLOAT;
    DECLARE @sumX2 FLOAT, @sumY2 FLOAT, @sumXY FLOAT;
    
    SELECT 
        @meanX = AVG(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END),
        @meanY = AVG(CAST(monthly_income AS FLOAT))
    FROM General_Data;
    
    SELECT 
        @sumXY = SUM((CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END - @meanX) * (Monthly_Income - @meanY)),
        @sumX2 = SUM(POWER(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END - @meanX, 2)),
        @sumY2 = SUM(POWER(Monthly_Income - @meanY, 2))
    FROM General_Data;
  
    SELECT @sumXY / SQRT(@sumX2 * @sumY2) AS CorrelationAttritionIncome;
END;

exec CalculateCorrelation_Attrition_Income

--Correlaions based on Income Category
CREATE PROC CalculateCorrelation_AttritionIncome
AS 
BEGIN
    WITH INCOME AS(
        SELECT 
            CASE 
                WHEN monthly_income <= 50000 THEN '0'
                WHEN monthly_income BETWEEN 50000 AND 100000 THEN '1'
                WHEN monthly_income BETWEEN 100000 AND 150000 THEN '2'
                ELSE '3'
            END AS IncomeGroup,
            CAST(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END AS FLOAT) AS attrition_numeric,
            CAST(monthly_income AS FLOAT) AS MonthlyIncomeNumeric
        FROM General_Data
    ),
    MeanValues AS (
        SELECT 
            IncomeGroup,
            AVG(attrition_numeric) AS meanX,
            AVG(MonthlyIncomeNumeric) AS meanY
        FROM INCOME
        GROUP BY IncomeGroup
    ),		
    Stats AS (
        SELECT 
            i.IncomeGroup,
            SUM((i.attrition_numeric - m.meanX) * (i.MonthlyIncomeNumeric - m.meanY)) AS sumXY,
            SUM(POWER(i.attrition_numeric - m.meanX, 2)) AS sumX2,
            SUM(POWER(i.MonthlyIncomeNumeric - m.meanY, 2)) AS sumY2
        FROM INCOME i
        JOIN MeanValues m ON i.IncomeGroup = m.IncomeGroup
        GROUP BY i.IncomeGroup, m.meanX, m.meanY
    )
    SELECT 
        IncomeGroup,
        CASE 
            WHEN SUM(sumX2) = 0 OR SUM(sumY2) = 0 THEN NULL
            ELSE SUM(sumXY) / SQRT(SUM(sumX2) * SUM(sumY2))
        END AS CorrelationAttritionIncome
    FROM Stats
    GROUP BY IncomeGroup;
END;

EXEC CalculateCorrelation_AttritionIncome

--Correlaions based on diatance from home
CREATE PROC CalculateCorrelation_Attrition_Distance
AS 
BEGIN 
    DECLARE @meanX FLOAT, @meanY FLOAT;
    DECLARE @sumX2 FLOAT, @sumY2 FLOAT, @sumXY FLOAT;
    
    SELECT 
        @meanX = AVG(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END),
        @meanY = AVG(CAST(Distance_From_Home AS FLOAT))
    FROM General_Data;
    
    SELECT 
        @sumXY = SUM((CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END - @meanX) * (Distance_From_Home- @meanY)),
        @sumX2 = SUM(POWER(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END - @meanX, 2)),
        @sumY2 = SUM(POWER(Distance_From_Home - @meanY, 2))
    FROM General_Data;
  
    SELECT @sumXY / SQRT(@sumX2 * @sumY2) AS CorrelationAttritionDistance;
END;

EXEC CalculateCorrelation_Attrition_Distance

--Correlaions based on diastance category
CREATE PROC CalculateCorrelation_AttritionDistanceCategory
AS 
BEGIN
    WITH Distance AS(
        SELECT 
            CASE 
                WHEN Distance_From_Home <= 10 THEN '0-10'
                WHEN Distance_From_Home BETWEEN 10 AND 20 THEN '10-20'
                ELSE '20-30'
            END AS DistanceCategory,
            CAST(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END AS FLOAT) AS attrition_numeric,
            CAST(Distance_From_Home AS FLOAT) AS DistanceNumeric
        FROM General_Data
    ),
    MeanValues AS (
        SELECT 
            DistanceCategory,
            AVG(attrition_numeric) AS meanX,
            AVG(DistanceNumeric) AS meanY
        FROM Distance
        GROUP BY DistanceCategory
    ),		
    Stats AS (
        SELECT 
            d.distancecategory,
            SUM((d.attrition_numeric - m.meanX) * (d.DistanceNumeric - m.meanY)) AS sumXY,
            SUM(POWER(d.attrition_numeric - m.meanX, 2)) AS sumX2,
            SUM(POWER(d.DistanceNumeric - m.meanY, 2)) AS sumY2
        FROM Distance d
        JOIN MeanValues m ON d.DistanceCategory = m.DistanceCategory
        GROUP BY d.DistanceCategory, m.meanX, m.meanY
    )
    SELECT 
        DistanceCategory,
        CASE 
            WHEN SUM(sumX2) = 0 OR SUM(sumY2) = 0 THEN NULL
            ELSE SUM(sumXY) / SQRT(SUM(sumX2) * SUM(sumY2))
        END AS CorrelationAttritionDistance
    FROM Stats
    GROUP BY DistanceCategory;
END;

EXEC  CalculateCorrelation_AttritionDistanceCategory

--Correlaions based on job level
CREATE PROC CalculateCorrelation_Attrition_JobLevel
AS 
BEGIN 
    DECLARE @meanX FLOAT, @meanY FLOAT;
    DECLARE @sumX2 FLOAT, @sumY2 FLOAT, @sumXY FLOAT;
    
    SELECT 
        @meanX = AVG(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END),
        @meanY = AVG(CAST(Job_Level AS FLOAT))
    FROM General_Data;
    
    SELECT 
        @sumXY = SUM((CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END - @meanX) * (Job_Level- @meanY)),
        @sumX2 = SUM(POWER(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END - @meanX, 2)),
        @sumY2 = SUM(POWER(Job_Level - @meanY, 2))
    FROM General_Data;
  
    SELECT @sumXY / SQRT(@sumX2 * @sumY2) AS CorrelationAttritionJobLevel;
END;

EXEC CalculateCorrelation_Attrition_JobLevel

--Correlaions based on number of companies worked
CREATE PROC CalculateCorrelation_Attrition_NumCompanies
AS 
BEGIN 
    DECLARE @meanX FLOAT, @meanY FLOAT;
    DECLARE @sumX2 FLOAT, @sumY2 FLOAT, @sumXY FLOAT;
    
    SELECT 
        @meanX = AVG(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END),
        @meanY = AVG(CAST(Num_Companies_Worked AS FLOAT))
    FROM General_Data;
    
    SELECT 
        @sumXY = SUM((CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END - @meanX) * (Num_Companies_Worked- @meanY)),
        @sumX2 = SUM(POWER(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END - @meanX, 2)),
        @sumY2 = SUM(POWER(Num_Companies_Worked - @meanY, 2))
    FROM General_Data;
  
    SELECT @sumXY / SQRT(@sumX2 * @sumY2) AS CorrelationAttritionNumCompaniesWorked;
END;

EXEC CalculateCorrelation_Attrition_NumCompanies

--Correlaions based on percent salary hike
CREATE PROC CalculateCorrelation_Attrition_PercentSalaryHike
AS 
BEGIN 
    DECLARE @meanX FLOAT, @meanY FLOAT;
    DECLARE @sumX2 FLOAT, @sumY2 FLOAT, @sumXY FLOAT;
    
    SELECT 
        @meanX = AVG(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END),
        @meanY = AVG(CAST(Percent_Salary_Hike AS FLOAT))
    FROM General_Data;
    
    SELECT 
        @sumXY = SUM((CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END - @meanX) * (Percent_Salary_Hike- @meanY)),
        @sumX2 = SUM(POWER(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END - @meanX, 2)),
        @sumY2 = SUM(POWER(Percent_Salary_Hike - @meanY, 2))
    FROM General_Data;
  
    SELECT @sumXY / SQRT(@sumX2 * @sumY2) AS CorrelationAttritionPercentSalaryHike;
END;

EXEC CalculateCorrelation_Attrition_PercentSalaryHike

--Correlaions based on stock level
CREATE PROC CalculateCorrelation_Attrition_StockLevel
AS 
BEGIN 
    DECLARE @meanX FLOAT, @meanY FLOAT;
    DECLARE @sumX2 FLOAT, @sumY2 FLOAT, @sumXY FLOAT;
    
    SELECT 
        @meanX = AVG(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END),
        @meanY = AVG(CAST(Stock_Option_Level AS FLOAT))
    FROM General_Data;
    
    SELECT 
        @sumXY = SUM((CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END - @meanX) * (Stock_Option_Level - @meanY)),
        @sumX2 = SUM(POWER(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END - @meanX, 2)),
        @sumY2 = SUM(POWER(Stock_Option_Level - @meanY, 2))
    FROM General_Data;
  
    SELECT @sumXY / SQRT(@sumX2 * @sumY2) AS CorrelationAttritionStockLevel;
END;

EXEC CalculateCorrelation_Attrition_StockLevel

--Correlaions based on total working years
CREATE PROC CalculateCorrelation_Attrition_TotalWorkingYears
AS 
BEGIN 
    DECLARE @meanX FLOAT, @meanY FLOAT;
    DECLARE @sumX2 FLOAT, @sumY2 FLOAT, @sumXY FLOAT;
    
    SELECT 
        @meanX = AVG(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END),
        @meanY = AVG(CAST(Total_Working_Years AS FLOAT))
    FROM General_Data;
    
    SELECT 
        @sumXY = SUM((CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END - @meanX) * (Total_Working_Years - @meanY)),
        @sumX2 = SUM(POWER(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END - @meanX, 2)),
        @sumY2 = SUM(POWER(Total_Working_Years - @meanY, 2))
    FROM General_Data;
  
    SELECT @sumXY / SQRT(@sumX2 * @sumY2) AS CorrelationAttritionTotalWorkingYears;
END;

EXEC CalculateCorrelation_Attrition_TotalWorkingYears

--Correlaions based on training times last year
CREATE PROC CalculateCorrelation_Attrition_TrainingTimesLastYear
AS 
BEGIN 
    DECLARE @meanX FLOAT, @meanY FLOAT;
    DECLARE @sumX2 FLOAT, @sumY2 FLOAT, @sumXY FLOAT;
    
    SELECT 
        @meanX = AVG(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END),
        @meanY = AVG(CAST(Training_Times_Last_Year AS FLOAT))
    FROM General_Data;
    
    SELECT 
        @sumXY = SUM((CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END - @meanX) * (Training_Times_Last_Year - @meanY)),
        @sumX2 = SUM(POWER(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END - @meanX, 2)),
        @sumY2 = SUM(POWER(Training_Times_Last_Year - @meanY, 2))
    FROM General_Data;
  
    SELECT @sumXY / SQRT(@sumX2 * @sumY2) AS CorrelationAttritionTrainingTimeLastYears;
END;

EXEC CalculateCorrelation_Attrition_TrainingTimesLastYear

--Correlaions based on years at the company
CREATE PROC CalculateCorrelation_Attrition_YearsAtCompany
AS 
BEGIN 
    DECLARE @meanX FLOAT, @meanY FLOAT;
    DECLARE @sumX2 FLOAT, @sumY2 FLOAT, @sumXY FLOAT;
    
    SELECT 
        @meanX = AVG(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END),
        @meanY = AVG(CAST(Years_At_Company AS FLOAT))
    FROM General_Data;
    
    SELECT 
        @sumXY = SUM((CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END - @meanX) * (Years_At_Company - @meanY)),
        @sumX2 = SUM(POWER(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END - @meanX, 2)),
        @sumY2 = SUM(POWER(Years_At_Company - @meanY, 2))
    FROM General_Data;
  
    SELECT @sumXY / SQRT(@sumX2 * @sumY2) AS CorrelationAttritionYearsAtCompany;
END;

EXEC CalculateCorrelation_Attrition_YearsAtCompany

--Correlaions based on years since last promotion
CREATE PROC CalculateCorrelation_Attrition_YearsSinceLastPromotion
AS 
BEGIN 
    DECLARE @meanX FLOAT, @meanY FLOAT;
    DECLARE @sumX2 FLOAT, @sumY2 FLOAT, @sumXY FLOAT;
    
    SELECT 
        @meanX = AVG(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END),
        @meanY = AVG(CAST(Years_Since_Last_Promotion AS FLOAT))
    FROM General_Data;
    
    SELECT 
        @sumXY = SUM((CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END - @meanX) * (Years_Since_Last_Promotion - @meanY)),
        @sumX2 = SUM(POWER(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END - @meanX, 2)),
        @sumY2 = SUM(POWER(Years_Since_Last_Promotion - @meanY, 2))
    FROM General_Data;
  
    SELECT @sumXY / SQRT(@sumX2 * @sumY2) AS CorrelationAttritionYearsSinceLastPromotion;
END;

EXEC CalculateCorrelation_Attrition_YearsSinceLastPromotion

--Correlaions based on years with the manager 
CREATE PROC CalculateCorrelation_Attrition_YearsWithCurrentManager
AS 
BEGIN 
    DECLARE @meanX FLOAT, @meanY FLOAT;
    DECLARE @sumX2 FLOAT, @sumY2 FLOAT, @sumXY FLOAT;
    
    SELECT 
        @meanX = AVG(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END),
        @meanY = AVG(CAST(Years_With_Current_Manager AS FLOAT))
    FROM General_Data;
    
    SELECT 
        @sumXY = SUM((CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END - @meanX) * (Years_With_Current_Manager - @meanY)),
        @sumX2 = SUM(POWER(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END - @meanX, 2)),
        @sumY2 = SUM(POWER(Years_With_Current_Manager - @meanY, 2))
    FROM General_Data;
  
    SELECT @sumXY / SQRT(@sumX2 * @sumY2) AS CorrelationAttritionYearsWithCurrentManager;
END;

EXEC CalculateCorrelation_Attrition_YearsWithCurrentManager

--Correlaions based on education
CREATE PROC CalculateCorrelation_Attrition_Education
AS 
BEGIN 
    DECLARE @meanX FLOAT, @meanY FLOAT;
    DECLARE @sumX2 FLOAT, @sumY2 FLOAT, @sumXY FLOAT;
    
    SELECT 
        @meanX = AVG(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END),
        @meanY = AVG(CAST(Education AS FLOAT))
    FROM General_Data;
    
    SELECT 
        @sumXY = SUM((CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END - @meanX) * (Education - @meanY)),
        @sumX2 = SUM(POWER(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0.0 END - @meanX, 2)),
        @sumY2 = SUM(POWER(Education - @meanY, 2))
    FROM General_Data;
  
    SELECT @sumXY / SQRT(@sumX2 * @sumY2) AS CorrelationAttritionEducation;
END;

EXEC CalculateCorrelation_Attrition_Education


-- Employees Who Left the Company by Age Group
SELECT 
    CASE 
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55 and above'
    END AS AgeGroup, 
    COUNT(*) AS EmployeeCount
FROM general_data
WHERE Attrition = 'Yes'
GROUP BY 
    CASE 
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55 and above'
    END;


--Annual Salary Increase Rate by Department for Employees Who Left	
SELECT 
    d.Department, 
    AVG(g.Percent_Salary_Hike) AS AverageSalaryHike
FROM 
    general_data g
JOIN 
    department d 
    ON g.Depart_ID = d.Depart_ID
WHERE 
    g.Attrition = 'Yes'
GROUP BY 
    d.Department;

--Employee Count by Education Level and Field for Employees Who Left

SELECT 
    e.Edu_Field, 
    g.Education, 
    COUNT(g.Employee_ID) AS EmployeeCount
FROM 
    general_data g
JOIN 
    education e 
    ON g.Edu_ID = e.Edu_ID
WHERE 
    g.Attrition = 'Yes'
GROUP BY 
    e.Edu_Field, 
    g.Education;

--Work-Life Balance Satisfaction by Marital Status for Employees Who Left

SELECT 
    s.Martal_Status, 
    AVG(e.Work_Life_Balance) AS AverageWorkLifeBalance
FROM 
    general_data g
JOIN 
    employee_data e 
    ON g.Employee_ID = e.Employee_ID
JOIN 
    status s 
    ON g.Status_ID = s.Status_ID
WHERE 
    g.Attrition = 'Yes'
GROUP BY 
    s.Martal_Status;

--Distribution of Employees by Number of Companies Worked for Who Left
SELECT 
    g.Num_Companies_Worked, 
    COUNT(g.Employee_ID) AS EmployeeCount
FROM 
    general_data g
WHERE 
    g.Attrition = 'Yes'
GROUP BY 
    g.Num_Companies_Worked
ORDER BY 
    g.Num_Companies_Worked;

--Distribution of Employees by Job Level for Employees Who Left
SELECT 
    g.Job_Level, 
    COUNT(g.Employee_ID) AS EmployeeCount
FROM 
    general_data g
WHERE 
    g.Attrition = 'Yes'
GROUP BY 
    g.Job_Level
ORDER BY 
    g.Job_Level;
--------------------------------------------------------------------------------------
--Distribution of Employees by Gender and Marital Status for Employees Who Left
SELECT 
    ge.Gender, 
    s.Martal_Status, 
    COUNT(g.Employee_ID) AS EmployeeCount
FROM 
    general_data g
JOIN 
    gender ge 
    ON g.Gender_ID = ge.Gender_ID
JOIN 
    status s 
    ON g.Status_ID = s.Status_ID
WHERE 
    g.Attrition = 'Yes'
GROUP BY 
    ge.Gender, 
    s.Martal_Status
ORDER BY 
    ge.Gender, 
    s.Martal_Status;

--Environment Satisfaction by Job Role for Employees Who Left
SELECT 
    j.JobRole, 
    AVG(e.Environment_Satisfaction) AS AverageEnvironmentSatisfaction
FROM 
    general_data g
JOIN 
    employee_data e 
    ON g.Employee_ID = e.Employee_ID
JOIN 
    jobrole j 
    ON g.Role_ID = j.Role_ID
WHERE 
    g.Attrition = 'Yes'
GROUP BY 
    j.JobRole;

--Annual Training Rate by Department for Employees Who Left
SELECT 
    d.Department, 
    AVG(g.Training_Times_Last_Year) AS AverageTrainingTimes
FROM 
    general_data g
JOIN 
    Department d 
    ON g.Depart_ID = d.Depart_ID
WHERE 
    g.Attrition = 'Yes'
GROUP BY 
    d.Department;

--Monthly Income by Marital Status for Employees Who Left
SELECT 
    s.Marital_Status, 
    AVG(g.Monthly_Income) AS AverageMonthlyIncome
FROM 
    general_data g
JOIN 
    status s 
    ON g.Status_ID = s.Status_ID
WHERE 
    g.Attrition = 'Yes'
GROUP BY 
    s.Marital_Status;

--Average Years with Current Manager by Job Role for Employees Who Left
SELECT 
    j.JobRole, 
    AVG(g.Years_With_Current_Manager) AS AverageYearsWithCurrentManager
FROM 
    general_data g
JOIN 
    jobrole j 
    ON g.Role_ID = j.Role_ID
WHERE 
    g.Attrition = 'Yes'
GROUP BY 
    j.JobRole;

--Performance Rating by Gender for Employees Who Left
SELECT 
    ge.Gender, 
    AVG(m.Performance_Rating) AS AveragePerformanceRating
FROM 
    general_data g
JOIN 
    manager_data m 
    ON g.Employee_ID = m.Employee_ID
JOIN 
    gender ge 
    ON g.Gender_ID = ge.Gender_ID
WHERE 
    g.Attrition = 'Yes'
GROUP BY 
    ge.Gender;

--Count of Employees Working More Than Standard Hours Who Left:
SELECT 
    COUNT(g.Employee_ID) AS OverworkingEmployees
FROM 
    general_data g
WHERE 
    g.Attrition = 'Yes' 
    AND g.Standard_Hours < (
        SELECT 
            AVG(g2.Standard_Hours)
        FROM 
            general_data g2
    );

--Job Satisfaction by Distance from Home for Employees Who Left
SELECT 
    CASE 
        WHEN g.Distance_From_Home < 5 THEN '0-5 km'
        WHEN g.Distance_From_Home BETWEEN 5 AND 10 THEN '5-10 km'
        WHEN g.Distance_From_Home BETWEEN 10 AND 20 THEN '10-20 km'
        ELSE '20+ km'
    END AS DistanceGroup, 
    AVG(e.Job_Satisfaction) AS AverageJobSatisfaction
FROM 
    general_data g
JOIN 
    employee_data e 
    ON g.Employee_ID = e.Employee_ID
WHERE 
    g.Attrition = 'Yes'
GROUP BY 
    CASE 
        WHEN g.Distance_From_Home < 5 THEN '0-5 km'
        WHEN g.Distance_From_Home BETWEEN 5 AND 10 THEN '5-10 km'
        WHEN g.Distance_From_Home BETWEEN 10 AND 20 THEN '10-20 km'
        ELSE '20+ km'
    END;

--The employee who have HIGH and LOW job satisfaction.
SELECT 
	EmP_Name,
    CASE 
        WHEN [Job_Satisfaction] > 2 THEN 'High'
        ELSE 'Low'
    END AS Job_Satisfaction_Level
FROM
    Employee_Data E 
INNER JOIN 
    General_Data G 
    ON E.Employee_ID = G.Employee_ID
WHERE 
    G.Attrition = 'yes';
