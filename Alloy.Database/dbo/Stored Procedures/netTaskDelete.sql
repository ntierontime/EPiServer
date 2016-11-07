CREATE PROCEDURE dbo.netTaskDelete
(
	@TaskID INT
)
AS
BEGIN
	SET NOCOUNT ON
	DELETE FROM 
	    tblTask 
	WHERE 
	    pkID=@TaskID
	    
	RETURN @@ROWCOUNT   
END
