USE MasaDb;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Course_Insert
    @UserId int,
    @Name nvarchar(80),
    @Code nvarchar(20),
    @Color nvarchar(7)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE Id = @UserId)
    BEGIN
        RAISERROR('NOT_FOUND', 16, 1);
        RETURN;
    END

    INSERT INTO dbo.Courses (UserId, Name, Code, Color)
    VALUES (@UserId, @Name, @Code, @Color);

    SELECT Id, UserId, Name, Code, Color
    FROM dbo.Courses
    WHERE Id = CONVERT(int, SCOPE_IDENTITY());
END
GO