CREATE PROCEDURE dbo.netPlugInSave
@PlugInID 		INT,
@Enabled 		BIT,
@Saved		DATETIME
AS
BEGIN
	UPDATE tblPlugIn SET
		Enabled 	= @Enabled,
		Saved		= @Saved
	WHERE pkID = @PlugInID
END
