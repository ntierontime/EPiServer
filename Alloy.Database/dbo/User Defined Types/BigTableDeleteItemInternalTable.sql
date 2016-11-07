CREATE TYPE [dbo].[BigTableDeleteItemInternalTable] AS TABLE (
    [Id]         BIGINT        NULL,
    [NestLevel]  INT           NULL,
    [ObjectPath] VARCHAR (MAX) NULL);

