CREATE PROCEDURE dbo.editDeleteContentVersion
(
	@WorkContentID		INT
)
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	DECLARE @ContentID			INT
	DECLARE @PublishedWorkID	INT
	DECLARE @LangBranchID		INT
	
	/* Verify that we can delete this version (i e do not allow removal of current version) */
	SELECT 
		@ContentID=tblContentLanguage.fkContentID, 
		@LangBranchID=tblContentLanguage.fkLanguageBranchID,
		@PublishedWorkID=tblContentLanguage.[Version] 
	FROM 
		tblWorkContent 
	INNER JOIN 
		tblContentLanguage ON tblContentLanguage.fkContentID=tblWorkContent.fkContentID AND tblContentLanguage.fkLanguageBranchID = tblWorkContent.fkLanguageBranchID
	WHERE 
		tblWorkContent.pkID=@WorkContentID
		
	IF (@@ROWCOUNT <> 1 OR @PublishedWorkID=@WorkContentID)
		RETURN -1
	IF ( (SELECT COUNT(pkID) FROM tblWorkContent WHERE fkContentID=@ContentID AND fkLanguageBranchID=@LangBranchID ) < 2 )
		RETURN -1
		
	EXEC editDeleteContentVersionInternal @WorkContentID=@WorkContentID
	
	RETURN 0
END
