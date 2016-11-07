create view [dbo].[VW_EPiServer.Packaging.Storage.StorageUpdateEntity] as select
CAST (R01.pkId as varchar(50)) + ':' + UPPER(CAST([Identity].Guid as varchar(50))) as [Id], R01.pkId as [StoreId], [Identity].Guid as [ExternalId], R01.ItemType as [ItemType],
R01.String01 as "ServerId",
R01.DateTime01 as "UpdateDate"
from [tblSystemBigTable] as R01 
inner join tblBigTableIdentity as [Identity] on R01.pkId=[Identity].pkId 
where R01.StoreName='EPiServer.Packaging.Storage.StorageUpdateEntity' and R01.Row=1