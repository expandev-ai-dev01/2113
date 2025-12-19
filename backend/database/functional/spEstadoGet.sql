/**
 * @summary
 * Stored procedure to get a specific state by ID or sigla.
 * Returns detailed information about a single state.
 *
 * @module database/functional
 */

CREATE OR ALTER PROCEDURE functional.spEstadoGet
    @id INT = NULL,
    @sigla NCHAR(2) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @id IS NULL AND @sigla IS NULL
    BEGIN
        RAISERROR('Either @id or @sigla must be provided', 16, 1);
        RETURN;
    END

    SELECT 
        id,
        nome,
        sigla,
        regiao,
        latitude,
        longitude,
        created_at,
        updated_at
    FROM functional.Estados
    WHERE (@id IS NOT NULL AND id = @id)
       OR (@sigla IS NOT NULL AND sigla = @sigla);
END
GO