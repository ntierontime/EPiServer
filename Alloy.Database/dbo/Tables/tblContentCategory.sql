CREATE TABLE [dbo].[tblContentCategory] (
    [pkID]               INT            IDENTITY (1, 1) NOT NULL,
    [fkContentID]        INT            NOT NULL,
    [fkCategoryID]       INT            NOT NULL,
    [CategoryType]       INT            CONSTRAINT [DF_tblContentCategory_CategoryType] DEFAULT ((0)) NOT NULL,
    [fkLanguageBranchID] INT            CONSTRAINT [DF_tblContentCategory_LanguageBranchID] DEFAULT ((1)) NOT NULL,
    [ScopeName]          NVARCHAR (450) NOT NULL,
    CONSTRAINT [PK_tblContentCategory] PRIMARY KEY NONCLUSTERED ([pkID] ASC),
    CONSTRAINT [FK_tblContentCategory_tblCategory] FOREIGN KEY ([fkCategoryID]) REFERENCES [dbo].[tblCategory] ([pkID]),
    CONSTRAINT [FK_tblContentCategory_tblContent] FOREIGN KEY ([fkContentID]) REFERENCES [dbo].[tblContent] ([pkID])
);


GO
CREATE CLUSTERED INDEX [IDX_tblContentCategory_fkContentID]
    ON [dbo].[tblContentCategory]([fkContentID] ASC, [CategoryType] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblContentCategory_fkCategoryID]
    ON [dbo].[tblContentCategory]([fkCategoryID] ASC)
    INCLUDE([fkContentID], [CategoryType], [fkLanguageBranchID]);

