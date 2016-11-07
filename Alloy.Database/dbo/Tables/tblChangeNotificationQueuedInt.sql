CREATE TABLE [dbo].[tblChangeNotificationQueuedInt] (
    [ProcessorId]  UNIQUEIDENTIFIER NOT NULL,
    [ConnectionId] UNIQUEIDENTIFIER NULL,
    [QueueOrder]   INT              NOT NULL,
    [Value]        INT              NOT NULL,
    CONSTRAINT [FK_ChangeNotification_ChangeNotificationInt_ChangeNotificationConnection] FOREIGN KEY ([ConnectionId]) REFERENCES [dbo].[tblChangeNotificationConnection] ([ConnectionId]),
    CONSTRAINT [FK_ChangeNotification_ChangeNotificationInt_ChangeNotificationProcessor] FOREIGN KEY ([ProcessorId]) REFERENCES [dbo].[tblChangeNotificationProcessor] ([ProcessorId])
);


GO
CREATE CLUSTERED INDEX [IDX_tblChangeNotificationQueuedInt]
    ON [dbo].[tblChangeNotificationQueuedInt]([ProcessorId] ASC, [QueueOrder] ASC);

