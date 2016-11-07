create view [dbo].[VW_XForms] as select
CAST (R01.pkId as varchar(50)) + ':' + UPPER(CAST([Identity].Guid as varchar(50))) as [Id], R01.pkId as [StoreId], [Identity].Guid as [ExternalId], R01.ItemType as [ItemType],
R01.Boolean01 as "AllowAnonymousPost",
R01.Boolean02 as "AllowMultiplePost",
R01.DateTime01 as "Changed",
R01.String01 as "ChangedBy",
R01.DateTime02 as "Created",
R01.String02 as "CreatedBy",
R01.String03 as "CustomUrl",
R01.String04 as "DocumentData",
R01.Guid01 as "FolderId",
R01.String05 as "FormName",
R01.String06 as "MailFrom",
R01.String07 as "MailSubject",
R01.String08 as "MailTo",
R01.Integer01 as "PageAfterPost",
R01.Guid02 as "PageGuidAfterPost"
from [tblSystemBigTable] as R01 
inner join tblBigTableIdentity as [Identity] on R01.pkId=[Identity].pkId 
where R01.StoreName='XForms' and R01.Row=1