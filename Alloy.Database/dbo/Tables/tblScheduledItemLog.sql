CREATE TABLE [dbo].[tblScheduledItemLog] (
    [pkID]              INT              IDENTITY (1, 1) NOT NULL,
    [fkScheduledItemId] UNIQUEIDENTIFIER NOT NULL,
    [Exec]              DATETIME         NOT NULL,
    [Status]            INT              NULL,
    [Text]              NVARCHAR (2048)  NULL,
    CONSTRAINT [PK_tblScheduledItemLog] PRIMARY KEY CLUSTERED ([pkID] ASC),
    CONSTRAINT [fk_tblScheduledItemLog_tblScheduledItem] FOREIGN KEY ([fkScheduledItemId]) REFERENCES [dbo].[tblScheduledItem] ([pkID])
);

