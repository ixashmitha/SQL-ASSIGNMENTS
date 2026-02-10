/*SQL_ASSIGNMENT_2*/

/*Relationship Tasks*/

CREATE TABLE CUSTOMERS(customer_id INT PRIMARY KEY,
					   c_name VARCHAR(15),
					   email VARCHAR(25),
					   order_id INT);

CREATE TABLE ORDERS(order_id INT PRIMARY KEY,
					amount BIGINT,
					order_date DATETIME,
					customer_id INT NOT NULL);
ALTER TABLE ORDERS ADD FOREIGN KEY (customer_id) REFERENCES CUSTOMERS(customer_id);
ALTER TABLE CUSTOMERS ALTER COLUMN c_name VARCHAR(15) NOT NULL;
ALTER TABLE CUSTOMERS ALTER COLUMN email VARCHAR(25) NOT NULL;
ALTER TABLE CUSTOMERS ADD CONSTRAINT ukid UNIQUE(customer_id,c_name);
ALTER TABLE CUSTOMERS DROP  CONSTRAINT ukid;
ALTER TABLE CUSTOMERS ADD UNIQUE(c_name);
INSERT INTO CUSTOMERS VALUES (101,'Hiranya','hiranya@gmail.com',1001),
							 (102,'Ashmitha','ashu@gmail.com',1002),
							 (103,'Harati','harati@gmail.com',1011),
							 (104,'Divya','divya@gmail.com',1201);
SELECT * FROM CUSTOMERS;
INSERT INTO ORDERS VALUES(1001,1200,'2026-02-05 16:11:00',101),
                         (1002,2500,'2026-02-05 16:20:00',102),
						 (1003,1800,'2026-02-05 16:35:00',101),
						 (1004,3200,'2026-02-05 17:00:00',103),
						 (1005,900,'2026-02-05 17:10:00',104),
						 (1006,1500,'2026-02-05 17:25:00',102),
						 (1007,2750,'2026-02-05 17:40:00',103),
						 (1008,600,'2026-02-05 18:00:00',101),
						 (1009,4100,'2026-02-05 18:20:00',104),
						 (1010,2200,'2026-02-05 18:45:00',102);
SELECT * FROM ORDERS;

INSERT INTO ORDERS VALUES(1011,2222,'2026-02-05 21:22:22',107);
/*Msg 547, Level 16, State 0, Line 36
The INSERT statement conflicted with the FOREIGN KEY constraint "FK__ORDERS__customer__440B1D61". The conflict occurred in database "TASK2", table "dbo.CUSTOMERS", column 'customer_id'.
The statement has been terminated.*/

/* MANY-TO-MANY SCHEMA IS ALREDY CREATED IN CUSTOMER AND ORDERS TABLE ,SO JUNCTION TABLE IS CREATED USING THAT SCHEMA*/
CREATE TABLE JUNCTION(j_id INT PRIMARY KEY, cust_id INT, ord_id INT,
                      FOREIGN KEY(cust_id) REFERENCES CUSTOMERS(customer_id),
					  FOREIGN KEY(ord_id) REFERENCES ORDERS(order_id));
SELECT * FROM JUNCTION;


/* INNER JOIN TASKS*/

SELECT * FROM CUSTOMERS INNER JOIN ORDERS ON CUSTOMERS.customer_id=ORDERS.order_id;
ALTER TABLE CUSTOMERS ADD city VARCHAR(23);
ALTER TABLE CUSTOMERS DROP COLUMN city;
ALTER TABLE ORDERS ADD city VARCHAR(23);
SELECT * FROM ORDERS;
SELECT CUSTOMERS.c_name,ORDERS.city FROM CUSTOMERS INNER JOIN ORDERS ON CUSTOMERS.customer_id=ORDERS.order_id;
CREATE TABLE PRODUCTS(p_id INT PRIMARY KEY,p_name VARCHAR(12),amount INT NOT NULL,c_id INT,o_id INT,
                     FOREIGN KEY (c_id) REFERENCES CUSTOMERS(customer_id),
					 FOREIGN KEY (o_id)  REFERENCES ORDERS(order_id));

