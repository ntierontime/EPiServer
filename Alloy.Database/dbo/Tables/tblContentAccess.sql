CREATE TABLE [dbo].[tblContentAccess] (
    [fkContentID] INT            NOT NULL,
    [Name]        NVARCHAR (255) NOT NULL,
    [IsRole]      INT            CONSTRAINT [DF_tblAccess_IsRole] DEFAULT ((1)) NOT NULL,
    [AccessMask]  INT            NOT NULL,
    CONSTRAINT [PK_tblContentAccess] PRIMARY KEY CLUSTERED ([fkContentID] ASC, [Name] ASC),
    CONSTRAINT [FK_tblContentAccess_tblContent] FOREIGN KEY ([fkContentID]) REFERENCES [dbo].[tblContent] ([pkID])
);

