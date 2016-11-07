CREATE PROCEDURE dbo.netPropertySearchNull
(
	@PageID			INT,
	@PropertyName 	NVARCHAR(255),
	@LanguageBranch	NCHAR(17) = NULL
)
AS
BEGIN
	DECLARE @LangBranchID NCHAR(17);
	SELECT @LangBranchID=pkID FROM tblLanguageBranch WHERE LanguageID=@LanguageBranch
	IF @LangBranchID IS NULL 
	BEGIN 
		if @LanguageBranch IS NOT NULL
			RAISERROR('Language branch %s is not defined',16,1, @LanguageBranch)
		else
			SET @LangBranchID = -1
	END
	
	SELECT DISTINCT(tblPageLanguage.fkPageID)
	FROM tblPageLanguage
	INNER JOIN tblTree ON tblTree.fkChildID=tblPageLanguage.fkPageID
	INNER JOIN tblPage ON tblPage.pkID=tblPageLanguage.fkPageID
	INNER JOIN tblPageType ON tblPageType.pkID=tblPage.fkPageTypeID
	INNER JOIN tblPageDefinition ON tblPageDefinition.fkPageTypeID=tblPageType.pkID
	WHERE tblPageType.ContentType = 0
	AND tblTree.fkParentID=@PageID  
	AND tblPageDefinition.Name=@PropertyName
	AND (@LangBranchID=-1 OR tblPageLanguage.fkLanguageBranchID=@LangBranchID OR tblPageDefinition.LanguageSpecific<3)
	AND NOT EXISTS
		(SELECT * FROM tblProperty 
		WHERE fkPageDefinitionID=tblPageDefinition.pkID 
		AND tblProperty.fkPageID=tblPage.pkID)
END
