CREATE TYPE [dbo].[HostDefinitionTable] AS TABLE (
    [Name]     VARCHAR (MAX) NULL,
    [Type]     INT           NULL,
    [Language] VARCHAR (50)  NULL,
    [Https]    BIT           NULL);

