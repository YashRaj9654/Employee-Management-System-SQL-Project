-- Employees Management System Project.

CREATE DATABASE Firm;
USE Firm;

CREATE TABLE Department(
Dept_ID INT PRIMARY KEY,
Dept_Name VARCHAR(50)
);

INSERT INTO Department VALUES
(1, "HR"),
(2, "IT"),
(3, "Finance"),
(4, "Sales");
SELECT * FROM Department;

CREATE TABLE Employees(
Emp_ID INT PRIMARY KEY,
Emp_Name VARCHAR(50),
Salary FLOAT,
Dept_ID INT,
Manager_ID INT,
Hire_Date DATE,
CONSTRAINT FOREIGN KEY (Dept_ID) REFERENCES Department(Dept_ID)
);

INSERT INTO Employees VALUES
(101, "Amit", 60000, 2, NULL, '2021-03-15'),
(102, "Neha", 45000, 2, 101, '2022-01-10'),
(103, "Rahul", 70000, 3, NULL, '2020-07-20'),
(104, "Priya", 50000, 3, 103, '2022-09-05'),
(105, "Ankit", 40000, 1, NULL, '2023-02-11'),
(106, "Sneha", 48000, 4, 105, '2021-12-01');
SELECT * FROM Employees;

-- 1.Employees with their Department Name.
SELECT 
    E.Emp_Name, D.Dept_Name
FROM
    Department D
        INNER JOIN
    Employees E ON D.Dept_ID = E.Dept_ID;
    
-- 2.Employees earning more than their Manager.
SELECT 
    E1.Emp_Name AS Manager_Name,
    E1.Salary,
    E2.Emp_Name AS Employee_Name,
    E2.Salary
FROM
    Employees E1
        INNER JOIN
    Employees E2 ON E1.Emp_ID = E2.Manager_ID
    WHERE E2.Salary > E1.Salary;

-- 3.Managers who manage more than 1 employee.
SELECT 
    M.Emp_Name AS Manager_Name, COUNT(E.Emp_ID) AS Team_Size
FROM
    Employees E
        INNER JOIN
    Employees M ON M.Emp_ID = E.Manager_ID
GROUP BY M.Emp_Name
HAVING Team_Size > 1;

-- 4.Department-wise Highest Salary.
SELECT 
    D.Dept_Name, MAX(E.Salary) AS Highest_Salary
FROM
    Department D
        INNER JOIN
    Employees E ON D.Dept_ID = E.Dept_ID
GROUP BY D.Dept_Name;

-- 5.Employees without Managers.
SELECT 
    Emp_Name
FROM
    Employees
WHERE
    Manager_ID IS NULL;
    
-- 6.Employees hired after 2021.
SELECT 
    Emp_Name, Hire_Date
FROM
    Employees
WHERE
    Hire_Date > '2021-12-31';
    
-- 7.Department-wise Average Salary.
WITH ABC AS(SELECT Dept_ID, AVG(Salary) FROM Employees GROUP BY Dept_ID) SELECT * FROM ABC;
SELECT AVG(Salary) FROM Employees;

-- 8.Employees earning more than Department Average.
WITH T1 AS 
(SELECT Dept_ID, AVG(Salary) AS Average_Salary FROM Employees GROUP BY Dept_ID) 
SELECT E.Emp_Name, E.Salary FROM Employees E INNER JOIN T1 T ON E.Dept_ID=T.Dept_ID WHERE E.Salary>Average_Salary;


WITH ABC AS (SELECT *, RANK() OVER(PARTITION BY Dept_ID ORDER BY Salary DESC) AS Ranks FROM Employees) SELECT * FROM ABC;

-- 9.Highest Paid Employees in Each Department.
WITH ABC AS (SELECT *, RANK() OVER(PARTITION BY Dept_ID ORDER BY Salary DESC) AS Ranks FROM Employees) SELECT * FROM ABC WHERE Ranks=1;