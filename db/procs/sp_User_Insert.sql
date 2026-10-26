USE MasaDb;
GO

CREATE OR ALTER PROCEDURE dbo.sp_User_Insert
    @Email nvarchar(256),
    @PasswordHash nvarchar(500),
    @FullName nvarchar(120)
AS
BEGIN
    SET NOCOUNT ON;

    SET @Email = LOWER(LTRIM(RTRIM(@Email)));

    IF EXISTS (SELECT 1 FROM dbo.Users WHERE Email = @Email)
    BEGIN
        RAISERROR('EMAIL_TAKEN', 16, 1);
        RETURN;
    END

    INSERT INTO dbo.Users (Email, PasswordHash, FullName)
    VALUES (@Email, @PasswordHash, @FullName);

    SELECT Id, Email, FullName, CreatedAt
    FROM dbo.Users
    WHERE Id = CONVERT(int, SCOPE_IDENTITY());
END
GO