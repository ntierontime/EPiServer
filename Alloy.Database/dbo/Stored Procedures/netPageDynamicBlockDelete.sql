CREATE PROCEDURE netPageDynamicBlockDelete
(
	@PageID INT,
	@WorkPageID INT,
	@DynamicBlock NVARCHAR(450)
)
AS
BEGIN
	SET NOCOUNT ON
	IF (@WorkPageID IS NULL OR @WorkPageID=0)
		DELETE
		FROM 
			tblProperty
		WHERE 
			fkPageID=@PageID AND ScopeName LIKE '%' + @DynamicBlock + '%'
	ELSE
		DELETE
		FROM 
			tblWorkProperty
		WHERE 
			fkWorkPageID=@WorkPageID AND ScopeName LIKE '%' + @DynamicBlock + '%'
END
