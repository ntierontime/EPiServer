CREATE PROCEDURE dbo.netContentAclChildAdd
(
	@Name NVARCHAR(255),
	@IsRole INT,
	@ContentID	INT,
	@AccessMask INT,
	@Merge BIT = 0
)
AS
BEGIN
    SET NOCOUNT ON
	CREATE TABLE #ignorecontents(IgnoreContentID INT PRIMARY KEY)
	IF @Merge = 1
	BEGIN
		INSERT INTO #ignorecontents(IgnoreContentID)
		SELECT fkChildID
		FROM tblTree
		WHERE fkParentID=@ContentID AND NOT EXISTS(SELECT * FROM tblContentAccess WHERE fkContentID=tblTree.fkChildID)
		EXEC netContentAclChildDelete @Name=@Name, @IsRole=@IsRole, @ContentID=@ContentID
	END
        
    /* Create new ACEs for all childs to @ContentID */
	INSERT INTO tblContentAccess 
		(fkContentID, 
		Name,
		IsRole, 
		AccessMask) 
	SELECT 
		fkChildID, 
		@Name,
		@IsRole, 
		@AccessMask
	FROM 
		tblTree
	WHERE 
		fkParentID=@ContentID AND NOT EXISTS(SELECT * FROM #ignorecontents WHERE IgnoreContentID=tblTree.fkChildID)
        
END
