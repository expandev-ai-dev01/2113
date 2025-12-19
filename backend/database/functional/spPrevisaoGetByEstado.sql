/**
 * @summary
 * Stored procedure to get weather forecasts for a specific state.
 * Returns forecasts for the next 7 days.
 *
 * @module database/functional
 */

CREATE OR ALTER PROCEDURE functional.spPrevisaoGetByEstado
    @estado_id INT,
    @dias INT = 7
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (@dias)
        p.id,
        p.estado_id,
        e.nome AS estado_nome,
        e.sigla AS estado_sigla,
        p.data_previsao,
        p.temp_maxima,
        p.temp_minima,
        p.probabilidade_chuva,
        p.condicao_prevista,
        p.indice_uv,
        p.created_at
    FROM functional.Previsoes p
    INNER JOIN functional.Estados e ON p.estado_id = e.id
    WHERE p.estado_id = @estado_id
      AND p.data_previsao >= CAST(GETDATE() AS DATE)
    ORDER BY p.data_previsao;
END
GO