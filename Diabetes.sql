use Diabetics

--IDENTIFICATIONS.
--Display Data.
select * from Diabetes_prediction

--IDENTFYING DATA TYPE
select column_name,
		data_type
from INFORMATION_SCHEMA.columns
where TABLE_NAME='Diabetes_Prediction'

--IDENTFYING CONSTRAINTS.
SELECT TABLE_NAME,
		CONSTRAINT_NAME,
		CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA='DBO'

SELECT * FROM Diabetes_prediction
ORDER BY EmployeeName ASC


--DATA CLEANING
-----------------------------------------------------------
--IDENTIFY NULL VALUE
SELECT * FROM Diabetes_prediction
WHERE EmployeeName =NULL

--IDENTIFY DUPLICATES.
--UNIQUE NAMES 
select 
	distinct (employeename)
from 
	Diabetes_prediction
ORDER BY 
	EmployeeName ASC

--NAMES AND NUMBER OF DUPLCATE NAMES.
SELECT 
	EmployeeName, 
		COUNT(*) AS Total
FROM 
	Diabetes_prediction
GROUP BY 
	(EmployeeName)
HAVING COUNT(*)>0
ORDER BY EmployeeName ASC

--EXTRACT ALL DATA RELATED TO EMPLOYEES WHO HAVE DUPLICATE.
select * from Diabetes_prediction
where EmployeeName IN(
	select 
		DISTINCT(EmployeeName) 
	from Diabetes_prediction 
	group by EmployeeName 
	having count (*)>1)
ORDER BY EmployeeName ASC

--Analyzing Duplicate Names with Different Data.
select employeename,
	gender,
	age,
	smoking_history,
	hypertension,
	diabetes,
	bmi,
	heart_disease,
	HbA1c_level, 
	count(*) as Count_Name
from Diabetes_prediction
group by EmployeeName,
		gender,
		age,
		smoking_history,
		hypertension,
		diabetes,
		bmi,
		heart_disease,
		HbA1c_level
having count(*)>1


--DATA VALIDATNG 
-------------------------------------------
--ENSURING AGE IS WITHIN A VALID RANGE
SELECT *
FROM Diabetes_prediction
WHERE age<0 OR age>100

--ENSURING BINARY VALUES (0 OR 1) ARE CORRECT
SELECT * FROM Diabetes_prediction
WHERE diabetes NOT IN (0,1) OR
	hypertension NOT IN (0,1) OR 
	heart_disease NOT IN (0,1)


--IMPROVE THE PERFORMANCE
---------------------------------------------------------
UPDATE Diabetes_prediction
	SET EmployeeName=UPPER(EmployeeName);


SELECT EmployeeName
FROM Diabetes_prediction


SELECT 
	EmployeeName,
	LEN(EmployeeName) AS OriginalLength,
	LEN(TRIM(RTRIM(EmployeeName))) AS TrimedLength
FROM Diabetes_prediction
WHERE 
	LEN(EmployeeName)<> LEN(LTRIM(RTRIM(EmployeeName)))


--CREATING INDEXES
CREATE CLUSTERED INDEX idx_EmployeeName
ON Diabetes_Prediction(EmployeeName)

--CREATING STORED PROCEDURE
CREATE PROC 
GetEmployeesByAge
	@MinAge FLOAT,
	@MaxAge FLOAT
AS 
BEGIN 
	SELECT 
		EmployeeName,
		age,
		diabetes,heart_disease
	FROM Diabetes_prediction
	WHERE age BETWEEN @MinAge AND @MaxAge;
END;

EXEC GetEmployeesByAge
@MinAge=0, @MaxAge=35
-------------------------------------------
--Correlations.
CREATE PROC
CalculateCorrelation_Diabetes_HbA1c
AS 
	BEGIN
		DECLARE @meanX FLOAT, @meanY FLOAT;
		DECLARE  @sumXY FLOAT,@sumX2 FLOAT, @sumY2 FLOAT;
		SELECT 
			@meanX=AVG(CAST(diabetes AS FLOAT)),
			@meanY=AVG(HbA1c_level)
		FROM Diabetes_prediction;
		SELECT 
			@sumXY=SUM((CAST(diabetes AS FLOAT)-@meanX)*(HbA1c_level-@meanY)),
			@sumX2=SUM(POWER(CAST(diabetes AS FLOAT)-@meanX,2)),
			@sumY2=SUM(POWER(HbA1c_level-@meanY,2))
		FROM Diabetes_prediction
		SELECT 
			@sumXY/SQRT(@sumX2*@sumY2) AS Correlation_Diabetes_HbA1c;
	END;

EXEC CalculateCorrelation_Diabetes_HbA1c
--------------------------------------------------

