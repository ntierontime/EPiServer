CREATE TABLE [dbo].[tblRemoteSite] (
    [pkID]           INT            IDENTITY (1, 1) NOT NULL,
    [Name]           NVARCHAR (100) NOT NULL,
    [Url]            NVARCHAR (255) NOT NULL,
    [IsTrusted]      BIT            CONSTRAINT [DF_tblRemoteSite_IsTrusted] DEFAULT ((0)) NOT NULL,
    [UserName]       NVARCHAR (50)  NULL,
    [Password]       NVARCHAR (50)  NULL,
    [Domain]         NVARCHAR (50)  NULL,
    [AllowUrlLookup] BIT            CONSTRAINT [DF_tblRemoteSite_AllowUrlLookup] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblRemoteSite] PRIMARY KEY CLUSTERED ([pkID] ASC),
    CONSTRAINT [IX_tblRemoteSite] UNIQUE NONCLUSTERED ([Name] ASC)
);

