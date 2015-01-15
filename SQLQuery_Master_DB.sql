CREATE TABLE Department
(
DeptID INT IDENTITY(1,1) PRIMARY KEY,
DeptName VARCHAR(100) NOT NULL,
IsActive bit NOT NULL
);
ALTER TABLE Department ADD CONSTRAINT DF_Active DEFAULT 1 FOR IsActive
ALTER TABLE Department ADD CONSTRAINT AK_Name UNIQUE (DeptName)
ALTER TABLE Department ADD CONSTRAINT CK_Name CHECK (DeptName <> ' ')
INSERT INTO Department
(
DeptName,
IsActive
)
VALUES
('Travel',1),
('Services',1),
('Security',1),
('HR',1)

select * from Department;
CREATE TABLE Employee
(
EmpID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
EmpName VARCHAR(100) NULL,
DOB DATE NULL,
VariablePay INT NULL,
IsContract BIT NULL,
DeptID INT NULL REFERENCES Department(DeptID)
)
INSERT INTO Employee
(
EmpName,
DOB,
VariablePay,
IsContract,
DeptID
)
VALUES
('Rani','12-02-1976',17,1,2)
 select * from Employee;

 delete from Employee where IsContract IS NULL;
 
 -------------------------------------------------------------------------------------------------
 
 
 
 
 select EmpName,CASE IsContract WHEN 1 THEN 'Contract' ELSE  'Non-Contract' END from Employee;
 
 
 select Count(IsContract)+ISNULL(IsContract,0), CASE IsContract  WHEN 1 THEN 'Contract' ELSE  'Non-Contract' END from Employee group by IsContract having IsContract>=0;

 select Count(EmpName),REPLACE(IsContract,null,0), CASE IsContract WHEN 1 THEN 'Contract' ELSE  'Non-Contract' END from Employee group by IsContract

 select count(EmpName),(REPLACE(IsContract,0,1)), CASE IsContract WHEN 1 THEN 'Contract' ELSE  'Non-Contract' END from Employee group by IsContract

 select COUNT(EmpName) from Employee group by IsContract;
 
 select MAX(variablepay) from Employee where MAX(variablepay)<((select VariablePay from Employee where MAX(variablepay)<(select MAX(variablepay) from Employee))
 
SELECT Top 1 VariablePay  FROM ( SELECT TOP 3 variablepay  FROM Employee  ORDER BY variablepay desc) as SubQuery order by VariablePay ;
 
 select MAX(VariablePay) from Employee where variablepay<(select MAX(variablepay) from Employee where variablepay<(select MAX(VariablePay) from Employee ))
 
 select MIN(VariablePay) from Employee where VariablePay IN(select top 3  VariablePay from Employee order by VariablePay DESC)
 
 
 --select Min(VariablePay) from (select top 3  VariablePay from Employee order by VariablePay desc);
 
 
 
 
 
 CREATE TABLE [dbo].[Product](
[Maker] [varchar](10) NOT NULL,
[Model] [varchar](50) NOT NULL PRIMARY KEY,
[Type] [varchar](10) NULL
) ON [PRIMARY]
INSERT INTO [Product] (Maker, Model, [Type])
VALUES ('DELL','NSeries','Laptop'),
('HP','9001','PC'),
('HP','9002','PC'),
('HP','9003','PC'),
('Lenovo','Thinkpad','Laptop'),
('HP','F4200','Printer'),
('HP','F2200','Printer'),
('HP','9004','PC')
 
 CREATE TABLE [dbo].[PC](
[ID] [int] IDENTITY(1,1) NOT NULL,
[Model] [varchar](50) NULL FOREIGN KEY REFERENCES Product(Model),
[Speed] [decimal](18, 0) NULL,
[RAM] [int] NULL,
[HD] [int] NULL,
[CD] [smallint] NULL,
[Price] [money] NULL
) ON [PRIMARY]
INSERT INTO PC (Model, Speed,RAM,HD,CD,Price)
VALUES ('9001',1.8,2048,300,4,500),
('9002',1.3,1024,300,4,400),
('9002',2.2,4096,400,4,550)

CREATE TABLE [dbo].[Laptop](
[ID] [int] IDENTITY(1,1) NOT NULL,
[Model] [varchar](50) NULL FOREIGN KEY REFERENCES Product(Model),
[Speed] [decimal](18, 0) NULL,
[RAM] [int] NULL,
[HD] [int] NULL,
[Screen] [int] NULL,
[Price] [money] NULL
) ON [PRIMARY]

INSERT INTO Laptop (Model, Speed,RAM,HD,Screen,Price)
VALUES ('NSeries',1.8,2048,300,11,550),
('Thinkpad',1.3,1024,300,13,450),
('NSeries',2.2,4096,400,17,650)

CREATE TABLE [dbo].[Printer](
[ID] [int] IDENTITY(1,1) NOT NULL,
[Model] [varchar](50) NULL FOREIGN KEY REFERENCES Product(Model),
[IsColor] [bit] NULL,
[Type] [varchar](50) NULL,
[Price] [money] NULL
) ON [PRIMARY]
INSERT INTO [Printer] (Model, IsColor, [Type], Price)
VALUES ('F4200',1,'Laser', 100),
('F2200',0,'Inkjet', 600)

select * from Product;
select * from PC;
select * from Printer;
select * from Laptop;
select Pc.Price,Pdt.Model from PC pc full outer join Product Pdt on pc.Model=Pdt.Model 
select Printer.Model,Printer.Price,PC.price from PC full outer join Printer on PC.Model=Printer.Model;
select * from Product left outer join PC on Product.Model=PC.Model;
select * from (select * from PC pc left Outer join Product pdt on pdt.Model=pc.Model) left outer join Printer pr  ; 
select ID ,model,case IsColor when 1 then 'Color' when 0 then 'Non-Color' end  from Printer;


--Find the model number, speed and hard drive capacity for all the PCs with prices below $500.

select model,Speed,HD,Price from PC where Price<500;

-- Find number of products from HP that are priced above $500
 
select COUNT(Product.Maker) from Product left outer join Printer on Product.Model=Printer.Model left outer join Laptop on Laptop.Model=Product.Model left outer join PC on PC.Model=Product.Model where Product.Maker='HP' and (PC.Price is not null or Printer.Price is not null or Laptop.Price is not null) and (PC.Price>500 or Laptop.Price>500 or Printer.Price>500) 

-- List the PCs and Laptops in the increasing order of price
 
select * from PC union select * from Laptop order by Price; 

 -- List the makers having at least one model priced above $500

select distinct Product.Maker from Product left outer join Laptop on Product.Model=Laptop.Model left outer join Printer on Product.Model=Printer.Model left outer join PC on Product.Model=PC.Model where PC.Price>500 or Laptop.Price>500 or Printer.Price>500;
 
select * from Product;
select * from Printer;
SELECT * FROM Laptop;
select * from PC;

select * from Product left outer join Printer on Product.Model=Printer.Model left outer join Laptop on Laptop.Model=Product.Model left outer join PC on PC.Model=Product.Model where PC.Price is not null or Printer.Price is not null or Laptop.Price is not null 



--5. Write a view that returns the Maker, Model, RAM, Speed, Price of Laptops.

create view View1 as  select Product.Maker,Product.Model,Laptop.RAM,Laptop.Speed,laptop.Price from Laptop inner join Product on Laptop.Model=Product.Model;

select * from View1
--6. Write a SP to read from the view: Maker, Model, Price of those laptops that are priced below $600

create Procedure P1 as begin select Product.Maker,Product.Model,Laptop.RAM,Laptop.Speed,laptop.Price from Laptop inner join Product on Laptop.Model=Product.Model where Laptop.Price<600 end

exec dbo.P1

--7. Write a SP that takes details of a new department (input values) and inserts new department record.

alter Procedure AdoSpPara @deptid int    as Begin select * from  Department where DeptId=@deptid end;

Exec dbo.AdoSpPara 'Travel';
select * from Department;
--8. Write a UDF to calculate average of variable pay for all employees of a particular department. Department ID should be the input parameter.

alter FUNCTION fun1(@deptId INT)
    RETURNS float
AS

BEGIN
DECLARE @avg float

select @avg = Avg(VariablePay)  from Employee where DeptID=@deptId;
    
    
    RETURN @avg
END

declare @dept float
exec @dept=dbo.fun1 @deptId=2
select @dept;

select * from Department;
select * from Employee;
insert into Employee VALUES(10,'MKP','1998-17-28',10,1,4)

CREATE TABLE PhoneType
(
PhoneType_ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
PhoneType_Description VARCHAR(50) NOT NULL,
PhoneType_Priority VARCHAR(10) NOT NULL
)

INSERT INTO PhoneType (PhoneType_Description,PhoneType_Priority)
VALUES ('Home','Priority2'), ('Work','Priority3'), ('Mobile','Priority1')

CREATE TABLE Person
(
Person_ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
Person_LastName VARCHAR(50) NULL,
Person_FirstName VARCHAR(50) NOT NULL,
Person_DOB DATE NOT NULL,
)
INSERT INTO Person (Person_LastName, Person_FirstName, Person_DOB)
VALUES ('Smith', 'Mkp', '11/24/1985'),
('Twain', 'Mark', '01/15/1973'),
('Naylor', 'Nick', '01/15/1973'),
('Smith', 'John', '5/02/1988'),
('Your', 'Name', '8/09/1988'),
(NULL, 'FirstName', '1/02/1980')
 select * from Person;
 --Question1: Select diferent birthdays available in DOB column of Person table. No DOB should be repeated in the result set.
select Distinct Person_DOB from Person
--Question2: Select all valid (non-null, non-empty) last names
select Person_LastName from Person where Person_LastName is Not Null;
--Question3: Select person ID, full name as '<Person_LastName>, <Person_FirstName>'. If a person has only first name display only first name. Use "+" operator for concatenation.
select Person_Id,Person_FirstName+','+isNull(Person_lastName,'')   from Person ;
--Question4: Retreive the number of persons with same last name.
select (COUNT(Person_LastName)-COUNT(distinct Person_LastName))+ from Person where Person_LastName is Not Null;
select Person_Lastname,COUNT(Person_lastname) from Person group by Person_LastName having Person_LastName is not null and  COUNT(Person_lastname)>1;
select * from Employee;
select * from Department;
--Q1: Create a SP to loop through (use cursor) Employee table and print “Working hrs of <Name>:” each employee with the rule:
--    Security works 12hrs and all others work 9.5 hrs.

select Employee.EmpName,DeptName from Department inner join Employee on Department.DeptID=Employee.DeptID;


create Procedure P3 
as
begin 
Declare @EmpName varchar(100)
Declare @DepartName varchar(100) 
declare dept_cursor cursor  for select Employee.EmpName,Department.DeptName from Department inner join Employee on Department.DeptID=Employee.DeptID
open dept_cursor
FETCH NEXT FROM dept_cursor INTO @EmpName,@DepartName  
WHILE @@FETCH_STATUS = 0   
BEGIN   
      IF(@DepartName='Security')
      print @EmpName +' Works for 12 Hr'
      else     
	  print @EmpName + ' Works for 9.5 Hr'
      FETCH NEXT FROM dept_cursor INTO @EmpName,@DepartName
       
END   

CLOSE dept_cursor   
DEALLOCATE dept_cursor  
end
exec dbo.P3


CREATE TABLE PersonPhone
(
PersonPhone_ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
Person_ID INT NOT NULL REFERENCES Person(Person_ID),
PhoneType_ID INT NULL REFERENCES PhoneType(PhoneType_ID),
PhoneNumber VARCHAR(10) NULL
)
INSERT INTO PersonPhone (Person_ID, PhoneType_ID, PhoneNumber)
VALUES (1, 3, '9485690421'), (1, 1, '0808347659'), (2, 2, '0808237959'), (3, 3, '9485690422'), (3, 2, '0808565459'),
(4, 3, '9485789421'), (3, 1, '080374658'), (3, NULL,NULL)
 
 CREATE TABLE PhoneType
(
PhoneType_ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
PhoneType_Description VARCHAR(50) NOT NULL,
PhoneType_Priority VARCHAR(10) NOT NULL
)
INSERT INTO PhoneType (PhoneType_Description,PhoneType_Priority)
VALUES ('Home','Priority2'), ('Work','Priority3'), ('Mobile','Priority1')
drop table PersonPhone
drop table PhoneType
;

--Write a query to fetch phone numbers against each person such that if person has "mobile number", 
--it should be picked; if no mobile number is for that person is available, pick other available phone 
--with the order of priority: Home, Work. 
--Hint: Loop using a cursor and use if conditions, temporary tables if you see a need.
select * from PersonPhone;
select * from PhoneType
select * from Person;

create Procedure P4 
as
begin 
declare @var Int = 1
DECLARE @Table TABLE(PersonID Int,Name varchar(50), 
Phone varchar(50),PhoneNum varchar(10))
declare @Name varchar(50) 
declare @PersonId Int
declare @Phone varchar(50)
declare @PhoneNum varchar(10)
declare phone_cursor cursor  for select Person.Person_Id,Person.Person_FirstName,PhoneType.PhoneType_Description,PersonPhone.PhoneNumber from 
 Person left outer join PersonPhone on Person.Person_Id=PersonPhone.Person_Id  left outer join PhoneType on PersonPhone.PhoneType_Id=PhoneType.PhoneType_Id
open phone_cursor
  
FETCH NEXT FROM phone_cursor INTO @PersonId,@Name , @Phone ,@PhoneNum 
WHILE @@FETCH_STATUS = 0   
BEGIN   
     
      IF(@PersonId=@var and @Phone='Mobile')
    begin
   insert into @Table(PersonId,Name,Phone,PhoneNum) values(@PersonId,@Name,@Phone,@PhoneNum)
    set @var = @var+1
    FETCH NEXT FROM phone_cursor INTO @PersonId,@Name , @Phone ,@PhoneNum 
    continue
    end
    else IF(@PersonId=@var and @Phone='Home')
    begin
    insert into @Table(PersonId,Name,Phone,PhoneNum) values(@PersonId,@Name,@Phone,@PhoneNum)
    set @var = @var+1
    FETCH NEXT FROM phone_cursor INTO @PersonId,@Name , @Phone ,@PhoneNum 
    continue
    end
     else IF(@PersonId=@var and @Phone='Work')
    begin
    insert into @Table(PersonId,Name,Phone,PhoneNum) values(@PersonId,@Name,@Phone,@PhoneNum)
    set @var = @var+1
    FETCH NEXT FROM phone_cursor INTO @PersonId,@Name , @Phone ,@PhoneNum 
    continue
    
    end 
    else IF(@PersonId=@var and @Phone is Null )
    begin
    insert into @Table(PersonId,Name,Phone,PhoneNum) values(@PersonId,@Name,@Phone,@PhoneNum)
    set @var = @var+1
    FETCH NEXT FROM phone_cursor INTO @PersonId,@Name , @Phone ,@PhoneNum 
    continue
    
    end 
    FETCH NEXT FROM phone_cursor INTO @PersonId,@Name, @Phone ,@PhoneNum        
       
END   
CLOSE phone_cursor
DEALLOCATE phone_cursor
select  * from  @Table
end


exec dbo.P4

--Write a SP to insert new person had his/her mobile phone number. Input paramters are: Person Lastname, 
--First name, DOB, Mobile Phone number.
--Use TRY/CATCH and TRAN. Use in-built function to read identity value inserted.



Alter procedure P5(@PersonLastName varchar(50),@PersonFirstName varchar(50),@DOB date,@MobileNumber varchar(10)) as begin 
begin try
begin tran
INSERT INTO Person (Person_LastName, Person_FirstName, Person_DOB)
VALUES (@PersonLastName, @PersonFirstName, @DOB)
INSERT INTO PersonPhone (Person_ID, PhoneType_ID, PhoneNumber)
VALUES (SCOPE_IDENTITY(), 3, '@MobileNumber')
end try
begin catch
SELECT 
        ERROR_NUMBER() AS ErrorNumber
        ,ERROR_SEVERITY() AS ErrorSeverity
        ,ERROR_STATE() AS ErrorState
        ,ERROR_PROCEDURE() AS ErrorProcedure
        ,ERROR_LINE() AS ErrorLine
        ,ERROR_MESSAGE() AS ErrorMessage;

if( XACT_STATE() !=0 )
begin
rollback
print 'Transaction Error!!!'
end 
end catch 
end
exec dbo.P5 'Kumar','Manish','12/1/1998',9046351984

insert into PersonPhone(Person_Id,PhoneType_ID,PhoneNumber) values(2,1,'9046351984')
--1. Write an After trigger for Dept table

select * from Person
select * from Department
alter table PersonPhone alter column PhoneNumber varchar(15)

alter trigger trg_dept on Department after insert as 
select 'New Department added on ' as Message ,CURRENT_TIMESTAMP as DATE
 insert into Department values('ABC',0)
 --select * from PersonPhone
--2. Write a INSTEAD of trigger on PersonPhone table so that "091" is prefixed to the orginial phone number entered.
alter trigger trg_PersonPhone on PersonPhone INSTEAD OF insert as 
declare @PhoneNum varchar(15)
select @PhoneNum=inserted.PhoneNumber from inserted
insert into PersonPhone(Person_Id,PhoneType_ID,PhoneNumber) values(2,1,'091'+@PhoneNum)
select 'New Phone Number Added: '+PhoneNumber  +' on ', CURRENT_TIMESTAMP from PersonPhone where PhoneNumber='091'+@PhoneNum

------------------------

create trigger trg_DeprtDelete on Department INSTEAD OF delete as 
declare @DeptName VARCHAR(100)
select @DeptName=deleted.DeptName from deleted
If(@DeptName='Manish')
Select 'You can''t Delete Department Named as Manish'  Message
Else 
begin
delete from Department where DeptName=@DeptName
select 'A Record  '+DeptName+'Deleted '+' on ', CURRENT_TIMESTAMP from Department where DeptName=@DeptName
end
delete from department where DeptName='Manish'
select * from employee
select * from Department
--1. Write a query to read records from employee table. Group the output by department and assign rown number based on variable pay (increasing value of variable pay) 
 
 select EmpId,EmpName,DOB,VariablePay,IsContract,
 Row_Number() over(PARTITION BY DeptId order by VariablePay) RowNum
  from (select e.EmpId,e.EmpName,e.DOB,e.VariablePay,e.IsContract,e.DeptID from Employee e left outer join Department
   on e.DeptId=Department.DeptId ) e1 
 
 select EmpId,EmpName,DOB,VariablePay,IsContract,DeptID,Row_Number() over(PARTITION BY DeptID Order BY VariablePay) RowNum From Employee order by VariablePay
 
--2. Write a CTE to fetch all product, laptop, pc and printer details, partition by maker and order by model (use row_number)
select * from Product
select * from PC
select * from Printer
select * from Laptop
;with cte as (
(select p.Maker,p.Model,pc.Price 
from Product p inner join Pc on p.Model=pc.Model) 
union 
(select p.Maker,p.Model,Laptop.Price
from Product p inner join Laptop on Laptop.Model=p.Model)
 union 
(select p.Maker,p.Model,Printer.Price 
from Product p inner join Printer on p.model=Printer.model )  
) 
select * from Department
select Maker,Model,Price,Row_Number() over(partition by maker order by model) RowId from cte 
--Add new dept ‘Finance’ and a list of 3 employees (‘Sinha’, ’Mukherjy’, ’PC’) for this dept, using a single SP.

create type Depttype1 as table (DeptId int,DeptName varchar(100))
create procedure P6 @deptTable Depttype readonly as begin 
insert into Department(DeptName) select DeptName from @deptTable end
declare @var1 Depttype
insert into @var1 values('Finnance')
EXEC DBO.P6 @var1
--Q1: Add new dept ‘Finance’ and a list of 3 employees (‘Sinha’, ’Mukherjy’, ’PC’) for this dept, using a single SP. Result set from SP should have newly created employees as result set. Use OUTPUT clause.
-- declare @mkp varchar(20)select EmpName,@mkp from Employee;
--select * from Department delete from Department where DeptName='Finnance1' 
create type Emptype3 as table (EmpName1 varchar(100))
alter procedure P6 @deptTable Depttype readonly,@EmpTable Emptype3 readonly as begin
declare @DeptId int 
insert into Department(DeptName) OUTPUT INSERTED.*  select DeptName from @deptTable 
set @DeptId=Scope_Identity()
insert into Employee(EmpName,DeptId) OUTPUT INSERTED.* select EmpName1,@DeptId from @EmpTable

end

declare @var1 Depttype
insert into @var1 values('Finnance11231212132214')
declare @var2 Emptype3
insert into @var2 values('sinha112123211322412'),('Mukher1j32y138121212112'),('pc122337112211121')
EXEC DBO.P6 @var1,@var2


--Q2: Create a UDF that takes phoneID as input paramter and returns formatted ph number  as "091-123-456-7890"
--select * from PersonPhone
--select Person_FirstName,Person_LastName,PersonPhone.PhoneNumber from Person inner join PersonPhone on PersonPhone.Person_Id=Person.Person_Id

alter FUNCTION fun3(@phoneId INT)
    RETURNS @PersonPhoneTable TABLE
   (
   Person_Id int,Person_FirstName varchar(50),Person_LastName varchar(50),PhoneNumber varchar(15)
   )
AS


BEGIN
insert @PersonPhoneTable select Person.Person_Id,Person_FirstName,Person_LastName,PersonPhone.PhoneNumber from Person inner join PersonPhone on PersonPhone.Person_Id=Person.Person_Id
declare @PhNum varchar(15)
--select @PhNum=PhoneNumber from PersonPhone where Person_Id=@phoneId
--update @PersonPhoneTable set @PhNum=PhoneNumber from PersonPhone where Person_Id=@phoneId
--select substring(@PhNum,3,3)+'-'+substring(@PhNum,4,3)+'-'+substring(@PhNum,7,3)+'-'+substring(@PhNum,10,4) from @PersonPhoneTable where Person_Id=@phoneId
    RETURN  
  --substring(@PhNum,3,3)+'-'+substring(@PhNum,4,3)+'-'+substring(@PhNum,7,3)+'-'+substring(@PhNum,10,4) 
END

declare @phoneId int
declare @table TABLE
   (
   Person_Id int,Person_FirstName varchar(50),Person_LastName varchar(50),PhoneNumber varchar(15)
   )
exec @table=fun3 @phoneId=1
select @table;

-----
CREATE FUNCTION LargeOrderShippers ( @FreightParm money )
RETURNS @OrderShipperTab TABLE
   (
    ShipperID     int,
    ShipperName   nvarchar(80),
    OrderID       int,
    ShippedDate   datetime,
    Freight       money
   )
AS
BEGIN
   INSERT @OrderShipperTab
        SELECT S.ShipperID, S.CompanyName,
               O.OrderID, O.ShippedDate, O.Freight
        FROM Shippers AS S
             INNER JOIN Orders AS O ON (S.ShipperID = O.ShipVia)
        WHERE O.Freight > @FreightParm
   RETURN
END

SELECT *
FROM LargeOrderShippers( $500 )
-------

--Q3: Write a query to use above UDF by passing person ID as input paramter and query should return person name with formatted ph number.
drop table ConctInfo
create table PaymentType(paymentType INT constraint Pk_PaymentType primary key IDENTITY(1,1),description char(20))
insert into PaymentType values('ONLine'),('CASH')
create table ConctInfo(ContactId int constraint Pk_ContactId primary key IDENTITY(1,1),Name char(45),street char(40),city char(20),state char(20),country char(20),ZipCode char(20),Phone char(20))
insert into ConctInfo values('Prachi','Btm 2nd Phase','Bangalore','Karnataka','India','560068','842984829'),('Ramdhi','Bomanhhalli','Bangalore','Karnataka','India','560068','862474624'),('Alen','Electronic City','Bangalore','Karnataka','India','560068','0892844842'),('Sruti','SilkBoard','Bangalore','Karnataka','India','560068','9084290482'),
insert into ConctInfo values('Danial','Btm 1st Stage','Bangalore','Karnataka','India','560068','782424787')
create table items(ItemNumber Int Constraint Pk_ItemNumber primary key  Identity(1,1),ItemName char(40),ItemPrice decimal )
insert into items values('IPhone5',10000.00),('Nexus5',5000.00),('Dell Laptop',15000.00),('MotoX',120000.00),('Mac Air',13000.00 )

create table OrderDesc(OrderId int constraint Pk_order_ID primary key Identity(1,1),Date_Ordered date,Date_FullFilled date,TaxFedral decimal,TaxState decimal,TaxLocal decimal,SubToatalBeforeTax decimal,ShipToContactId int references ConctInfo(ContactId),BillToContactId int references ConctInfo(ContactId))
insert into OrderDesc(Date_Ordered,Date_FullFilled ,TaxFedral ,TaxState ,TaxLocal ,SubToatalBeforeTax,ShipToContactId ,BillToContactId ) values('1/1/2013','12/06/2013',1290.00,1600.00,978.00,5400.00,1,1),('1/1/2013','09/02/2013',1200.00,1100.00,900.00,5600.00,1,2),('1/1/2013','12/05/2013',1200.00,1100.00,900.00,5600.00,2,2),('1/1/2013','10/02/2013',1200.00,1100.00,900.00,5600.00,2,3),('1/3/2013','10/02/2013',1200.00,1100.00,900.00,5600.00,2,4),('1/1/2013','10/3/2013',1200.00,1100.00,900.00,5600.00,2,5),('1/1/2013','10/3/2013',1200.00,1100.00,900.00,5600.00,3,2),('1/1/2013','10/3/2013',1200.00,1100.00,900.00,5600.00,3,3),('1/1/2013','10/3/2013',1200.00,1100.00,900.00,5600.00,3,4),('1/1/2013','10/3/2013',1200.00,1100.00,900.00,5600.00,3,5),('1/1/2013','10/3/2013',1200.00,1100.00,900.00,5600.00,4,4),('1/1/2013','10/3/2013',1200.00,1100.00,900.00,5600.00,5,1),('1/1/2013','10/3/2013',1200.00,1100.00,900.00,5600.00,5,2)
select * from ConctInfo
select * from OrderItem
select * from OrderDesc
select * from items
select * from PaymentType
select * from OrderPayment

create table OrderPayment(OrderId int references OrderDesc(OrderId),PaymentNumber int constraint PK_PaymentNumber primary key Identity(1,1),PaymentType int references PaymentType(PaymentType),amount decimal) 
insert into OrderPayment(OrderId,PaymentType,amount) values(1,2,100011)
drop table OrderPayment

create table OrderItem(OrderId int references OrderDesc(OrderId),ItemSequence 
int Primary key Identity(1,1),ItemNumber int references Items(ItemNumber),NumberOrder int,TotalPrice decimal)
insert into OrderItem(OrderId,ItemNumber,NumberOrder,TotalPrice) values(1,1,12,12112),(2,1,21,21212),(3,2,31,212121),(4,3,31,212121),(5,4,31,212121),(6,5,31,212121),(7,3,31,212121),(8,2,31,212121),(9,1,31,212121),(10,3,31,212121),(11,4,31,212121),(12,3,31,212121),(13,1,31,212121)
--delete from OrderDesc
--drop table OrderItem
--Q1. Write a SP to fetch all those customers who have same shipping and billing address
select * from ConctInfo where ContactId in (select ShipToContactId from OrderDesc where ShipToContactId=BillToContactId) 
--Q2. Write a SP to fetch only those customers who have put more than one order
select * from ConctInfo where ContactId in (select BillToContactId from OrderDesc where (select count(BillToContactId) from OrderDesc)>1) 
--Q3. Write UDF/SP to fetch all customers and calculate the total order amount 

--   (of all orders for that customer (billing address)) in one column against each customer.

select ci.ContactId,ci.Name,ci.street,ci.city,ci.state,ci.country,ci.ZipCode,ci.Phone,oi.TotalPrice from ContactInfo ci inner join OrderItem oi on ci.
