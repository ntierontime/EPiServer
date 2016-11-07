CREATE PROCEDURE [dbo].[ChangeNotificationGetStatus]
    @connectionId uniqueidentifier
as
begin
    begin try
        begin transaction
        declare @processorId uniqueidentifier
        declare @processorStatus nvarchar(30)
        declare @lastConsistentDbUtc datetime
        declare @processorStatusTable table (ProcessorId uniqueidentifier, ProcessorStatus nvarchar(30), LastConsistentDbUtc datetime)
        insert into @processorStatusTable (ProcessorId, ProcessorStatus, LastConsistentDbUtc)
        exec ChangeNotificationAccessConnectionWorker @connectionId
        select @processorId = ProcessorId, @processorStatus = ProcessorStatus, @lastConsistentDbUtc = LastConsistentDbUtc
        from @processorStatusTable
        declare @queuedDataType nvarchar(30)
        select @queuedDataType = ChangeNotificationDataType
        from tblChangeNotificationProcessor
        where ProcessorId = @processorId
        declare @queuedItemCount int
        if (@processorStatus = 'closed')
        begin
            set @queuedItemCount = 0
        end
        else if (@queuedDataType = 'Int')
        begin
            select @queuedItemCount = COUNT(*)
            from tblChangeNotificationQueuedInt
            where ProcessorId = @processorId and ConnectionId is null
        end
        else if (@queuedDataType = 'Guid')
        begin
            select @queuedItemCount = COUNT(*)
            from tblChangeNotificationQueuedGuid
            where ProcessorId = @processorId and ConnectionId is null
        end
        else if (@queuedDataType = 'String')
        begin
            select @queuedItemCount = COUNT(*)
            from tblChangeNotificationQueuedString
            where ProcessorId = @processorId and ConnectionId is null
        end
        select
            @processorStatus as ProcessorStatus,
            @queuedItemCount as QueuedItemCount,
            case when @processorStatus = 'valid' and @queuedItemCount = 0 then GETUTCDATE() else @lastConsistentDbUtc end as LastConsistentDbUtc
        commit transaction
    end try
    begin catch
        declare @msg nvarchar(4000), @sev int, @stt int
        select @msg = ERROR_MESSAGE(), @sev = ERROR_SEVERITY(), @stt = ERROR_STATE()
        rollback transaction
        raiserror(@msg, @sev, @stt)
    end catch
end
