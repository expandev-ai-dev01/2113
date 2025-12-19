/**
 * @summary
 * Stored procedure to get current weather data for a specific state.
 * Returns the most recent weather data record.
 *
 * @module database/functional
 */

CREATE OR ALTER PROCEDURE functional.spDadosAtuaisGetByEstado
    @estado_id INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 1
        da.id,
        da.estado_id,
        e.nome AS estado_nome,
        e.sigla AS estado_sigla,
        da.temperatura,
        da.umidade,
        da.pressao,
        da.condicao_tempo,
        da.velocidade_vento,
        da.data_hora,
        da.created_at
    FROM functional.DadosAtuais da
    INNER JOIN functional.Estados e ON da.estado_id = e.id
    WHERE da.estado_id = @estado_id
    ORDER BY da.data_hora DESC;
END
GO