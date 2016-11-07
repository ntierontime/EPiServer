CREATE TABLE [dbo].[tblActivityLogComment] (
    [pkID]        BIGINT         IDENTITY (1, 1) NOT NULL,
    [EntryId]     BIGINT         NOT NULL,
    [Author]      NVARCHAR (255) NULL,
    [Created]     DATETIME       NOT NULL,
    [LastUpdated] DATETIME       NOT NULL,
    [Message]     NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_tblActivityLogComment] PRIMARY KEY CLUSTERED ([pkID] ASC),
    CONSTRAINT [FK_tblActivityLogComment_tblActivityLog] FOREIGN KEY ([EntryId]) REFERENCES [dbo].[tblActivityLog] ([pkID]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IDX_tblActivityLogComment_EntryId]
    ON [dbo].[tblActivityLogComment]([EntryId] ASC);

