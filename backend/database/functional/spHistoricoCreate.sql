/**
 * @summary
 * Stored procedure to create historical weather data record.
 * Inserts aggregated daily weather data for a specific state.
 *
 * @module database/functional
 */

CREATE OR ALTER PROCEDURE functional.spHistoricoCreate
    @estado_id INT,
    @data_registro DATE,
    @temperatura_media DECIMAL(5, 2),
    @temperatura_max DECIMAL(5, 2),
    @temperatura_min DECIMAL(5, 2),
    @umidade_media INT,
    @pressao_media DECIMAL(6, 2),
    @precipitacao_total DECIMAL(6, 2) = 0
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate estado exists
    IF NOT EXISTS (SELECT 1 FROM functional.Estados WHERE id = @estado_id)
    BEGIN
        RAISERROR('Estado not found', 16, 1);
        RETURN;
    END

    -- Check if historical record already exists for this date
    IF EXISTS (SELECT 1 FROM functional.Historico WHERE estado_id = @estado_id AND data_registro = @data_registro)
    BEGIN
        -- Update existing record
        UPDATE functional.Historico
        SET temperatura_media = @temperatura_media,
            temperatura_max = @temperatura_max,
            temperatura_min = @temperatura_min,
            umidade_media = @umidade_media,
            pressao_media = @pressao_media,
            precipitacao_total = @precipitacao_total
        WHERE estado_id = @estado_id AND data_registro = @data_registro;

        SELECT 
            id,
            estado_id,
            data_registro,
            temperatura_media,
            temperatura_max,
            temperatura_min,
            umidade_media,
            pressao_media,
            precipitacao_total,
            created_at
        FROM functional.Historico
        WHERE estado_id = @estado_id AND data_registro = @data_registro;
    END
    ELSE
    BEGIN
        -- Insert new record
        INSERT INTO functional.Historico (
            estado_id,
            data_registro,
            temperatura_media,
            temperatura_max,
            temperatura_min,
            umidade_media,
            pressao_media,
            precipitacao_total
        )
        VALUES (
            @estado_id,
            @data_registro,
            @temperatura_media,
            @temperatura_max,
            @temperatura_min,
            @umidade_media,
            @pressao_media,
            @precipitacao_total
        );

        SELECT 
            id,
            estado_id,
            data_registro,
            temperatura_media,
            temperatura_max,
            temperatura_min,
            umidade_media,
            pressao_media,
            precipitacao_total,
            created_at
        FROM functional.Historico
        WHERE id = SCOPE_IDENTITY();
    END
END
GO