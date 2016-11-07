create view [dbo].[VW_VisitorGroup] as select
CAST (R01.pkId as varchar(50)) + ':' + UPPER(CAST([Identity].Guid as varchar(50))) as [Id], R01.pkId as [StoreId], [Identity].Guid as [ExternalId], R01.ItemType as [ItemType],
R01.Integer01 as "CriteriaOperator",
R01.Boolean01 as "EnableStatistics",
R01.Boolean02 as "IsSecurityRole",
R01.String01 as "Name",
R01.String02 as "Notes",
R01.Integer02 as "PointsThreshold"
from [tblSystemBigTable] as R01 
inner join tblBigTableIdentity as [Identity] on R01.pkId=[Identity].pkId 
where R01.StoreName='VisitorGroup' and R01.Row=1