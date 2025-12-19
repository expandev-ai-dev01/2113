/**
 * @summary
 * Stored procedure to create weather forecast record.
 * Inserts new forecast data for a specific state and date.
 *
 * @module database/functional
 */

CREATE OR ALTER PROCEDURE functional.spPrevisaoCreate
    @estado_id INT,
    @data_previsao DATE,
    @temp_maxima DECIMAL(5, 2),
    @temp_minima DECIMAL(5, 2),
    @probabilidade_chuva INT,
    @condicao_prevista NVARCHAR(50),
    @indice_uv INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate estado exists
    IF NOT EXISTS (SELECT 1 FROM functional.Estados WHERE id = @estado_id)
    BEGIN
        RAISERROR('Estado not found', 16, 1);
        RETURN;
    END

    -- Check if forecast already exists for this date
    IF EXISTS (SELECT 1 FROM functional.Previsoes WHERE estado_id = @estado_id AND data_previsao = @data_previsao)
    BEGIN
        -- Update existing forecast
        UPDATE functional.Previsoes
        SET temp_maxima = @temp_maxima,
            temp_minima = @temp_minima,
            probabilidade_chuva = @probabilidade_chuva,
            condicao_prevista = @condicao_prevista,
            indice_uv = @indice_uv
        WHERE estado_id = @estado_id AND data_previsao = @data_previsao;

        SELECT 
            id,
            estado_id,
            data_previsao,
            temp_maxima,
            temp_minima,
            probabilidade_chuva,
            condicao_prevista,
            indice_uv,
            created_at
        FROM functional.Previsoes
        WHERE estado_id = @estado_id AND data_previsao = @data_previsao;
    END
    ELSE
    BEGIN
        -- Insert new forecast
        INSERT INTO functional.Previsoes (
            estado_id,
            data_previsao,
            temp_maxima,
            temp_minima,
            probabilidade_chuva,
            condicao_prevista,
            indice_uv
        )
        VALUES (
            @estado_id,
            @data_previsao,
            @temp_maxima,
            @temp_minima,
            @probabilidade_chuva,
            @condicao_prevista,
            @indice_uv
        );

        SELECT 
            id,
            estado_id,
            data_previsao,
            temp_maxima,
            temp_minima,
            probabilidade_chuva,
            condicao_prevista,
            indice_uv,
            created_at
        FROM functional.Previsoes
        WHERE id = SCOPE_IDENTITY();
    END
END
GO