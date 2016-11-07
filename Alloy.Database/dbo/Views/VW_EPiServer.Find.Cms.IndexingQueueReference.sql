create view [dbo].[VW_EPiServer.Find.Cms.IndexingQueueReference] as select
CAST (R01.pkId as varchar(50)) + ':' + UPPER(CAST([Identity].Guid as varchar(50))) as [Id], R01.pkId as [StoreId], [Identity].Guid as [ExternalId], R01.ItemType as [ItemType],
R01.Integer01 as "Action",
R01.Boolean01 as "Cascade",
R01.Boolean02 as "EnableLanguageFilter",
R01.String01 as "Item",
R01.String02 as "Language",
R01.DateTime01 as "TimeStamp"
from [tblBigTable] as R01 
inner join tblBigTableIdentity as [Identity] on R01.pkId=[Identity].pkId 
where R01.StoreName='EPiServer.Find.Cms.IndexingQueueReference' and R01.Row=1