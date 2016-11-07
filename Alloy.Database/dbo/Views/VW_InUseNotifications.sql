create view [dbo].[VW_InUseNotifications] as select
CAST (R01.pkId as varchar(50)) + ':' + UPPER(CAST([Identity].Guid as varchar(50))) as [Id], R01.pkId as [StoreId], [Identity].Guid as [ExternalId], R01.ItemType as [ItemType],
R01.Boolean01 as "AddedManually",
R01.Indexed_Guid01 as "ContentGuid",
R01.DateTime01 as "CreateTime",
R01.Indexed_String01 as "LanguageBranch",
R01.DateTime02 as "Modified",
R01.Indexed_String02 as "User"
from [tblBigTable] as R01 
inner join tblBigTableIdentity as [Identity] on R01.pkId=[Identity].pkId 
where R01.StoreName='InUseNotifications' and R01.Row=1