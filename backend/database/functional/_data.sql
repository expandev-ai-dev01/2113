/**
 * @summary
 * Seed data for ClimaBrasil weather system.
 * Populates Estados table with all 26 Brazilian states and Federal District.
 *
 * @module database/functional
 */

-- =============================================
-- Seed Data: Brazilian States
-- =============================================
IF NOT EXISTS (SELECT 1 FROM functional.Estados)
BEGIN
    INSERT INTO functional.Estados (nome, sigla, regiao, latitude, longitude)
    VALUES
        -- Norte
        ('Acre', 'AC', 'Norte', -9.0238, -70.8120),
        ('Amapá', 'AP', 'Norte', 0.9020, -52.0030),
        ('Amazonas', 'AM', 'Norte', -3.4168, -65.8561),
        ('Pará', 'PA', 'Norte', -1.9981, -54.9306),
        ('Rondônia', 'RO', 'Norte', -10.8312, -63.3405),
        ('Roraima', 'RR', 'Norte', 2.7376, -62.0751),
        ('Tocantins', 'TO', 'Norte', -10.1753, -48.2982),
        
        -- Nordeste
        ('Alagoas', 'AL', 'Nordeste', -9.5713, -36.7820),
        ('Bahia', 'BA', 'Nordeste', -12.5797, -41.7007),
        ('Ceará', 'CE', 'Nordeste', -5.4984, -39.3206),
        ('Maranhão', 'MA', 'Nordeste', -4.9609, -45.2744),
        ('Paraíba', 'PB', 'Nordeste', -7.2399, -36.7819),
        ('Pernambuco', 'PE', 'Nordeste', -8.8137, -36.9541),
        ('Piauí', 'PI', 'Nordeste', -7.7183, -42.7289),
        ('Rio Grande do Norte', 'RN', 'Nordeste', -5.4026, -36.9541),
        ('Sergipe', 'SE', 'Nordeste', -10.5741, -37.3857),
        
        -- Centro-Oeste
        ('Distrito Federal', 'DF', 'Centro-Oeste', -15.7939, -47.8828),
        ('Goiás', 'GO', 'Centro-Oeste', -15.8270, -49.8362),
        ('Mato Grosso', 'MT', 'Centro-Oeste', -12.6819, -56.9211),
        ('Mato Grosso do Sul', 'MS', 'Centro-Oeste', -20.7722, -54.7852),
        
        -- Sudeste
        ('Espírito Santo', 'ES', 'Sudeste', -19.1834, -40.3089),
        ('Minas Gerais', 'MG', 'Sudeste', -18.5122, -44.5550),
        ('Rio de Janeiro', 'RJ', 'Sudeste', -22.9099, -43.2095),
        ('São Paulo', 'SP', 'Sudeste', -23.5505, -46.6333),
        
        -- Sul
        ('Paraná', 'PR', 'Sul', -25.2521, -52.0215),
        ('Rio Grande do Sul', 'RS', 'Sul', -30.0346, -51.2177),
        ('Santa Catarina', 'SC', 'Sul', -27.2423, -50.2189);

    PRINT 'Estados brasileiros inseridos com sucesso.';
END
ELSE
BEGIN
    PRINT 'Estados já existem no banco de dados.';
END
GO