/**
 * @summary
 * Stored procedure to get historical weather data for a specific state.
 * Returns paginated historical records within a date range.
 *
 * @module database/functional
 */

CREATE OR ALTER PROCEDURE functional.spHistoricoGetByEstado
    @estado_id INT,
    @data_inicio DATE,
    @data_fim DATE,
    @page INT = 1,
    @pageSize INT = 100
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate date range (max 90 days per page)
    IF DATEDIFF(DAY, @data_inicio, @data_fim) > 90
    BEGIN
        RAISERROR('Date range cannot exceed 90 days', 16, 1);
        RETURN;
    END

    DECLARE @offset INT = (@page - 1) * @pageSize;

    -- Get total count
    DECLARE @total INT;
    SELECT @total = COUNT(*)
    FROM functional.Historico
    WHERE estado_id = @estado_id
      AND data_registro BETWEEN @data_inicio AND @data_fim;

    -- Get paginated data
    SELECT 
        h.id,
        h.estado_id,
        e.nome AS estado_nome,
        e.sigla AS estado_sigla,
        h.data_registro,
        h.temperatura_media,
        h.temperatura_max,
        h.temperatura_min,
        h.umidade_media,
        h.pressao_media,
        h.precipitacao_total,
        h.created_at,
        @total AS total_records,
        @page AS current_page,
        @pageSize AS page_size
    FROM functional.Historico h
    INNER JOIN functional.Estados e ON h.estado_id = e.id
    WHERE h.estado_id = @estado_id
      AND h.data_registro BETWEEN @data_inicio AND @data_fim
    ORDER BY h.data_registro DESC
    OFFSET @offset ROWS
    FETCH NEXT @pageSize ROWS ONLY;
END
GO