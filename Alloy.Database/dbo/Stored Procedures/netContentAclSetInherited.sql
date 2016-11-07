CREATE PROCEDURE dbo.netContentAclSetInherited
(
	@ContentID INT,
	@Recursive INT
)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@Recursive = 1)
    BEGIN
        /* Remove all old ACEs for @ContentID and below */
        DELETE FROM 
           tblContentAccess
        WHERE 
            fkContentID IN (SELECT fkChildID FROM tblTree WHERE fkParentID=@ContentID) OR 
            fkContentID=@ContentID
        RETURN
    END
	ELSE
	BEGIN
		DELETE FROM tblContentAccess
		WHERE fkContentID = @ContentID
	END
END
