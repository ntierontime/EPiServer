CREATE PROCEDURE dbo.netContentAclList
(
	@ContentID INT
)
AS
BEGIN
	SET NOCOUNT ON
	SELECT 
		Name,
		IsRole, 
		AccessMask
	FROM 
		tblContentAccess
	WHERE 
		fkContentID=@ContentID
	ORDER BY
		IsRole DESC,
		Name
END
