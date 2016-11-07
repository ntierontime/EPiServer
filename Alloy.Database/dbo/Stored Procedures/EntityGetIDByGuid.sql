CREATE PROCEDURE dbo.EntityGetIDByGuid
@unqID uniqueidentifier
AS
BEGIN
	SELECT 
		intObjectTypeID, intObjectID
	FROM tblEntityGuid
	WHERE unqID = @unqID
END
