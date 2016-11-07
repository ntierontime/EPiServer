CREATE TABLE [dbo].[tblEntityType] (
    [intID]   INT           IDENTITY (1, 1) NOT NULL,
    [strName] VARCHAR (400) NOT NULL,
    CONSTRAINT [PK_tblEntityType] PRIMARY KEY CLUSTERED ([intID] ASC)
);

