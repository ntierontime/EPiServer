CREATE PROCEDURE [dbo].[netPropertyDefinitionGetUsage]
(
	@PropertyDefinitionID	INT,
	@OnlyNoneMasterLanguage	BIT = 0,
	@OnlyPublished	BIT = 0
)
AS
BEGIN
	
	
	SET NOCOUNT ON
	
	--Get blocktype if property is block property
	DECLARE @ContentTypeID INT;
	SET @ContentTypeID = (SELECT tblContentType.pkID FROM 
		tblPropertyDefinition
		INNER JOIN tblPropertyDefinitionType ON tblPropertyDefinition.fkPropertyDefinitionTypeID = tblPropertyDefinitionType.pkID
		INNER JOIN tblContentType ON tblPropertyDefinitionType.fkContentTypeGUID = tblContentType.ContentTypeGUID
		WHERE tblPropertyDefinition.pkID = @PropertyDefinitionID);
	
	IF (@OnlyPublished = 1)
	BEGIN
		IF (@ContentTypeID IS NOT NULL)
		BEGIN
			SELECT DISTINCT
				tblContentLanguage.fkContentID as ContentID, 
				0 AS WorkID,
				tblContentLanguage.Name,
				tblLanguageBranch.LanguageID AS LanguageBranch,
				tblLanguageBranch.Name AS LanguageBranchName
			FROM 
				tblContentProperty 
			INNER JOIN 
				dbo.GetExistingScopesForDefinition(@PropertyDefinitionID) as ExistingScopes ON tblContentProperty.ScopeName = ExistingScopes.ScopeName
			INNER JOIN 
				tblContentLanguage ON tblContentProperty.fkContentID=tblContentLanguage.fkContentID
			INNER JOIN
				tblContent ON tblContent.pkID=tblContentLanguage.fkContentID
			INNER JOIN
				tblLanguageBranch ON tblLanguageBranch.pkID=tblContentLanguage.fkLanguageBranchID
			WHERE
				tblContentLanguage.fkLanguageBranchID=tblContentProperty.fkLanguageBranchID AND
				(@OnlyNoneMasterLanguage=0 OR tblContentProperty.fkLanguageBranchID<>tblContent.fkMasterLanguageBranchID)
		END
		ELSE
		BEGIN
			SELECT DISTINCT
				tblContentLanguage.fkContentID as ContentID, 
				0 AS WorkID,
				tblContentLanguage.Name,
				tblLanguageBranch.LanguageID AS LanguageBranch,
				tblLanguageBranch.Name AS LanguageBranchName
			FROM 
				tblContentProperty
			INNER JOIN 
				tblContentLanguage ON tblContentProperty.fkContentID=tblContentLanguage.fkContentID
			INNER JOIN
				tblContent ON tblContent.pkID=tblContentLanguage.fkContentID
			INNER JOIN
				tblLanguageBranch ON tblLanguageBranch.pkID=tblContentLanguage.fkLanguageBranchID
			WHERE
				tblContentLanguage.fkLanguageBranchID=tblContentProperty.fkLanguageBranchID AND
				tblContentProperty.fkPropertyDefinitionID=@PropertyDefinitionID AND
				(@OnlyNoneMasterLanguage=0 OR tblContentProperty.fkLanguageBranchID<>tblContent.fkMasterLanguageBranchID)
		END
	END
	ELSE
	BEGIN
		IF (@ContentTypeID IS NOT NULL)
		BEGIN
			SELECT DISTINCT
				tblContent.pkID as ContentID, 
				tblWorkContent.pkID AS WorkID,
				tblWorkContent.Name,
				tblLanguageBranch.LanguageID AS LanguageBranch
			FROM 
				tblWorkContentProperty
			INNER JOIN
				dbo.GetExistingScopesForDefinition(@PropertyDefinitionID) as ExistingScopes ON tblWorkContentProperty.ScopeName = ExistingScopes.ScopeName
			INNER JOIN
				tblWorkContent ON tblWorkContentProperty.fkWorkContentID=tblWorkContent.pkID
			INNER JOIN
				tblContent ON tblWorkContent.fkContentID=tblContent.pkID
			INNER JOIN 
				tblContentLanguage ON tblWorkContent.fkContentID=tblContentLanguage.fkContentID 
			INNER JOIN
				tblLanguageBranch ON tblLanguageBranch.pkID=tblContentLanguage.fkLanguageBranchID
			WHERE
				tblWorkContent.fkLanguageBranchID = tblLanguageBranch.pkID AND
				(@OnlyNoneMasterLanguage=0 OR tblWorkContent.fkLanguageBranchID<>tblContent.fkMasterLanguageBranchID)
		END
		ELSE
		BEGIN
			SELECT DISTINCT
				tblContent.pkID as ContentID, 
				tblWorkContent.pkID AS WorkID,
				tblWorkContent.Name,
				tblLanguageBranch.LanguageID AS LanguageBranch
			FROM 
				tblWorkContentProperty
			INNER JOIN
				tblWorkContent ON tblWorkContentProperty.fkWorkContentID=tblWorkContent.pkID
			INNER JOIN
				tblContent ON tblWorkContent.fkContentID=tblContent.pkID
			INNER JOIN 
				tblContentLanguage ON tblWorkContent.fkContentID=tblContentLanguage.fkContentID 
			INNER JOIN
				tblLanguageBranch ON tblLanguageBranch.pkID=tblContentLanguage.fkLanguageBranchID
			WHERE
				tblWorkContent.fkLanguageBranchID = tblLanguageBranch.pkID AND
				tblWorkContentProperty.fkPropertyDefinitionID=@PropertyDefinitionID AND
				(@OnlyNoneMasterLanguage=0 OR tblWorkContent.fkLanguageBranchID<>tblContent.fkMasterLanguageBranchID)
		END
	END
	RETURN 0
END
