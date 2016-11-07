CREATE PROCEDURE [dbo].[netActivityLogEntryDelete]
(
   @Id	BIGINT
)
AS            
BEGIN
		UPDATE 
			[tblActivityLog]
		SET 
			[Deleted] = 1 
		WHERE 
			[pkID] = @Id  AND [Deleted] = 0
		EXEC netActivityLogGetAssociations @Id
END
