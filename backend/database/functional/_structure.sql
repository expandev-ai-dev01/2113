/**
 * @summary
 * Database structure for ClimaBrasil weather system.
 * Creates tables for Brazilian states, current weather data, forecasts, and historical records.
 *
 * @module database/functional
 */

-- =============================================
-- Table: Estados (Brazilian States)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Estados')
BEGIN
    CREATE TABLE functional.Estados (
        id INT IDENTITY(1,1) PRIMARY KEY,
        nome NVARCHAR(100) NOT NULL,
        sigla NCHAR(2) NOT NULL UNIQUE,
        regiao NVARCHAR(50) NOT NULL,
        latitude DECIMAL(10, 8) NOT NULL,
        longitude DECIMAL(11, 8) NOT NULL,
        created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
        updated_at DATETIME2 NOT NULL DEFAULT GETDATE(),
        CONSTRAINT CK_Estados_Sigla CHECK (LEN(sigla) = 2),
        CONSTRAINT CK_Estados_Regiao CHECK (regiao IN ('Norte', 'Nordeste', 'Centro-Oeste', 'Sudeste', 'Sul'))
    );

    CREATE INDEX IX_Estados_Sigla ON functional.Estados(sigla);
    CREATE INDEX IX_Estados_Regiao ON functional.Estados(regiao);
END
GO

-- =============================================
-- Table: DadosAtuais (Current Weather Data)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'DadosAtuais')
BEGIN
    CREATE TABLE functional.DadosAtuais (
        id INT IDENTITY(1,1) PRIMARY KEY,
        estado_id INT NOT NULL,
        temperatura DECIMAL(5, 2) NOT NULL,
        umidade INT NOT NULL,
        pressao DECIMAL(6, 2) NOT NULL,
        condicao_tempo NVARCHAR(50) NOT NULL,
        velocidade_vento DECIMAL(5, 2) NULL,
        data_hora DATETIME2 NOT NULL,
        created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_DadosAtuais_Estados FOREIGN KEY (estado_id) REFERENCES functional.Estados(id),
        CONSTRAINT CK_DadosAtuais_Temperatura CHECK (temperatura BETWEEN -10 AND 50),
        CONSTRAINT CK_DadosAtuais_Umidade CHECK (umidade BETWEEN 0 AND 100),
        CONSTRAINT CK_DadosAtuais_Pressao CHECK (pressao BETWEEN 950 AND 1050),
        CONSTRAINT CK_DadosAtuais_Condicao CHECK (condicao_tempo IN ('ensolarado', 'parcialmente nublado', 'nublado', 'chuvoso', 'tempestade')),
        CONSTRAINT CK_DadosAtuais_VelocidadeVento CHECK (velocidade_vento IS NULL OR velocidade_vento >= 0)
    );

    CREATE INDEX IX_DadosAtuais_EstadoData ON functional.DadosAtuais(estado_id, data_hora DESC);
    CREATE INDEX IX_DadosAtuais_DataHora ON functional.DadosAtuais(data_hora DESC);
END
GO

-- =============================================
-- Table: Previsoes (Weather Forecasts)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Previsoes')
BEGIN
    CREATE TABLE functional.Previsoes (
        id INT IDENTITY(1,1) PRIMARY KEY,
        estado_id INT NOT NULL,
        data_previsao DATE NOT NULL,
        temp_maxima DECIMAL(5, 2) NOT NULL,
        temp_minima DECIMAL(5, 2) NOT NULL,
        probabilidade_chuva INT NOT NULL,
        condicao_prevista NVARCHAR(50) NOT NULL,
        indice_uv INT NULL,
        created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_Previsoes_Estados FOREIGN KEY (estado_id) REFERENCES functional.Estados(id),
        CONSTRAINT CK_Previsoes_Temperaturas CHECK (temp_maxima >= temp_minima),
        CONSTRAINT CK_Previsoes_ProbabilidadeChuva CHECK (probabilidade_chuva BETWEEN 0 AND 100),
        CONSTRAINT CK_Previsoes_Condicao CHECK (condicao_prevista IN ('ensolarado', 'parcialmente nublado', 'nublado', 'chuvoso', 'tempestade')),
        CONSTRAINT CK_Previsoes_IndiceUV CHECK (indice_uv IS NULL OR indice_uv BETWEEN 0 AND 11)
    );

    CREATE INDEX IX_Previsoes_EstadoData ON functional.Previsoes(estado_id, data_previsao);
    CREATE INDEX IX_Previsoes_DataPrevisao ON functional.Previsoes(data_previsao);
