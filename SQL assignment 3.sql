
CREATE TABLE zones(
    zone_id INT IDENTITY(1,1) PRIMARY KEY,
    zone_name VARCHAR(50),
    description VARCHAR(255)
);
ALTER TABLE zones
ALTER COLUMN zone_name VARCHAR(50) NOT NULL;
ALTER TABLE zones
ADD created_at DATETIME DEFAULT GETDATE();
CREATE TABLE service_types(
    service_type_id INT IDENTITY(1,1) PRIMARY KEY,
    service_name VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    created_at DATETIME DEFAULT GETDATE()
);
CREATE TABLE customers(
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_name VARCHAR(100),
    is_special_pricing BIT
);
ALTER TABLE customers
ALTER COLUMN customer_name VARCHAR(100) NOT NULL;
ALTER TABLE customers
ADD CONSTRAINT DF_customer_special DEFAULT 0 FOR is_special_pricing;
ALTER TABLE customers
ADD created_at DATETIME DEFAULT GETDATE();
CREATE TABLE rates(
    rate_id INT IDENTITY(1,1) PRIMARY KEY,
    zone_id INT,
    service_type_id INT,
    min_weight DECIMAL(10,2),
    max_weight DECIMAL(10,2),
    base_price DECIMAL(10,2),
    effective_start_date DATE,
    effective_end_date DATE
);
ALTER TABLE rates
ADD CONSTRAINT FK_rates_zone
FOREIGN KEY(zone_id) REFERENCES zones(zone_id);
ALTER TABLE rates
ADD CONSTRAINT FK_rates_service
FOREIGN KEY(service_type_id) REFERENCES service_types(service_type_id);
ALTER TABLE rates
ADD CONSTRAINT CHK_weight CHECK (min_weight < max_weight);
ALTER TABLE rates
ADD created_at DATETIME DEFAULT GETDATE();
CREATE TABLE customer_special_rates(
    special_rate_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT,
    zone_id INT,
    service_type_id INT,
    min_weight DECIMAL(10,2),
    max_weight DECIMAL(10,2),
    base_price DECIMAL(10,2),
    effective_start_date DATE,
    effective_end_date DATE
);
ALTER TABLE customer_special_rates
ADD FOREIGN KEY(customer_id) REFERENCES customers(customer_id);
ALTER TABLE customer_special_rates
ADD FOREIGN KEY(zone_id) REFERENCES zones(zone_id);
ALTER TABLE customer_special_rates
ADD FOREIGN KEY(service_type_id) REFERENCES service_types(service_type_id);
CREATE TABLE surcharge_types(
    surcharge_type_id INT IDENTITY(1,1) PRIMARY KEY,
    surcharge_name VARCHAR(100),
    is_percentage BIT
);
ALTER TABLE surcharge_types
ADD created_at DATETIME DEFAULT GETDATE();
CREATE TABLE rate_surcharges(
    rate_surcharge_id INT IDENTITY(1,1) PRIMARY KEY,
    rate_id INT,
    surcharge_type_id INT,
    value DECIMAL(10,2),
    effective_start_date DATE,
    effective_end_date DATE
);
ALTER TABLE rate_surcharges
ADD FOREIGN KEY(rate_id) REFERENCES rates(rate_id);
ALTER TABLE rate_surcharges
ADD FOREIGN KEY(surcharge_type_id) REFERENCES surcharge_types(surcharge_type_id);
CREATE TABLE shipments(
    shipment_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT,
    zone_id INT,
    service_type_id INT,
    weight DECIMAL(10,2),
    shipment_date DATE,
    applied_rate_id INT,
    is_special_pricing BIT,
    base_price_applied DECIMAL(10,2),
    total_surcharge DECIMAL(10,2),
    final_price DECIMAL(10,2)
);
ALTER TABLE shipments
ADD FOREIGN KEY(customer_id) REFERENCES customers(customer_id);
ALTER TABLE shipments
ADD FOREIGN KEY(zone_id) REFERENCES zones(zone_id);
ALTER TABLE shipments
ADD FOREIGN KEY(service_type_id) REFERENCES service_types(service_type_id);
ALTER TABLE shipments
ADD FOREIGN KEY(applied_rate_id) REFERENCES rates(rate_id);
ALTER TABLE shipments
ADD created_at DATETIME DEFAULT GETDATE();
CREATE TABLE shipment_surcharges(
    shipment_surcharge_id INT IDENTITY(1,1) PRIMARY KEY,
    shipment_id INT,
    surcharge_type_id INT,
    amount DECIMAL(10,2)
);
ALTER TABLE shipment_surcharges
ADD FOREIGN KEY(shipment_id) REFERENCES shipments(shipment_id);
ALTER TABLE shipment_surcharges
ADD FOREIGN KEY(surcharge_type_id) REFERENCES surcharge_types(surcharge_type_id);
INSERT INTO zones(zone_name,description)
VALUES ('Zone A','Local'),
       ('Zone B','Interstate');