INSERT INTO PRODUCTS VALUES
(1,'Laptop',55000,101,1001),
(2,'Mouse',800,102,1002),
(3,'Keyboard',1500,101,1003),
(4,'Monitor',12000,103,1004),
(5,'USB',600,104,1005),
(6,'Headset',2200,102,1006),
(7,'Tablet',30000,103,1007),
(8,'Charger',900,101,1008),
(9,'Printer',15000,104,1009),
(10,'Camera',45000,102,1010);

SELECT * FROM PRODUCTS INNER JOIN CUSTOMERS ON PRODUCTS.p_id=CUSTOMERS.customer_id
                       INNER JOIN ORDERS ON PRODUCTS.p_id=ORDERS.order_id;

SELECT c.customer_id, c.c_name, c.email, o.order_id, p.p_name, p.amount FROM PRODUCTS p
INNER JOIN CUSTOMERS c ON p.c_id=c.customer_id
INNER JOIN ORDERS o ON p.o_id=o.order_id 
WHERE p.amount>10000 AND c.c_name LIKE '%a';

/*LEFT JOIN TASKS*/
SELECT * FROM CUSTOMERS c LEFT JOIN ORDERS o ON c.order_id=o.order_id;

SELECT * FROM CUSTOMERS c LEFT JOIN ORDERS o ON c.order_id=o.order_id 
WHERE o.order_id IS NULL;

CREATE TABLE DEPARTMENT ( dept_id INT PRIMARY KEY,
						  dept_name VARCHAR(50) NOT NULL UNIQUE,
						  location VARCHAR(50));

CREATE TABLE EMPLOYEES ( emp_id INT PRIMARY KEY,
						 emp_name VARCHAR(50) NOT NULL,
						 salary INT NOT NULL,
						 hire_date DATETIME,
						 dept_id INT,
						 CONSTRAINT fk_emp_dept FOREIGN KEY (dept_id) REFERENCES DEPARTMENT(dept_id));

INSERT INTO DEPARTMENT VALUES
(1,'HR','Block A'),
(2,'IT','Block B'),
(3,'Finance','Block C'),
(4,'Sales','Block D');

INSERT INTO EMPLOYEES VALUES
(101,'Hiranya',60000,'2023-01-10',2),
(102,'Ashmitha',55000,'2023-03-12',2),
(103,'Harati',50000,'2022-11-05',1),
(104,'Divya',72000,'2021-07-19',3),
(105,'Aysh',48000,'2024-02-01',4),
(106,'Vibhu',80000,'2020-09-09',2),
(107,'Addy',45000,'2024-06-15',NULL); 

SELECT * FROM DEPARTMENT;
SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENT LEFT JOIN EMPLOYEES ON DEPARTMENT.dept_id=EMPLOYEES.dept_id WHERE emp_id IS NOT NULL ; 
SELECT * FROM DEPARTMENT LEFT JOIN EMPLOYEES ON DEPARTMENT.dept_id=EMPLOYEES.dept_id WHERE emp_id IS NULL; 
SELECT * FROM PRODUCTS LEFT JOIN ORDERS ON PRODUCTS.o_id=ORDERS.order_id
WHERE order_id IS NULL;
SELECT * FROM PRODUCTS LEFT JOIN ORDERS ON PRODUCTS.o_id=ORDERS.order_id 
WHERE PRODUCTS.amount < 10000;
SELECT * FROM PRODUCTS LEFT JOIN ORDERS ON PRODUCTS.o_id=ORDERS.order_id
WHERE PRODUCTS.p_name LIKE 'c%';

/*RIGHT JOIN TASKS*/

SELECT * FROM ORDERS o RIGHT JOIN CUSTOMERS c ON o.order_id=c.order_id;
SELECT * FROM ORDERS o RIGHT JOIN CUSTOMERS c ON o.order_id=c.order_id 
WHERE o.order_id IS NULL;
SELECT d.dept_name,e.emp_name FROM DEPARTMENT d RIGHT JOIN EMPLOYEES e ON d.dept_id=e.dept_id;
SELECT d.dept_name,e.emp_name FROM DEPARTMENT d RIGHT JOIN EMPLOYEES e ON d.dept_id=e.dept_id
WHERE dept_name='IT';
SELECT d.dept_name,e.emp_name FROM DEPARTMENT d RIGHT JOIN EMPLOYEES e ON d.dept_id=e.dept_id;
SELECT d.dept_name, COUNT(e.emp_name) AS emp_count FROM DEPARTMENT d RIGHT JOIN EMPLOYEES e ON d.dept_id=e.dept_id
GROUP BY d.dept_name;

