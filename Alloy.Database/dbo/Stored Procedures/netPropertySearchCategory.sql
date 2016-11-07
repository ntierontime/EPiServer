CREATE PROCEDURE dbo.netPropertySearchCategory
(
	@PageID			INT,
	@PropertyName 	NVARCHAR(255),
	@Equals			BIT = 0,
	@NotEquals		BIT = 0,
	@CategoryList	NVARCHAR(2000) = NULL,
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
	
	DECLARE @categoryTable AS TABLE (fkCategoryID int)
	IF NOT @CategoryList IS NULL
	BEGIN
		INSERT INTO @categoryTable
		EXEC netCategoryStringToTable @CategoryList=@CategoryList
	END
	IF @CategoryList IS NULL
		SELECT DISTINCT(tblProperty.fkPageID)
		FROM tblProperty
		INNER JOIN tblPageDefinition ON tblPageDefinition.pkID=tblProperty.fkPageDefinitionID
		INNER JOIN tblTree ON tblTree.fkChildID=tblProperty.fkPageID
		INNER JOIN tblPageLanguage ON tblPageLanguage.fkPageID=tblProperty.fkPageID
		INNER JOIN tblPageType ON tblPageDefinition.fkPageTypeID=tblPageType.pkID
		WHERE tblPageType.ContentType = 0 
		AND tblTree.fkParentID=@PageID 
		AND tblPageDefinition.Name=@PropertyName
		AND Property = 8		
		AND (@LangBranchID=-1 OR tblProperty.fkLanguageBranchID=@LangBranchID OR tblPageDefinition.LanguageSpecific<3)
		AND (
					SELECT Count(tblCategoryPage.fkPageID)
					FROM tblCategoryPage
					INNER JOIN tblPageDefinition ON tblPageDefinition.pkID = tblCategoryPage.CategoryType
					WHERE tblCategoryPage.CategoryType=tblProperty.fkPageDefinitionID
					AND tblCategoryPage.fkPageID=tblProperty.fkPageID
					AND (@LangBranchID=-1 OR tblCategoryPage.fkLanguageBranchID=@LangBranchID OR tblPageDefinition.LanguageSpecific<3)
			)=0	
			
				
	ELSE
		IF @Equals=1
			SELECT DISTINCT(tblProperty.fkPageID)
			FROM tblProperty
			INNER JOIN tblPageDefinition ON tblPageDefinition.pkID=tblProperty.fkPageDefinitionID
			INNER JOIN tblTree ON tblTree.fkChildID=tblProperty.fkPageID
			INNER JOIN tblPageLanguage ON tblPageLanguage.fkPageID=tblProperty.fkPageID
			INNER JOIN tblPageType ON tblPageDefinition.fkPageTypeID=tblPageType.pkID
			WHERE tblPageType.ContentType = 0 
			AND tblTree.fkParentID=@PageID 
			AND tblPageDefinition.Name=@PropertyName
			AND Property = 8		
			AND (@LangBranchID=-1 OR tblProperty.fkLanguageBranchID=@LangBranchID OR tblPageDefinition.LanguageSpecific<3)
			AND EXISTS
					(SELECT *
					FROM tblCategoryPage 
					INNER JOIN @categoryTable ct ON tblCategoryPage.fkCategoryID=ct.fkCategoryID
					INNER JOIN tblPageDefinition ON tblPageDefinition.pkID = tblCategoryPage.CategoryType
					WHERE tblCategoryPage.fkPageID=tblProperty.fkPageID AND tblCategoryPage.CategoryType=tblProperty.fkPageDefinitionID
					AND (@LangBranchID=-1 OR tblCategoryPage.fkLanguageBranchID=@LangBranchID OR tblPageDefinition.LanguageSpecific<3))
		ELSE
			SELECT DISTINCT(tblProperty.fkPageID)
			FROM tblProperty
			INNER JOIN tblPageDefinition ON tblPageDefinition.pkID=tblProperty.fkPageDefinitionID
			INNER JOIN tblTree ON tblTree.fkChildID=tblProperty.fkPageID
			INNER JOIN tblPageLanguage ON tblPageLanguage.fkPageID=tblProperty.fkPageID
			INNER JOIN tblPageType ON tblPageDefinition.fkPageTypeID=tblPageType.pkID
			WHERE tblPageType.ContentType = 0 
			AND tblTree.fkParentID=@PageID 
			AND tblPageDefinition.Name=@PropertyName
			AND Property = 8		
			AND (@LangBranchID=-1 OR tblProperty.fkLanguageBranchID=@LangBranchID OR tblPageDefinition.LanguageSpecific<3)
			AND NOT EXISTS
					(SELECT *
					FROM tblCategoryPage 
					INNER JOIN @categoryTable ct ON tblCategoryPage.fkCategoryID=ct.fkCategoryID
					INNER JOIN tblPageDefinition ON tblPageDefinition.pkID = tblCategoryPage.CategoryType
					WHERE tblProperty.fkPageID=tblCategoryPage.fkPageID AND tblCategoryPage.CategoryType=tblProperty.fkPageDefinitionID
					AND (@LangBranchID=-1 OR tblCategoryPage.fkLanguageBranchID=@LangBranchID OR tblPageDefinition.LanguageSpecific<3))
END
