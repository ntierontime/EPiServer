CREATE PROCEDURE dbo.netSchedulerLoadJob 
	@pkID UNIQUEIDENTIFIER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    SELECT CONVERT(NVARCHAR(40),pkID) AS pkID,Name,CONVERT(INT,Enabled) AS Enabled,LastExec,LastStatus,LastText,NextExec,[DatePart],Interval,MethodName,CONVERT(INT,fStatic) AS fStatic,TypeName,AssemblyName,InstanceData, IsRunning, CurrentStatusMessage, DateDiff(second, LastPing, GETUTCDATE()) as SecondsAfterLastPing
	FROM tblScheduledItem
	WHERE pkID = @pkID
END
