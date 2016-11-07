create procedure [dbo].[Save_VisitorGroup]
@Id bigint output,
@UniqueId uniqueidentifier,
@ItemType nvarchar(2048),
@CriteriaOperator int = NULL,
@EnableStatistics bit = NULL,
@IsSecurityRole bit = NULL,
@Name nvarchar(max) = NULL,
@Notes nvarchar(max) = NULL,
@PointsThreshold int = NULL
as
begin
declare @pkId bigint
	select @pkId = pkId from tblBigTableIdentity where [Guid] = @UniqueId
	if @pkId IS NULL
	begin
		begin transaction
		insert into [tblBigTableIdentity]([Guid], [StoreName]) values(@UniqueId, 'VisitorGroup')

		select @Id = SCOPE_IDENTITY()
				insert into [tblSystemBigTable] (pkId, StoreName, Row, ItemType,Integer01,Boolean01,Boolean02,String01,String02,Integer02)
		values(@Id, 'VisitorGroup', 1, @ItemType ,@CriteriaOperator,@EnableStatistics,@IsSecurityRole,@Name,@Notes,@PointsThreshold)

		commit transaction
	end
	else
	begin
		begin transaction
		select @Id = @pkId
		DECLARE @rows int
		select @rows = count(*) from [tblSystemBigTable] where pkId = @Id
		if(@rows < 1) begin
				insert into [tblSystemBigTable] (pkId, StoreName, Row, ItemType,Integer01,Boolean01,Boolean02,String01,String02,Integer02)
		values(@Id, 'VisitorGroup', 1, @ItemType ,@CriteriaOperator,@EnableStatistics,@IsSecurityRole,@Name,@Notes,@PointsThreshold)

		end
		else begin
				update [tblSystemBigTable] set 
		ItemType = @ItemType,
		Integer01 = @CriteriaOperator,
		Boolean01 = @EnableStatistics,
		Boolean02 = @IsSecurityRole,
		String01 = @Name,
		String02 = @Notes,
		Integer02 = @PointsThreshold
                from [tblSystemBigTable]
                where pkId=@pkId
                and Row=1
		end
		commit transaction
	end
end