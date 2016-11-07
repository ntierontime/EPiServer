create procedure [dbo].[Save_XFormData_3D2E938BE9A04411A82FA05AEFB2B5CC]
@Id bigint output,
@UniqueId uniqueidentifier,
@ItemType nvarchar(2048),
@AreaofInterest nvarchar(max) = NULL,
@Email nvarchar(max) = NULL,
@Message nvarchar(max) = NULL,
@Meta_ChannelOptions int = NULL,
@Meta_DatePosted datetime = NULL,
@Meta_FormId uniqueidentifier = NULL,
@Meta_PageGuid uniqueidentifier = NULL,
@Meta_UserName nvarchar(450) = NULL,
@Name nvarchar(max) = NULL
as
begin
declare @pkId bigint
	select @pkId = pkId from tblBigTableIdentity where [Guid] = @UniqueId
	if @pkId IS NULL
	begin
		begin transaction
		insert into [tblBigTableIdentity]([Guid], [StoreName]) values(@UniqueId, 'XFormData_3D2E938BE9A04411A82FA05AEFB2B5CC')

		select @Id = SCOPE_IDENTITY()
				insert into [tblXFormData] (pkId, StoreName, Row, ItemType,String01,String02,String03,ChannelOptions,DatePosted,FormId,PageGuid,UserName,String04)
		values(@Id, 'XFormData_3D2E938BE9A04411A82FA05AEFB2B5CC', 1, @ItemType ,@AreaofInterest,@Email,@Message,@Meta_ChannelOptions,@Meta_DatePosted,@Meta_FormId,@Meta_PageGuid,@Meta_UserName,@Name)

		commit transaction
	end
	else
	begin
		begin transaction
		select @Id = @pkId
		DECLARE @rows int
		select @rows = count(*) from [tblXFormData] where pkId = @Id
		if(@rows < 1) begin
				insert into [tblXFormData] (pkId, StoreName, Row, ItemType,String01,String02,String03,ChannelOptions,DatePosted,FormId,PageGuid,UserName,String04)
		values(@Id, 'XFormData_3D2E938BE9A04411A82FA05AEFB2B5CC', 1, @ItemType ,@AreaofInterest,@Email,@Message,@Meta_ChannelOptions,@Meta_DatePosted,@Meta_FormId,@Meta_PageGuid,@Meta_UserName,@Name)

		end
		else begin
				update [tblXFormData] set 
		ItemType = @ItemType,
		String01 = @AreaofInterest,
		String02 = @Email,
		String03 = @Message,
		ChannelOptions = @Meta_ChannelOptions,
		DatePosted = @Meta_DatePosted,
		FormId = @Meta_FormId,
		PageGuid = @Meta_PageGuid,
		UserName = @Meta_UserName,
		String04 = @Name
                from [tblXFormData]
                where pkId=@pkId
                and Row=1
		end
		commit transaction
	end
end