/* OUTER JOIN TASKS*/

SELECT * FROM CUSTOMERS c LEFT JOIN ORDERS o ON c.customer_id = o.customer_id
UNION 
SELECT * FROM CUSTOMERS c RIGHT JOIN ORDERS o ON c.customer_id = o.customer_id;

SELECT * FROM EMPLOYEES e LEFT JOIN DEPARTMENT d ON e.emp_id=d.dept_id
UNION 
SELECT * FROM  EMPLOYEES e RIGHT JOIN DEPARTMENT d ON e.emp_id=d.dept_id;

SELECT c.customer_id,c.c_name,o.order_id,'Matched/LeftSide' AS src FROM CUSTOMERS c LEFT JOIN ORDERS o ON c.customer_id = o.customer_id 
UNION 
SELECT c.customer_id,c.c_name,o.order_id,'RightOnly' AS src FROM CUSTOMERS c RIGHT JOIN ORDERS o ON c.customer_id = o.customer_id WHERE c.customer_id IS NULL;

/* SELF JOIN TASKS*/
ALTER TABLE EMPLOYEES ADD manager_id INT;
SELECT * FROM EMPLOYEES;
UPDATE EMPLOYEES SET manager_id = 106 WHERE emp_id IN (101,102);
UPDATE EMPLOYEES SET manager_id = 103 WHERE emp_id = 105;
UPDATE EMPLOYEES SET manager_id = 104 WHERE emp_id = 107;
UPDATE EMPLOYEES SET manager_id = NULL WHERE emp_id IN (103,104,106);
SELECT e.emp_name AS Employee,m.emp_name AS Manager FROM EMPLOYEES e,EMPLOYEES m WHERE e.emp_id=m.emp_id;
SELECT e.emp_name AS Employee,m.emp_name AS Manager FROM EMPLOYEES e,EMPLOYEES m WHERE e.emp_id=m.emp_id
ORDER BY e.emp_name;
SELECT DISTINCT e.emp_name AS Employee,m.emp_name AS Manager FROM EMPLOYEES e,EMPLOYEES m WHERE e.emp_id=m.emp_id;

ALTER TABLE EMPLOYEES ADD mentor_id INT;
ALTER TABLE EMPLOYEES ADD CONSTRAINT fk_mentor FOREIGN KEY (mentor_id) REFERENCES EMPLOYEES(emp_id);
UPDATE EMPLOYEES SET mentor_id = 106 WHERE emp_id IN (101,102,105);
UPDATE EMPLOYEES SET mentor_id = 104 WHERE emp_id IN (103,107);
UPDATE EMPLOYEES SET mentor_id = 103 WHERE emp_id = 102;
UPDATE EMPLOYEES SET mentor_id = NULL WHERE emp_id IN (104,106);
SELECT  e.emp_name AS Employee,ma.emp_name AS Mentor FROM EMPLOYEES e, EMPLOYEES ma WHERE e.mentor_id = ma.emp_id;
SELECT mgr.emp_name  AS Manager,men.emp_name AS Mentor,e.emp_name AS Employee
FROM EMPLOYEES e lEFT JOIN EMPLOYEES mgr ON e.manager_id = mgr.emp_id LEFT JOIN EMPLOYEES men ON e.mentor_id = men.emp_id
ORDER BY Manager, Mentor, Employee;

/*CROSS JOIN TASKS*/

SELECT c.customer_id,c.c_name,p.p_id,p.p_name FROM CUSTOMERS c CROSS JOIN PRODUCTS p;

CREATE TABLE ROLES (role_id INT PRIMARY KEY,role_name VARCHAR(30));

INSERT INTO ROLES VALUES (1,'Developer'), (2,'Tester'), (3,'Manager'), (4,'Analyst');

SELECT e.emp_name,r.role_name FROM EMPLOYEES e CROSS JOIN ROLES r;

SELECT * FROM CUSTOMERS c CROSS JOIN PRODUCTS p;

/* MULTI-TABLE JOIN TASKS*/

