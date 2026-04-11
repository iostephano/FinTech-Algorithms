import Foundation
import CryptoKit

// ============================================================
// FINTECH ALGORITHMS IN SWIFT
// Playground organizado por categorías para uso en Xcode
// Autor: GitHub Portfolio
// ============================================================


// ============================================================
// MARK: - MODELO BASE
// ============================================================

/// Estructura base de Transacción usada en todos los ejemplos.
struct Tx {
    let id: String
    let amount: Decimal
    let date: Date
}


// ============================================================
// MARK: - 1. OPERACIONES CON TRANSACCIONES
// ============================================================

// MARK: 1.1 Ordenar transacciones
// Qué hace: ordena de la más antigua a la más reciente;
//           si son del mismo día, primero la de mayor monto.
// Complejidad: O(n log n)

func sortByDateAmount(_ txs: [Tx]) -> [Tx] {
    txs.sorted {
        if $0.date == $1.date { return $0.amount > $1.amount }
        return $0.date < $1.date
    }
}

// Ejemplo 1.1
let calendar = Calendar.current
let day1 = calendar.date(from: DateComponents(year: 2025, month: 1, day: 10))!
let day2 = calendar.date(from: DateComponents(year: 2025, month: 1, day: 11))!
let txs_1_1: [Tx] = [
    .init(id: "A", amount: 100, date: day1),
    .init(id: "B", amount: 200, date: day1),
    .init(id: "C", amount: 50,  date: day2)
]
let sorted_1_1 = sortByDateAmount(txs_1_1).map(\.id)
// Resultado: ["B", "A", "C"]
print("1.1 Ordenar transacciones:", sorted_1_1)


// MARK: 1.2 Filtrar por monto
// Qué hace: selecciona solo las transacciones que superan cierto monto.
// Complejidad: O(n)

func filterGreaterThan(_ txs: [Tx], threshold: Decimal) -> [Tx] {
    txs.filter { $0.amount > threshold }
}

// Ejemplo 1.2
let txs_1_2: [Tx] = [
    .init(id: "A", amount: 30,  date: Date()),
    .init(id: "B", amount: 250, date: Date()),
    .init(id: "C", amount: 120, date: Date()),
    .init(id: "D", amount: 60,  date: Date())
]
let filtered_1_2 = filterGreaterThan(txs_1_2, threshold: 100).map(\.id)
// Resultado: ["B", "C"]
print("1.2 Filtrar por monto:", filtered_1_2)


// MARK: 1.3 Top K gastos
// Qué hace: encuentra los k gastos de mayor valor.
// Complejidad: O(n log k)

func topKSpends(_ txs: [Tx], k: Int) -> [Tx] {
    guard k > 0 else { return [] }
    return Array(txs.sorted { $0.amount > $1.amount }.prefix(k))
}

// Ejemplo 1.3
let txs_1_3: [Tx] = [
    .init(id: "A", amount: 120, date: Date()),
    .init(id: "B", amount: 999, date: Date()),
    .init(id: "C", amount: 45,  date: Date()),
    .init(id: "D", amount: 300, date: Date()),
    .init(id: "E", amount: 501, date: Date())
]
let top3 = topKSpends(txs_1_3, k: 3).map { "\($0.id):\($0.amount)" }
// Resultado: ["B:999", "E:501", "D:300"]
print("1.3 Top K gastos:", top3)


// MARK: 1.4 Buscar por ID (búsqueda binaria)
// Qué hace: localiza una transacción en una lista ordenada por ID.
// Complejidad: O(log n)

func binarySearchByID(_ txsSortedByID: [Tx], id: String) -> Int? {
    var lo = 0, hi = txsSortedByID.count - 1
    while lo <= hi {
        let mid = lo + (hi - lo) / 2
        let midID = txsSortedByID[mid].id
        if midID == id  { return mid }
        if midID < id   { lo = mid + 1 } else { hi = mid - 1 }
    }
    return nil
}

