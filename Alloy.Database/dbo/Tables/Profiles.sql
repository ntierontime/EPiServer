CREATE TABLE [dbo].[Profiles] (
    [UserId]               UNIQUEIDENTIFIER NOT NULL,
    [PropertyNames]        NVARCHAR (MAX)   NOT NULL,
    [PropertyValueStrings] NVARCHAR (MAX)   NOT NULL,
    [PropertyValueBinary]  VARBINARY (MAX)  NOT NULL,
    [LastUpdatedDate]      DATETIME         NOT NULL,
    PRIMARY KEY CLUSTERED ([UserId] ASC),
    CONSTRAINT [ProfileEntity_User] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([UserId])
);

