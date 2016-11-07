CREATE PROCEDURE [dbo].[ChangeNotificationCloseConnection]
    @connectionId uniqueidentifier
as
begin
    begin try
        begin transaction
        declare @processorId uniqueidentifier
        declare @processorStatus nvarchar(30)
        select @processorId = p.ProcessorId, @processorStatus = p.ProcessorStatus
        from tblChangeNotificationConnection c
        join tblChangeNotificationProcessor p on c.ProcessorId = p.ProcessorId
        where c.ConnectionId = @connectionId
        update tblChangeNotificationQueuedInt set ConnectionId = null where ConnectionId = @connectionId
        update tblChangeNotificationQueuedGuid set ConnectionId = null where ConnectionId = @connectionId
        update tblChangeNotificationQueuedString set ConnectionId = null where ConnectionId = @connectionId
        delete from tblChangeNotificationConnection where ConnectionId = @connectionId
        if (@processorStatus != 'valid' and not exists (select 1 from tblChangeNotificationConnection where ProcessorId = @processorId))
        begin
            -- if there are no connections to the queue and it is not in a valid state, remove it from persistent storage.
            delete from tblChangeNotificationQueuedInt where ProcessorId = @processorId
            delete from tblChangeNotificationQueuedGuid where ProcessorId = @processorId
            delete from tblChangeNotificationQueuedString where ProcessorId = @processorId
            delete from tblChangeNotificationProcessor where ProcessorId = @processorId
        end
        commit transaction
        select @connectionId as ConnectionId
    end try
    begin catch
        declare @msg nvarchar(4000), @sev int, @stt int
        select @msg = ERROR_MESSAGE(), @sev = ERROR_SEVERITY(), @stt = ERROR_STATE()
        rollback transaction
        raiserror(@msg, @sev, @stt)
    end catch
end
