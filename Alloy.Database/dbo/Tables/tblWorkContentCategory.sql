CREATE TABLE [dbo].[tblWorkContentCategory] (
    [pkID]            INT            IDENTITY (1, 1) NOT NULL,
    [fkWorkContentID] INT            NOT NULL,
    [fkCategoryID]    INT            NOT NULL,
    [CategoryType]    INT            CONSTRAINT [DF_tblWorkContentCategory_CategoryType] DEFAULT ((0)) NOT NULL,
    [ScopeName]       NVARCHAR (450) NOT NULL,
    CONSTRAINT [PK_tblWorkContentCategory] PRIMARY KEY NONCLUSTERED ([pkID] ASC),
    CONSTRAINT [FK_tblWorkContentCategory_tblCategory] FOREIGN KEY ([fkCategoryID]) REFERENCES [dbo].[tblCategory] ([pkID]),
    CONSTRAINT [FK_tblWorkContentCategory_tblWorkContent] FOREIGN KEY ([fkWorkContentID]) REFERENCES [dbo].[tblWorkContent] ([pkID])
);


GO
CREATE CLUSTERED INDEX [IDX_tblWorkContentCategory_fkWorkContentID]
    ON [dbo].[tblWorkContentCategory]([fkWorkContentID] ASC, [CategoryType] ASC);

