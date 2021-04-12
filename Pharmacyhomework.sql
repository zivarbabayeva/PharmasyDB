Create dataBase PharmasynewDb

use PharmasynewDb;


CREATE TABLE DoctorOfPharmasy(
Id int identity Primary key,
[Name] nvarchar(150) not null,
Surname nvarchar(150) not null,
PharmacyId int
)
CREATE TABLE Customers(
Id int identity Primary key,
[Name] nvarchar(150) not null,
Surname nvarchar(150) not null,
PayedMoney decimal
)
CREATE TABLE Drugstore(
Id int identity Primary key,
Earnings decimal,
Budget decimal,
Taxes decimal,
DrugstoreId int references DoctorOfPharmasy(Id),
MedicinesId int
)
CREATe TABLE Medicines(
Id int identity Primary key,
[Name] nvarchar(150) not null,
Cost decimal not null,
DateOfProduction date not null,
CountryOfProduction nvarchar(150) not null,
Pharmakokinetics text not null,
SubCategory_Id int,
MedicinesId int references Drugstore(Id)
)
Create Table Subcategories(
Id int identity Primary key,
[Name] nvarchar(150) not null,
CategoryId int,
SubCategoryId int references Medicines(Id)
)
Create Table Categories(
Id int identity Primary key,
Indications text not null,
MedicinesId int,
CategoryId int references SubCategories(Id)
)
Create Table MedicineByRecipe(
Id int identity Primary key,
ReleaseForm nvarchar(100) not null,
PrescriptionAmount int not null,
MedicineId int,
RecipeId int
)
Create Table Pharmacists(
Id int identity Primary key,
[Name] nvarchar(150) not null,
Surname nvarchar(150) not null,
Salary decimal not null,
DrugstoreId int references Drugstore(Id) 
)
CREATE TABLE Recipe(
Id int identity Primary key,
[Date] datetime,
DoctorOfPharmasyId int references DoctorOfPharmasy(Id),
CustomerId int references Customers(Id),
MedicineByRecipeId int references MedicineByRecipe(Id)
)
Create Table Selling(
Id int identity Primary key,
SellingTime datetime,
PharmacistsId int references Pharmacists(Id),
MedicinesId int references Medicines(Id),
CustomersId int references Customers(Id),
DrugstoreId int references Drugstore(Id),
RecipeId int references Recipe(Id)
)
--View
CREATE VIEW GetSellingsMedicinesReportWithId
As
SELECT ph.Id 'Patient Id', ph.Name 'Pharmacists Name', ph.Surname, ph.Salary, 
		m.Name 'Medicines Name', m.Cost, m.DateOfProduction, 
		m.CountryOfproduction, m.Pharmakokinetics, 
		c.Name 'Customer Name', c.Surname, c.PayedMoney, c.Id 'Customers Id', 
		d.Earnings 'Drugstore Earnings', d.Budget, d.Taxes
 FROM Selling s

JOIN Pharmacists ph
ON
s.PharmacistsId=ph.Id

JOIN Medicines m
ON
s.MedicinesId=m.Id

JOIN Customers c
ON 
s.CustomersId=c.Id

JOIN Drugstore d
ON
s.DrugstoreId=d.Id

SELECT*FROM GetSellingsMedicinesReport

--Procedure
CREATE PROCEDUR usp_GetSellingsMedicinesReportById@medicinesId int
AS
SELECT *From GetSellingsMedicinesReportWithId
WHERE MedicinesId= @medicinesId
CREATE PROCEDUR usp_GetSellingsMedicinesAndCustomersId @medicinesId int,@customersId int=1
AS
SELECT *From GetSellingsMedicinesReportWithId
WHERE MedicinesId= @medicinesId AND CustomersId=@customersId

EXEC usp_GetMedicinesReportById 1
EXEC usp_GetMedicinesReportByCustomersAndMedicinesId @customersId=1,@medicinesId=1
