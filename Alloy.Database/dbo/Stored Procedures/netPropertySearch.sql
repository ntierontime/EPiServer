CREATE PROCEDURE dbo.netPropertySearch
(
	@PageID			INT,
	@FindProperty	NVARCHAR(255),
	@NotProperty	NVARCHAR(255),
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
		
	SET NOCOUNT ON
	/* All levels */
	SELECT
		tblPage.pkID
	FROM 
		tblPage
	INNER JOIN
		tblTree ON tblTree.fkChildID=tblPage.pkID
	INNER JOIN
		tblPageType ON tblPage.fkPageTypeID=tblPageType.pkID
	INNER JOIN
		tblPageDefinition ON tblPageType.pkID=tblPageDefinition.fkPageTypeID 
		AND tblPageDefinition.Name=@FindProperty
	INNER JOIN
		tblProperty ON tblProperty.fkPageID=tblPage.pkID 
		AND tblPageDefinition.pkID=tblProperty.fkPageDefinitionID
	INNER JOIN 
		tblPageLanguage ON tblPageLanguage.fkPageID=tblPage.pkID
	WHERE
		tblPageType.ContentType = 0 AND
		tblTree.fkParentID=@PageID AND
		tblPage.Deleted = 0 AND
		tblPageLanguage.[Status] = 4 AND
		(@LangBranchID=-1 OR tblPageLanguage.fkLanguageBranchID=@LangBranchID OR tblPageDefinition.LanguageSpecific<3) AND
		(@NotProperty IS NULL OR NOT EXISTS(
			SELECT * FROM tblProperty 
			INNER JOIN tblPageDefinition ON tblPageDefinition.pkID=tblProperty.fkPageDefinitionID 
			WHERE tblPageDefinition.Name=@NotProperty 
			AND tblProperty.fkPageID=tblPage.pkID))
	ORDER BY tblPageLanguage.Name ASC
END
