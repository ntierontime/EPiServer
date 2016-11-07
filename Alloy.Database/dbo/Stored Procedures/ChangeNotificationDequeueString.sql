CREATE PROCEDURE [dbo].[ChangeNotificationDequeueString]
    @connectionId uniqueidentifier,
    @maxItems int
as
begin
    begin try
        begin transaction
        declare @processorId uniqueidentifier
        declare @processorStatus nvarchar(30)
        declare @processorStatusTable table (ProcessorId uniqueidentifier, ProcessorStatus nvarchar(30), LastConsistentDbUtc datetime)
        insert into @processorStatusTable (ProcessorId, ProcessorStatus, LastConsistentDbUtc)
        exec ChangeNotificationAccessConnectionWorker @connectionId, 'String'
        select @processorId = ProcessorId, @processorStatus = ProcessorStatus
        from @processorStatusTable
        if (@processorStatus = 'valid')
        begin
            if exists (select 1 from tblChangeNotificationQueuedString where ConnectionId = @connectionId)
            begin
                raiserror('A batch is already pending for the specified queue connection.', 16, 1)
            end
            declare @result table (Value nvarchar(450) collate Latin1_General_BIN2)
            insert into @result (Value)
            select top (@maxItems) Value
            from tblChangeNotificationQueuedString
			where ProcessorId = @processorId
			  and ConnectionId is null
			order by QueueOrder
            update tblChangeNotificationQueuedString
            set ConnectionId = @connectionId
            where ProcessorId = @processorId
              and Value in (select Value from @result)
            select Value from @result
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
