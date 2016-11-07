CREATE PROCEDURE netSoftLinksGetBrokenCount
	@OwnerContentID int
AS
BEGIN
		SELECT Count(*)
		FROM [tblContentSoftlink]
		INNER JOIN tblTree ON tblContentSoftlink.fkOwnerContentID = tblTree.fkChildID
		WHERE (tblTree.fkParentID = @OwnerContentID OR (tblContentSoftlink.fkOwnerContentID = @OwnerContentID AND tblTree.NestingLevel = 1)) AND LinkStatus <> 0
END
