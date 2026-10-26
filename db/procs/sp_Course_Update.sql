USE MasaDb;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Course_Update
    @UserId int,
    @Id int,
    @Name nvarchar(80),
    @Code nvarchar(20),
    @Color nvarchar(7)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Courses
    SET Name = @Name,
        Code = @Code,
        Color = @Color
    WHERE Id = @Id
      AND UserId = @UserId;

    SELECT Id, UserId, Name, Code, Color
    FROM dbo.Courses
    WHERE Id = @Id
      AND UserId = @UserId;
END
GO