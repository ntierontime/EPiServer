CREATE FUNCTION [dbo].[GetExistingScopesForDefinition] 
(
	@PropertyDefinitionID int
)
RETURNS @ScopedPropertiesTable TABLE 
(
	ScopeName nvarchar(450)
)
AS
BEGIN
	--Get blocktype if property is block property
	DECLARE @ContentTypeID INT;
	SET @ContentTypeID = (SELECT tblContentType.pkID FROM 
		tblPropertyDefinition
		INNER JOIN tblPropertyDefinitionType ON tblPropertyDefinition.fkPropertyDefinitionTypeID = tblPropertyDefinitionType.pkID
		INNER JOIN tblContentType ON tblPropertyDefinitionType.fkContentTypeGUID = tblContentType.ContentTypeGUID
		WHERE tblPropertyDefinition.pkID = @PropertyDefinitionID);
		
	IF (@ContentTypeID IS NOT NULL)
	BEGIN
		INSERT INTO @ScopedPropertiesTable
		SELECT Property.ScopeName FROM
			tblWorkContentProperty as Property WITH(INDEX(IDX_tblWorkContentProperty_ScopeName))
			INNER JOIN dbo.GetScopedBlockProperties(@ContentTypeID) as ScopedProperties ON 
				Property.ScopeName LIKE (ScopedProperties.ScopeName + '%')
				WHERE ScopedProperties.ScopeName LIKE ('%.' + CAST(@PropertyDefinitionID as VARCHAR)+ '.')
	END
	
	RETURN 
END
