CREATE PROCEDURE dbo.editDeleteContentVersionInternal
(
	@WorkContentID		INT
)
AS
BEGIN
	UPDATE tblWorkContent SET fkMasterVersionID=NULL WHERE fkMasterVersionID=@WorkContentID
	DELETE FROM tblWorkContentProperty WHERE fkWorkContentID=@WorkContentID
	DELETE FROM tblWorkContentCategory WHERE fkWorkContentID=@WorkContentID
	DELETE FROM tblWorkContent WHERE pkID=@WorkContentID
	
	RETURN 0
END
