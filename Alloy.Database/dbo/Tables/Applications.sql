CREATE TABLE [dbo].[Applications] (
    [ApplicationId]   UNIQUEIDENTIFIER NOT NULL,
    [ApplicationName] NVARCHAR (235)   NOT NULL,
    [Description]     NVARCHAR (256)   NULL,
    PRIMARY KEY CLUSTERED ([ApplicationId] ASC)
);

