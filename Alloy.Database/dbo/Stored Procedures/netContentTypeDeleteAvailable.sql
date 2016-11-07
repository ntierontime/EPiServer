CREATE PROCEDURE dbo.netContentTypeDeleteAvailable
	@ContentTypeID INT,
	@ChildID INT = 0
AS
BEGIN
	IF (@ChildID = 0)
		DELETE FROM tblContentTypeToContentType WHERE fkContentTypeParentID = @ContentTypeID
	ELSE
		DELETE FROM tblContentTypeToContentType WHERE fkContentTypeParentID = @ContentTypeID AND fkContentTypeChildID = @ChildID
END
