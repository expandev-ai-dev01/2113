/**
 * @summary
 * Stored procedure to create current weather data record.
 * Inserts new weather data for a specific state.
 *
 * @module database/functional
 */

CREATE OR ALTER PROCEDURE functional.spDadosAtuaisCreate
    @estado_id INT,
    @temperatura DECIMAL(5, 2),
    @umidade INT,
    @pressao DECIMAL(6, 2),
    @condicao_tempo NVARCHAR(50),
    @velocidade_vento DECIMAL(5, 2) = NULL,
    @data_hora DATETIME2
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate estado exists
    IF NOT EXISTS (SELECT 1 FROM functional.Estados WHERE id = @estado_id)
    BEGIN
        RAISERROR('Estado not found', 16, 1);
        RETURN;
    END

    INSERT INTO functional.DadosAtuais (
        estado_id,
        temperatura,
        umidade,
        pressao,
        condicao_tempo,
        velocidade_vento,
        data_hora
    )
    VALUES (
        @estado_id,
        @temperatura,
        @umidade,
        @pressao,
        @condicao_tempo,
        @velocidade_vento,
        @data_hora
    );

    SELECT 
        id,
        estado_id,
        temperatura,
        umidade,
        pressao,
        condicao_tempo,
        velocidade_vento,
        data_hora,
        created_at
    FROM functional.DadosAtuais
    WHERE id = SCOPE_IDENTITY();
END
GO