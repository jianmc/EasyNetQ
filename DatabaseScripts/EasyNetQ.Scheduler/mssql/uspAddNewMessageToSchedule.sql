SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[dbo].[uspAddNewMessageToScheduler]') AND type_desc IN ('SQL_STORED_PROCEDURE'))
BEGIN
	PRINT 'Dropping procedure [dbo].[uspAddNewMessageToScheduler]'
	DROP PROCEDURE [dbo].[uspAddNewMessageToScheduler]
END
GO

PRINT 'Creating procedure [dbo].[uspAddNewMessageToScheduler]'
GO
CREATE PROCEDURE [dbo].[uspAddNewMessageToScheduler] 
	@WakeTime DATETIME,
	@BindingKey NVARCHAR(1000),
	@Message NVARCHAR(MAX),
	@CancellationKey NVARCHAR(256) = null,
	@Exchange NVARCHAR(256) = null,
	@ExchangeType NVARCHAR(16) = null,
	@RoutingKey NVARCHAR(256) = null,
	@MessageProperties NVARCHAR(max) = null,
	@InstanceName NVARCHAR(100) = ''
AS
DECLARE @NewIDTbl TABLE (ID INT)
DECLARE @NewID INT
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRANSACTION
INSERT INTO WorkItems (
	BindingKey, 
	InnerMessage, 
	CancellationKey,
	Exchange,
	ExchangeType,
	RoutingKey,
	MessageProperties,
	InstanceName
) 
OUTPUT Inserted.WorkItemID INTO @NewIDTbl(ID)
 VALUES (
	@BindingKey, 
	@Message, 
	@CancellationKey,
	@Exchange,
	@ExchangeType,
	@RoutingKey,
	@MessageProperties,
	@InstanceName
)
-- get the ID of the inserted record for use in the child table
-- SCOPE_IDENTITY()
IF @@ERROR > 0
	ROLLBACK TRANSACTION
ELSE
	-- only setup the child status record if the WorkItem insert succeeded
	BEGIN
		SELECT @NewID = (SELECT ID FROM @NewIDTbl)

		INSERT INTO WorkItemStatus (WorkItemID, [Status], WakeTime)
		OUTPUT INSERTED.WorkItemID, INSERTED.status, INSERTED.WakeTime
		VALUES (@NewID, 0, @WakeTime)
		
		IF @@ERROR > 0 
			ROLLBACK TRANSACTION
		ELSE
			BEGIN
				 COMMIT TRANSACTION
			END 
	END


