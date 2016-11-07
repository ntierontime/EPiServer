CREATE PROCEDURE netSoftLinksGetBroken
	@SkipCount int,
	@MaxResults int,
	@RootPageId int
AS
BEGIN
	SELECT [pkID]
		,[fkOwnerContentID]
		,[fkReferencedContentGUID]
		,[OwnerLanguageID]
		,[ReferencedLanguageID]
		,[LinkURL]
		,[LinkType]
		,[LinkProtocol]
		,[ContentLink]
		,[LastCheckedDate]
		,[FirstDateBroken]
		,[HttpStatusCode]
		,[LinkStatus]
	FROM (
		SELECT [pkID]
			,[fkOwnerContentID]
			,[fkReferencedContentGUID]
			,[OwnerLanguageID]
			,[ReferencedLanguageID]
			,[LinkURL]
			,[LinkType]
			,[LinkProtocol]
			,[ContentLink]
			,[LastCheckedDate]
			,[FirstDateBroken]
			,[HttpStatusCode]
			,[LinkStatus]
			,ROW_NUMBER() OVER (ORDER BY pkID ASC) as RowNumber
		FROM [tblContentSoftlink]
		INNER JOIN tblTree ON tblContentSoftlink.fkOwnerContentID = tblTree.fkChildID 
		WHERE (tblTree.fkParentID = @RootPageId OR (tblContentSoftlink.fkOwnerContentID = @RootPageId AND tblTree.NestingLevel = 1)) AND LinkStatus <> 0
		) BrokenLinks
	WHERE BrokenLinks.RowNumber > @SkipCount AND BrokenLinks.RowNumber <= @SkipCount+@MaxResults
END
