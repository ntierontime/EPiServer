CREATE FUNCTION [dbo].[GetScopedBlockProperties] 
(
	@ContentTypeID int
)
RETURNS @ScopedPropertiesTable TABLE 
(
	ScopeName nvarchar(450)
)
AS
BEGIN
	WITH ScopedProperties(ContentTypeID, PropertyDefinitionID, Scope, Level)
	AS
	(
		--Top level statement
		SELECT T1.pkID as ContentTypeID, tblPropertyDefinition.pkID as PropertyDefinitionID, 
			Cast('.' + CAST(tblPropertyDefinition.pkID as VARCHAR) + '.' as varchar) as Scope, 0 as Level
		FROM tblPropertyDefinition
		INNER JOIN tblContentType AS T1 ON T1.pkID=tblPropertyDefinition.fkContentTypeID
		INNER JOIN tblPropertyDefinitionType ON tblPropertyDefinitionType.pkID = tblPropertyDefinition.fkPropertyDefinitionTypeID
		INNER JOIN tblContentType ON tblPropertyDefinitionType.fkContentTypeGUID = tblContentType.ContentTypeGUID
		WHERE tblContentType.pkID = @ContentTypeID
		UNION ALL
		
		--Recursive statement
		SELECT T1.pkID as ContentTypeID, tblPropertyDefinition.pkID as PropertyDefinitionID, 
			Cast('.' + CAST(tblPropertyDefinition.pkID as VARCHAR) + Scope as varchar ) as Scope, ScopedProperties.Level+1 as Level
		FROM tblPropertyDefinition
		INNER JOIN tblContentType AS T1 ON T1.pkID=tblPropertyDefinition.fkContentTypeID
		INNER JOIN tblPropertyDefinitionType ON tblPropertyDefinitionType.pkID = tblPropertyDefinition.fkPropertyDefinitionTypeID
		INNER JOIN tblContentType ON tblPropertyDefinitionType.fkContentTypeGUID = tblContentType.ContentTypeGUID
		INNER JOIN ScopedProperties ON ScopedProperties.ContentTypeID = tblContentType.pkID
	)
	INSERT INTO @ScopedPropertiesTable(ScopeName) SELECT Scope from ScopedProperties
	
	RETURN 
END
