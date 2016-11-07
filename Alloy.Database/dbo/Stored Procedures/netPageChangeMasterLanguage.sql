CREATE PROCEDURE [dbo].[netPageChangeMasterLanguage]
(
	@PageID						INT,
	@NewMasterLanguageBranchID	INT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @OldMasterLanguageBranchID INT;
	DECLARE @LastNewMasterLanguageVersion INT;
	DECLARE @LastOldMasterLanguageVersion INT;
	SET @OldMasterLanguageBranchID = (SELECT fkMasterLanguageBranchID FROM tblPage WHERE pkID = @PageID);
	IF(@NewMasterLanguageBranchID = @OldMasterLanguageBranchID)
		RETURN -1;
	SET @LastNewMasterLanguageVersion = (SELECT [Version] FROM tblPageLanguage WHERE fkPageID = @PageID AND fkLanguageBranchID = @NewMasterLanguageBranchID AND PendingPublish = 0)
	IF (@LastNewMasterLanguageVersion IS NULL)
		RETURN -1;
	SET @LastOldMasterLanguageVersion = (SELECT PublishedVersion FROM tblPage WHERE pkID = @PageID)
	IF (@LastOldMasterLanguageVersion IS NULL)
		RETURN -1
	
	--Do the actual change of master language branch
	UPDATE
		tblPage
	SET
		tblPage.fkMasterLanguageBranchID = @NewMasterLanguageBranchID
	WHERE
		pkID = @PageID
	--Update tblProperty for common properties
	UPDATE
		tblProperty
	SET
		fkLanguageBranchID = @NewMasterLanguageBranchID
	FROM
		tblProperty
	INNER JOIN
		tblPageDefinition
	ON
		tblProperty.fkPageDefinitionID = tblPageDefinition.pkID
	WHERE
		LanguageSpecific < 3
	AND
		fkPageID = @PageID
	--Update tblCategoryPage for builtin and common categories
	UPDATE
		tblCategoryPage
	SET
		fkLanguageBranchID = @NewMasterLanguageBranchID
	FROM
		tblCategoryPage
	LEFT JOIN
		tblPageDefinition
	ON
		tblCategoryPage.CategoryType = tblPageDefinition.pkID
	WHERE
		(LanguageSpecific < 3
	OR
		LanguageSpecific IS NULL)
	AND
		fkPageID = @PageID
	--Move work categories and properties between the last versions of the languages
	UPDATE
		tblWorkProperty
	SET
		fkWorkPageID = @LastNewMasterLanguageVersion
	FROM
		tblWorkProperty
	INNER JOIN
		tblPageDefinition
	ON
		tblWorkProperty.fkPageDefinitionID = tblPageDefinition.pkID
	WHERE
		LanguageSpecific < 3
	AND
		fkWorkPageID = @LastOldMasterLanguageVersion
	UPDATE
		tblWorkCategory
	SET
		fkWorkPageID = @LastNewMasterLanguageVersion
	FROM
		tblWorkCategory
	LEFT JOIN
		tblPageDefinition
	ON
		tblWorkCategory.CategoryType = tblPageDefinition.pkID
	WHERE
		(LanguageSpecific < 3
	OR
		LanguageSpecific IS NULL)
	AND
		fkWorkPageID = @LastOldMasterLanguageVersion
	--Remove any remaining common properties for old master language versions
	DELETE FROM
		tblWorkProperty
	FROM
		tblWorkProperty
	INNER JOIN
		tblPageDefinition
	ON
		tblWorkProperty.fkPageDefinitionID = tblPageDefinition.pkID
	WHERE
		LanguageSpecific < 3
	AND
		fkWorkPageID IN (SELECT pkID FROM tblWorkPage WHERE fkPageID = @PageID AND fkLanguageBranchID = @OldMasterLanguageBranchID)
	--Remove any remaining common categories for old master language versions
	DELETE FROM
		tblWorkCategory
	FROM
		tblWorkCategory
	LEFT JOIN
		tblPageDefinition
	ON
		tblWorkCategory.CategoryType = tblPageDefinition.pkID
	WHERE
		(LanguageSpecific < 3
	OR
		LanguageSpecific IS NULL)
	AND
		fkWorkPageID IN (SELECT pkID FROM tblWorkPage WHERE fkPageID = @PageID AND fkLanguageBranchID = @OldMasterLanguageBranchID)
	RETURN 0
END
