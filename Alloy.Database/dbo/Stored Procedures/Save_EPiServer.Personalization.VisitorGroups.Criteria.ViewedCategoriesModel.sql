create procedure [dbo].[Save_EPiServer.Personalization.VisitorGroups.Criteria.ViewedCategoriesModel]
@Id bigint output,
@UniqueId uniqueidentifier,
@ItemType nvarchar(2048),
@CategoryGuid uniqueidentifier = NULL,
@NumberOfPageViews int = NULL,
@SelectedCategory int = NULL
as
begin
declare @pkId bigint
	select @pkId = pkId from tblBigTableIdentity where [Guid] = @UniqueId
	if @pkId IS NULL
	begin
		begin transaction
		insert into [tblBigTableIdentity]([Guid], [StoreName]) values(@UniqueId, 'EPiServer.Personalization.VisitorGroups.Criteria.ViewedCategoriesModel')

		select @Id = SCOPE_IDENTITY()
				insert into [tblBigTable] (pkId, StoreName, Row, ItemType,Guid01,Integer01,Integer02)
		values(@Id, 'EPiServer.Personalization.VisitorGroups.Criteria.ViewedCategoriesModel', 1, @ItemType ,@CategoryGuid,@NumberOfPageViews,@SelectedCategory)

		commit transaction
	end
	else
	begin
		begin transaction
		select @Id = @pkId
		DECLARE @rows int
		select @rows = count(*) from [tblBigTable] where pkId = @Id
		if(@rows < 1) begin
				insert into [tblBigTable] (pkId, StoreName, Row, ItemType,Guid01,Integer01,Integer02)
		values(@Id, 'EPiServer.Personalization.VisitorGroups.Criteria.ViewedCategoriesModel', 1, @ItemType ,@CategoryGuid,@NumberOfPageViews,@SelectedCategory)

		end
		else begin
				update [tblBigTable] set 
		ItemType = @ItemType,
		Guid01 = @CategoryGuid,
		Integer01 = @NumberOfPageViews,
		Integer02 = @SelectedCategory
                from [tblBigTable]
                where pkId=@pkId
                and Row=1
		end
		commit transaction
	end
end