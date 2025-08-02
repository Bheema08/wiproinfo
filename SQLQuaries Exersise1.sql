use EmpSample_#OK;

-- one time 
SELECT name
FROM tblEmployees
WHERE name NOT LIKE '% %';


-- Three part Time
SELECT name
FROM tblEmployees
WHERE LEN(name) - LEN(REPLACE(name, ' ', '')) = 2;

SELECT * FROM tblEmployees
WHERE ' ' + name + ' ' LIKE '% Ram %';


SELECT
    65 | 11 '[65_OR_11]',
    65 ^ 11  '[65_XOR_11]',
    65 & 11   '[65_AND_11]',
    (12 & 4) | (13 & 1)  '[Expr4]',
    127 | 64  '[127_OR_64]',
    127 ^ 64   '[127_XOR_64]',
    127 ^ 128  '[127_XOR_128]',
    127 & 64    '[127_AND_64]',
    127 & 128    '[127_AND_128]';
	-- 5.retive data from centralmaster tablle
	SELECT * FROM tblCentreMaster;

	--6.List of Unique Employee Types
SELECT DISTINCT EmployeeType
FROM dbo.tblEmployees;

---7. Query: Name, FatherName, DOB of employees based on PresentBasic
---a. Greater than 3000
SELECT Name, FatherName, DOB
FROM dbo.tblEmployees
WHERE PresentBasic > 3000;
	-- Less than 3000.
SELECT Name, FatherName, DOB
FROM dbo.tblEmployees
WHERE PresentBasic < 3000;

-- Between 3000 and 5000
SELECT Name, FatherName, DOB
FROM dbo.tblEmployees
WHERE PresentBasic BETWEEN 3000 AND 5000;

--- 8. Query: All details of employees based on Name
---a. Ends with 'KHAN'
SELECT *
FROM dbo.tblEmployees
WHERE Name LIKE '%KHAN';

---b. Starts with 'CHANDRA'
SELECT *
FROM dbo.tblEmployees
WHERE Name LIKE 'CHANDRA%';
---c. Name is 'RAMESH' and initial is between A–T
SELECT *
FROM dbo.tblEmployees
WHERE Name LIKE '[A-T].RAMESH';


