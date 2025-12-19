import { useState } from 'react';
import { AlertCircle, RefreshCw } from 'lucide-react';
import { useEstados, useWeatherData } from '@/domain/weather/hooks';
import { BrazilMap, SearchEstado, CurrentWeather, ForecastList } from '@/domain/weather/components';
import { Button } from '@/core/components/button';
import { Alert, AlertDescription, AlertTitle } from '@/core/components/alert';
import { LoadingSpinner } from '@/core/components/loading-spinner';
import {
  Empty,
  EmptyDescription,
  EmptyHeader,
  EmptyMedia,
  EmptyTitle,
} from '@/core/components/empty';

function WeatherPage() {
  const [selectedEstadoId, setSelectedEstadoId] = useState<number | null>(null);

  const { data: estados, isLoading: isLoadingEstados, error: estadosError } = useEstados();
  const {
    data: weatherData,
    isLoading: isLoadingWeather,
    error: weatherError,
    refetch,
  } = useWeatherData(selectedEstadoId);

  const handleEstadoSelect = (estadoId: number) => {
    setSelectedEstadoId(estadoId);
  };

  if (isLoadingEstados) {
    return (
      <div className="flex h-full min-h-[60vh] items-center justify-center">
        <LoadingSpinner className="size-8" />
      </div>
    );
  }

  if (estadosError) {
    return (
      <div className="container mx-auto max-w-4xl py-8">
        <Alert variant="destructive">
          <AlertCircle className="size-4" />
          <AlertTitle>Erro ao carregar estados</AlertTitle>
          <AlertDescription>
            Não foi possível carregar a lista de estados. Tente novamente mais tarde.
          </AlertDescription>
        </Alert>
      </div>
    );
  }

  return (
    <div className="container mx-auto max-w-7xl space-y-8 py-8">
      <header className="space-y-4">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-4xl font-bold tracking-tight">ClimaBrasil</h1>
            <p className="text-muted-foreground mt-2">
              Informações meteorológicas dos estados brasileiros
            </p>
          </div>
          {selectedEstadoId && (
            <Button
              variant="outline"
              size="sm"
              onClick={() => refetch()}
              disabled={isLoadingWeather}
            >
              <RefreshCw className={isLoadingWeather ? 'animate-spin' : ''} />
              Atualizar
            </Button>
          )}
        </div>

        <SearchEstado estados={estados || []} onEstadoSelect={handleEstadoSelect} />
      </header>

      <BrazilMap
        estados={estados || []}
        selectedEstadoId={selectedEstadoId}
        onEstadoSelect={handleEstadoSelect}
      />

      {!selectedEstadoId && (
        <Empty className="min-h-[40vh]">
          <EmptyHeader>
            <EmptyMedia variant="icon">
              <AlertCircle />
            </EmptyMedia>
            <EmptyTitle>Selecione um estado</EmptyTitle>
            <EmptyDescription>
              Clique em um estado no mapa ou use a busca para visualizar as informações climáticas
            </EmptyDescription>
          </EmptyHeader>
        </Empty>
      )}

      {selectedEstadoId && isLoadingWeather && (
        <div className="flex min-h-[40vh] items-center justify-center">
          <LoadingSpinner className="size-8" />
        </div>
      )}

      {selectedEstadoId && weatherError && (
        <Alert variant="destructive">
          <AlertCircle className="size-4" />
          <AlertTitle>Erro ao carregar dados climáticos</AlertTitle>
          <AlertDescription>
            Não foi possível carregar os dados meteorológicos. Tente novamente.
          </AlertDescription>
        </Alert>
      )}

      {selectedEstadoId && weatherData && (
        <div className="space-y-6">
          {weatherData.dadosAtuais ? (
            <CurrentWeather dados={weatherData.dadosAtuais} estadoNome={weatherData.estado.nome} />
          ) : (
            <Alert>
              <AlertCircle className="size-4" />
              <AlertTitle>Dados atuais indisponíveis</AlertTitle>
              <AlertDescription>
                Os dados climáticos atuais estão temporariamente indisponíveis para este estado.
              </AlertDescription>
            </Alert>
          )}

          {weatherData.previsoes.length > 0 ? (
            <ForecastList previsoes={weatherData.previsoes} />
          ) : (
            <Alert>
              <AlertCircle className="size-4" />
              <AlertTitle>Previsões indisponíveis</AlertTitle>
              <AlertDescription>
                As previsões meteorológicas estão temporariamente indisponíveis para este estado.
              </AlertDescription>
            </Alert>
          )}
        </div>
      )}
    </div>
  );
}

export { WeatherPage };
