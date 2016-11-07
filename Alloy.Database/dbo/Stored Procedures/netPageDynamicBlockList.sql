CREATE PROCEDURE dbo.netPageDynamicBlockList
(
	@PageID INT,
	@WorkPageID INT
)
AS
BEGIN
	SET NOCOUNT ON
	IF (@WorkPageID IS NULL OR @WorkPageID=0)
		SELECT 
			ScopeName
		FROM 
			tblProperty
		WHERE 
			fkPageID=@PageID AND ScopeName LIKE '%.D:%'
	ELSE
		SELECT 
			ScopeName
		FROM 
			tblWorkProperty
		WHERE 
			fkWorkPageID=@WorkPageID AND ScopeName LIKE '%.D:%'
END
