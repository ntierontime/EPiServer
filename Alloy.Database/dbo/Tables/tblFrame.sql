CREATE TABLE [dbo].[tblFrame] (
    [pkID]             INT            IDENTITY (1, 1) NOT NULL,
    [FrameName]        NVARCHAR (100) NOT NULL,
    [FrameDescription] NVARCHAR (255) NULL,
    [SystemFrame]      BIT            CONSTRAINT [DF_tblFrame_SystemFrame] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblFrame] PRIMARY KEY CLUSTERED ([pkID] ASC)
);

