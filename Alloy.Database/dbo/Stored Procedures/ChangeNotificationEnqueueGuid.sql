CREATE PROCEDURE [dbo].[ChangeNotificationEnqueueGuid]
    @processorId uniqueidentifier,
    @items ChangeNotificationGuidTable readonly
as
begin
    begin try
        begin transaction
        declare @processorStatus nvarchar(30)
        select @processorStatus = ProcessorStatus
        from tblChangeNotificationProcessor
        where ProcessorId = @processorId
        if (@processorStatus != 'invalid' and @processorStatus != 'closed')
        begin
            declare @queueOrder int
            update tblChangeNotificationProcessor
            set @queueOrder = NextQueueOrderValue = NextQueueOrderValue + 1, LastConsistentDbUtc = case when @processorStatus = 'valid' and NextQueueOrderValue = 0 then GETUTCDATE() else LastConsistentDbUtc end
            where ProcessorId = @processorId
            -- insert values from @items, avoiding any values which are already in the queue and not in an outstanding batch.
            insert into tblChangeNotificationQueuedGuid (ProcessorId, QueueOrder, ConnectionId, Value)
            select @processorId, @queueOrder, null, i.Value
            from @items i
            left outer join tblChangeNotificationQueuedGuid q
                on q.ProcessorId = @processorId
                and q.ConnectionId is null
                and i.Value = q.Value
            where q.ProcessorId is null
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
