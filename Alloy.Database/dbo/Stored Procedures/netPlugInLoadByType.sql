CREATE PROCEDURE dbo.netPlugInLoadByType
(
	@AssemblyName NVARCHAR(255),
	@TypeName NVARCHAR(255)
)
AS
BEGIN
	SET NOCOUNT ON
	SELECT pkID, TypeName, AssemblyName, Saved, Created, Enabled FROM tblPlugIn WHERE AssemblyName=@AssemblyName AND TypeName=@TypeName
END
