CREATE TABLE [dbo].[tblProject] (
    [pkID]                    INT            IDENTITY (1, 1) NOT NULL,
    [Name]                    NVARCHAR (255) NOT NULL,
    [IsPublic]                BIT            NOT NULL,
    [Created]                 DATETIME       NOT NULL,
    [CreatedBy]               NVARCHAR (255) NOT NULL,
    [Status]                  INT            NOT NULL,
    [PublishingTrackingToken] NVARCHAR (255) NULL,
    [DelayPublishUntil]       DATETIME       NULL,
    CONSTRAINT [PK_tblProject] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_tblProject_StatusName]
    ON [dbo].[tblProject]([Status] ASC, [Name] ASC);

