/**
 * @summary
 * Stored procedure to list all Brazilian states.
 * Returns basic information about all states in the system.
 *
 * @module database/functional
 */

CREATE OR ALTER PROCEDURE functional.spEstadosList
AS
BEGIN
    SET NOCOUNT ON;

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
    ORDER BY nome;
END
GO