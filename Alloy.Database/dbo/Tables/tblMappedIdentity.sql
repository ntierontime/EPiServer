CREATE TABLE [dbo].[tblMappedIdentity] (
    [pkID]                   INT              IDENTITY (1, 1) NOT NULL,
    [Provider]               NVARCHAR (255)   NOT NULL,
    [ProviderUniqueId]       NVARCHAR (450)   NOT NULL,
    [ContentGuid]            UNIQUEIDENTIFIER CONSTRAINT [DF_tblMappedIdentity_ContentGuid] DEFAULT (newid()) NOT NULL,
    [ExistingContentId]      INT              NULL,
    [ExistingCustomProvider] BIT              NULL,
    CONSTRAINT [PK_tblMappedIdentity] PRIMARY KEY NONCLUSTERED ([pkID] ASC)
);


GO
CREATE CLUSTERED INDEX [IDX_tblMappedIdentity_ProviderUniqueId]
    ON [dbo].[tblMappedIdentity]([ProviderUniqueId] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblMappedIdentity_Provider]
    ON [dbo].[tblMappedIdentity]([Provider] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_tblMappedIdentity_ContentGuid]
    ON [dbo].[tblMappedIdentity]([ContentGuid] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblMappedIdentity_ExternalId]
    ON [dbo].[tblMappedIdentity]([ExistingContentId] ASC, [ExistingCustomProvider] ASC);

