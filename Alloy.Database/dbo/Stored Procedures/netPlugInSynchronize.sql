CREATE PROCEDURE dbo.netPlugInSynchronize
(
	@AssemblyName NVARCHAR(255),
	@TypeName NVARCHAR(255),
	@DefaultEnabled Bit,
	@CurrentDate DATETIME
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @id INT
	SELECT @id = pkID FROM tblPlugIn WHERE AssemblyName=@AssemblyName AND TypeName=@TypeName
	IF @id IS NULL
	BEGIN
		INSERT INTO tblPlugIn(AssemblyName,TypeName,Enabled, Created, Saved) VALUES(@AssemblyName,@TypeName,@DefaultEnabled, @CurrentDate, @CurrentDate)
		SET @id =  SCOPE_IDENTITY() 
	END
	SELECT pkID, TypeName, AssemblyName, Saved, Created, Enabled FROM tblPlugIn WHERE pkID = @id
END
