# FinTech Algorithms en Swift

Un Xcode Playground de macOS con 35 funciones Swift puras de dominio FinTech, organizadas por
categoría dentro de `FinTechAlgorithms.playground`. Cada función incluye una breve descripción de
qué hace, su complejidad, un ejemplo ejecutable y un comentario `// Resultado:` con el valor
esperado.

Es un recurso educativo y de portafolio técnico — una referencia de algoritmos aplicados a
finanzas — no un backend ni un SDK listo para producción.

---

## Requisitos

Requisitos declarados por el proyecto (no verificados en este repositorio, ya que no incluye
CI ni un entorno de build automatizado):

- Xcode 26 o superior
- macOS 15 o superior
- Swift 6.0 — declarado explícitamente en `contents.xcplayground`

---

## Cómo abrir y ejecutar

1. Descarga o clona este repositorio.
2. Descomprime `FinTechAlgorithms.playground.zip` si es necesario.
3. Abre `FinTechAlgorithms.playground` directamente en Xcode.
4. Ejecuta el Playground completo con **⌘ + Shift + Return**.
5. Usa el navegador de **MARK** (**⌘ + 6**) para saltar entre las 7 categorías.

Cada sección se valida manualmente: se ejecuta el ejemplo impreso y se contrasta contra el
comentario `// Resultado:` que lo acompaña. El repositorio no incluye un target de pruebas
automatizadas (XCTest) ni integración continua.

---

## Modelo base

Todas las funciones relacionadas con transacciones usan una estructura `Tx` compartida:

```swift
struct Tx {
    let id: String
    let amount: Decimal
    let date: Date
}
```

Los montos monetarios se representan con `Decimal` (no `Double`) para evitar el error de
redondeo binario propio de la coma flotante en cálculos financieros.

---

## Índice de funciones

### 1. Operaciones con transacciones
| # | Función | Descripción | Complejidad |
|---|---------|-------------|-------------|
| 1.1 | `sortByDateAmount` | Ordena por fecha ascendente, monto descendente en empate | O(n log n) |
| 1.2 | `filterGreaterThan` | Filtra transacciones que superan un umbral | O(n) |
| 1.3 | `topKSpends` | Retorna las K transacciones de mayor monto | O(n log k) |
| 1.4 | `binarySearchByID` | Búsqueda binaria en lista ordenada por ID | O(log n) |
| 1.5 | `dedupeByID` | Elimina duplicados preservando la primera aparición | O(n) |

### 2. Análisis de precios
| # | Función | Descripción | Complejidad |
|---|---------|-------------|-------------|
| 2.1 | `movingAverage` | Media Móvil Simple (SMA) con ventana deslizante | O(n) |
| 2.2 | `localExtrema` | Detecta picos y valles locales | O(n) |
| 2.3 | `dayDiffs` | Diferencias de precio día a día | O(n) |
| 2.4 | `cumulativeReturn` | Rendimiento acumulado a partir de retornos periódicos | O(n) |
| 2.5 | `maxProfit` | Máxima ganancia con una sola compra y venta | O(n) |

### 3. Cálculos financieros
| # | Función | Descripción | Complejidad |
|---|---------|-------------|-------------|
| 3.1 | `compoundInterest` | Interés compuesto: A = P(1 + r/n)^(nt) | O(1) |
| 3.2 | `convertCurrency` | Conversión de divisas con tabla de tasas | O(1) |
| 3.3 | `parseMoney` | Parsea texto monetario con formato local a Decimal | O(1) |
| 3.4 | `bankersRound` | Redondeo bancario (round half to even) | O(1) |
| 3.5 | `detectFraud` | Detecta transacciones sospechosas en ventana de tiempo | O(n log n) |

### 4. Seguridad y validación
| # | Función | Descripción | Complejidad |
|---|---------|-------------|-------------|
| 4.1 | `luhnCheck` | Algoritmo de Luhn para validar números de tarjeta | O(n) |
| 4.2 | `generateSessionID` | Genera un UUID único por sesión u operación | O(1) |
| 4.3 | `normalizeInput` | Limpia espacios en números de cuenta o tarjeta | O(n) |
| 4.4 | `sha256` | Hash SHA-256 de propósito general (ver [Nota de seguridad](#nota-de-seguridad)) | O(n) |
| 4.5 | `isValidEmail` | Validación de formato de email con expresión regular | O(n) |

### 5. Algoritmos y estructuras de datos
| # | Función | Descripción | Complejidad |
|---|---------|-------------|-------------|
| 5.1 | `linearSearch` / `binarySearch` | Comparativa búsqueda lineal vs binaria | O(n) / O(log n) |
| 5.2 | `quicksort` | Implementación de Quicksort | O(n log n) prom. |
| 5.3 | `median` | Cálculo de mediana y percentiles | O(n log n) |
| 5.4 | `outliersIQR` | Detección de outliers por rango intercuartílico | O(n log n) |
| 5.5 | `uniqueWithSet` | Deduplicación eficiente usando Set | O(n) |

### 6. Reportes y agrupación
| # | Función | Descripción | Complejidad |
|---|---------|-------------|-------------|
| 6.1 | `histogram` | Conteo de frecuencias por categoría | O(n) |
| 6.2 | `groupByMonth` | Agrupa transacciones por mes-año | O(n) |
| 6.3 | `cumulativeBalance` | Balance acumulado a lo largo del tiempo | O(n log n) |
| 6.4 | `averageByCategory` | Gasto promedio por categoría | O(n) |
| 6.5 | `exportCSV` | Exporta transacciones a formato CSV | O(n) |

### 7. Análisis cuantitativo
| # | Función | Descripción | Complejidad |
|---|---------|-------------|-------------|
| 7.1 | `logReturns` / `annualizedReturn` | Retornos logarítmicos y anualización | O(n) |
| 7.2 | `annualizedVolatility` | Desviación estándar anualizada de retornos | O(n) |
| 7.3 | `annualizedSharpe` | Sharpe ratio anualizado | O(n) |
| 7.4 | `smaCrossoverPnL` | Backtesting de estrategia SMA Crossover | O(n) |
| 7.5 | `rebalanceOrders` | Rebalanceo de portafolio a pesos objetivo | O(n) |

---

## Nota de seguridad

La función `sha256` (sección 4.4) ilustra **hashing genérico de propósito general**. SHA-256 por
sí solo **no debe usarse para almacenar contraseñas**: carece de sal y de un factor de trabajo
(work factor), por lo que es vulnerable a ataques de fuerza bruta y tablas precalculadas. Para
almacenamiento de contraseñas en producción se requiere una función de derivación de clave (KDF)
lenta y salada, como **Argon2**, **bcrypt** o **PBKDF2**.

---

## Licencia

MIT — ver el archivo [LICENSE](LICENSE).

---

## Autor

Stephano Portella
