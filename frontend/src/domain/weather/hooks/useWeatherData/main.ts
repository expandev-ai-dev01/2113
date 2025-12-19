import { useQuery } from '@tanstack/react-query';
import { weatherService } from '../../services/weatherService';
import type { WeatherData } from '../../types/models';

export const useWeatherData = (estadoId: number | null) => {
  return useQuery({
    queryKey: ['weather', estadoId],
    queryFn: async (): Promise<WeatherData | null> => {
      if (!estadoId) return null;

      const [estados, dadosAtuais, previsoes] = await Promise.all([
        weatherService.listEstados(),
        weatherService.getDadosAtuais(estadoId).catch(() => undefined),
        weatherService.getPrevisoes(estadoId),
      ]);

      const estado = estados.find((e) => e.id === estadoId);
      if (!estado) return null;

      return {
        estado,
        dadosAtuais,
        previsoes,
      };
    },
    enabled: !!estadoId,
    staleTime: 1000 * 60 * 30, // 30 minutes
  });
};
