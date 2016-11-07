CREATE PROCEDURE dbo.netPlugInSaveSettings
@PlugInID 		INT,
@Settings 		NVARCHAR(MAX),
@Saved			DATETIME
AS
BEGIN
	UPDATE tblPlugIn SET
		Settings 	= @Settings,
		Saved		= @Saved	
	WHERE pkID = @PlugInID
END