CREATE PROC
CalculateCorrelation_Diabetes_BloodGlucose
AS 
	BEGIN
		DECLARE @meanX FLOAT, @meanY FLOAT;
		DECLARE  @sumXY FLOAT,@sumX2 FLOAT, @sumY2 FLOAT;
		SELECT 
			@meanX=AVG(CAST(diabetes AS FLOAT)),
			@meanY=AVG(blood_glucose_level)
		FROM Diabetes_prediction;
		SELECT 
			@sumXY=SUM((CAST(diabetes AS FLOAT)-@meanX)*(blood_glucose_level-@meanY)),
			@sumX2=SUM(POWER(CAST(diabetes AS FLOAT)-@meanX,2)),
			@sumY2=SUM(POWER(blood_glucose_level-@meanY,2))
		FROM Diabetes_prediction
		SELECT 
			@sumXY/SQRT(@sumX2*@sumY2) AS Correlation_Diabetes_blood_glucose_level;
	END;

EXEC CalculateCorrelation_Diabetes_BloodGlucose
-------------------------------------

CREATE PROC
CalculateCorrelation_Diabetes_Bmi
AS 
	BEGIN
		DECLARE @meanX FLOAT, @meanY FLOAT;
		DECLARE  @sumXY FLOAT,@sumX2 FLOAT, @sumY2 FLOAT;
		SELECT 
			@meanX=AVG(CAST(diabetes AS FLOAT)),
			@meanY=AVG(bmi)
		FROM Diabetes_prediction;
		SELECT 
			@sumXY=SUM((CAST(diabetes AS FLOAT)-@meanX)*(bmi-@meanY)),
			@sumX2=SUM(POWER(CAST(diabetes AS FLOAT)-@meanX,2)),
			@sumY2=SUM(POWER(bmi-@meanY,2))
		FROM Diabetes_prediction
		SELECT 
			@sumXY/SQRT(@sumX2*@sumY2) AS Correlation_Diabetes_bmi;
	END;

EXEC CalculateCorrelation_Diabetes_Bmi
-------------------------------------------------------------
--EDA
SELECT 
	COUNT(*) AS TotalRows,
	MIN(age) AS MinAge,
	MAX(age) AS MaxAge,
	AVG(age) AS AvgAge,
	MIN(bmi) AS MinBmi,
	MAX(bmi) AS MaxBmi,
	AVG(bmi) AS AvgBmi,
	MIN(HbA1c_level) AS MinHbA1cLevel,
	MAX(HbA1c_level) AS MaxHbA1cLevel,
	AVG(HbA1c_level) AS AvgHbA1cLevel,
	MIN(blood_glucose_level) AS MinBloodGlucoseLevel,
	MAX(blood_glucose_level) AS MaxBloodGlucoseLevel,
	AVG(blood_glucose_level) AS AvgBloodGlucoseLevel
FROM Diabetes_prediction


-- COUNT AND PERCENTAGE OF GENDER
SELECT gender ,
		COUNT(*) AS TotalCount,
		COUNT(*)*100/SUM(COUNT(*)) OVER () AS GenderPercentage
FROM Diabetes_prediction
GROUP BY gender 

--COUNT AND PERCENTAGE OF DIABETES.
SELECT 
	diabetes,
	COUNT(*) AS TotalCount,
	COUNT(*)*100/SUM(COUNT(*)) OVER () AS DiabetesPercntage
FROM Diabetes_prediction
GROUP BY diabetes

--COUNT AND PERCENTAGE OF HYPERTENSION.
SELECT 
	hypertension,
	COUNT(*) AS TotalCount,
	COUNT(*)*100/SUM(COUNT(*)) OVER () AS HypertensionPercntage
FROM Diabetes_prediction
GROUP BY hypertension

--COUNT AND PERCENTAGE OF HEART DISEASE
SELECT 
	heart_disease,
	COUNT(*) AS TotalCount,
	COUNT(*)*100/SUM(COUNT(*)) OVER () AS HeartDiseasePercntage
FROM Diabetes_prediction
GROUP BY heart_disease

--DATA DIISTRIBUTION AND OUTLIERS 
SELECT 
	age,
	COUNT(*) AS Frequency
FROM Diabetes_prediction
GROUP BY Age
ORDER BY Age

--DISTRIBUTIOIN OF BMI
SELECT 
	bmi,
	COUNT(*) AS Frequency
FROM Diabetes_prediction
GROUP BY bmi

