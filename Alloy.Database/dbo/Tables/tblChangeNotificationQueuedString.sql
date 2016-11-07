CREATE TABLE [dbo].[tblChangeNotificationQueuedString] (
    [ProcessorId]  UNIQUEIDENTIFIER NOT NULL,
    [ConnectionId] UNIQUEIDENTIFIER NULL,
    [QueueOrder]   INT              NOT NULL,
    [Value]        NVARCHAR (450)   COLLATE Latin1_General_BIN2 NOT NULL,
    CONSTRAINT [FK_ChangeNotification_ChangeNotificationString_ChangeNotificationConnection] FOREIGN KEY ([ConnectionId]) REFERENCES [dbo].[tblChangeNotificationConnection] ([ConnectionId]),
    CONSTRAINT [FK_ChangeNotification_ChangeNotificationString_ChangeNotificationProcessor] FOREIGN KEY ([ProcessorId]) REFERENCES [dbo].[tblChangeNotificationProcessor] ([ProcessorId])
);


GO
CREATE CLUSTERED INDEX [IDX_tblChangeNotificationQueuedString]
    ON [dbo].[tblChangeNotificationQueuedString]([ProcessorId] ASC, [QueueOrder] ASC);