END
GO

-- =============================================
-- Table: Historico (Historical Weather Data)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Historico')
BEGIN
    CREATE TABLE functional.Historico (
        id INT IDENTITY(1,1) PRIMARY KEY,
        estado_id INT NOT NULL,
        data_registro DATE NOT NULL,
        temperatura_media DECIMAL(5, 2) NOT NULL,
        temperatura_max DECIMAL(5, 2) NOT NULL,
        temperatura_min DECIMAL(5, 2) NOT NULL,
        umidade_media INT NOT NULL,
        pressao_media DECIMAL(6, 2) NOT NULL,
        precipitacao_total DECIMAL(6, 2) NOT NULL DEFAULT 0,
        created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_Historico_Estados FOREIGN KEY (estado_id) REFERENCES functional.Estados(id),
        CONSTRAINT CK_Historico_Temperaturas CHECK (temperatura_max >= temperatura_media AND temperatura_media >= temperatura_min),
        CONSTRAINT CK_Historico_Umidade CHECK (umidade_media BETWEEN 0 AND 100),
        CONSTRAINT CK_Historico_Pressao CHECK (pressao_media BETWEEN 950 AND 1050),
        CONSTRAINT CK_Historico_Precipitacao CHECK (precipitacao_total >= 0)
    );

    CREATE INDEX IX_Historico_EstadoData ON functional.Historico(estado_id, data_registro DESC);
    CREATE INDEX IX_Historico_DataRegistro ON functional.Historico(data_registro DESC);
END
GO

-- =============================================
-- Table: Usuarios (System Users)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Usuarios')
BEGIN
    CREATE TABLE functional.Usuarios (
        id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
        email NVARCHAR(100) NOT NULL UNIQUE,
        password_hash NVARCHAR(255) NOT NULL,
        role NVARCHAR(20) NOT NULL DEFAULT 'user',
        ativo BIT NOT NULL DEFAULT 1,
        created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
        updated_at DATETIME2 NOT NULL DEFAULT GETDATE(),
        last_login DATETIME2 NULL,
        CONSTRAINT CK_Usuarios_Role CHECK (role IN ('admin', 'user', 'readonly')),
        CONSTRAINT CK_Usuarios_Email CHECK (email LIKE '%@%')
    );

    CREATE INDEX IX_Usuarios_Email ON functional.Usuarios(email);
    CREATE INDEX IX_Usuarios_Role ON functional.Usuarios(role);
END
GO

-- =============================================
-- Table: ResetTokens (Password Reset Tokens)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ResetTokens')
BEGIN
    CREATE TABLE functional.ResetTokens (
        id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
        usuario_id UNIQUEIDENTIFIER NOT NULL,
        token_hash NVARCHAR(255) NOT NULL,
        expires_at DATETIME2 NOT NULL,
        used_at DATETIME2 NULL,
        created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_ResetTokens_Usuarios FOREIGN KEY (usuario_id) REFERENCES functional.Usuarios(id) ON DELETE CASCADE
    );

    CREATE INDEX IX_ResetTokens_UsuarioExpires ON functional.ResetTokens(usuario_id, expires_at);
    CREATE INDEX IX_ResetTokens_TokenHash ON functional.ResetTokens(token_hash);
END
GO