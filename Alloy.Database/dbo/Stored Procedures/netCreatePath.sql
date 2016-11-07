CREATE PROCEDURE dbo.netCreatePath
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @RootPage INT
	UPDATE tblPage SET PagePath=''
	SELECT @RootPage=pkID FROM tblPage WHERE fkParentID IS NULL AND PagePath = ''
	UPDATE tblPage SET PagePath='.' WHERE pkID=@RootPage
	
	WHILE (1 = 1)
	BEGIN
	
		UPDATE CHILD SET CHILD.PagePath = PARENT.PagePath + CONVERT(VARCHAR, PARENT.pkID) + '.'
		FROM tblPage CHILD INNER JOIN tblPage PARENT ON CHILD.fkParentID = PARENT.pkID
		WHERE CHILD.PagePath = '' AND PARENT.PagePath <> ''
		
		IF (@@ROWCOUNT = 0)
			BREAK	
	
	END	
	
END