// Ejemplo 1.4
let txs_1_4: [Tx] = [
    .init(id: "TX01", amount: 10,  date: Date()),
    .init(id: "TX03", amount: 7,   date: Date()),
    .init(id: "TX02", amount: 55,  date: Date()),
    .init(id: "TX04", amount: 200, date: Date())
]
let sortedByID = txs_1_4.sorted { $0.id < $1.id }
if let idx = binarySearchByID(sortedByID, id: "TX03") {
    print("1.4 Buscar por ID: encontrado →", sortedByID[idx].id)
}


// MARK: 1.5 Eliminar duplicados
// Qué hace: elimina transacciones repetidas, preservando la primera aparición.
// Complejidad: O(n)

func dedupeByID(_ txs: [Tx]) -> [Tx] {
    var seen = Set<String>()
    var out: [Tx] = []
    for t in txs where !seen.contains(t.id) {
        seen.insert(t.id)
        out.append(t)
    }
    return out
}

// Ejemplo 1.5
let txs_1_5: [Tx] = [
    .init(id: "A", amount: 10, date: Date()),
    .init(id: "B", amount: 10, date: Date()),
    .init(id: "A", amount: 10, date: Date()), // duplicado
    .init(id: "C", amount: 99, date: Date()),
    .init(id: "B", amount: 10, date: Date())  // duplicado
]
let deduped = dedupeByID(txs_1_5).map(\.id)
// Resultado: ["A", "B", "C"]
print("1.5 Eliminar duplicados:", deduped)


// ============================================================
// MARK: - 2. ANÁLISIS DE PRECIOS
// ============================================================

// MARK: 2.1 Media móvil simple (SMA)
// Qué hace: calcula el promedio de los últimos k precios (ventana deslizante).
// Complejidad: O(n)

func movingAverage(_ prices: [Decimal], k: Int) -> [Decimal] {
    guard k > 0, prices.count >= k else { return [] }
    var sum: Decimal = prices.prefix(k).reduce(0, +)
    var out: [Decimal] = [sum / Decimal(k)]
    for i in k..<prices.count {
        sum += prices[i] - prices[i - k]
        out.append(sum / Decimal(k))
    }
    return out
}

// Ejemplo 2.1
let sma = movingAverage([10, 11, 12, 13, 14, 15], k: 3)
// Resultado: [11, 12, 13, 14]
print("2.1 SMA:", sma)


// MARK: 2.2 Máximos y mínimos locales
// Qué hace: detecta picos y valles comparando cada punto con sus vecinos.
// Complejidad: O(n)

enum Extremum { case peak(index: Int), valley(index: Int) }

func localExtrema(_ p: [Decimal]) -> [Extremum] {
    guard p.count >= 3 else { return [] }
    var out: [Extremum] = []
    for i in 1..<(p.count - 1) {
        if p[i] > p[i - 1] && p[i] > p[i + 1] { out.append(.peak(index: i)) }
        if p[i] < p[i - 1] && p[i] < p[i + 1] { out.append(.valley(index: i)) }
    }
    return out
}

// Ejemplo 2.2
let extrema = localExtrema([10, 12, 11, 13, 9, 10])
// peaks en índice 1 y 3, valley en índice 4
print("2.2 Extremos locales:", extrema.map {
    switch $0 {
    case .peak(let i):   return "peak@\(i)"
    case .valley(let i): return "valley@\(i)"
    }
})


// MARK: 2.3 Diferencias diarias de precios
// Qué hace: calcula cuánto sube o baja el precio respecto al día anterior.
// Complejidad: O(n)

func dayDiffs(_ p: [Decimal]) -> [Decimal] {
    guard p.count >= 2 else { return [] }
    return (1..<p.count).map { p[$0] - p[$0 - 1] }
}

// Ejemplo 2.3
let diffs = dayDiffs([10, 11, 10.5, 12])
// Resultado: [1, -0.5, 1.5]
print("2.3 Diferencias diarias:", diffs)


// MARK: 2.4 Rendimiento acumulado
// Qué hace: multiplica todos los retornos periódicos → crecimiento total.
// Fórmula: (1+r1)*(1+r2)*... - 1
// Complejidad: O(n)

func cumulativeReturn(_ returns: [Decimal]) -> Decimal {
    returns.reduce(Decimal(1)) { $0 * (1 + $1) } - 1
}

