CREATE PROCEDURE dbo.netContentDeleteLanguage
(
	@ContentID		INT,
	@LanguageBranch	NCHAR(17)
)
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	
	DECLARE @LangBranchID		INT
		
	SELECT @LangBranchID = pkID FROM tblLanguageBranch WHERE LanguageID=@LanguageBranch
	IF @LangBranchID IS NULL
	BEGIN
		--Unknown language
		RETURN -1
	END
	IF EXISTS( SELECT * FROM tblPage WHERE pkID=@ContentID AND fkMasterLanguageBranchID=@LangBranchID )
	BEGIN
		--Cannot delete master language branch
		RETURN -2
	END
	IF NOT EXISTS( SELECT * FROM tblPageLanguage WHERE fkPageID=@ContentID AND fkLanguageBranchID=@LangBranchID )
	BEGIN
		--Language does not exist on content instance
		RETURN -3
	END
	UPDATE tblWorkContent SET fkMasterVersionID=NULL WHERE pkID IN (SELECT pkID FROM tblWorkContent WHERE fkContentID=@ContentID AND fkLanguageBranchID=@LangBranchID)
    
	DELETE FROM tblWorkContentProperty WHERE fkWorkContentID IN (SELECT pkID FROM tblWorkContent WHERE fkContentID=@ContentID AND fkLanguageBranchID=@LangBranchID)
	DELETE FROM tblWorkContentCategory WHERE fkWorkContentID IN (SELECT pkID FROM tblWorkContent WHERE fkContentID=@ContentID AND fkLanguageBranchID=@LangBranchID)
	DELETE FROM tblContentLanguage WHERE fkContentID=@ContentID AND fkLanguageBranchID=@LangBranchID
	DELETE FROM tblWorkContent WHERE fkContentID=@ContentID AND fkLanguageBranchID=@LangBranchID
	DELETE FROM tblContentSoftlink WHERE fkOwnerContentID =  @ContentID AND OwnerLanguageID = @LangBranchID
	DELETE FROM tblContentProperty FROM tblContentProperty
	INNER JOIN tblPropertyDefinition ON tblPropertyDefinition.pkID=tblContentProperty.fkPropertyDefinitionID
	WHERE fkContentID=@ContentID 
	AND fkLanguageBranchID=@LangBranchID
	AND fkContentTypeID IS NOT NULL
	
	DELETE FROM tblContentCategory WHERE fkContentID=@ContentID AND fkLanguageBranchID=@LangBranchID
		
	RETURN 1
END
