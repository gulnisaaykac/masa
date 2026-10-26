USE MasaDb;
GO

CREATE TABLE dbo.Materials
(
    Id int IDENTITY(1, 1) NOT NULL CONSTRAINT PK_Materials PRIMARY KEY,
    CourseId int NOT NULL,
    FileName nvarchar(260) NOT NULL,
    StoredPath nvarchar(400) NOT NULL,
    Status nvarchar(20) NOT NULL,
    ErrorMessage nvarchar(500) NULL,
    Truncated bit NOT NULL CONSTRAINT DF_Materials_Truncated DEFAULT 0,
    UploadedAt datetime2 NOT NULL CONSTRAINT DF_Materials_UploadedAt DEFAULT sysutcdatetime(),
    CONSTRAINT FK_Materials_Courses FOREIGN KEY (CourseId) REFERENCES dbo.Courses (Id) ON DELETE CASCADE
);

CREATE INDEX IX_Materials_CourseId ON dbo.Materials (CourseId);

CREATE TABLE dbo.MaterialPages
(
    Id int IDENTITY(1, 1) NOT NULL CONSTRAINT PK_MaterialPages PRIMARY KEY,
    MaterialId int NOT NULL,
    PageNumber int NOT NULL,
    Text nvarchar(max) NOT NULL,
    CONSTRAINT FK_MaterialPages_Materials FOREIGN KEY (MaterialId) REFERENCES dbo.Materials (Id) ON DELETE CASCADE
);

CREATE TABLE dbo.StudyPacks
(
    Id int IDENTITY(1, 1) NOT NULL CONSTRAINT PK_StudyPacks PRIMARY KEY,
    MaterialId int NOT NULL,
    Summary nvarchar(max) NOT NULL,
    RawJson nvarchar(max) NOT NULL,
    PromptVersion nvarchar(20) NULL,
    CreatedAt datetime2 NOT NULL CONSTRAINT DF_StudyPacks_CreatedAt DEFAULT sysutcdatetime(),
    CONSTRAINT FK_StudyPacks_Materials FOREIGN KEY (MaterialId) REFERENCES dbo.Materials (Id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX UX_StudyPacks_MaterialId ON dbo.StudyPacks (MaterialId);

CREATE TABLE dbo.Terms
(
    Id int IDENTITY(1, 1) NOT NULL CONSTRAINT PK_Terms PRIMARY KEY,
    StudyPackId int NOT NULL,
    Word nvarchar(80) NOT NULL,
    Definition nvarchar(400) NOT NULL,
    CONSTRAINT FK_Terms_StudyPacks FOREIGN KEY (StudyPackId) REFERENCES dbo.StudyPacks (Id) ON DELETE CASCADE
);

CREATE TABLE dbo.Cards
(
    Id int IDENTITY(1, 1) NOT NULL CONSTRAINT PK_Cards PRIMARY KEY,
    StudyPackId int NOT NULL,
    Front nvarchar(300) NOT NULL,
    Back nvarchar(600) NOT NULL,
    DueAt datetime2 NOT NULL CONSTRAINT DF_Cards_DueAt DEFAULT sysutcdatetime(),
    LastResult nvarchar(10) NULL,
    CONSTRAINT FK_Cards_StudyPacks FOREIGN KEY (StudyPackId) REFERENCES dbo.StudyPacks (Id) ON DELETE CASCADE
);

CREATE INDEX IX_Cards_DueAt ON dbo.Cards (DueAt);

CREATE TABLE dbo.Questions
(
    Id int IDENTITY(1, 1) NOT NULL CONSTRAINT PK_Questions PRIMARY KEY,
    StudyPackId int NOT NULL,
    Prompt nvarchar(500) NOT NULL,
    ChoiceA nvarchar(200) NOT NULL,
    ChoiceB nvarchar(200) NOT NULL,
    ChoiceC nvarchar(200) NOT NULL,
    ChoiceD nvarchar(200) NOT NULL,
    CorrectChoice nvarchar(1) NOT NULL,
    Explanation nvarchar(400) NULL,
    CONSTRAINT FK_Questions_StudyPacks FOREIGN KEY (StudyPackId) REFERENCES dbo.StudyPacks (Id) ON DELETE CASCADE
);

CREATE TABLE dbo.Events
(
    Id int IDENTITY(1, 1) NOT NULL CONSTRAINT PK_Events PRIMARY KEY,
    CourseId int NOT NULL,
    Title nvarchar(120) NOT NULL,
    EventType nvarchar(20) NOT NULL,
    DueAt datetime2 NOT NULL,
    Source nvarchar(10) NOT NULL,
    IsConfirmed bit NOT NULL,
    CONSTRAINT FK_Events_Courses FOREIGN KEY (CourseId) REFERENCES dbo.Courses (Id) ON DELETE CASCADE
);

CREATE INDEX IX_Events_DueAt ON dbo.Events (DueAt);

CREATE TABLE dbo.CardReviews
(
    Id int IDENTITY(1, 1) NOT NULL CONSTRAINT PK_CardReviews PRIMARY KEY,
    CardId int NOT NULL,
    Result nvarchar(10) NOT NULL,
    ReviewedAt datetime2 NOT NULL CONSTRAINT DF_CardReviews_ReviewedAt DEFAULT sysutcdatetime(),
    CONSTRAINT FK_CardReviews_Cards FOREIGN KEY (CardId) REFERENCES dbo.Cards (Id) ON DELETE CASCADE
);
GO