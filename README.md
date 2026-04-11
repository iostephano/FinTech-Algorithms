# FinTech Algorithms en Swift

Una colección de 35 algoritmos esenciales para aplicaciones financieras, escritos en Swift y organizados como un Xcode Playground. Cubre desde la gestión básica de transacciones hasta análisis cuantitativo avanzado.

---

## Contenido

### 1. Operaciones con Transacciones
| # | Función | Descripción | Complejidad |
|---|---------|-------------|-------------|
| 1.1 | `sortByDateAmount` | Ordena por fecha ascendente, monto descendente en empate | O(n log n) |
| 1.2 | `filterGreaterThan` | Filtra transacciones que superan un umbral | O(n) |
| 1.3 | `topKSpends` | Retorna las K transacciones de mayor monto | O(n log k) |
| 1.4 | `binarySearchByID` | Búsqueda binaria en lista ordenada por ID | O(log n) |
| 1.5 | `dedupeByID` | Elimina duplicados preservando la primera aparición | O(n) |

### 2. Análisis de Precios
| # | Función | Descripción | Complejidad |
|---|---------|-------------|-------------|
| 2.1 | `movingAverage` | Media Móvil Simple (SMA) con ventana deslizante | O(n) |
| 2.2 | `localExtrema` | Detecta picos y valles locales | O(n) |
| 2.3 | `dayDiffs` | Diferencias de precio día a día | O(n) |
| 2.4 | `cumulativeReturn` | Rendimiento acumulado a partir de retornos periódicos | O(n) |
| 2.5 | `maxProfit` | Máxima ganancia con una sola compra y venta | O(n) |

### 3. Cálculos Financieros
| # | Función | Descripción | Complejidad |
|---|---------|-------------|-------------|
| 3.1 | `compoundInterest` | Interés compuesto: A = P(1 + r/n)^(nt) | O(1) |
| 3.2 | `convertCurrency` | Conversión de divisas con tabla de tasas | O(1) |
| 3.3 | `parseMoney` | Parsea texto monetario con formato local a Decimal | O(1) |
| 3.4 | `bankersRound` | Redondeo bancario (round half to even) | O(1) |
| 3.5 | `detectFraud` | Detecta transacciones sospechosas en ventana de tiempo | O(n log n) |

### 4. Seguridad y Validación
| # | Función | Descripción | Complejidad |
|---|---------|-------------|-------------|
| 4.1 | `luhnCheck` | Algoritmo de Luhn para validar números de tarjeta | O(n) |
| 4.2 | `generateSessionID` | Genera un UUID único por sesión u operación | O(1) |
| 4.3 | `normalizeInput` | Limpia espacios en números de cuenta o tarjeta | O(n) |
| 4.4 | `sha256` | Hash SHA-256 para contraseñas y datos sensibles | O(n) |
| 4.5 | `isValidEmail` | Validación de formato de email con expresión regular | O(n) |

### 5. Algoritmos y Estructuras de Datos
| # | Función | Descripción | Complejidad |
|---|---------|-------------|-------------|
| 5.1 | `linearSearch` / `binarySearch` | Comparativa búsqueda lineal vs binaria | O(n) / O(log n) |
| 5.2 | `quicksort` | Implementación de Quicksort | O(n log n) prom. |
| 5.3 | `median` | Cálculo de mediana y percentiles | O(n log n) |
| 5.4 | `outliersIQR` | Detección de outliers por rango intercuartílico | O(n log n) |
| 5.5 | `uniqueWithSet` | Deduplicación eficiente usando Set | O(n) |

### 6. Reportes y Agrupación
| # | Función | Descripción | Complejidad |
|---|---------|-------------|-------------|
| 6.1 | `histogram` | Conteo de frecuencias por categoría | O(n) |
| 6.2 | `groupByMonth` | Agrupa transacciones por mes-año | O(n) |
| 6.3 | `cumulativeBalance` | Balance acumulado a lo largo del tiempo | O(n log n) |
| 6.4 | `averageByCategory` | Gasto promedio por categoría | O(n) |
| 6.5 | `exportCSV` | Exporta transacciones a formato CSV | O(n) |

### 7. Análisis Cuantitativo
| # | Función | Descripción | Complejidad |
|---|---------|-------------|-------------|
| 7.1 | `logReturns` / `annualizedReturn` | Retornos logarítmicos y anualización | O(n) |
| 7.2 | `annualizedVolatility` | Desviación estándar anualizada de retornos | O(n) |
| 7.3 | `annualizedSharpe` | Sharpe ratio anualizado | O(n) |
| 7.4 | `smaCrossoverPnL` | Backtesting de estrategia SMA Crossover | O(n) |
| 7.5 | `rebalanceOrders` | Rebalanceo de portafolio a pesos objetivo | O(n) |

---

## Requisitos

- Xcode 26 o superior
- macOS 15 o superior
- Swift 6.0

---

## Uso

1. Descarga o clona este repositorio
2. Descomprime `FinTechAlgorithms.playground.zip` si es necesario
3. Abre `FinTechAlgorithms.playground` directamente en Xcode
4. Presiona **⌘ + Shift + Return** para ejecutar el Playground completo
5. Usa el navegador de **MARK** (`⌘ + 6`) para saltar entre secciones

Cada función incluye:
- Documentación inline que explica qué hace y por qué es útil en FinTech
- Un ejemplo funcional con salida impresa
- Anotación de complejidad temporal

---

## Modelo Base

Todas las funciones relacionadas con transacciones usan una estructura `Tx` compartida:

```swift
struct Tx {
    let id: String
    let amount: Decimal
    let date: Date
}
```

---

## Licencia

MIT — libre para usar, adaptar y distribuir.
