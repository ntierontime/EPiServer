CREATE PROCEDURE dbo.netCategoryListAll
AS
BEGIN
	SET NOCOUNT ON
	;WITH 
	  cte_anchor AS (
		SELECT *,
			   0 AS Indent, 
			   CAST(RIGHT('00000' + CAST(SortOrder as VarChar(6)), 6) AS varchar(MAX)) AS [path]
		   FROM tblCategory
		   WHERE fkParentID IS NULL), 
	  cte_recursive AS (
		 SELECT *
		   FROM cte_anchor
		   UNION ALL
			 SELECT c.*, 
					r.Indent + 1 AS Indent, 
					r.[path] + '.' + CAST(RIGHT('00000' + CAST(c.SortOrder as VarChar(6)), 6) AS varchar(MAX)) AS [path]
			 FROM tblCategory c
			 JOIN cte_recursive r ON c.fkParentID = r.pkID)
	SELECT pkID,
		   fkParentID,
		   CategoryGUID,
		   CategoryName,
		   CategoryDescription,
		   Available,
		   Selectable,
		   SortOrder,
		   Indent
	  FROM cte_recursive 
	  WHERE fkParentID IS NOT NULL
	  ORDER BY [path]
	
	RETURN 0
END
