CREATE PROCEDURE [dbo].[netBlockTypeCheckUsage]
(
	@BlockTypeID		INT,
	@OnlyPublished	BIT = 0
)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@OnlyPublished = 1)
	BEGIN
		SELECT TOP 1
			Property.fkContentID as ContentID, 
			0 AS WorkID
		FROM tblContentProperty as Property WITH(INDEX(IDX_tblContentProperty_ScopeName))
		INNER JOIN dbo.GetScopedBlockProperties(@BlockTypeID) as ScopedProperties ON 
			Property.ScopeName LIKE (ScopedProperties.ScopeName + '%')
	END
	ELSE
	BEGIN
		SELECT TOP 1
			WorkContent.fkContentID as ContentID, 
			WorkContent.pkID as WorkID
		FROM tblWorkContentProperty as Property WITH(INDEX(IDX_tblWorkContentProperty_ScopeName))
		INNER JOIN dbo.GetScopedBlockProperties(@BlockTypeID) as ScopedProperties ON 
			Property.ScopeName LIKE (ScopedProperties.ScopeName + '%')
		INNER JOIN
			tblWorkContent as WorkContent ON Property.fkWorkContentID=WorkContent.pkID
	END
END
