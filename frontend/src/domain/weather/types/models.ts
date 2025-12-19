export interface Estado {
  id: number;
  nome: string;
  sigla: string;
  regiao: string;
  latitude: number;
  longitude: number;
}

export interface DadosClimaticosAtuais {
  id: number;
  estadoId: number;
  temperatura: number;
  umidade: number;
  pressao: number;
  condicaoTempo: 'ensolarado' | 'parcialmente nublado' | 'nublado' | 'chuvoso' | 'tempestade';
  velocidadeVento?: number;
  dataHora: string;
}

export interface PrevisaoMeteorologica {
  id: number;
  estadoId: number;
  dataPrevisao: string;
  temperaturaMaxima: number;
  temperaturaMinima: number;
  probabilidadeChuva: number;
  condicaoPrevista: 'ensolarado' | 'parcialmente nublado' | 'nublado' | 'chuvoso' | 'tempestade';
  indiceUv?: number;
}

export interface DadosHistoricos {
  id: number;
  estadoId: number;
  dataRegistro: string;
  temperaturaMedia: number;
  temperaturaMax: number;
  temperaturaMin: number;
  umidadeMedia: number;
  pressaoMedia: number;
  precipitacaoTotal: number;
}

export interface WeatherData {
  estado: Estado;
  dadosAtuais?: DadosClimaticosAtuais;
  previsoes: PrevisaoMeteorologica[];
}
