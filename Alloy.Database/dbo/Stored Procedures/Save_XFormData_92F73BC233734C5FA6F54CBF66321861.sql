create procedure [dbo].[Save_XFormData_92F73BC233734C5FA6F54CBF66321861]
@Id bigint output,
@UniqueId uniqueidentifier,
@ItemType nvarchar(2048),
@Email nvarchar(max) = NULL,
@Meta_ChannelOptions int = NULL,
@Meta_DatePosted datetime = NULL,
@Meta_FormId uniqueidentifier = NULL,
@Meta_PageGuid uniqueidentifier = NULL,
@Meta_UserName nvarchar(450) = NULL,
@Subscription nvarchar(max) = NULL
as
begin
declare @pkId bigint
	select @pkId = pkId from tblBigTableIdentity where [Guid] = @UniqueId
	if @pkId IS NULL
	begin
		begin transaction
		insert into [tblBigTableIdentity]([Guid], [StoreName]) values(@UniqueId, 'XFormData_92F73BC233734C5FA6F54CBF66321861')

		select @Id = SCOPE_IDENTITY()
				insert into [tblXFormData] (pkId, StoreName, Row, ItemType,String01,ChannelOptions,DatePosted,FormId,PageGuid,UserName,String02)
		values(@Id, 'XFormData_92F73BC233734C5FA6F54CBF66321861', 1, @ItemType ,@Email,@Meta_ChannelOptions,@Meta_DatePosted,@Meta_FormId,@Meta_PageGuid,@Meta_UserName,@Subscription)

		commit transaction
	end
	else
	begin
		begin transaction
		select @Id = @pkId
		DECLARE @rows int
		select @rows = count(*) from [tblXFormData] where pkId = @Id
		if(@rows < 1) begin
				insert into [tblXFormData] (pkId, StoreName, Row, ItemType,String01,ChannelOptions,DatePosted,FormId,PageGuid,UserName,String02)
		values(@Id, 'XFormData_92F73BC233734C5FA6F54CBF66321861', 1, @ItemType ,@Email,@Meta_ChannelOptions,@Meta_DatePosted,@Meta_FormId,@Meta_PageGuid,@Meta_UserName,@Subscription)

		end
		else begin
				update [tblXFormData] set 
		ItemType = @ItemType,
		String01 = @Email,
		ChannelOptions = @Meta_ChannelOptions,
		DatePosted = @Meta_DatePosted,
		FormId = @Meta_FormId,
		PageGuid = @Meta_PageGuid,
		UserName = @Meta_UserName,
		String02 = @Subscription
                from [tblXFormData]
                where pkId=@pkId
                and Row=1
		end
		commit transaction
	end
end