create view [dbo].[VW_EPiServer.Personalization.VisitorGroups.Criteria.ViewedCategoriesModel] as select
CAST (R01.pkId as varchar(50)) + ':' + UPPER(CAST([Identity].Guid as varchar(50))) as [Id], R01.pkId as [StoreId], [Identity].Guid as [ExternalId], R01.ItemType as [ItemType],
R01.Guid01 as "CategoryGuid",
R01.Integer01 as "NumberOfPageViews",
R01.Integer02 as "SelectedCategory"
from [tblBigTable] as R01 
inner join tblBigTableIdentity as [Identity] on R01.pkId=[Identity].pkId 
where R01.StoreName='EPiServer.Personalization.VisitorGroups.Criteria.ViewedCategoriesModel' and R01.Row=1