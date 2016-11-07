CREATE PROCEDURE dbo.EntityGetGuidByID
@intObjectTypeID int,
@intObjectID int
AS
BEGIN
	SELECT unqID FROM tblEntityGuid WHERE intObjectTypeID = @intObjectTypeID AND intObjectID = @intObjectID
END
