CREATE PROCEDURE [dbo].[ChangeNotificationAccessConnectionWorker]
    @connectionId uniqueidentifier,
    @expectedChangeNotificationDataType nvarchar(30) = null
as
begin
    update tblChangeNotificationConnection
    set LastActivityDbUtc = GETUTCDATE()
    where ConnectionId = @connectionId
    declare @processorId uniqueidentifier
    declare @queuedDataType nvarchar(30)
    declare @processorStatus nvarchar(30)
    declare @nextQueueOrderValue int
    declare @lastConsistentDbUtc datetime
    declare @isOpen bit
    select @processorId = p.ProcessorId, @queuedDataType = p.ChangeNotificationDataType, @processorStatus = p.ProcessorStatus, @nextQueueOrderValue = p.NextQueueOrderValue, @lastConsistentDbUtc = p.LastConsistentDbUtc, @isOpen = c.IsOpen
    from tblChangeNotificationProcessor p
    join tblChangeNotificationConnection c on p.ProcessorId = c.ProcessorId
    where c.ConnectionId = @connectionId
    if (@processorId is null)
    begin
        set @processorStatus = 'closed'
    end
    else if (@expectedChangeNotificationDataType is not null and @expectedChangeNotificationDataType != @queuedDataType)
    begin
        set @processorStatus = 'type_mismatch'
    end
    else if (@processorStatus = 'invalid' or @isOpen = 1)
    begin
        -- the queue is invalid, or the current connection is valid.
        -- all pending connection requests may be considered open.
        update tblChangeNotificationConnection
        set IsOpen = 1
        where ProcessorId = @processorId and IsOpen = 0
        if (@processorStatus = 'valid' and @nextQueueOrderValue = 0)
        begin
            set @lastConsistentDbUtc = GETUTCDATE()
        end
    end
    else if (@isOpen = 0 and @processorStatus != 'invalid')
    begin
        set @processorStatus = 'opening'
    end
    select @processorId as ProcessorId,  @processorStatus as ProcessorStatus, @lastConsistentDbUtc
end
