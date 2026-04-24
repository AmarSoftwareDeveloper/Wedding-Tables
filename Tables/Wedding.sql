
CREATE TABLE StatusMaster
(
StatusId INT PRIMARY KEY,
StatusName VARCHAR(50) NOT NULL UNIQUE,
IsActive BIT DEFAULT 1
);

---------------------------------

CREATE TABLE Leads
(
LeadId BIGINT IDENTITY(1,1) PRIMARY KEY,
UserId BIGINT NOT NULL,
VehicleId INT NOT NULL,
PickupLocation VARCHAR(200) NOT NULL,
DropLocation VARCHAR(200) NOT NULL,
PickupDateTime DATETIME NOT NULL,
EstimatedCost DECIMAL(10,2) NULL,
LeadStatusId INT NOT NULL DEFAULT 1,
CreatedOn DATETIME DEFAULT GETDATE(),
CreatedBy INT NULL,
ModifiedOn DATETIME NULL,
ModifiedBy INT NULL,
CONSTRAINT FK_Leads_Vehicle 
    FOREIGN KEY (VehicleId) REFERENCES VehicleMaster(VehicleId),
CONSTRAINT FK_Leads_Status 
   FOREIGN KEY (LeadStatusId) REFERENCES StatusMaster(StatusId)
);

----------------------------------------------
CREATE TABLE LeadLogs
(
LogId BIGINT IDENTITY(1,1) PRIMARY KEY,
LeadId BIGINT NOT NULL,
ActionTaken VARCHAR(100) NOT NULL,
Remarks VARCHAR(MAX) NULL,
OldStatusId INT NULL,
NewStatusId INT NULL,
ActionBy INT NULL,
ActionOn DATETIME DEFAULT GETDATE(),
CONSTRAINT FK_LeadLogs_Lead 
    FOREIGN KEY (LeadId) REFERENCES Leads(LeadId) ON DELETE CASCADE,
CONSTRAINT FK_LeadLogs_OldStatus 
    FOREIGN KEY (OldStatusId) REFERENCES StatusMaster(StatusId),
CONSTRAINT FK_LeadLogs_NewStatus 
    FOREIGN KEY (NewStatusId) REFERENCES StatusMaster(StatusId)
);

----------------------------------------------------

CREATE TABLE LeadConfirmations
(
ConfirmationId BIGINT IDENTITY(1,1) PRIMARY KEY,
LeadId BIGINT NOT NULL UNIQUE,  
FinalAmount DECIMAL(10,2) NOT NULL,
PaymentStatus VARCHAR(50) DEFAULT 'Pending',
PaymentMode VARCHAR(50) NULL,
PaidAmount DECIMAL(10,2) DEFAULT 0,
DriverName VARCHAR(100) NULL,
DriverMobile VARCHAR(15) NULL,
ConfirmedOn DATETIME DEFAULT GETDATE(),
CONSTRAINT FK_LeadConfirmations_Lead 
    FOREIGN KEY (LeadId) REFERENCES Leads(LeadId) ON DELETE CASCADE,
CONSTRAINT CHK_PaymentStatus 
   CHECK (PaymentStatus IN ('Pending', 'Paid', 'Partial'))
);