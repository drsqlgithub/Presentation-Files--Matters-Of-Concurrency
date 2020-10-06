USE LetMeFinish;
GO

DROP TABLE IF EXISTS demo_mem.SingleTable;
DROP TABLE IF EXISTS demo_mem.Interaction;
DROP TABLE IF EXISTS demo_mem.Person;

DROP SCHEMA IF EXISTS demo_mem;
GO

CREATE SCHEMA Demo_Mem;
GO

CREATE TABLE Demo_Mem.SingleTable
(
    singleTableId int IDENTITY(1, 1) CONSTRAINT PKsingleTable PRIMARY KEY NONCLUSTERED HASH WITH(BUCKET_COUNT = 100),
    value         varchar(100),
    padding       char(4000) --default (replicate('A',4000)) --NOT SUPPORTED
)
WITH (MEMORY_OPTIMIZED = ON);

INSERT INTO Demo_Mem.SingleTable(Value, Padding)
VALUES('Fred', REPLICATE('a', 4000)),
(   'Barney', REPLICATE('a', 4000)),
(   'Wilma', REPLICATE('a', 4000)),
(   'Betty', REPLICATE('a', 4000)),
(   'Mr_Slate', REPLICATE('a', 4000)),
(   'Slagstone', REPLICATE('a', 4000)),
(   'Gazoo', REPLICATE('a', 4000)),
(   'Hoppy', REPLICATE('a', 4000)),
(   'Schmoo', REPLICATE('a', 4000)),
(   'Slaghoople', REPLICATE('a', 4000)),
(   'Pebbles', REPLICATE('a', 4000)),
(   'BamBam', REPLICATE('a', 4000)),
(   'Rockhead', REPLICATE('a', 4000)),
(   'Arnold', REPLICATE('a', 4000)),
(   'ArnoldMom', REPLICATE('a', 4000)),
(   'Tex', REPLICATE('a', 4000)),
(   'Dino', REPLICATE('a', 4000));
GO

CREATE TABLE Demo_Mem.Person
(
    PersonId int          IDENTITY(1, 1) CONSTRAINT PKPerson PRIMARY KEY NONCLUSTERED HASH WITH(BUCKET_COUNT = 100),
    Name     varchar(100) CONSTRAINT AKPerson UNIQUE NONCLUSTERED,
)
WITH (MEMORY_OPTIMIZED = ON);
GO

INSERT INTO Demo_Mem.Person(Name)
SELECT value
FROM   Demo_Mem.SingleTable;
GO

CREATE TABLE Demo_Mem.Interaction
(
    InteractionId   int          IDENTITY(1, 1) CONSTRAINT PKInteraction PRIMARY KEY NONCLUSTERED HASH WITH(BUCKET_COUNT = 100),
    Subject         nvarchar(20),
    Message         nvarchar(100),
    InteractionTime datetime2(0),
    PersonId        int          CONSTRAINT FKInteraction$References$Demo_Person REFERENCES Demo_Mem.Person(PersonId),
    CONSTRAINT AKInteraction UNIQUE NONCLUSTERED
    (
        PersonId,
        Subject,
        Message)
)
WITH (MEMORY_OPTIMIZED = ON);
GO

--add an insert first that loads other rows
INSERT INTO Demo_Mem.Interaction(Subject, Message, InteractionTime, PersonId)
VALUES('Hello1', 'Hello There', SYSDATETIME(), 10);

INSERT INTO Demo_Mem.Interaction(Subject, Message, InteractionTime, PersonId)
VALUES('Hello2', 'Hello There', SYSDATETIME(), 9);

INSERT INTO Demo_Mem.Interaction(Subject, Message, InteractionTime, PersonId)
VALUES('Hello3', 'Hello There', SYSDATETIME(), 8);
GO