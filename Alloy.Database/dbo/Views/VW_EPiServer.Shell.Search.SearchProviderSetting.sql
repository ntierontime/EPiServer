create view [dbo].[VW_EPiServer.Shell.Search.SearchProviderSetting] as select
CAST (R01.pkId as varchar(50)) + ':' + UPPER(CAST([Identity].Guid as varchar(50))) as [Id], R01.pkId as [StoreId], [Identity].Guid as [ExternalId], R01.ItemType as [ItemType],
R01.String01 as "FullName",
R01.Boolean01 as "IsEnabled",
R01.Integer01 as "SortIndex"
from [tblBigTable] as R01 
inner join tblBigTableIdentity as [Identity] on R01.pkId=[Identity].pkId 
where R01.StoreName='EPiServer.Shell.Search.SearchProviderSetting' and R01.Row=1