create view [dbo].[VW_EPiServer.Shell.Storage.PersonalizedViewSettingsStorage] as select
CAST (R01.pkId as varchar(50)) + ':' + UPPER(CAST([Identity].Guid as varchar(50))) as [Id], R01.pkId as [StoreId], [Identity].Guid as [ExternalId], R01.ItemType as [ItemType],
R01.Indexed_String01 as "UserName",
R01.Indexed_String02 as "ViewName"
from [tblSystemBigTable] as R01 
inner join tblBigTableIdentity as [Identity] on R01.pkId=[Identity].pkId 
where R01.StoreName='EPiServer.Shell.Storage.PersonalizedViewSettingsStorage' and R01.Row=1