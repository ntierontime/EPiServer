CREATE TABLE [dbo].[tblLanguageBranch] (
    [pkID]           INT            IDENTITY (1, 1) NOT NULL,
    [LanguageID]     NCHAR (17)     NOT NULL,
    [Name]           NVARCHAR (255) NULL,
    [SortIndex]      INT            NOT NULL,
    [SystemIconPath] NVARCHAR (255) NULL,
    [URLSegment]     NVARCHAR (255) NULL,
    [ACL]            NVARCHAR (MAX) NULL,
    [Enabled]        BIT            CONSTRAINT [DF__tblLanguageBranch__Enabled] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_tblLanguageBranch] PRIMARY KEY CLUSTERED ([pkID] ASC),
    CONSTRAINT [IX_tblLanguageBranch] UNIQUE NONCLUSTERED ([LanguageID] ASC)
);

