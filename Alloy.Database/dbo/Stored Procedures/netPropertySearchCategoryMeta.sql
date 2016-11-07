CREATE PROCEDURE dbo.netPropertySearchCategoryMeta
(
	@PageID			INT,
	@PropertyName 	NVARCHAR(255),
	@Equals			BIT = 0,
	@NotEquals		BIT = 0,
	@CategoryList	NVARCHAR(2000) = NULL,
	@LanguageBranch		NCHAR(17) = NULL
)
AS
BEGIN
	DECLARE @LangBranchID NCHAR(17);
	
	DECLARE @categoryTable AS TABLE (fkCategoryID int)
	IF NOT @CategoryList IS NULL
	BEGIN
		INSERT INTO @categoryTable
		EXEC netCategoryStringToTable @CategoryList=@CategoryList
	END
	SELECT fkChildID
	FROM tblTree
	INNER JOIN tblContent WITH (NOLOCK) ON tblTree.fkChildID=tblContent.pkID
	WHERE tblContent.ContentType = 0 AND tblTree.fkParentID=@PageID 
	AND
    	(
		(@CategoryList IS NULL AND 	(
							SELECT Count(tblCategoryPage.fkPageID)
							FROM tblCategoryPage
							WHERE tblCategoryPage.CategoryType=0
							AND tblCategoryPage.fkPageID=tblTree.fkChildID
						)=0
		)
		OR
		(@Equals=1 AND tblTree.fkChildID IN
						(SELECT tblCategoryPage.fkPageID 
						FROM tblCategoryPage 
						INNER JOIN @categoryTable ct ON tblCategoryPage.fkCategoryID=ct.fkCategoryID 
						WHERE tblCategoryPage.CategoryType=0)
		)
		OR
		(@NotEquals=1 AND tblTree.fkChildID NOT IN
						(SELECT tblCategoryPage.fkPageID 
						FROM tblCategoryPage 
						INNER JOIN @categoryTable ct ON tblCategoryPage.fkCategoryID=ct.fkCategoryID 
						WHERE tblCategoryPage.CategoryType=0)
		)
	)
END
