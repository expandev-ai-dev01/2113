import { useState } from 'react';
import type { Estado } from '../../types/models';
import { cn } from '@/core/lib/utils';

interface BrazilMapProps {
  estados: Estado[];
  selectedEstadoId: number | null;
  onEstadoSelect: (estadoId: number) => void;
}

function BrazilMap({ estados, selectedEstadoId, onEstadoSelect }: BrazilMapProps) {
  const [hoveredEstadoId, setHoveredEstadoId] = useState<number | null>(null);

  return (
    <div className="bg-card relative w-full rounded-lg border p-6 shadow-sm">
      <h2 className="mb-4 text-xl font-semibold">Mapa do Brasil</h2>
      <div className="grid grid-cols-2 gap-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5">
        {estados?.map((estado) => (
          <button
            key={estado.id}
            onClick={() => onEstadoSelect(estado.id)}
            onMouseEnter={() => setHoveredEstadoId(estado.id)}
            onMouseLeave={() => setHoveredEstadoId(null)}
            className={cn(
              'rounded-md border px-4 py-3 text-sm font-medium transition-all duration-200',
              'focus-visible:ring-ring hover:shadow-md focus-visible:outline-none focus-visible:ring-2',
              selectedEstadoId === estado.id
                ? 'border-primary bg-primary text-primary-foreground'
                : 'border-border bg-background hover:bg-accent',
              hoveredEstadoId === estado.id && selectedEstadoId !== estado.id ? 'scale-105' : ''
            )}
          >
            <div className="font-bold">{estado.sigla}</div>
            <div className="text-xs opacity-80">{estado.nome}</div>
          </button>
        ))}
      </div>
    </div>
  );
}

export { BrazilMap };
