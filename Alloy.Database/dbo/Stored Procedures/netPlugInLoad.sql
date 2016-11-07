CREATE PROCEDURE dbo.netPlugInLoad
@PlugInID INT
AS
BEGIN
	SELECT pkID, AssemblyName, TypeName, Settings, Saved, Created, Enabled
	FROM tblPlugIn
	WHERE pkID = @PlugInID OR @PlugInID = -1
END
