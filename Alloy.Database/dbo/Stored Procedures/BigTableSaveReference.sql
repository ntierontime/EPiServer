CREATE PROCEDURE [dbo].[BigTableSaveReference]
	@Id bigint,
	@Type int,
	@PropertyName nvarchar(75),
	@CollectionType nvarchar(2000) = NULL,
	@ElementType nvarchar(2000) = NULL,
	@ElementStoreName nvarchar(375) = null,
	@IsKey bit,
	@Index int,
	@BooleanValue bit = NULL,
	@IntegerValue int = NULL,
	@LongValue bigint = NULL,
	@DateTimeValue datetime = NULL,
	@GuidValue uniqueidentifier = NULL,
	@FloatValue float = NULL,	
	@StringValue nvarchar(max) = NULL,
	@BinaryValue varbinary(max) = NULL,
	@RefIdValue bigint = NULL,
	@ExternalIdValue bigint = NULL,
	@DecimalValue decimal(18, 3) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if not exists(select * from tblBigTableReference where pkId = @Id and PropertyName = @PropertyName and IsKey = @IsKey and [Index] = @Index)
	begin
		-- insert
		insert into tblBigTableReference
		values
		(
			@Id,
			@Type,
			@PropertyName,
			@CollectionType,
			@ElementType,
			@ElementStoreName,
			@IsKey,
			@Index,
			@BooleanValue,
			@IntegerValue,
			@LongValue,
			@DateTimeValue,
			@GuidValue,
			@FloatValue,
			@StringValue,
			@BinaryValue,
			@RefIdValue,
			@ExternalIdValue,
			@DecimalValue
		)
	end
	else
	begin
		-- update
		update tblBigTableReference
		set
		CollectionType = @CollectionType,
		ElementType = @ElementType,
		ElementStoreName  = @ElementStoreName,
		BooleanValue = @BooleanValue,
		IntegerValue = @IntegerValue,
		LongValue = @LongValue,
		DateTimeValue = @DateTimeValue,
		GuidValue = @GuidValue,
		FloatValue = @FloatValue,
		StringValue = @StringValue,
		BinaryValue = @BinaryValue,
		RefIdValue = @RefIdValue,
		ExternalIdValue = @ExternalIdValue,
		DecimalValue = @DecimalValue
		where
		pkId = @Id and PropertyName = @PropertyName and IsKey = @IsKey and [Index] = @Index
	end   
END