// Ejemplo 2.4 (retornos en decimales)
let cumRet = cumulativeReturn([0.01, -0.02, 0.03])
// ≈ 0.0197 (1.97%)
print("2.4 Rendimiento acumulado:", cumRet)


// MARK: 2.5 Mejor momento para comprar y vender
// Qué hace: ganancia máxima comprando una vez y vendiendo después.
// Complejidad: O(n)

func maxProfit(_ prices: [Decimal]) -> Decimal {
    var minPrice = Decimal.greatestFiniteMagnitude
    var best: Decimal = 0
    for p in prices {
        if p < minPrice { minPrice = p }
        let profit = p - minPrice
        if profit > best { best = profit }
    }
    return best
}

// Ejemplo 2.5
let profit = maxProfit([10, 7, 5, 8, 11, 9])
// Resultado: 6 (comprar a 5, vender a 11)
print("2.5 Max profit:", profit)


// ============================================================
// MARK: - 3. CÁLCULOS FINANCIEROS
// ============================================================

// MARK: 3.1 Interés compuesto
// Qué hace: calcula el monto acumulado con interés compuesto.
// Fórmula: A = P * (1 + r/n)^(n*t)
// Complejidad: O(1)

func compoundInterest(principal: Decimal, rate: Decimal, times: Int, years: Int) -> Decimal {
    let base        = (1 + (rate / Decimal(times)))
    let exponent    = times * years
    let baseNumber  = NSDecimalNumber(decimal: base)
    let powered     = baseNumber.raising(toPower: exponent)
    return NSDecimalNumber(decimal: principal).multiplying(by: powered).decimalValue
}

// Ejemplo 3.1
let totalCompound = compoundInterest(principal: 1000, rate: 0.05, times: 12, years: 2)
// ≈ 1104.94
print("3.1 Interés compuesto:", totalCompound)


// MARK: 3.2 Conversión de divisas
// Qué hace: convierte un monto entre divisas usando una tabla de tasas.
// Complejidad: O(1)

func convertCurrency(amount: Decimal, from: String, to: String, rates: [String: Decimal]) -> Decimal? {
    guard let fromRate = rates[from], let toRate = rates[to] else { return nil }
    return amount / fromRate * toRate
}

// Ejemplo 3.2
let rates: [String: Decimal] = ["USD": 1.0, "EUR": 0.9, "PEN": 3.7]
if let converted = convertCurrency(amount: 100, from: "USD", to: "PEN", rates: rates) {
    print("3.2 Conversión de divisas: 100 USD =", converted, "PEN")
}


// MARK: 3.3 Conversión de formato monetario
// Qué hace: transforma un texto con formato de dinero en Decimal.
// Complejidad: O(1)

func parseMoney(_ text: String, locale: Locale = .current) -> Decimal? {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.locale = locale
    return formatter.number(from: text)?.decimalValue
}

// Ejemplo 3.3
if let value = parseMoney("1,234.56", locale: Locale(identifier: "en_US")) {
    print("3.3 parseMoney:", value)
}


// MARK: 3.4 Redondeo bancario (Round Half to Even)
// Qué hace: redondea evitando sesgo en grandes volúmenes de operaciones.
// Complejidad: O(1)

func bankersRound(_ value: Decimal, scale: Int) -> Decimal {
    var num = value
    var result = Decimal()
    NSDecimalRound(&result, &num, scale, .bankers)
    return result
}

// Ejemplo 3.4
let r1 = bankersRound(2.345, scale: 2) // → 2.34
let r2 = bankersRound(2.355, scale: 2) // → 2.36
print("3.4 Redondeo bancario: 2.345 →", r1, " | 2.355 →", r2)


// MARK: 3.5 Detección simple de fraude
// Qué hace: alerta si hay demasiadas transacciones en una ventana de tiempo.
// Complejidad: O(n log n)

func detectFraud(transactions: [Date], within seconds: TimeInterval, threshold: Int) -> Bool {
    let sorted = transactions.sorted()
    for i in 0..<sorted.count {
        let window = sorted[i...].prefix(threshold)
        if let first = window.first, let last = window.last {
            if last.timeIntervalSince(first) <= seconds { return true }
        }
    }
    return false
}

