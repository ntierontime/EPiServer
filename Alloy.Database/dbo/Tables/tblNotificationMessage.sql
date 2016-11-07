CREATE TABLE [dbo].[tblNotificationMessage] (
    [pkID]      INT            IDENTITY (1, 1) NOT NULL,
    [Sender]    NVARCHAR (255) NULL,
    [Recipient] NVARCHAR (255) NOT NULL,
    [Channel]   NVARCHAR (50)  NULL,
    [Type]      NVARCHAR (50)  NULL,
    [Subject]   NVARCHAR (255) NULL,
    [Content]   NVARCHAR (MAX) NULL,
    [Sent]      DATETIME2 (7)  NULL,
    [SendAt]    DATETIME2 (7)  NULL,
    [Saved]     DATETIME2 (7)  NOT NULL,
    [Read]      DATETIME2 (7)  NULL,
    [Category]  NVARCHAR (255) NULL,
    CONSTRAINT [PK_tblNotificationMessage] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_tblNotificationMessage_SendAt]
    ON [dbo].[tblNotificationMessage]([SendAt] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblNotificationMessage_Sent]
    ON [dbo].[tblNotificationMessage]([Sent] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblNotificationMessage_Read]
    ON [dbo].[tblNotificationMessage]([Read] ASC);

