CREATE TABLE [dbo].[tblChangeNotificationProcessor] (
    [ProcessorId]                UNIQUEIDENTIFIER NOT NULL,
    [ChangeNotificationDataType] NVARCHAR (30)    NOT NULL,
    [ProcessorName]              NVARCHAR (4000)  NOT NULL,
    [ProcessorStatus]            NVARCHAR (30)    NOT NULL,
    [NextQueueOrderValue]        INT              NOT NULL,
    [LastConsistentDbUtc]        DATETIME         NULL,
    CONSTRAINT [PK_ChangeNotificationProcessor] PRIMARY KEY CLUSTERED ([ProcessorId] ASC),
    CONSTRAINT [CK_ChangeNotificationProcessor_ChangeNotificationDataType] CHECK ([ChangeNotificationDataType]='Guid' OR [ChangeNotificationDataType]='String' OR [ChangeNotificationDataType]='Int'),
    CONSTRAINT [CK_ChangeNotificationProcessor_ProcessorStatus] CHECK ([ProcessorStatus]='valid' OR [ProcessorStatus]='recovering' OR [ProcessorStatus]='invalid')
);

