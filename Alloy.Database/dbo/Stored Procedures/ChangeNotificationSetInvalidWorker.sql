CREATE PROCEDURE [dbo].[ChangeNotificationSetInvalidWorker]
    @processorId uniqueidentifier,
    @inactiveConnectionTimeoutSeconds int
as
begin
    delete from tblChangeNotificationQueuedInt where ProcessorId = @processorId
    delete from tblChangeNotificationQueuedGuid where ProcessorId = @processorId
    delete from tblChangeNotificationQueuedString where ProcessorId = @processorId
    update tblChangeNotificationProcessor
    set ProcessorStatus = 'invalid', NextQueueOrderValue = 0, LastConsistentDbUtc = null
    where ProcessorId = @processorId
    delete from tblChangeNotificationConnection
    where ProcessorId = @processorId and LastActivityDbUtc < DATEADD(second, -@inactiveConnectionTimeoutSeconds, GETUTCDATE())
    update tblChangeNotificationConnection
    set IsOpen = 1
    where ProcessorId = @processorId and IsOpen = 0
end
