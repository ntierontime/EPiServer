CREATE TABLE [dbo].[tblPlugIn] (
    [pkID]         INT            IDENTITY (1, 1) NOT NULL,
    [AssemblyName] NVARCHAR (255) NOT NULL,
    [TypeName]     NVARCHAR (255) NOT NULL,
    [Settings]     NVARCHAR (MAX) NULL,
    [Saved]        DATETIME       NOT NULL,
    [Created]      DATETIME       NOT NULL,
    [Enabled]      BIT            CONSTRAINT [DF_tblPlugIn_Enabled] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_tblPlugIn] PRIMARY KEY CLUSTERED ([pkID] ASC)
);

