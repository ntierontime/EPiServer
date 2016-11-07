CREATE PROCEDURE [dbo].[netPropertyDefinitionCheckUsage]
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
			SELECT TOP 1
				tblContentLanguage.fkContentID as ContentID, 
				0 AS WorkID
			FROM 
				tblContentProperty 
			INNER JOIN 
				dbo.GetExistingScopesForDefinition(@PropertyDefinitionID) as ExistingScopes ON tblContentProperty.ScopeName = ExistingScopes.ScopeName
			INNER JOIN 
				tblContentLanguage ON tblContentProperty.fkContentID=tblContentLanguage.fkContentID
		END
		ELSE
		BEGIN
			SELECT TOP 1
				tblContentLanguage.fkContentID as ContentID, 
				0 AS WorkID
			FROM 
				tblContentProperty
			INNER JOIN 
				tblContentLanguage ON tblContentProperty.fkContentID=tblContentLanguage.fkContentID
			WHERE
				tblContentLanguage.fkLanguageBranchID=tblContentProperty.fkLanguageBranchID AND
				tblContentProperty.fkPropertyDefinitionID=@PropertyDefinitionID
		END
	END
	ELSE
	BEGIN
		IF (@ContentTypeID IS NOT NULL)
		BEGIN
			SELECT TOP 1
				tblWorkContent.fkContentID as ContentID, 
				tblWorkContent.pkID AS WorkID
			FROM 
				tblWorkContentProperty
			INNER JOIN
				dbo.GetExistingScopesForDefinition(@PropertyDefinitionID) as ExistingScopes ON tblWorkContentProperty.ScopeName = ExistingScopes.ScopeName
			INNER JOIN
				tblWorkContent ON tblWorkContentProperty.fkWorkContentID=tblWorkContent.pkID
		END
		ELSE
		BEGIN
			SELECT TOP 1
				tblWorkContent.fkContentID as ContentID, 
				tblWorkContent.pkID AS WorkID
			FROM 
				tblWorkContentProperty
			INNER JOIN
				tblWorkContent ON tblWorkContentProperty.fkWorkContentID=tblWorkContent.pkID
			WHERE
				tblWorkContentProperty.fkPropertyDefinitionID=@PropertyDefinitionID
		END
	END
	RETURN 0
END
