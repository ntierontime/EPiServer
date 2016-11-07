CREATE PROCEDURE [dbo].[ChangeNotificationOpenConnection]
    @processorId uniqueidentifier,
    @queuedDataType nvarchar(30),
    @processorName nvarchar(4000),
    @inactiveConnectionTimeoutSeconds int
as
begin
    declare @connectionId uniqueidentifier
    declare @processorStatus nvarchar(30)
    declare @configuredChangeNotificationDataType nvarchar(30)
    begin try
        begin transaction
        declare @utcnow datetime = GETUTCDATE()
        select @processorStatus = ProcessorStatus, @configuredChangeNotificationDataType = ChangeNotificationDataType
        from tblChangeNotificationProcessor
        where ProcessorId = @processorId
        if (@processorStatus is null)
        begin
            -- the queue does not exist on the database yet. create and open with state invalid.
            set @processorStatus = 'invalid'
            insert into tblChangeNotificationProcessor (ProcessorId, ChangeNotificationDataType, ProcessorName, ProcessorStatus, NextQueueOrderValue)
            values (@processorId, @queuedDataType, @processorName, @processorStatus, 0)
            set @connectionId = NEWID()
            insert into tblChangeNotificationConnection (ProcessorId, ConnectionId, IsOpen, LastActivityDbUtc)
            values (@processorId, @connectionId, 1, @utcnow)
        end
        else if (@processorStatus = 'invalid' or exists (select 1
            from tblChangeNotificationConnection
            where ProcessorId = @processorId and LastActivityDbUtc < DATEADD(second, -@inactiveConnectionTimeoutSeconds, @utcnow)))
        begin
            -- the queue exists.  we can skip waiting for another running processor to confirm the state, since it is invalid anyways.
            exec ChangeNotificationSetInvalidWorker @processorId, @inactiveConnectionTimeoutSeconds
            set @connectionId = NEWID()
            insert into tblChangeNotificationConnection (ProcessorId, ConnectionId, IsOpen, LastActivityDbUtc)
            values (@processorId, @connectionId, 1, @utcnow)
        end
        else if (@queuedDataType = @configuredChangeNotificationDataType)
        begin
            set @connectionId = NEWID()
            declare @isOpen bit
            if exists (select 1 from tblChangeNotificationConnection where ProcessorId = @processorId)
            begin
                -- there are connections open, which may or may not still be running.
                -- leave the isOpen flag set to 0 as a request for a running process to confirm the queue status.
                set @isOpen = 0
            end
            else
            begin
                -- there are no connections to the queue. open with the current status intact.
                set @isOpen = 1
            end
            insert into tblChangeNotificationConnection (ProcessorId, ConnectionId, IsOpen, LastActivityDbUtc)
            values (@processorId, @connectionId, @isOpen, GETUTCDATE())
        end
        else
        begin
            -- the processor exists with a different queued type. throw an exception.
            raiserror('The specified processor ID already exists with a different queued type.', 16, 1)
        end
        select c.ConnectionId, case when c.IsOpen = 0 then 'opening' else p.ProcessorStatus end as ProcessorStatus
        from tblChangeNotificationConnection c
        join tblChangeNotificationProcessor p on c.ProcessorId = p.ProcessorId
        where c.ConnectionId = @connectionId
        commit transaction
    end try
    begin catch
        declare @msg nvarchar(4000), @sev int, @stt int
        select @msg = ERROR_MESSAGE(), @sev = ERROR_SEVERITY(), @stt = ERROR_STATE()
        rollback transaction
        raiserror(@msg, @sev, @stt)
    end catch
end
