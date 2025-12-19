import { format } from 'date-fns';
import { ptBR } from 'date-fns/locale';
import { Cloud, CloudRain, CloudSnow, Sun, Wind } from 'lucide-react';
import type { DadosClimaticosAtuais } from '../../types/models';
import { Card, CardContent, CardHeader, CardTitle } from '@/core/components/card';
import { Separator } from '@/core/components/separator';

interface CurrentWeatherProps {
  dados: DadosClimaticosAtuais;
  estadoNome: string;
}

const weatherIcons = {
  ensolarado: Sun,
  'parcialmente nublado': Cloud,
  nublado: Cloud,
  chuvoso: CloudRain,
  tempestade: CloudSnow,
};

function CurrentWeather({ dados, estadoNome }: CurrentWeatherProps) {
  const WeatherIcon = weatherIcons[dados.condicaoTempo];
  const lastUpdate = format(new Date(dados.dataHora), "dd/MM/yyyy 'às' HH:mm", {
    locale: ptBR,
  });

  return (
    <Card>
      <CardHeader>
        <CardTitle>Clima Atual - {estadoNome}</CardTitle>
      </CardHeader>
      <CardContent className="space-y-6">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-4">
            <WeatherIcon className="text-primary size-16" />
            <div>
              <div className="text-4xl font-bold">{dados.temperatura.toFixed(1)}°C</div>
              <div className="text-muted-foreground text-sm capitalize">{dados.condicaoTempo}</div>
            </div>
          </div>
        </div>

        <Separator />

        <div className="grid grid-cols-2 gap-4 md:grid-cols-3">
          <div className="space-y-1">
            <div className="text-muted-foreground text-sm">Umidade</div>
            <div className="text-xl font-semibold">{dados.umidade}%</div>
          </div>

          <div className="space-y-1">
            <div className="text-muted-foreground text-sm">Pressão</div>
            <div className="text-xl font-semibold">{dados.pressao.toFixed(1)} hPa</div>
          </div>

          {dados.velocidadeVento !== undefined && (
            <div className="space-y-1">
              <div className="text-muted-foreground flex items-center gap-1 text-sm">
                <Wind className="size-4" />
                Vento
              </div>
              <div className="text-xl font-semibold">{dados.velocidadeVento.toFixed(1)} km/h</div>
            </div>
          )}
        </div>

        <div className="text-muted-foreground text-xs">Última atualização: {lastUpdate}</div>
      </CardContent>
    </Card>
  );
}

export { CurrentWeather };
