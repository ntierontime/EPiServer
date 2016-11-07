create procedure [dbo].[Save_XForms]
@Id bigint output,
@UniqueId uniqueidentifier,
@ItemType nvarchar(2048),
@AllowAnonymousPost bit = NULL,
@AllowMultiplePost bit = NULL,
@Changed datetime = NULL,
@ChangedBy nvarchar(max) = NULL,
@Created datetime = NULL,
@CreatedBy nvarchar(max) = NULL,
@CustomUrl nvarchar(max) = NULL,
@DocumentData nvarchar(max) = NULL,
@FolderId uniqueidentifier = NULL,
@FormName nvarchar(max) = NULL,
@MailFrom nvarchar(max) = NULL,
@MailSubject nvarchar(max) = NULL,
@MailTo nvarchar(max) = NULL,
@PageAfterPost int = NULL,
@PageGuidAfterPost uniqueidentifier = NULL
as
begin
declare @pkId bigint
	select @pkId = pkId from tblBigTableIdentity where [Guid] = @UniqueId
	if @pkId IS NULL
	begin
		begin transaction
		insert into [tblBigTableIdentity]([Guid], [StoreName]) values(@UniqueId, 'XForms')

		select @Id = SCOPE_IDENTITY()
				insert into [tblSystemBigTable] (pkId, StoreName, Row, ItemType,Boolean01,Boolean02,DateTime01,String01,DateTime02,String02,String03,String04,Guid01,String05,String06,String07,String08,Integer01,Guid02)
		values(@Id, 'XForms', 1, @ItemType ,@AllowAnonymousPost,@AllowMultiplePost,@Changed,@ChangedBy,@Created,@CreatedBy,@CustomUrl,@DocumentData,@FolderId,@FormName,@MailFrom,@MailSubject,@MailTo,@PageAfterPost,@PageGuidAfterPost)

		commit transaction
	end
	else
	begin
		begin transaction
		select @Id = @pkId
		DECLARE @rows int
		select @rows = count(*) from [tblSystemBigTable] where pkId = @Id
		if(@rows < 1) begin
				insert into [tblSystemBigTable] (pkId, StoreName, Row, ItemType,Boolean01,Boolean02,DateTime01,String01,DateTime02,String02,String03,String04,Guid01,String05,String06,String07,String08,Integer01,Guid02)
		values(@Id, 'XForms', 1, @ItemType ,@AllowAnonymousPost,@AllowMultiplePost,@Changed,@ChangedBy,@Created,@CreatedBy,@CustomUrl,@DocumentData,@FolderId,@FormName,@MailFrom,@MailSubject,@MailTo,@PageAfterPost,@PageGuidAfterPost)

		end
		else begin
				update [tblSystemBigTable] set 
		ItemType = @ItemType,
		Boolean01 = @AllowAnonymousPost,
		Boolean02 = @AllowMultiplePost,
		DateTime01 = @Changed,
		String01 = @ChangedBy,
		DateTime02 = @Created,
		String02 = @CreatedBy,
		String03 = @CustomUrl,
		String04 = @DocumentData,
		Guid01 = @FolderId,
		String05 = @FormName,
		String06 = @MailFrom,
		String07 = @MailSubject,
		String08 = @MailTo,
		Integer01 = @PageAfterPost,
		Guid02 = @PageGuidAfterPost
                from [tblSystemBigTable]
                where pkId=@pkId
                and Row=1
		end
		commit transaction
	end
end