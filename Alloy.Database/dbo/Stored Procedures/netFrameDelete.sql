CREATE PROCEDURE dbo.netFrameDelete
(
	@FrameID		INT,
	@ReplaceFrameID	INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
		
		IF (NOT EXISTS(SELECT pkID FROM tblFrame WHERE pkID=@ReplaceFrameID))
			SET @ReplaceFrameID=NULL
		UPDATE tblWorkPage SET fkFrameID=@ReplaceFrameID WHERE fkFrameID=@FrameID
		UPDATE tblPageLanguage SET fkFrameID=@ReplaceFrameID WHERE fkFrameID=@FrameID
		DELETE FROM tblFrame WHERE pkID=@FrameID
					
	RETURN 0
END
