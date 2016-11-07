create view [dbo].[VW_XFormData_92F73BC233734C5FA6F54CBF66321861] as select
CAST (R01.pkId as varchar(50)) + ':' + UPPER(CAST([Identity].Guid as varchar(50))) as [Id], R01.pkId as [StoreId], [Identity].Guid as [ExternalId], R01.ItemType as [ItemType],
R01.String01 as "Email",
R01.ChannelOptions as "Meta_ChannelOptions",
R01.DatePosted as "Meta_DatePosted",
R01.FormId as "Meta_FormId",
R01.PageGuid as "Meta_PageGuid",
R01.UserName as "Meta_UserName",
R01.String02 as "Subscription"
from [tblXFormData] as R01 
inner join tblBigTableIdentity as [Identity] on R01.pkId=[Identity].pkId 
where R01.StoreName='XFormData_92F73BC233734C5FA6F54CBF66321861' and R01.Row=1