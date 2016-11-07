CREATE TABLE [dbo].[tblCategory] (
    [pkID]                INT              IDENTITY (1, 1) NOT NULL,
    [fkParentID]          INT              NULL,
    [CategoryGUID]        UNIQUEIDENTIFIER CONSTRAINT [DF_tblCategory_CategoryGUID] DEFAULT (newid()) NOT NULL,
    [SortOrder]           INT              CONSTRAINT [DF_tblCategory_PeerOrder] DEFAULT ((100)) NOT NULL,
    [Available]           BIT              CONSTRAINT [DF_tblCategory_Available] DEFAULT ((1)) NOT NULL,
    [Selectable]          BIT              CONSTRAINT [DF_tblCategory_Selectable] DEFAULT ((1)) NOT NULL,
    [SuperCategory]       BIT              CONSTRAINT [DF_tblCategory_SuperCategory] DEFAULT ((0)) NOT NULL,
    [CategoryName]        NVARCHAR (50)    NOT NULL,
    [CategoryDescription] NVARCHAR (255)   NULL,
    CONSTRAINT [PK_tblCategory] PRIMARY KEY CLUSTERED ([pkID] ASC),
    CONSTRAINT [FK_tblCategory_tblCategory] FOREIGN KEY ([fkParentID]) REFERENCES [dbo].[tblCategory] ([pkID])
);