// Ejemplo 3.5
let now = Date()
let fraudTxs = [now, now.addingTimeInterval(5), now.addingTimeInterval(8)]
let isFraud = detectFraud(transactions: fraudTxs, within: 10, threshold: 3)
// Resultado: true (3 transacciones en 10 segundos)
print("3.5 Detección de fraude:", isFraud)


// ============================================================
// MARK: - 4. SEGURIDAD Y VALIDACIÓN
// ============================================================

// MARK: 4.1 Validación de tarjeta (Algoritmo de Luhn)
// Qué hace: valida que un número de tarjeta sea correcto.
// Complejidad: O(n)

func luhnCheck(_ number: String) -> Bool {
    let digits = number.compactMap { Int(String($0)) }
    guard digits.count == number.count else { return false }
    var sum = 0
    for (i, d) in digits.reversed().enumerated() {
        if i % 2 == 1 {
            let doubled = d * 2
            sum += doubled > 9 ? doubled - 9 : doubled
        } else {
            sum += d
        }
    }
    return sum % 10 == 0
}

// Ejemplo 4.1
let validCard = luhnCheck("4532015112830366") // → true
print("4.1 Luhn check:", validCard)


// MARK: 4.2 Generación de UUID de sesión
// Qué hace: crea un identificador único e irrepetible para cada sesión/operación.
// Complejidad: O(1)

func generateSessionID() -> String {
    UUID().uuidString
}

// Ejemplo 4.2
let sessionID = generateSessionID()
print("4.2 UUID sesión:", sessionID)


// MARK: 4.3 Normalización de inputs
// Qué hace: elimina espacios y caracteres extra en números de cuenta o tarjeta.
// Complejidad: O(n)

func normalizeInput(_ text: String) -> String {
    text.replacingOccurrences(of: " ", with: "")
        .trimmingCharacters(in: .whitespacesAndNewlines)
}

// Ejemplo 4.3
let normalized = normalizeInput("  1234 5678  ")
// Resultado: "12345678"
print("4.3 Normalización:", normalized)


// MARK: 4.4 Hash SHA-256
// Qué hace: genera un hash seguro, no reversible. Ideal para contraseñas.
// Complejidad: O(n)

func sha256(_ text: String) -> String {
    let data   = Data(text.utf8)
    let hashed = SHA256.hash(data: data)
    return hashed.compactMap { String(format: "%02x", $0) }.joined()
}

// Ejemplo 4.4
let hash = sha256("password123")
print("4.4 SHA-256:", String(hash.prefix(20)) + "...")


// MARK: 4.5 Validación de formato de email
// Qué hace: verifica si un email cumple un formato válido (útil en KYC).
// Complejidad: O(n)

func isValidEmail(_ email: String) -> Bool {
    let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
}

// Ejemplo 4.5
print("4.5 Email válido:", isValidEmail("test@mail.com"))   // true
print("4.5 Email inválido:", isValidEmail("no-es-email"))   // false


// ============================================================
// MARK: - 5. ALGORITMOS Y ESTRUCTURAS DE DATOS
// ============================================================

// MARK: 5.1 Búsqueda lineal vs. binaria
// Complejidad: lineal O(n) | binaria O(log n)

func linearSearch(_ arr: [Int], target: Int) -> Int? {
    for (i, v) in arr.enumerated() {
        if v == target { return i }
    }
    return nil
}

func binarySearch(_ arr: [Int], target: Int) -> Int? {
    var lo = 0, hi = arr.count - 1
    while lo <= hi {
        let mid = (lo + hi) / 2
        if arr[mid] == target   { return mid }
        else if arr[mid] < target { lo = mid + 1 }
        else                      { hi = mid - 1 }
    }
    return nil
}

// Ejemplo 5.1
let searchArr = [1, 2, 3, 4, 5]
print("5.1 Búsqueda lineal (target: 4):", linearSearch(searchArr, target: 4) as Any)
print("5.1 Búsqueda binaria (target: 4):", binarySearch(searchArr, target: 4) as Any)


// MARK: 5.2 Quicksort
// Qué hace: ordena elementos usando Quicksort (divide y conquista).
// Complejidad: O(n log n) promedio, O(n²) peor caso

