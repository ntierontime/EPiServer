CREATE PROCEDURE [dbo].[netConvertPageType]
(
	@PageID		INT,
	@FromPageType	INT,
	@ToPageType		INT,
	@Recursive		BIT,
	@IsTest			BIT
)
AS
BEGIN
	DECLARE @cnt INT;
	CREATE TABLE #updatepages (fkChildID INT)
	INSERT INTO #updatepages(fkChildID)
	SELECT fkChildID
	FROM tblTree tree
	JOIN tblPage page
	ON page.pkID = tree.fkChildID 
	WHERE @Recursive = 1
	AND tree.fkParentID = @PageID
	AND page.fkPageTypeID = @FromPageType
	UNION (SELECT pkID FROM tblPage WHERE pkID = @PageID AND fkPageTypeID = @FromPageType)
	IF @IsTest = 1
	BEGIN
		SET @cnt = (SELECT COUNT(*) FROM #updatepages)
	END
	ELSE
	BEGIN		
		UPDATE tblPage SET fkPageTypeID=@ToPageType
		WHERE EXISTS (
			SELECT * from #updatepages WHERE fkChildID=pkID)
		SET @cnt = @@rowcount
	END		
	DROP TABLE #updatepages
	RETURN (@cnt)
END
