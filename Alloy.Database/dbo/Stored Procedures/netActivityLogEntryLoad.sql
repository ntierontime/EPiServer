CREATE PROCEDURE [dbo].[netActivityLogEntryLoad]
(
   @Id				BIGINT
)
AS            
BEGIN
	SELECT * FROM [tblActivityLog]
	WHERE pkID = @Id
END