--CORRELATION HYPERTENSION AND DIABETES.
WITH CTE AS (
	SELECT 
		AVG(CAST(hypertension AS FLOAT)) AS AvgHypertension,
		AVG(CAST(diabetes AS FLOAT))  AS AvgDiabetes,
		STDEV(CAST(hypertension  AS FLOAT)) AS StdevHypertension,
		STDEV(CAST(diabetes AS FLOAT)) AS StdevDiabetes
	FROM Diabetes_prediction
),
Covariance AS(
		SELECT 
			SUM((hypertension-AvgHypertension)*(diabetes- AvgDiabetes))/
			(COUNT(*)-1) AS Covariance
		FROM Diabetes_Prediction,
		CTE
)
SELECT Covariance/(StdevHypertension*StdevDiabetes) AS CorrelationHypertensionDiabetes
FROM Covariance,CTE;

--CORRELATIOIN HEART DISEASE AND DIABETES.
WITH CTE AS (
	SELECT 
		AVG(CAST(heart_disease AS FLOAT)) AS AvgHeartDisease,
		AVG(CAST(diabetes AS FLOAT))  AS AvgDiabetes,
		STDEV(CAST(heart_disease  AS FLOAT)) AS StdevHeartDisease,
		STDEV(CAST(diabetes AS FLOAT)) AS StdevDiabetes
	FROM Diabetes_prediction
),
Covariance AS(
		SELECT 
			SUM((heart_disease-AvgHeartDisease)*(diabetes- AvgDiabetes))/
			(COUNT(*)-1) AS Covariance
		FROM Diabetes_Prediction,
		CTE
)
SELECT Covariance/(StdevDiabetes*StdevHeartDisease) AS CorrelationHeartDiseaseDiabetes
FROM Covariance,CTE;



--TOTAL EMPLOYEES AND DISEASE PERCENTAGES.
SELECT
		COUNT(*) AS TotalEmployees,
		SUM(CASE
				WHEN diabetes=1 THEN 1
				ELSE 0
			END)*100/COUNT(*) AS DiabetesPercentage,
		SUM(CASE
				WHEN hypertension=1 THEN 1
				ELSE 0
			END)*100/COUNT(*) AS HypertensionPercentage,
			SUM(CASE
					WHEN heart_disease=1 THEN 1 
					ELSE 0
				END)*100/COUNT(*) AS HeratDiseasPercentage
FROM Diabetes_prediction

--TOTAL NUMBER DIABETES BY GENDER.
WITH CTE AS (
    SELECT 
        gender,
        diabetes
    FROM 
        Diabetes_prediction
)
SELECT gender,
    ISNULL([0], 0) AS NoDiabetes,
    ISNULL([1], 0) AS Diabetes
FROM 
    CTE
PIVOT (
    COUNT(diabetes) FOR diabetes IN ([0], [1])
	
) AS pt;

--AGE GROUP DISTRIBUTION
SELECT 
	CASE
		WHEN age BETWEEN 0 AND 18 THEN '0-18'
		WHEN age BETWEEN 19 AND 35 THEN '19-35'
		WHEN age BETWEEN 36 AND 50 THEN '36-50'
		WHEN age BETWEEN 51 AND 65 THEN '51-65'
		ELSE '66+'
	END AS AgeGroup,
	COUNT(*) AS NumberEmployees
FROM Diabetes_prediction
GROUP BY 
		CASE
		WHEN age BETWEEN 0 AND 18 THEN '0-18'
		WHEN age BETWEEN 19 AND 35 THEN '19-35'
		WHEN age BETWEEN 36 AND 50 THEN '36-50'
		WHEN age BETWEEN 51 AND 65 THEN '51-65'
		ELSE '66+'
	END
ORDER BY AgeGroup 

--CATEGORICAL DATA ANALYSIS.
--DISTRIBUTION BY GENDER
SELECT 
	gender,
	SUM(CASE 
			WHEN diabetes=1 THEN 1 
			ELSE 0
		END)AS TotalDiabetes,
	SUM(CASE
			WHEN heart_disease=1 THEN 1 
			ELSE 0
		END) AS TotalHeartDisease,
	SUM(CASE
			WHEN hypertension =1 THEN 1 
			ELSE 0
		END) AS TotalHypertension
FROM Diabetes_prediction
GROUP BY gender;

--DISEASE PERCENTAGE BY AGE GROUP.
SELECT 
	CASE
		WHEN age BETWEEN 0 AND 18 THEN '0-18'
		WHEN age BETWEEN 19 AND 35 THEN '19-35'
		WHEN age BETWEEN 36 AND 50 THEN '36-50'
		WHEN age BETWEEN 51 AND 65 THEN '51-65'
		ELSE '66+'
	END AS AgeGroup,
		SUM(CASE
				WHEN diabetes=1 THEN 1
				ELSE 0
			END)*100/COUNT(*) AS DiabetesPercentage,
		SUM(CASE
				WHEN hypertension=1 THEN 1
				ELSE 0
			END)*100/COUNT(*) AS HypertensionPercentage,
			SUM(CASE
					WHEN heart_disease=1 THEN 1 
					ELSE 0
				END)*100/COUNT(*) AS HeratDiseasPercentage,
				COUNT(*) AS TotalEmployees
