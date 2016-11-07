CREATE PROCEDURE dbo.netContentTypeToContentTypeList
AS
BEGIN
	SET NOCOUNT ON
	SELECT
		fkContentTypeParentID AS ID,
		fkContentTypeChildID AS ChildID,
		Access AS AccessMask,
		Availability,
		Allow
	FROM tblContentTypeToContentType
	ORDER BY fkContentTypeParentID
END
