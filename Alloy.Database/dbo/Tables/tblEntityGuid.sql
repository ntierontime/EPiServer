CREATE TABLE [dbo].[tblEntityGuid] (
    [intObjectTypeID] INT              NOT NULL,
    [intObjectID]     INT              NOT NULL,
    [unqID]           UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_tblEntityGuid] PRIMARY KEY CLUSTERED ([intObjectTypeID] ASC, [intObjectID] ASC)
);

