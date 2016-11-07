CREATE PROCEDURE dbo.EntityGetGuidByIdFromIdentity
@intObjectTypeID int,
@intObjectID int
AS
BEGIN
	SELECT Guid FROM tblBigTableIdentity INNER JOIN tblBigTableStoreConfig 
		ON tblBigTableIdentity.StoreName = tblBigTableStoreConfig.StoreName
		WHERE tblBigTableIdentity.pkId = @intObjectID AND
			tblBigTableStoreConfig.EntityTypeId = @intObjectTypeID
END