CREATE TABLE ORDER_ITEMS (item_id INT PRIMARY KEY,
						 order_id INT,
						 product_id INT,
						 qty INT,
						 price INT,
    					 FOREIGN KEY (order_id) REFERENCES ORDERS(order_id),
						 FOREIGN KEY (product_id) REFERENCES PRODUCTS(p_id));

INSERT INTO ORDER_ITEMS VALUES
(1,1001,1,1,55000),
(2,1001,2,2,800),
(3,1002,3,1,1500),
(4,1002,6,1,2200),
(5,1003,4,1,12000),
(6,1004,7,1,30000),
(7,1004,5,3,600),
(8,1005,8,2,900),
(9,1006,9,1,15000),
(10,1007,10,1,45000);

SELECT * FROM CUSTOMERS c JOIN ORDERS o ON c.customer_id=o.order_id
                           JOIN ORDERS oi ON c.customer_id=oi.order_id;

CREATE TABLE SUPPLIERS (supplier_id INT PRIMARY KEY,
						supplier_name VARCHAR(50));

ALTER TABLE PRODUCTS ADD supplier_id INT;
ALTER TABLE PRODUCTS ADD CONSTRAINT fk_prod_supplier FOREIGN KEY (supplier_id) REFERENCES SUPPLIERS(supplier_id);

INSERT INTO SUPPLIERS VALUES
(201,'TechSource Pvt Ltd'),
(202,'Global Gadgets'),
(203,'Prime Electronics'),
(204,'NextGen Supplies'),
(205,'SmartWare Distributors');

UPDATE PRODUCTS SET supplier_id = 201 WHERE p_id IN (1,3,8);
UPDATE PRODUCTS SET supplier_id = 202 WHERE p_id IN (2,6);
UPDATE PRODUCTS SET supplier_id = 203 WHERE p_id IN (4,9);
UPDATE PRODUCTS SET supplier_id = 204 WHERE p_id IN (5,7);
UPDATE PRODUCTS SET supplier_id = 205 WHERE p_id = 10;

SELECT * FROM ORDERS o
JOIN PRODUCTS p ON o.order_id = p.o_id
JOIN SUPPLIERS s ON p.supplier_id = s.supplier_id;
CREATE TABLE LOCATIONS (location_id INT PRIMARY KEY,
						city VARCHAR(50));

ALTER TABLE DEPARTMENT ADD location_id INT;

ALTER TABLE DEPARTMENT ADD CONSTRAINT fk_dept_loc FOREIGN KEY (location_id) REFERENCES LOCATIONS(location_id);
INSERT INTO LOCATIONS VALUES
(1,'Hyderabad'),
(2,'Bangalore'),
(3,'Chennai'),
(4,'Mumbai'),
(5,'Delhi');

UPDATE DEPARTMENT SET location_id = 1 WHERE dept_id = 1;
UPDATE DEPARTMENT SET location_id = 2 WHERE dept_id = 2;
UPDATE DEPARTMENT SET location_id = 3 WHERE dept_id = 3;
UPDATE DEPARTMENT SET location_id = 4 WHERE dept_id = 4;

SELECT * FROM EMPLOYEES e JOIN DEPARTMENT d ON e.emp_id=d.dept_id
                           JOIN LOCATIONS l ON d.dept_id=l.location_id;
SELECT * FROM CUSTOMERS c JOIN ORDERS o ON c.customer_id=o.order_id
                          JOIN ORDER_ITEMS ol ON o.order_id=ol.order_id
						  JOIN PRODUCTS p ON ol.order_id=p.p_id;

SELECT c.customer_id,c.c_name,o.order_id,o.order_date,p.p_id,p.p_name,oi.qty,s.supplier_name
FROM CUSTOMERS c
JOIN ORDERS o ON c.customer_id = o.customer_id
JOIN ORDER_ITEMS oi ON o.order_id = oi.order_id
JOIN PRODUCTS p ON oi.product_id = p.p_id
JOIN SUPPLIERS s ON p.supplier_id = s.supplier_id;

