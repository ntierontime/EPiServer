CREATE PROCEDURE dbo.netSchedulerAdd
(
	@out_Id			uniqueidentifier output,
	@methodName		nvarchar(100),
	@fStatic		bit,
	@typeName		nvarchar(1024),
	@assemblyName	nvarchar(100),
	@data			image,
	@dtExec			datetime,
	@sRecurDatePart	nchar(2),
	@Interval		int,
	@out_fRefresh	bit output
)
as
begin
	set nocount on
		
	select @out_Id = newid()
	
	select @out_fRefresh = case when exists( select * from tblScheduledItem where NextExec < @dtExec ) then 0 else 1 end
	
	insert into tblScheduledItem( pkID, Enabled, MethodName, fStatic, TypeName, AssemblyName, NextExec, [DatePart], [Interval], InstanceData )
	   values( @out_Id, 1, @methodName, @fStatic, @typeName, @assemblyName, @dtExec, @sRecurDatePart, @Interval, @data )
	
	return
end
