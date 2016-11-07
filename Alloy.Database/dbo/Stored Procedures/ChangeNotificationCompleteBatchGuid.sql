CREATE PROCEDURE [dbo].[ChangeNotificationCompleteBatchGuid]
    @connectionId uniqueidentifier,
    @success bit
as
begin
    begin try
        begin transaction
        declare @processorId uniqueidentifier
        declare @processorStatus nvarchar(30)
        declare @processorStatusTable table (ProcessorId uniqueidentifier, ProcessorStatus nvarchar(30), LastConsistentDbUtc datetime)
        insert into @processorStatusTable (ProcessorId, ProcessorStatus, LastConsistentDbUtc)
        exec ChangeNotificationAccessConnectionWorker @connectionId, 'Guid'
        select @processorId = ProcessorId, @processorStatus = ProcessorStatus
        from @processorStatusTable
        if (@processorStatus != 'invalid' and @processorStatus != 'closed')
        begin
            if (@success = 1)
            begin
                delete from tblChangeNotificationQueuedGuid
                where ConnectionId = @connectionId
                if not exists (select 1 from tblChangeNotificationQueuedGuid where ProcessorId = @processorId)
                begin
                    update tblChangeNotificationProcessor
                    set NextQueueOrderValue = 0, LastConsistentDbUtc = GETUTCDATE()
                    where ProcessorId = @processorId
                end
            end
            else
            begin
                declare @queueOrder int
                update tblChangeNotificationProcessor
                set @queueOrder = NextQueueOrderValue = NextQueueOrderValue + 1
                where ProcessorId = @processorId
                update tblChangeNotificationQueuedGuid
                set QueueOrder = @queueOrder, ConnectionId = null
                where ConnectionId = @connectionId
            end
        end
        commit transaction
    end try
    begin catch
    declare @msg nvarchar(4000), @sev int, @stt int
        select @msg = ERROR_MESSAGE(), @sev = ERROR_SEVERITY(), @stt = ERROR_STATE()
        rollback transaction
        raiserror(@msg, @sev, @stt)
    end catch
end