/*JOIN + GROUP BY Tasks*/
SELECT * FROM ORDERS o;
SELECT * FROM CUSTOMERS c;
SELECT * FROM DEPARTMENT d;
SELECT * FROM EMPLOYEES e;
SELECT * FROM PRODUCTS p;
SELECT c.c_name, COUNT(c.order_id) AS ordercount FROM ORDERS o  RIGHT JOIN CUSTOMERS c ON c.order_id=o.order_id
GROUP BY c.c_name;
SELECT c.c_name, SUM(o.amount) AS total_amount FROM ORDERS o  RIGHT JOIN CUSTOMERS c ON c.order_id=o.order_id
GROUP BY c.c_name;
SELECT d.dept_name, COUNT(emp_id) AS emp_count FROM EMPLOYEES e LEFT JOIN DEPARTMENT d ON e.dept_id=d.dept_id
GROUP BY d.dept_name;
SELECT p.p_name, COUNT(o.customer_id) AS prod_order_count FROM PRODUCTS p LEFT JOIN ORDERS o ON p.o_id=o.order_id
GROUP BY p.p_name;
SELECT d.dept_name, SUM(e.salary) AS total_salary FROM DEPARTMENT d LEFT JOIN EMPLOYEES e ON d.dept_id=e.dept_id
GROUP BY d.dept_name;

/* JOIN + HAVING Tasks*/

SELECT c.c_name, COUNT(c.order_id) AS ordercount FROM ORDERS o  RIGHT JOIN CUSTOMERS c ON c.order_id=o.order_id
GROUP BY c.c_name
HAVING COUNT(c.order_id)>0;
SELECT d.dept_name, COUNT(emp_id) AS emp_count FROM EMPLOYEES e LEFT JOIN DEPARTMENT d ON e.dept_id=d.dept_id
GROUP BY d.dept_name
HAVING COUNT(emp_id)>2;
SELECT p.p_name, COUNT(o.customer_id) AS prod_order_count FROM PRODUCTS p LEFT JOIN ORDERS o ON p.o_id=o.order_id
GROUP BY p.p_name
HAVING COUNT(o.customer_id)>10;
SELECT c.c_name, SUM(o.amount) AS total_amount FROM ORDERS o  RIGHT JOIN CUSTOMERS c ON c.order_id=o.order_id
GROUP BY c.c_name
HAVING SUM(o.amount)>1300;


/*JOIN + COUNT Tasks*/

SELECT c.c_name,COUNT(c.order_id) AS order_count FROM CUSTOMERS c LEFT JOIN ORDERS o ON c.order_id=o.order_id 
GROUP BY c.c_name;
SELECT d.dept_name,COUNT(e.emp_id) AS No_of_employees FROM DEPARTMENT d LEFT JOIN EMPLOYEES e ON d.dept_id=e.dept_id 
GROUP BY d.dept_name;

SELECT * FROM PRODUCTS;

ALTER TABLE PRODUCTS ADD category VARCHAR(30);

UPDATE PRODUCTS SET category = 'Electronics' WHERE p_name IN ('Laptop','Tablet','Camera');
UPDATE PRODUCTS SET category = 'Accessories' WHERE p_name IN ('Mouse','Keyboard','Headset','Charger');
UPDATE PRODUCTS SET category = 'Peripherals' WHERE p_name IN ('Monitor','Printer');
UPDATE PRODUCTS SET category = 'Storage' WHERE p_name = 'USB';

SELECT * FROM PRODUCTS;

SELECT p1.category,COUNT(p2.p_id) AS product_count FROM PRODUCTS p1 JOIN PRODUCTS p2 ON p1.category=p2.category GROUP BY p1.category;

UPDATE ORDERS SET city='hyderabd' WHERE customer_id IN(101,102,103);
UPDATE ORDERS SET city='pune' WHERE customer_id IN(104,105);
ALTER TABLE ORDERS DROP COLUMN city;
ALTER TABLE CUSTOMERS ADD city VARCHAR(25);
UPDATE CUSTOMERS SET city='hyderabd' WHERE customer_id IN(101,102);
UPDATE CUSTOMERS SET city='pune' WHERE customer_id IN(103,104);
SELECT * FROM CUSTOMERS;
SELECT * FROM ORDERS;
SELECT c.city,COUNT(o.order_id) AS Orders_count FROM CUSTOMERS c JOIN ORDERS o ON c.customer_id=o.customer_id GROUP BY c.city; 

