create procedure [dbo].[Save_VisitorGroupCriterion]
@Id bigint output,
@UniqueId uniqueidentifier,
@ItemType nvarchar(2048),
@Enabled bit = NULL,
@NamingContainer nvarchar(max) = NULL,
@Notes nvarchar(max) = NULL,
@Points int = NULL,
@Required bit = NULL,
@TypeName nvarchar(max) = NULL
as
begin
declare @pkId bigint
	select @pkId = pkId from tblBigTableIdentity where [Guid] = @UniqueId
	if @pkId IS NULL
	begin
		begin transaction
		insert into [tblBigTableIdentity]([Guid], [StoreName]) values(@UniqueId, 'VisitorGroupCriterion')

		select @Id = SCOPE_IDENTITY()
				insert into [tblSystemBigTable] (pkId, StoreName, Row, ItemType,Boolean01,String01,String02,Integer01,Boolean02,String03)
		values(@Id, 'VisitorGroupCriterion', 1, @ItemType ,@Enabled,@NamingContainer,@Notes,@Points,@Required,@TypeName)

		commit transaction
	end
	else
	begin
		begin transaction
		select @Id = @pkId
		DECLARE @rows int
		select @rows = count(*) from [tblSystemBigTable] where pkId = @Id
		if(@rows < 1) begin
				insert into [tblSystemBigTable] (pkId, StoreName, Row, ItemType,Boolean01,String01,String02,Integer01,Boolean02,String03)
		values(@Id, 'VisitorGroupCriterion', 1, @ItemType ,@Enabled,@NamingContainer,@Notes,@Points,@Required,@TypeName)

		end
		else begin
				update [tblSystemBigTable] set 
		ItemType = @ItemType,
		Boolean01 = @Enabled,
		String01 = @NamingContainer,
		String02 = @Notes,
		Integer01 = @Points,
		Boolean02 = @Required,
		String03 = @TypeName
                from [tblSystemBigTable]
                where pkId=@pkId
                and Row=1
		end
		commit transaction
	end
end