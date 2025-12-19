/**
 * @service weatherService
 * @domain weather
 * @type REST
 */

import { authenticatedClient } from '@/core/lib/api';
import type {
  Estado,
  DadosClimaticosAtuais,
  PrevisaoMeteorologica,
  DadosHistoricos,
} from '../types/models';

export const weatherService = {
  /**
   * Lista todos os estados brasileiros
   */
  async listEstados(): Promise<Estado[]> {
    const { data } = await authenticatedClient.get<{ data: Estado[] }>('/estados');
    return data.data;
  },

  /**
   * Obtém dados climáticos atuais de um estado
   */
  async getDadosAtuais(estadoId: number): Promise<DadosClimaticosAtuais> {
    const { data } = await authenticatedClient.get<{ data: DadosClimaticosAtuais }>(
      `/weather/current/${estadoId}`
    );
    return data.data;
  },

  /**
   * Obtém previsões meteorológicas de um estado (próximos 7 dias)
   */
  async getPrevisoes(estadoId: number): Promise<PrevisaoMeteorologica[]> {
    const { data } = await authenticatedClient.get<{ data: PrevisaoMeteorologica[] }>(
      `/weather/forecast/${estadoId}`
    );
    return data.data;
  },

  /**
   * Obtém dados históricos de um estado
   */
  async getHistorico(
    estadoId: number,
    dataInicio: string,
    dataFim: string
  ): Promise<DadosHistoricos[]> {
    const { data } = await authenticatedClient.get<{ data: DadosHistoricos[] }>(
      `/weather/history/${estadoId}`,
      {
        params: { dataInicio, dataFim },
      }
    );
    return data.data;
  },
};
