create view [dbo].[VW_EPiServer.Core.PropertySettings.PropertySettingsWrapper] as select
CAST (R01.pkId as varchar(50)) + ':' + UPPER(CAST([Identity].Guid as varchar(50))) as [Id], R01.pkId as [StoreId], [Identity].Guid as [ExternalId], R01.ItemType as [ItemType],
R01.String01 as "Description",
R01.String02 as "DisplayName",
R01.Boolean01 as "IsDefault",
R01.Boolean02 as "IsGlobal",
R01.String03 as "TypeFullName"
from [tblSystemBigTable] as R01 
inner join tblBigTableIdentity as [Identity] on R01.pkId=[Identity].pkId 
where R01.StoreName='EPiServer.Core.PropertySettings.PropertySettingsWrapper' and R01.Row=1