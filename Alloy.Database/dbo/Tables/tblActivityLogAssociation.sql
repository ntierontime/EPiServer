CREATE TABLE [dbo].[tblActivityLogAssociation] (
    [From] NVARCHAR (255) NOT NULL,
    [To]   BIGINT         NOT NULL,
    CONSTRAINT [PK_tblActivityLogAssociation] PRIMARY KEY NONCLUSTERED ([From] ASC, [To] ASC),
    CONSTRAINT [FK_tblActivityLogAssociation_tblActivityLog] FOREIGN KEY ([To]) REFERENCES [dbo].[tblActivityLog] ([pkID]) ON DELETE CASCADE
);


GO
CREATE CLUSTERED INDEX [IDX_tblActivityLogAssociation_From]
    ON [dbo].[tblActivityLogAssociation]([From] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblActivityLogAssociation_To]
    ON [dbo].[tblActivityLogAssociation]([To] ASC);

