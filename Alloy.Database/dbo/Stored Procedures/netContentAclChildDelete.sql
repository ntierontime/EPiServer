CREATE PROCEDURE dbo.netContentAclChildDelete
(
	@Name NVARCHAR(255),
	@IsRole INT,
	@ContentID	INT
)
AS
BEGIN
    SET NOCOUNT ON
 
    IF (@Name IS NULL)
    BEGIN
        DELETE FROM 
           tblContentAccess
        WHERE EXISTS(SELECT * FROM tblTree WHERE fkParentID=@ContentID AND fkChildID=tblContentAccess.fkContentID)
            
        RETURN
    END
    DELETE FROM 
       tblContentAccess
    WHERE Name=@Name
		AND IsRole=@IsRole
		AND EXISTS(SELECT * FROM tblTree WHERE fkParentID=@ContentID AND fkChildID=tblContentAccess.fkContentID)
END
