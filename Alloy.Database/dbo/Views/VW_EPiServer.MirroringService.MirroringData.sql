create view [dbo].[VW_EPiServer.MirroringService.MirroringData] as select
CAST (R01.pkId as varchar(50)) + ':' + UPPER(CAST([Identity].Guid as varchar(50))) as [Id], R01.pkId as [StoreId], [Identity].Guid as [ExternalId], R01.ItemType as [ItemType],
R01.String01 as "AdminMailaddress",
R01.Integer01 as "ContentTypeChangingState",
R01.Boolean01 as "ContinueOnError",
R01.String02 as "DestinationRoot",
R01.String03 as "DestinationUri",
R01.Boolean02 as "Enabled",
R01.Guid01 as "FromPageGuid",
R01.String04 as "ImpersonateUserName",
R01.Boolean03 as "IncludeRoot",
R01.Boolean04 as "InitialMirroringDone",
R01.Long01 as "LastChangeLoqSequenceRead",
R01.DateTime01 as "LastExecutionUTC",
R01.DateTime02 as "LastMailMessageUTC",
R01.Integer02 as "LastState",
R01.String05 as "LastStatus",
R01.String06 as "Name",
R01.String07 as "Params",
R01.Boolean05 as "SendMailMessage",
R01.Integer03 as "TransferAction",
R02.Boolean01 as "UseDefaultMirroringAddress",
R01.Integer04 as "ValidationContext",
R01.Integer05 as "VisitorGroupChangingState"
from [tblSystemBigTable] as R01 
inner join tblBigTableIdentity as [Identity] on R01.pkId=[Identity].pkId 
left outer join tblSystemBigTable as R02 on R01.pkId = R02.pkId and R02.Row=2
where R01.StoreName='EPiServer.MirroringService.MirroringData' and R01.Row=1