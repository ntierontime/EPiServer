CREATE TABLE [dbo].[tblScheduledItem] (
    [pkID]                 UNIQUEIDENTIFIER CONSTRAINT [DF__tblSchedul__pkID__1A34DF26] DEFAULT (newid()) NOT NULL,
    [Name]                 NVARCHAR (50)    NULL,
    [Enabled]              BIT              CONSTRAINT [DF_tblScheduledItem_Enabled] DEFAULT ((0)) NOT NULL,
    [LastExec]             DATETIME         NULL,
    [LastStatus]           INT              NULL,
    [LastText]             NVARCHAR (2048)  NULL,
    [NextExec]             DATETIME         NULL,
    [DatePart]             NCHAR (2)        NULL,
    [Interval]             INT              NULL,
    [MethodName]           NVARCHAR (100)   NOT NULL,
    [fStatic]              BIT              NOT NULL,
    [TypeName]             NVARCHAR (1024)  NOT NULL,
    [AssemblyName]         NVARCHAR (100)   NOT NULL,
    [InstanceData]         IMAGE            NULL,
    [IsRunning]            BIT              CONSTRAINT [DF__tblScheduledItem__IsRunnning] DEFAULT ((0)) NOT NULL,
    [CurrentStatusMessage] NVARCHAR (2048)  NULL,
    [LastPing]             DATETIME         NULL,
    CONSTRAINT [PK__tblScheduledItem__1940BAED] PRIMARY KEY CLUSTERED ([pkID] ASC),
    CONSTRAINT [CK_tblScheduledItem] CHECK ([DatePart]='yy' OR ([DatePart]='mm' OR ([DatePart]='wk' OR ([DatePart]='dd' OR ([DatePart]='hh' OR ([DatePart]='mi' OR ([DatePart]='ss' OR [DatePart]='ms')))))))
);

