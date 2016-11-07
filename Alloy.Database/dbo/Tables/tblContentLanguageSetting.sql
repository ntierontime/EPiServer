CREATE TABLE [dbo].[tblContentLanguageSetting] (
    [fkContentID]            INT             NOT NULL,
    [fkLanguageBranchID]     INT             NOT NULL,
    [fkReplacementBranchID]  INT             NULL,
    [LanguageBranchFallback] NVARCHAR (1000) NULL,
    [Active]                 BIT             CONSTRAINT [DF__tblConten__Activ__51300E55] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_tblContentLanguageSetting] PRIMARY KEY CLUSTERED ([fkContentID] ASC, [fkLanguageBranchID] ASC),
    CONSTRAINT [FK_tblContentLanguageSetting_tblContent] FOREIGN KEY ([fkContentID]) REFERENCES [dbo].[tblContent] ([pkID]),
    CONSTRAINT [FK_tblContentLanguageSetting_tblLanguageBranch1] FOREIGN KEY ([fkLanguageBranchID]) REFERENCES [dbo].[tblLanguageBranch] ([pkID]),
    CONSTRAINT [FK_tblContentLanguageSetting_tblLanguageBranch2] FOREIGN KEY ([fkReplacementBranchID]) REFERENCES [dbo].[tblLanguageBranch] ([pkID])
);