INSERT INTO service_types(service_name,description)
VALUES ('Standard','Regular delivery'),
       ('Express','Fast delivery');
INSERT INTO customers(customer_name,is_special_pricing)
VALUES ('ABC Traders',1),
       ('XYZ Logistics',0);
INSERT INTO rates(zone_id,service_type_id,min_weight,max_weight,base_price,effective_start_date,effective_end_date)
VALUES (1,1,0,5,100,'2024-01-01',NULL),
       (1,2,0,5,150,'2024-01-01',NULL);
INSERT INTO surcharge_types(surcharge_name,is_percentage)
VALUES ('Fuel Charge',1),
       ('Handling Fee',0);
INSERT INTO rate_surcharges(rate_id,surcharge_type_id,value,effective_start_date,effective_end_date)
VALUES (1,1,10,'2024-01-01',NULL),
       (1,2,20,'2024-01-01',NULL);

INSERT INTO shipments(customer_id,zone_id,service_type_id,weight,shipment_date,
applied_rate_id,is_special_pricing,base_price_applied,total_surcharge,final_price)
VALUES (1,1,1,3,'2024-06-01',1,1,90,29,119);

INSERT INTO shipment_surcharges(shipment_id,surcharge_type_id,amount)
VALUES (1,1,9),
       (1,2,20);
SELECT * FROM zones;
SELECT * FROM service_types;
SELECT * FROM customers;
SELECT * FROM rates;
SELECT * FROM shipments;
INSERT INTO zones(zone_name,description)
VALUES ('Zone C','International'),
       ('Zone D','Remote Area');
INSERT INTO service_types(service_name,description)
VALUES ('Same-Day','Delivery within 24 hours'),
       ('Economy','Low cost shipping');
INSERT INTO customers(customer_name,is_special_pricing)
VALUES ('Global Corp',1),
       ('Fast Movers',0);
INSERT INTO rates(zone_id,service_type_id,min_weight,max_weight,base_price,effective_start_date,effective_end_date)
VALUES (1,1,5,10,180,'2024-01-01',NULL),
       (2,1,0,5,220,'2024-01-01',NULL);
UPDATE rates
SET base_price = 200
WHERE rate_id = 4;
INSERT INTO customer_special_rates
(customer_id,zone_id,service_type_id,min_weight,max_weight,base_price,effective_start_date,effective_end_date)
VALUES (3,1,1,0,5,95,'2024-01-01',NULL);
INSERT INTO surcharge_types(surcharge_name,is_percentage)
VALUES ('Insurance Fee',0);
INSERT INTO rate_surcharges(rate_id,surcharge_type_id,value,effective_start_date,effective_end_date)
VALUES (3,1,12,'2024-01-01',NULL);
INSERT INTO shipments(customer_id,zone_id,service_type_id,weight,shipment_date,
applied_rate_id,is_special_pricing,base_price_applied,total_surcharge,final_price)
VALUES (2,1,2,4,'2024-06-05',2,0,150,38,188),
       (3,1,1,4,'2024-07-01',1,1,95,29,124);
INSERT INTO shipment_surcharges(shipment_id,surcharge_type_id,amount)
VALUES (2,1,18),
       (2,2,20),
       (3,1,9),
       (3,2,20);
 /*1st qn*/
SELECT r.rate_id,z.zone_name,st.service_name,r.base_price,r.effective_start_date,r.effective_end_date FROM rates r JOIN zones z ON r.zone_id = z.zone_id
                                                                                                                   JOIN service_types st ON r.service_type_id = st.service_type_id
WHERE GETDATE() BETWEEN r.effective_start_date
                    AND ISNULL(r.effective_end_date, GETDATE());
/* 2. qn*/
SELECT s.shipment_id,s.applied_rate_id,r_current.rate_id AS current_rate FROM shipments s JOIN rates r_current ON s.zone_id = r_current.zone_id
                                                                                                               AND s.service_type_id = r_current.service_type_id
                                                                                                               AND s.weight BETWEEN r_current.min_weight AND r_current.max_weight
                                                                                                               AND GETDATE() BETWEEN r_current.effective_start_date
                                                                                                               AND ISNULL(r_current.effective_end_date, GETDATE())
WHERE s.applied_rate_id <> r_current.rate_id;
/* 3. qn*/
SELECT s.shipment_id,c.customer_name,s.base_price_applied,s.total_surcharge,s.final_price FROM shipments s JOIN customers c ON s.customer_id = c.customer_id;
/* 4. qn */
SELECT r.* FROM rates r JOIN zones z ON r.zone_id = z.zone_id 
                        JOIN service_types st ON r.service_type_id = st.service_type_id
WHERE z.zone_name = 'Zone A'
AND st.service_name = 'Standard';
/*5th qn*/
SELECT s.shipment_id,c.customer_name,s.final_price FROM shipments s
JOIN customers c ON s.customer_id = c.customer_id
WHERE s.is_special_pricing = 1;