/*JOIN + WHERE Tasks*/
SELECT c.customer_id, c.c_name, c.email,o.order_date,o.order_id FROM CUSTOMERS c JOIN ORDERS o ON c.order_id=o.order_id WHERE o.order_date>'2026-01-01 00:00:00';
SELECT e.emp_id,e.emp_name FROM EMPLOYEES e JOIN DEPARTMENT d ON e.dept_id=d.dept_id WHERE d.dept_id=1;
ALTER TABLE ORDERS ADD city VARCHAR(25);
UPDATE ORDERS SET city = 'hyderabad' WHERE customer_id IN (101,102);
UPDATE ORDERS SET city = 'Bangalore' WHERE order_id IN (1002,1006,1010,1011);
UPDATE ORDERS SET city = 'Chennai'   WHERE order_id IN (1004,1007);
UPDATE ORDERS SET city = 'Mumbai'    WHERE order_id IN (1005,1009);
SELECT c.customer_id, c.c_name,o.order_date,o.order_id FROM CUSTOMERS c JOIN ORDERS o ON c.customer_id=o.customer_id 
WHERE o.city='hyderabad';
SELECT p.p_id,p.p_name,o.amount FROM PRODUCTS p JOIN ORDERS o ON p.o_id=o.order_id 
WHERE p.amount>1000;
/*JOIN + LIKE Tasks*/
SELECT c.customer_id, c.c_name, c.email,o.order_date,o.order_id FROM CUSTOMERS c JOIN ORDERS o ON c.order_id=o.order_id 
WHERE c.c_name LIKE 'a%';
SELECT e.emp_id,e.emp_name,d.dept_name FROM EMPLOYEES e JOIN DEPARTMENT d ON e.dept_id=d.dept_id 
WHERE e.emp_name LIKE '%a%';
SELECT * FROM ORDERS;
SELECT p.p_id,p.p_name,o.order_date,o.amount FROM PRODUCTS p JOIN ORDERS o ON p.o_id=o.order_id 
WHERE CONVERT(VARCHAR, order_date, 120)  LIKE '2026-02-05%';

/*JOIN + Constraints Tasks*/

ALTER TABLE ORDERS ADD FOREIGN KEY (customer_id) REFERENCES CUSTOMERS(customer_id);

SELECT c.customer_id, c.c_name, o.order_id, o.amount FROM CUSTOMERS c INNER JOIN ORDERS o ON c.customer_id = o.customer_id;

INSERT INTO ORDERS VALUES(1012,5200,'2026-01-05 18:45:00',11);
/*Msg 547, Level 16, State 0, Line 47
The INSERT statement conflicted with the FOREIGN KEY constraint "FK__ORDERS__customer__5812160E". The conflict occurred in database "college_db", table "dbo.CUSTOMERS", column 'customer_id'.
The statement has been terminated.*/
ALTER TABLE ORDERS ADD CONSTRAINT UQ_orders_orderdate UNIQUE(order_id);
SELECT * FROM ORDERS;
SELECT o.order_id, c.c_name, c.email FROM ORDERS o JOIN CUSTOMERS c ON o.customer_id = c.customer_id WHERE o.order_id = 1001;

SELECT * FROM EMPLOYEES e JOIN DEPARTMENT d ON e.dept_id=d.dept_id WHERE e.salary IS NOT NULL;

INSERT INTO ORDERS(order_id, amount, order_date, customer_id) VALUES (9999, 1000, GETDATE(), 999);
/*Msg 547, Level 16, State 0, Line 241
The INSERT statement conflicted with the FOREIGN KEY constraint "FK__ORDERS__customer__5812160E". The conflict occurred in database "college_db", table "dbo.CUSTOMERS", column 'customer_id'.
The statement has been terminated.*/

/*Multi-Select JOIN Tasks*/

SELECT c.c_name,o.order_id,o.amount,
(SELECT COUNT(*) FROM ORDERS o WHERE o.customer_id = c.customer_id) AS total_orders,
(SELECT AVG(amount) FROM ORDERS) AS avg_order_amount
FROM CUSTOMERS c JOIN ORDERS o ON c.customer_id = o.customer_id;

