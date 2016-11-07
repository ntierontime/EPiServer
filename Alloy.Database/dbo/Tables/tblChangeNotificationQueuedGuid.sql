CREATE TABLE [dbo].[tblChangeNotificationQueuedGuid] (
    [ProcessorId]  UNIQUEIDENTIFIER NOT NULL,
    [ConnectionId] UNIQUEIDENTIFIER NULL,
    [QueueOrder]   INT              NOT NULL,
    [Value]        UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [FK_ChangeNotification_ChangeNotificationGuid_ChangeNotificationConnection] FOREIGN KEY ([ConnectionId]) REFERENCES [dbo].[tblChangeNotificationConnection] ([ConnectionId]),
    CONSTRAINT [FK_ChangeNotification_ChangeNotificationGuid_ChangeNotificationProcessor] FOREIGN KEY ([ProcessorId]) REFERENCES [dbo].[tblChangeNotificationProcessor] ([ProcessorId])
);


GO
CREATE CLUSTERED INDEX [IDX_tblChangeNotificationQueuedGuid]
    ON [dbo].[tblChangeNotificationQueuedGuid]([ProcessorId] ASC, [QueueOrder] ASC);

