CREATE PROCEDURE dbo.netContentTypeDelete
(
	@ContentTypeID		INT
)
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	
	/* Do not try to delete a type that is in use */
	SELECT pkID as ContentID, Name as ContentName
	FROM tblContent
	INNER JOIN tblContentLanguage ON tblContentLanguage.fkContentID=tblContent.pkID
	WHERE fkContentTypeID=@ContentTypeID AND tblContentLanguage.fkLanguageBranchID=tblContent.fkMasterLanguageBranchID
	IF (@@ROWCOUNT <> 0)
		RETURN 1
	/* If the content type is used in a content definition, it can't be deleted */
	DECLARE @ContentTypeGuid UNIQUEIDENTIFIER
	SET @ContentTypeGuid = (SELECT ContentType.ContentTypeGUID
	FROM tblContentType as ContentType 
	WHERE ContentType.pkID=@ContentTypeID)
	
	DECLARE @PropertyDefinitionTypeID INT
	SET @PropertyDefinitionTypeID = (SELECT pkID FROM tblPropertyDefinitionType WHERE fkContentTypeGUID = @ContentTypeGuid)
	
	SELECT ContentType.pkID AS ContentTypeID, ContentType.Name AS ContentTypeName 
	FROM tblContentType AS ContentType
	INNER JOIN tblPropertyDefinition AS PropertyDefinition ON ContentType.pkID = PropertyDefinition.fkContentTypeID
	WHERE PropertyDefinition.fkPropertyDefinitionTypeID = @PropertyDefinitionTypeID
	IF (@@ROWCOUNT <> 0)
		RETURN 1
		
	/* If the content type is in use, do not delete */
	SELECT TOP 1 Property.pkID
	FROM  
	tblContentProperty as Property WITH(INDEX(IDX_tblContentProperty_ScopeName))
	INNER JOIN dbo.GetScopedBlockProperties(@ContentTypeID) as ScopedProperties ON 
			Property.ScopeName LIKE (ScopedProperties.ScopeName + '%')
	IF (@@ROWCOUNT <> 0)
		RETURN 1
	
	DELETE FROM 
		tblContentTypeDefault
	WHERE 
		fkContentTypeID=@ContentTypeID
	DELETE FROM 
		tblWorkContentProperty
	FROM 
		tblWorkContentProperty AS WP
	INNER JOIN 
		tblPropertyDefinition AS PD ON WP.fkPropertyDefinitionID=PD.pkID 
	WHERE 
		PD.Property=3 AND 
		ContentType=@ContentTypeID
	DELETE FROM 
		tblContentProperty
	FROM 
		tblContentProperty AS P
	INNER JOIN 
		tblPropertyDefinition AS PD ON P.fkPropertyDefinitionID=PD.pkID 
	WHERE 
		PD.Property=3 AND 
		ContentType=@ContentTypeID
	DELETE FROM 
		tblContentTypeToContentType 
	WHERE 
		fkContentTypeParentID=@ContentTypeID OR 
		fkContentTypeChildID=@ContentTypeID
		
	DELETE FROM 
		tblPropertyDefinition 
	WHERE 
		fkContentTypeID=@ContentTypeID
	DELETE FROM 
		tblPropertyDefinitionType
	FROM 
		tblPropertyDefinitionType
	INNER JOIN tblContentType ON tblPropertyDefinitionType.fkContentTypeGUID = tblContentType.ContentTypeGUID
	WHERE
		tblContentType.pkID=@ContentTypeID
		
	DELETE FROM 
		tblContentType
	WHERE
		pkID=@ContentTypeID
	
	RETURN 0
END
