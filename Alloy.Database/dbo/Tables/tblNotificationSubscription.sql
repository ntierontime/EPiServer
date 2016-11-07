CREATE TABLE [dbo].[tblNotificationSubscription] (
    [pkID]            INT            IDENTITY (1, 1) NOT NULL,
    [UserName]        NVARCHAR (255) NOT NULL,
    [SubscriptionKey] NVARCHAR (255) NOT NULL,
    [Active]          BIT            DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_tblNotificationSubscription] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_tblNotificationSubscription_UserName]
    ON [dbo].[tblNotificationSubscription]([UserName] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblNotificationSubscription_SubscriptionKey]
    ON [dbo].[tblNotificationSubscription]([SubscriptionKey] ASC);

