CREATE PROCEDURE [dbo].netSchedulerSave
(
@pkID		UNIQUEIDENTIFIER,
@Name		NVARCHAR(50),
@Enabled	BIT = 0,
@NextExec 	DATETIME,
@DatePart	NCHAR(2) = NULL,
@Interval	INT = 0,
@MethodName NVARCHAR(100),
@fStatic 	BIT,
@TypeName 	NVARCHAR(1024),
@AssemblyName NVARCHAR(100),
@InstanceData	IMAGE = NULL
)
AS
BEGIN
IF EXISTS(SELECT * FROM tblScheduledItem WHERE pkID=@pkID)
	UPDATE tblScheduledItem SET
		Name 		= @Name,
		Enabled 	= @Enabled,
		NextExec 	= @NextExec,
		[DatePart] 	= @DatePart,
		Interval 		= @Interval,
		MethodName 	= @MethodName,
		fStatic 		= @fStatic,
		TypeName 	= @TypeName,
		AssemblyName 	= @AssemblyName,
		InstanceData	= @InstanceData
	WHERE pkID = @pkID
ELSE
	INSERT INTO tblScheduledItem(pkID,Name,Enabled,NextExec,[DatePart],Interval,MethodName,fStatic,TypeName,AssemblyName,InstanceData)
	VALUES(@pkID,@Name,@Enabled,@NextExec,@DatePart,@Interval, @MethodName,@fStatic,@TypeName,@AssemblyName,@InstanceData)
END
