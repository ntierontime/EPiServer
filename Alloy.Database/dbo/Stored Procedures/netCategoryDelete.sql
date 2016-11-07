CREATE PROCEDURE dbo.netCategoryDelete
(
	@CategoryID			INT
)
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
		CREATE TABLE #Reversed (pkID INT PRIMARY KEY)
		/* Find category and descendants */
		;WITH Categories AS (
		  SELECT pkID, 0 as [Level]
		  FROM tblCategory
		  WHERE pkID = @CategoryID
		  UNION ALL
		  SELECT c1.pkID, [Level] + 1
		  FROM tblCategory c1 
			INNER JOIN Categories c2 ON c1.fkParentID = c2.pkID
		 ) 
		/* Reverse order to avoid reference constraint errors */
		INSERT INTO #Reversed (pkID) 
		SELECT pkID FROM Categories ORDER BY [Level] DESC
		/* Delete any references from content tables */
		DELETE FROM tblCategoryPage WHERE fkCategoryID IN (SELECT pkID FROM #Reversed)
		DELETE FROM tblWorkCategory WHERE fkCategoryID IN (SELECT pkID FROM #Reversed)
		
		/* Delete the categories */
		DELETE FROM tblCategory WHERE pkID IN (SELECT pkID FROM #Reversed)
		DROP TABLE #Reversed
	RETURN 0
END
