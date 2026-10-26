USE MasaDb;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Course_Delete
    @UserId int,
    @Id int
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Affected int;

    DELETE FROM dbo.Courses
    WHERE Id = @Id
      AND UserId = @UserId;

    SET @Affected = @@ROWCOUNT;

    SELECT @Affected AS Affected;
END
GO