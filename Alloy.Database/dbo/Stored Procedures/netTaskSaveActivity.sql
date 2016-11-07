CREATE PROCEDURE dbo.netTaskSaveActivity
(
    @TaskID INT,
    @Activity NVARCHAR(MAX) = NULL
)
AS
BEGIN
	UPDATE 
	    tblTask 
	SET
		Activity = @Activity
	WHERE 
	    pkID = @TaskID
END