func quicksort(_ arr: [Int]) -> [Int] {
    guard arr.count > 1 else { return arr }
    let pivot   = arr[arr.count / 2]
    let less    = arr.filter { $0 < pivot }
    let equal   = arr.filter { $0 == pivot }
    let greater = arr.filter { $0 > pivot }
    return quicksort(less) + equal + quicksort(greater)
}

// Ejemplo 5.2
let sorted_5_2 = quicksort([3, 6, 8, 10, 1, 2, 1])
// Resultado: [1, 1, 2, 3, 6, 8, 10]
print("5.2 Quicksort:", sorted_5_2)


// MARK: 5.3 Mediana y percentiles
// Qué hace: calcula la mediana sin distorsión por outliers.
// Complejidad: O(n log n)

func median(_ arr: [Decimal]) -> Decimal? {
    guard !arr.isEmpty else { return nil }
    let sorted = arr.sorted()
    let mid    = arr.count / 2
    if arr.count % 2 == 0 {
        return (sorted[mid - 1] + sorted[mid]) / 2
    } else {
        return sorted[mid]
    }
}

// Ejemplo 5.3
print("5.3 Mediana [1,2,3,4,5]:", median([1, 2, 3, 4, 5]) as Any) // 3
print("5.3 Mediana [1,2,3,4]:", median([1, 2, 3, 4]) as Any)       // 2.5


// MARK: 5.4 Detección de outliers (IQR)
// Qué hace: marca valores extremos fuera del rango intercuartílico.
// Complejidad: O(n log n)

func outliersIQR(_ xs: [Decimal]) -> [Decimal] {
    guard xs.count > 4 else { return [] }
    let s = xs.sorted(); let n = s.count
    let lower = Array(s.prefix(n / 2))
    let upper = Array(s.suffix(n / 2))
    guard let q1 = median(lower), let q3 = median(upper) else { return [] }
    let iqr  = q3 - q1
    let low  = q1 - Decimal(1.5) * iqr
    let high = q3 + Decimal(1.5) * iqr
    return s.filter { $0 < low || $0 > high }
}

// Ejemplo 5.4
let sample: [Decimal] = [10, 12, 12, 13, 12, 400]
let outliers = outliersIQR(sample)
// Resultado: [400]
print("5.4 Outliers IQR:", outliers)


// MARK: 5.5 Optimización de memoria con Set
// Qué hace: elimina duplicados con una estructura de datos más eficiente.
// Complejidad: O(n) — sin garantía de orden

func uniqueWithSet(_ arr: [Int]) -> [Int] {
    Array(Set(arr))
}

// Ejemplo 5.5
let unique = uniqueWithSet([1, 2, 2, 3, 3, 4])
print("5.5 Únicos con Set:", unique.sorted())


// ============================================================
// MARK: - 6. REPORTES Y AGRUPACIÓN
// ============================================================

// MARK: 6.1 Histograma de frecuencias
// Qué hace: cuenta ocurrencias por categoría.
// Complejidad: O(n)

func histogram<T: Hashable>(_ items: [T]) -> [T: Int] {
    var dict: [T: Int] = [:]
    for item in items {
        dict[item, default: 0] += 1
    }
    return dict
}

// Ejemplo 6.1
let categories = ["Food", "Food", "Travel", "Bills", "Food"]
let hist = histogram(categories)
// Resultado: ["Food": 3, "Travel": 1, "Bills": 1]
print("6.1 Histograma:", hist)


// MARK: 6.2 Agrupación de transacciones por mes
// Qué hace: agrupa transacciones según mes-año.
// Complejidad: O(n)

func groupByMonth(_ txs: [Tx]) -> [String: [Tx]] {
    let f = DateFormatter()
    f.dateFormat = "MM-yyyy"
    return Dictionary(grouping: txs) { f.string(from: $0.date) }
}

// Ejemplo 6.2
let jan = calendar.date(from: DateComponents(year: 2025, month: 1, day: 15))!
let feb = calendar.date(from: DateComponents(year: 2025, month: 2, day: 10))!
let txs_6_2: [Tx] = [
    .init(id: "T1", amount: 100, date: jan),
    .init(id: "T2", amount: 200, date: jan),
    .init(id: "T3", amount: 150, date: feb)
]
let grouped = groupByMonth(txs_6_2)
print("6.2 Grupos por mes:", grouped.mapValues { $0.map(\.id) })


