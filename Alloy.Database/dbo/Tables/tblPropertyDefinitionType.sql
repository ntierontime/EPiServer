CREATE TABLE [dbo].[tblPropertyDefinitionType] (
    [pkID]              INT              NOT NULL,
    [Property]          INT              NOT NULL,
    [Name]              NVARCHAR (255)   NOT NULL,
    [TypeName]          NVARCHAR (255)   NULL,
    [AssemblyName]      NVARCHAR (255)   NULL,
    [fkContentTypeGUID] UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_tblPropertyDefinitionType] PRIMARY KEY CLUSTERED ([pkID] ASC)
);

