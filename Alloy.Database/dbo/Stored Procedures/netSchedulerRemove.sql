CREATE procedure dbo.netSchedulerRemove
@ID	uniqueidentifier
as
begin
	set nocount on
	
	delete from tblScheduledItemLog where fkScheduledItemId = @ID
	delete from tblScheduledItem where pkID = @ID
	
	return
end