// MARK: 6.3 Balance acumulado en el tiempo
// Qué hace: muestra cómo evoluciona el saldo transacción a transacción.
// Complejidad: O(n log n)

func cumulativeBalance(_ txs: [Tx], start: Decimal = 0) -> [(Date, Decimal)] {
    let sorted = txs.sorted { $0.date < $1.date }
    var balance = start
    var result: [(Date, Decimal)] = []
    for t in sorted {
        balance += t.amount
        result.append((t.date, balance))
    }
    return result
}

// Ejemplo 6.3
let txs_6_3: [Tx] = [
    .init(id: "X1", amount: 500,  date: jan),
    .init(id: "X2", amount: -200, date: feb)
]
let balances = cumulativeBalance(txs_6_3)
print("6.3 Balance acumulado:", balances.map { "\($0.1)" })


// MARK: 6.4 Promedio por categoría
// Qué hace: calcula el gasto promedio por cada categoría.
// Complejidad: O(n)

func averageByCategory(_ txs: [(String, Decimal)]) -> [String: Decimal] {
    var sums:   [String: Decimal] = [:]
    var counts: [String: Int]     = [:]
    for (cat, amt) in txs {
        sums[cat,   default: 0] += amt
        counts[cat, default: 0] += 1
    }
    return sums.mapValues { val in
        // Buscar la categoría que tiene este valor total
        let cat = sums.first { $0.value == val }?.key ?? ""
        return val / Decimal(counts[cat] ?? 1)
    }
}

// Ejemplo 6.4
let catTxs: [(String, Decimal)] = [("Food", 20), ("Food", 30), ("Travel", 50)]
let avgByCat = averageByCategory(catTxs)
// Resultado: ["Food": 25, "Travel": 50]
print("6.4 Promedio por categoría:", avgByCat)


// MARK: 6.5 Exportar transacciones a CSV
// Qué hace: transforma transacciones en texto CSV (para Excel / Google Sheets).
// Complejidad: O(n)

func exportCSV(_ txs: [Tx]) -> String {
    var rows = ["id,amount,date"]
    let f = ISO8601DateFormatter()
    for t in txs {
        rows.append("\(t.id),\(t.amount),\(f.string(from: t.date))")
    }
    return rows.joined(separator: "\n")
}

// Ejemplo 6.5
let csv = exportCSV(txs_6_2)
print("6.5 CSV:\n", csv)


// ============================================================
// MARK: - 7. ANÁLISIS CUANTITATIVO
// ============================================================

// MARK: 7.1 Retornos logarítmicos y anualización
// Qué hace: calcula r_t = ln(P_t / P_{t-1}) y anualiza el retorno medio.
// Complejidad: O(n)

func logReturns(_ prices: [Double]) -> [Double] {
    guard prices.count > 1 else { return [] }
    return (1..<prices.count).map { log(prices[$0] / prices[$0 - 1]) }
}

/// Anualiza el retorno logarítmico medio asumiendo 252 días bursátiles.
func annualizedReturn(meanDailyLogRet: Double, tradingDays: Double = 252) -> Double {
    exp(meanDailyLogRet * tradingDays) - 1
}

// Ejemplo 7.1
let prices_7 = [100.0, 102.0, 101.0, 105.0, 108.0]
let logRets   = logReturns(prices_7)
let meanLog   = logRets.reduce(0, +) / Double(logRets.count)
let annRet    = annualizedReturn(meanDailyLogRet: meanLog)
print("7.1 Log returns:", logRets.map { String(format: "%.4f", $0) })
print("7.1 Retorno anualizado:", String(format: "%.2f%%", annRet * 100))


// MARK: 7.2 Volatilidad anualizada
// Qué hace: desviación estándar diaria escalada a un año (sd * √252).
// Complejidad: O(n)

