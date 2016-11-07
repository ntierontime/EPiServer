create view [dbo].[VW_EPiParentRestoreStore] as select
CAST (R01.pkId as varchar(50)) + ':' + UPPER(CAST([Identity].Guid as varchar(50))) as [Id], R01.pkId as [StoreId], [Identity].Guid as [ExternalId], R01.ItemType as [ItemType],
R01.String01 as "ParentLink",
R01.String02 as "SourceLink"
from [tblSystemBigTable] as R01 
inner join tblBigTableIdentity as [Identity] on R01.pkId=[Identity].pkId 
where R01.StoreName='EPiParentRestoreStore' and R01.Row=1