import { useQuery } from '@tanstack/react-query';
import { weatherService } from '../../services/weatherService';

export const useEstados = () => {
  return useQuery({
    queryKey: ['estados'],
    queryFn: () => weatherService.listEstados(),
    staleTime: 1000 * 60 * 60, // 1 hour
  });
};