func annualizedVolatility(_ dailyLogReturns: [Double], tradingDays: Double = 252) -> Double {
    guard !dailyLogReturns.isEmpty else { return 0 }
    let mean   = dailyLogReturns.reduce(0, +) / Double(dailyLogReturns.count)
    let varSum = dailyLogReturns.reduce(0) { $0 + pow($1 - mean, 2) }
    let sdDaily = sqrt(varSum / Double(dailyLogReturns.count))
    return sdDaily * sqrt(tradingDays)
}

// Ejemplo 7.2
let vol = annualizedVolatility(logRets)
print("7.2 Volatilidad anualizada:", String(format: "%.4f", vol))


// MARK: 7.3 Sharpe Ratio anualizado
// Qué hace: exceso de retorno anual / volatilidad anual.
// Complejidad: O(n)

func annualizedSharpe(dailyLogReturns: [Double], dailyRiskFree: Double = 0.0) -> Double {
    guard !dailyLogReturns.isEmpty else { return 0 }
    let excess      = dailyLogReturns.map { $0 - dailyRiskFree }
    let meanExcess  = excess.reduce(0, +) / Double(excess.count)
    let muAnnual    = exp(meanExcess * 252) - 1
    let sigmaAnnual = annualizedVolatility(dailyLogReturns)
    return sigmaAnnual == 0 ? 0 : muAnnual / sigmaAnnual
}

// Ejemplo 7.3
let sharpe = annualizedSharpe(dailyLogReturns: logRets)
print("7.3 Sharpe ratio:", String(format: "%.4f", sharpe))


// MARK: 7.4 Estrategia SMA Crossover (Backtesting)
// Qué hace: entra en compra cuando SMA corta > SMA larga; calcula P&L acumulado.
// Complejidad: O(n)

func sma(_ xs: [Double], _ k: Int) -> [Double] {
    guard k > 0, xs.count >= k else { return [] }
    var acc = xs.prefix(k).reduce(0, +)
    var out = [acc / Double(k)]
    for i in k..<xs.count { acc += xs[i] - xs[i - k]; out.append(acc / Double(k)) }
    return out
}

func smaCrossoverPnL(_ prices: [Double], short: Int, long: Int) -> Double {
    guard prices.count > long, short < long else { return 0 }
    let s = sma(prices, short)
    let l = sma(prices, long)
    var pnl: Double = 0
    for i in (long - 1)..<prices.count - 1 {
        let signalLong = s[i - (short - 1)] > l[i - (long - 1)]
        let retNext    = log(prices[i + 1] / prices[i])
        if signalLong { pnl += retNext }
    }
    return exp(pnl) - 1
}

// Ejemplo 7.4
let longPrices = stride(from: 100.0, through: 130.0, by: 1.0).map {
    $0 + Double.random(in: -2...2)
}
let crossoverReturn = smaCrossoverPnL(longPrices, short: 3, long: 5)
print("7.4 SMA Crossover P&L:", String(format: "%.2f%%", crossoverReturn * 100))


// MARK: 7.5 Rebalanceo de portafolio a pesos objetivo
// Qué hace: calcula órdenes de compra/venta para alcanzar los pesos objetivo.
// Complejidad: O(n)

func rebalanceOrders(
    prices: [Double],
    holdings: [Double],
    cash: Double,
    targetWeights: [Double]
) -> [Double] {
    precondition(
        prices.count == holdings.count && prices.count == targetWeights.count,
        "Dimensiones incorrectas"
    )
    let equity       = cash + zip(prices, holdings).reduce(0) { $0 + $1.0 * $1.1 }
    let targetsValue = targetWeights.map { $0 * equity }
    let targetShares = zip(targetsValue, prices).map { $0 / $1 }
    return zip(targetShares, holdings).map { $0 - $1 }
}

// Ejemplo 7.5
// Portafolio: 2 activos, quiero 60% / 40%
let orders = rebalanceOrders(
    prices:        [50.0, 100.0],
    holdings:      [10.0, 3.0],
    cash:          200.0,
    targetWeights: [0.6, 0.4]
)
// Positivo → comprar, Negativo → vender
print("7.5 Órdenes de rebalanceo:", orders.map { String(format: "%.2f", $0) })


// ============================================================
// MARK: - FIN DEL PLAYGROUND
// ============================================================
print("\n✅ Todos los snippets ejecutados correctamente.")
