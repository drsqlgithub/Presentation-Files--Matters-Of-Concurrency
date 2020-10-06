--Viewing data
use LetMeFinish
GO

--Description: Show locks held by READ UNCOMMITTED read only transaction 
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRANSACTION

SELECT *
FROM   Demo.SingleTable

--What will be locked?

ROLLBACK TRANSACTION
GO

--Description: Show locks held by READ COMMITTED read only transaction
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRANSACTION

SELECT *
FROM   Demo.SingleTable

--What will be locked?

ROLLBACK TRANSACTION
GO

--Description: Show locks held by REPEATABLE READ read only transaction
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

SELECT *
FROM   Demo.SingleTable

--What will be locked?

ROLLBACK TRANSACTION
GO

--Description: Show locks held by SERIALIZABLE read only transaction
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
BEGIN TRANSACTION
GO
SELECT *
FROM   Demo.SingleTable

--What will be locked?

ROLLBACK TRANSACTION
GO

--Description: Show locks held by SNAPSHOT (On Disk Tables) read only transaction

--must turn on Snapshot Isolation Capabilities
ALTER DATABASE LetMeFinish
	SET ALLOW_SNAPSHOT_ISOLATION ON
GO
SET TRANSACTION ISOLATION LEVEL SNAPSHOT
BEGIN TRANSACTION

SELECT *
FROM   Demo.SingleTable

--What will be locked?

ROLLBACK TRANSACTION
GO


--Modifying data

--Description: Show locks held by READ UNCOMMITTED modification transaction

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

BEGIN TRANSACTION

UPDATE Demo.SingleTable
SET Value = UPPER(Value)
WHERE Value like 'F%'

--What will be locked?

ROLLBACK TRANSACTION
GO


--Description: Show locks held by READ COMMITTED modification transaction

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRANSACTION

UPDATE Demo.SingleTable
SET Value = UPPER(Value)
WHERE Value like 'F%'

--What will be locked?

ROLLBACK TRANSACTION
GO


--Description: Show locks held by REPEATABLE READ modification transaction

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

UPDATE Demo.SingleTable
SET Value = UPPER(Value)
WHERE Value like 'F%'

--What will be locked?

ROLLBACK TRANSACTION
GO

--Description: Show locks held by SERIALIZABLE modification transaction

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
BEGIN TRANSACTION

UPDATE Demo.SingleTable
SET Value = UPPER(Value)
WHERE Value like 'F%'

--What will be locked? (Note that SERIALIZABLE applies to the read of the table, so no new
--rows could be created due to this requiring a table scan (no index on Value column)

ROLLBACK TRANSACTION
GO

--Description: Show locks held by SNAPSHOT (On Disk) modification transaction

SET TRANSACTION ISOLATION LEVEL SNAPSHOT
BEGIN TRANSACTION

UPDATE Demo.SingleTable
SET Value = UPPER(Value)
WHERE Value like 'F%'


--What will be locked?

ROLLBACK TRANSACTION
GO