SELECT c.c_name AS Customer, o.order_id AS OrderNo, o.amount AS OrderValue ,
(SELECT MAX(amount) FROM ORDERS) AS MaxOrder 
FROM CUSTOMERS c JOIN ORDERS o ON c.customer_id=o.customer_id;

SELECT c.c_name AS Customer, o.order_id AS OrderNo, o.amount*1.18 AS OrderValueIncludingTax ,
(SELECT MAX(amount) FROM ORDERS) AS MaxOrder 
FROM CUSTOMERS c JOIN ORDERS o ON c.customer_id=o.customer_id;

SELECT c.c_name,o.order_id,o.amount,
CASE
WHEN o.amount>(SELECT AVG(amount) FROM ORDERS)
THEN 'Average'
WHEN o.amount>(SELECT AVG(amount)*1.5 FROM ORDERS)
THEN 'Very HIGH'
ELSE 'Normal'
END AS category
FROM CUSTOMERS c JOIN ORDERS o ON c.customer_id = o.customer_id;

/*JOIN + Subquery Tasks (IN / NOT IN / EXISTS / NOT EXISTS)*/
SELECT * FROM ORDERS;
SELECT * FROM PRODUCTS;
SELECT * FROM CUSTOMERS c JOIN ORDERS o ON c.customer_id=o.customer_id WHERE c.customer_id IN(101,102);
SELECT * FROM CUSTOMERS c JOIN ORDERS o ON c.customer_id=o.customer_id WHERE c.customer_id NOT IN(101,102);
SELECT p.* FROM PRODUCTS p LEFT JOIN ORDER_ITEMS oi ON p.p_id = oi.product_id WHERE oi.product_id IS NULL;
SELECT e.* FROM EMPLOYEES e LEFT JOIN DEPARTMENT d ON e.dept_id=d.dept_id WHERE d.dept_id IS NULL;
SELECT o.* FROM ORDERS o JOIN (SELECT AVG(amount) AS Average_amount FROM ORDERS) a ON o.amount>a.Average_amount;
SELECT DISTINCT c.* FROM CUSTOMERS c JOIN ORDERS o ON c.customer_id=o.customer_id 
                                     JOIN(SELECT AVG(amount) AS average_amount FROM ORDERS)a ON o.amount>a.average_amount;
SELECT * FROM DEPARTMENT;
SELECT * FROM EMPLOYEES;
SELECT e.* FROM EMPLOYEES e JOIN DEPARTMENT d ON e.dept_id=d.dept_id 
                            JOIN(SELECT dept_id,AVG(salary) AS avg_sal FROM EMPLOYEES GROUP BY dept_id) davg ON e.dept_id=davg.dept_id AND e.salary>davg.avg_sal;
SELECT * FROM DEPARTMENT dept_id IS NOT NULL;
SELECT * FROM CUSTOMERS WHERE order_id NOT IN (SELECT order_id FROM ORDERS WHERE order_id IS NULL );
SELECT * FROM CUSTOMERS c JOIN ORDERS o ON c.customer_id = o.customer_id 
                          AND o.amount > ( SELECT AVG(amount) FROM ORDERS );
SELECT c.c_name, t.total_orders FROM CUSTOMERS c JOIN (SELECT customer_id, COUNT(*) total_orders FROM ORDERS GROUP BY customer_id) t ON c.customer_id = t.customer_id;
SELECT DISTINCT c.* FROM CUSTOMERS c JOIN ORDERS o ON c.customer_id = o.customer_id WHERE o.customer_id IS NOT NULL;
SELECT c.* FROM CUSTOMERS c LEFT JOIN ORDERS o ON c.customer_id = o.customer_id WHERE o.customer_id IS NULL;
SELECT e.emp_name, d.dept_name FROM EMPLOYEES e
JOIN DEPARTMENT d ON e.dept_id = d.dept_id
JOIN (
    SELECT dept_id, AVG(salary) avg_sal
    FROM EMPLOYEES
    GROUP BY dept_id
) a ON e.dept_id = a.dept_id ;
SELECT d.dept_name, t.avg_sal FROM DEPARTMENT d
JOIN (
    SELECT dept_id, AVG(salary) avg_sal
    FROM EMPLOYEES
    GROUP BY dept_id
) t ON d.dept_id = t.dept_id;
