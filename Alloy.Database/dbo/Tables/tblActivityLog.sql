CREATE TABLE [dbo].[tblActivityLog] (
    [pkID]        BIGINT         IDENTITY (1, 1) NOT NULL,
    [LogData]     NVARCHAR (MAX) NULL,
    [ChangeDate]  DATETIME       NOT NULL,
    [Type]        NVARCHAR (50)  NOT NULL,
    [Action]      INT            CONSTRAINT [DF_tblActivityLog_Action] DEFAULT ((0)) NOT NULL,
    [ChangedBy]   NVARCHAR (255) NOT NULL,
    [RelatedItem] NVARCHAR (255) NULL,
    [Deleted]     BIT            DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblActivityLog] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_tblActivityLog_ChangeDate]
    ON [dbo].[tblActivityLog]([ChangeDate] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblActivityLog_Pkid_ChangeDate]
    ON [dbo].[tblActivityLog]([pkID] ASC, [ChangeDate] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblActivityLog_RelatedItem]
    ON [dbo].[tblActivityLog]([RelatedItem] ASC)
    INCLUDE([Deleted]);

