CREATE TYPE [dbo].[ProjectItemTable] AS TABLE (
    [ID]                  INT            NULL,
    [ProjectID]           INT            NULL,
    [ContentLinkID]       INT            NULL,
    [ContentLinkWorkID]   INT            NULL,
    [ContentLinkProvider] NVARCHAR (255) NULL,
    [Language]            NVARCHAR (17)  NULL,
    [Category]            NVARCHAR (255) NULL);

