use database demo_sales;
create or replace schema demo_sales.scd_schema;

create or replace table customers (
customer_id integer,
customer_name varchar(255),
customer_email varchar(255),
customer_phone varchar(255),
load_date DATE,
customer_address varchar(255)
);

insert into customers values
(1, 'Arpit Rathi', 'arpit@gmail.com', '2222222222', '2022-04-14', '125 New St'),
(2, 'Pawan Singh', 'pawan@gmail.com', '4444444444', '2024-04-10', '256 Highway St'),
(3, 'Karan Agrawal', 'karan@gmail.com', '6666666666', '2022-07-12', '100 Sonaway Mn'),
(4, 'Aarav Bishnoi', 'aarav@gmail.com', '8888888888', '2024-08-24', '140 Main Street');


select * from demo_sales.scd_schema.customers;



-- Applying Type 1 SCD ---- overwritten
update customers set customer_phone = '1111111111'
where customer_phone ='2222222222';

-- Applying Type2 SCD ---- using a flag
alter table customers add column isActive boolean;
select * from demo_sales.scd_schema.customers;
update customers set isActive=True;
select * from demo_sales.scd_schema.customers;

alter table customers add column customer_segment string;
update customers set customer_segment='gold' where customer_phone = '1111111111';

-- changing gold to platinum in table
insert into customers 
select
customer_id,
customer_name,
customer_email,
customer_phone,
load_date,
customer_address,
isactive,
'platinum'
from customers where customer_id=1;

select * from customers;
update customers set isactive = False where customer_id = 1 and customer_segment='gold';


-- using load date and end date.
create or replace table employees (
customer_id integer,
customer_name varchar(255),
customer_email varchar(255),
customer_phone varchar(255),
load_date DATE,
end_date DATE Null,
customer_address varchar(255),
customer_segment string
);

insert into employees values
(1, 'Arpit Rathi', 'arpit@gmail.com', '2222222222', '2022-04-14',NULL, '125 New St','gold'),
(2, 'Pawan Singh', 'pawan@gmail.com', '4444444444', '2024-04-10',NULL, '256 Highway St','gold'),
(3, 'Karan Agrawal', 'karan@gmail.com', '6666666666', '2022-07-12',NULL, '100 Sonaway Mn','gold'),
(4, 'Aarav Bishnoi', 'aarav@gmail.com', '8888888888', '2024-08-24',NULL, '140 Main Street','gold');

select * from employees;

-- alter column value for customer_id = 2
update employees set end_date = CURRENT_DATE where customer_id = 1 and customer_segment='gold';
-- inserting the new row with updated values 
insert into employees 
select
customer_id,
customer_name,
customer_email,
customer_phone,
current_date,
null,
customer_address,
'platinum'
from employees where customer_id = 1;


select * from employees;
select row_number() over(order by customer_id) as row_key, * 
from employees;

-- Now applying the SCD 3 on customers table
--  we will only keep the previous value
select * from customers;
alter table customers add column previous_segment string;


update customers set customer_segment= 'silver', previous_segment = 'platinum'
where customer_id = 1 and isactive=True;





