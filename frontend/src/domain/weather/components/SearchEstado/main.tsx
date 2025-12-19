import { useState, useMemo } from 'react';
import { Search } from 'lucide-react';
import type { Estado } from '../../types/models';
import { Input } from '@/core/components/input';
import { cn } from '@/core/lib/utils';

interface SearchEstadoProps {
  estados: Estado[];
  onEstadoSelect: (estadoId: number) => void;
}

function SearchEstado({ estados, onEstadoSelect }: SearchEstadoProps) {
  const [searchTerm, setSearchTerm] = useState('');
  const [showResults, setShowResults] = useState(false);

  const filteredEstados = useMemo(() => {
    if (!searchTerm || searchTerm.length < 2) return [];

    const term = searchTerm.toLowerCase();
    return estados
      ?.filter(
        (estado) =>
          estado.nome.toLowerCase().includes(term) || estado.sigla.toLowerCase().includes(term)
      )
      .slice(0, 10);
  }, [searchTerm, estados]);

  const handleSelect = (estadoId: number) => {
    onEstadoSelect(estadoId);
    setSearchTerm('');
    setShowResults(false);
  };

  return (
    <div className="relative w-full">
      <div className="relative">
        <Search className="text-muted-foreground size-4 absolute left-3 top-1/2 -translate-y-1/2" />
        <Input
          type="text"
          placeholder="Buscar estado por nome ou sigla..."
          value={searchTerm}
          onChange={(e) => {
            setSearchTerm(e.target.value);
            setShowResults(true);
          }}
          onFocus={() => setShowResults(true)}
          onBlur={() => setTimeout(() => setShowResults(false), 200)}
          className="pl-10"
        />
      </div>

      {showResults && filteredEstados.length > 0 && (
        <div className="bg-popover absolute top-full z-50 mt-2 w-full rounded-md border shadow-md">
          <div className="max-h-60 overflow-y-auto p-1">
            {filteredEstados.map((estado) => (
              <button
                key={estado.id}
                onClick={() => handleSelect(estado.id)}
                className={cn(
                  'hover:bg-accent hover:text-accent-foreground w-full rounded-sm px-3 py-2 text-left text-sm transition-colors'
                )}
              >
                <div className="font-medium">
                  {estado.nome} ({estado.sigla})
                </div>
                <div className="text-muted-foreground text-xs">{estado.regiao}</div>
              </button>
            ))}
          </div>
        </div>
      )}

      {showResults && searchTerm.length >= 2 && filteredEstados.length === 0 && (
        <div className="bg-popover text-muted-foreground absolute top-full z-50 mt-2 w-full rounded-md border p-4 text-center text-sm shadow-md">
          Nenhum estado encontrado para este termo
        </div>
      )}
    </div>
  );
}

export { SearchEstado };
