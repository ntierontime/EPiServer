CREATE PROCEDURE dbo.netContentTypeAddAvailable
(
	@ContentTypeID INT,
	@ChildID INT,
	@Availability INT = 0,
	@Access INT = 2,
	@Allow BIT = NULL
)
AS
BEGIN
	IF (@Availability = 1 OR @Availability = 2)
		DELETE FROM tblContentTypeToContentType WHERE
			fkContentTypeParentID = @ContentTypeID
	ELSE
		DELETE FROM tblContentTypeToContentType WHERE
			fkContentTypeParentID = @ContentTypeID AND fkContentTypeChildID = @ChildID
	INSERT INTO tblContentTypeToContentType
	(fkContentTypeParentID, fkContentTypeChildID, Access, Availability, Allow)
	VALUES
	(@ContentTypeID, @ChildID, @Access, @Availability, @Allow)
END
