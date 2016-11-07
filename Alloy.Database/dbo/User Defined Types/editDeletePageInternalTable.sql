CREATE TYPE [dbo].[editDeletePageInternalTable] AS TABLE (
    [pkID]     INT              NOT NULL,
    [PageGUID] UNIQUEIDENTIFIER NULL,
    PRIMARY KEY CLUSTERED ([pkID] ASC));

