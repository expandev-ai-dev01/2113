import { format } from 'date-fns';
import { ptBR } from 'date-fns/locale';
import { Cloud, CloudRain, CloudSnow, Droplets, Sun, ThermometerSun } from 'lucide-react';
import type { PrevisaoMeteorologica } from '../../types/models';
import { Card, CardContent, CardHeader, CardTitle } from '@/core/components/card';
import { Badge } from '@/core/components/badge';
import { cn } from '@/core/lib/utils';

interface ForecastListProps {
  previsoes: PrevisaoMeteorologica[];
}

const weatherIcons = {
  ensolarado: Sun,
  'parcialmente nublado': Cloud,
  nublado: Cloud,
  chuvoso: CloudRain,
  tempestade: CloudSnow,
};

const getUvClassification = (indice?: number) => {
  if (!indice) return null;
  if (indice <= 2) return { label: 'Baixo', variant: 'default' as const };
  if (indice <= 5) return { label: 'Moderado', variant: 'secondary' as const };
  if (indice <= 7) return { label: 'Alto', variant: 'outline' as const };
  if (indice <= 10) return { label: 'Muito Alto', variant: 'destructive' as const };
  return { label: 'Extremo', variant: 'destructive' as const };
};

function ForecastList({ previsoes }: ForecastListProps) {
  const today = format(new Date(), 'yyyy-MM-dd');

  return (
    <Card>
      <CardHeader>
        <CardTitle>Previsão para os Próximos 7 Dias</CardTitle>
      </CardHeader>
      <CardContent>
        <div className="space-y-3">
          {previsoes?.map((previsao) => {
            const WeatherIcon = weatherIcons[previsao.condicaoPrevista];
            const isToday = previsao.dataPrevisao === today;
            const uvInfo = getUvClassification(previsao.indiceUv);

            return (
              <div
                key={previsao.id}
                className={cn(
                  'flex items-center justify-between rounded-lg border p-4 transition-all hover:shadow-md',
                  isToday ? 'border-primary bg-primary/5' : 'bg-card'
                )}
              >
                <div className="flex items-center gap-4">
                  <WeatherIcon className="text-primary size-10" />
                  <div>
                    <div className="font-semibold">
                      {format(new Date(previsao.dataPrevisao), 'EEEE', { locale: ptBR })}
                      {isToday && (
                        <Badge variant="default" className="ml-2">
                          Hoje
                        </Badge>
                      )}
                    </div>
                    <div className="text-muted-foreground text-sm">
                      {format(new Date(previsao.dataPrevisao), 'dd/MM/yyyy')}
                    </div>
                    <div className="text-muted-foreground mt-1 text-xs capitalize">
                      {previsao.condicaoPrevista}
                    </div>
                  </div>
                </div>

                <div className="flex items-center gap-6">
                  <div className="text-center">
                    <div className="flex items-center gap-1 text-sm">
                      <ThermometerSun className="size-4" />
                      <span className="font-semibold">
                        {previsao.temperaturaMaxima.toFixed(1)}°
                      </span>
                    </div>
                    <div className="text-muted-foreground text-xs">
                      {previsao.temperaturaMinima.toFixed(1)}°
                    </div>
                  </div>

                  <div className="text-center">
                    <div className="flex items-center gap-1 text-sm">
                      <Droplets className="text-primary size-4" />
                      <span className="font-semibold">{previsao.probabilidadeChuva}%</span>
                    </div>
                    <div className="text-muted-foreground text-xs">Chuva</div>
                  </div>

                  {uvInfo && (
                    <div className="text-center">
                      <Badge variant={uvInfo.variant}>{uvInfo.label}</Badge>
                      <div className="text-muted-foreground mt-1 text-xs">
                        UV {previsao.indiceUv}
                      </div>
                    </div>
                  )}
                </div>
              </div>
            );
          })}
        </div>
      </CardContent>
    </Card>
  );
}

export { ForecastList };
