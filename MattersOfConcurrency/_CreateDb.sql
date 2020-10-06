--Turn on SQLCMD Mode to run this script

--variables that are common across all projects
--:r "C:\Users\louis\Dropbox\Projects 2014\_SettingsFiles\SQL2014Variables.sql"
:r "C:\Users\louis\Dropbox\Projects 2016\_SettingsFiles\SQL2016Variables.sql"

--if no, and db exists, then it will fail
:setvar DROPEXISTING Yes

--stop script execution if an error occurs
:ON ERROR EXIT

--database name
:setvar DataBaseName LetMeFinish
--SIMPLE FULL
:setvar RecoveryMode Simple
--ENABLED or DISABLED
:setvar DelayedDurabity DISABLED
--YES to create in mem filegroup
:setvar IncludeInMem YES

:setvar ReadCommittedSnapshot OFF
:setvar SnapshotIsolationLevel OFF
:setvar MemOptimizedElevateToSnapshot OFF

:setvar databaseSize 30MB
:setvar databaseMaxSize 2GB
:setvar logSize 30MB
:setvar logMaxSize 100MB


use master
Go
set nocount on
GO

--drop db if you are recreating it, dropping all connections to existing database.
if exists (select * from sys.databases where name = '$(DataBaseName)') and '$(DROPEXISTING)' = 'Yes'
 exec ('
alter database  $(DataBaseName)
 
	set single_user with rollback immediate;

drop database $(DataBaseName);')

CREATE DATABASE $(DataBaseName)
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'$(DataBaseName)', FILENAME = N'$(dataFile)$(DataBaseName).mdf' , SIZE = $(databaseSize) , MAXSIZE = $(databaseMaxSize), FILEGROWTH = 10% )
  LOG ON																													  						
( NAME = N'$(DataBaseName)_log', FILENAME = N'$(logFile)$(DataBaseName)_log.ldf' , SIZE = $(logSize) , MAXSIZE = $(logMaxSize) , FILEGROWTH = 10%);
GO

IF '$(IncludeInMem)' = 'YES'
 BEGIN
		ALTER DATABASE $(DataBaseName) ADD FILEGROUP [MemoryOptimizedFG] CONTAINS MEMORY_OPTIMIZED_DATA; 

		ALTER DATABASE $(DataBaseName)
		ADD FILE
		(
		 NAME= N'$(DataBaseName)_inmemFiles',
		 FILENAME = N'$(dataFile)$(DataBaseName)InMemfiles'
		)
		TO FILEGROUP [MemoryOptimizedFG];
 END
GO


GO

ALTER DATABASE $(DataBaseName)
	SET RECOVERY $(RecoveryMode)
GO

ALTER DATABASE LetMeFinish
	SET READ_COMMITTED_SNAPSHOT $(ReadCommittedSnapshot)
GO
ALTER DATABASE LetMeFinish
	SET ALLOW_SNAPSHOT_ISOLATION $(SnapshotIsolationLevel)
GO
ALTER DATABASE LetMeFinish
  SET MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT $(MemOptimizedElevateToSnapshot)
GO
ALTER DATABASE $(DataBaseName) SET DELAYED_DURABILITY = $(DelayedDurabity)  
GO
use Tempdb --if you forget sqlcmd mode, at least objects wont be in master!
go
use $(DataBaseName)
go

create schema Demo
go
create table Demo.SingleTable
(
	singleTableId int identity(1,1) CONSTRAINT PKsingleTable PRIMARY KEY,
	value varchar(100) --no key on value for demo purposes
)
insert into Demo.SingleTable
values  ('Fred'      ),
		('Barney'	 ),
		('Wilma'	 ),
		('Betty'	 ),
		('Mr_Slate'	 ),
		('Slagstone' ),
		('Gazoo'	 ),
		('Hoppy'	 ),
		('Schmoo'	 ),
		('Slaghoople'),
		('Pebbles'	 ),
		('BamBam'	 ),
		('Rockhead'	 ),
		('Arnold'	 ),
		('ArnoldMom' ),
		('Tex'		 ),
		('Dino'		 )


create table Demo.Person
(
	PersonId int identity(1,1) CONSTRAINT PKPerson PRIMARY KEY,
	Name varchar(100) CONSTRAINT AKPerson UNIQUE,
)
insert into Demo.Person (Name)
select value from Demo.SingleTable
GO
create table Demo.Interaction
(
	InteractionId int identity(1,1) CONSTRAINT PKInteraction PRIMARY KEY,
	Subject  nvarchar(20),
	Message  nvarchar(100),
	InteractionTime datetime2(0),
	PersonId int CONSTRAINT FKInteraction$References$Demo_Person REFERENCES Demo.Person(PersonId),
	CONSTRAINT AKInteraction UNIQUE (PersonId,Subject,Message)
)