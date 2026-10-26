USE MasaDb;
GO

CREATE OR ALTER PROCEDURE dbo.sp_User_GetByEmail
    @Email nvarchar(256)
AS
BEGIN
    SET NOCOUNT ON;

    SET @Email = LOWER(LTRIM(RTRIM(@Email)));

    SELECT Id, Email, PasswordHash, FullName
    FROM dbo.Users
    WHERE Email = @Email;
END
GO