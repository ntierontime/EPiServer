CREATE PROCEDURE dbo.EntityGetIdByGuidFromIdentity
@uniqueID uniqueidentifier
AS
BEGIN
	SELECT tblBigTableStoreConfig.EntityTypeId as EntityTypeId, tblBigTableIdentity.pkId as ObjectId  
		FROM tblBigTableIdentity INNER JOIN tblBigTableStoreConfig 
		ON tblBigTableIdentity.StoreName = tblBigTableStoreConfig.StoreName
		WHERE tblBigTableIdentity.Guid = @uniqueID
END
