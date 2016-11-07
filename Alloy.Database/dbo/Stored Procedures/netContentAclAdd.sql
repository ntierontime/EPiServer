CREATE PROCEDURE dbo.netContentAclAdd
(
	@Name NVARCHAR(255),
	@IsRole INT,
	@ContentID INT,
	@AccessMask INT
)
AS
BEGIN
	SET NOCOUNT ON
	
	UPDATE 
	    tblContentAccess 
	SET 
	    AccessMask=@AccessMask
	WHERE 
	    fkContentID=@ContentID AND 
	    Name=@Name AND 
	    IsRole=@IsRole
	    
	IF (@@ROWCOUNT = 0)
	BEGIN
		-- Does not exist, create it
		INSERT INTO tblContentAccess 
		    (fkContentID, Name, IsRole, AccessMask) 
		VALUES 
		    (@ContentID, @Name, @IsRole, @AccessMask)
	END
END
