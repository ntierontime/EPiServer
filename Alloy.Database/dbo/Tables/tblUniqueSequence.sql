CREATE TABLE [dbo].[tblUniqueSequence] (
    [Name]      NVARCHAR (255) NOT NULL,
    [LastValue] INT            CONSTRAINT [DF__tblUniqueSequence__LastValue] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblUniqueSequence] PRIMARY KEY CLUSTERED ([Name] ASC)
);

