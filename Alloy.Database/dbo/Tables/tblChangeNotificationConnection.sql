CREATE TABLE [dbo].[tblChangeNotificationConnection] (
    [ConnectionId]      UNIQUEIDENTIFIER NOT NULL,
    [ProcessorId]       UNIQUEIDENTIFIER NOT NULL,
    [IsOpen]            BIT              NOT NULL,
    [LastActivityDbUtc] DATETIME         NOT NULL,
    CONSTRAINT [PK_ChangeNotificationConnection] PRIMARY KEY CLUSTERED ([ConnectionId] ASC),
    CONSTRAINT [FK_ChangeNotificationConnection_ChangeNotificationProcessor] FOREIGN KEY ([ProcessorId]) REFERENCES [dbo].[tblChangeNotificationProcessor] ([ProcessorId])
);

