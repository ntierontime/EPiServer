CREATE PROCEDURE dbo.EntitySetEntry
@intObjectTypeID int,
@intObjectID int,
@uniqueID uniqueidentifier
AS
BEGIN
	INSERT INTO tblEntityGuid
			(intObjectTypeID, intObjectID, unqID)
	VALUES
			(@intObjectTypeID, @intObjectID, @uniqueID)
END