FROM Diabetes_prediction
GROUP BY 
	CASE
		WHEN age BETWEEN 0 AND 18 THEN '0-18'
		WHEN age BETWEEN 19 AND 35 THEN '19-35'
		WHEN age BETWEEN 36 AND 50 THEN '36-50'
		WHEN age BETWEEN 51 AND 65 THEN '51-65'
		ELSE '66+'
	END 
ORDER BY AgeGroup
--FILTERING AND ANALYZING BASED ON CONDITIONS
--PERCENTAGE OF DIABETES AND HYPERTENSIION.
SELECT 
	SUM(
		CASE
			WHEN Diabetes=1 AND Hypertension =1 THEN 1
			else 0
		END) *100 /COUNT(*) AS DiabetesAndHypertensionPercentage
FROM Diabetes_prediction

--DIABETES AND HYPERTENSION AS PIVOT TABLE.
WITH CTE AS (
    SELECT gender,diabetes,
        CASE 
			WHEN diabetes=1 AND hypertension=1 THEN 'Both'
			WHEN diabetes=0 AND hypertension=0 THEN 'None'
			WHEN diabetes=1 AND hypertension=0 THEN 'Diabetes_Only'
			WHEN diabetes=0 AND hypertension=1 THEN 'hypertension_Only'
		END AS Condition,
		CASE 
			WHEN age BETWEEN 0 AND 18 THEN '0-18'
			WHEN age BETWEEN 19 AND 35 THEN '19-35'
			WHEN age BETWEEN 36 AND 55 THEN  '36-55'
			WHEN age BETWEEN 56 AND 65 THEN '56-65'
			ELSE '66+'
		END AS AgeGroup
    FROM 
        Diabetes_prediction
)
SELECT
	gender,
	AgeGroup,
    ISNULL([Both], 0) AS Both,
    ISNULL([None], 0) AS None,
	ISNULL([Diabetes_Only],0) AS OnlyDiabetes,
	ISNULL([hypertension_Only],0) AS OnlyHYpertension
FROM 
    CTE
PIVOT (
    COUNT(diabetes) FOR Condition IN ([Both], [None], [Diabetes_Only], [hypertension_Only])
) AS pt
ORDER BY gender, AgeGroup

--SMOKING HISTORY VS. DISEASE PREVALENCE
SELECT 
	smoking_history,
	SUM(CASE 
			WHEN Diabetes=1 THEN 1 
			ELSE 0
		END)*100/ COUNT(*) AS DiabetesPercentage,
	SUM(CASE
			WHEN heart_disease =1 THEN 1 
			ELSE 0
		END)*100 /COUNT(*) AS HeartDiseasePercentage
FROM Diabetes_prediction
GROUP BY smoking_history

--Heart Disease BY GENDER 		
WITH CTE AS (
    SELECT 
        gender,
        heart_disease
    FROM 
        Diabetes_prediction
)
SELECT
    gender,
    ISNULL([0], 0) AS NoDiabetes,
    ISNULL([1], 0) AS Diabetes
FROM 
    CTE
PIVOT (
    COUNT(heart_disease) FOR heart_disease IN ([0], [1])
) AS pt
ORDER BY gender;

--DIABETES & HEART DISEASE BY GENDER
WITH CTE AS (
    SELECT 
        gender,diabetes,
        CASE 
			WHEN diabetes=1 AND heart_disease=1 THEN 'Both'
			WHEN diabetes=0 AND heart_disease=0 THEN 'None'
			WHEN diabetes=1 AND heart_disease=0 THEN 'Diabetes_Only'
			WHEN diabetes=0 AND heart_disease=1 THEN 'Heart_Disease_Only'
		END AS Condition
    FROM 
        Diabetes_prediction
)
SELECT
      gender,
    ISNULL([Both], 0) AS Both,
    ISNULL([None], 0) AS None,
	ISNULL([Diabetes_Only],0) AS OnlyDiabetes,
	ISNULL([Heart_Disease_Only],0) AS Only_Heart_Disease
FROM 
    CTE
PIVOT (
    COUNT(diabetes) FOR Condition IN ([Both], [None], [Diabetes_Only], [Heart_Disease_Only])
) AS pt
ORDER BY gender;

--PROPORTION TESTS.
SELECT 
	gender,
	diabetes,
	COUNT(*) AS TotalCount,
	(COUNT(*)*1.0/
(SELECT COUNT(*) 
FROM Diabetes_prediction)) AS Proportion
FROM Diabetes_prediction
GROUP BY 
	gender,diabetes
order by gender
