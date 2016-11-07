create view [dbo].[VW_VisitorGroupCriterion] as select
CAST (R01.pkId as varchar(50)) + ':' + UPPER(CAST([Identity].Guid as varchar(50))) as [Id], R01.pkId as [StoreId], [Identity].Guid as [ExternalId], R01.ItemType as [ItemType],
R01.Boolean01 as "Enabled",
R01.String01 as "NamingContainer",
R01.String02 as "Notes",
R01.Integer01 as "Points",
R01.Boolean02 as "Required",
R01.String03 as "TypeName"
from [tblSystemBigTable] as R01 
inner join tblBigTableIdentity as [Identity] on R01.pkId=[Identity].pkId 
where R01.StoreName='VisitorGroupCriterion' and R01.Row=1