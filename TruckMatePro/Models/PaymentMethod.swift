import Foundation

enum PaymentMethod: String, Codable, CaseIterable {
    case hourly
    case daily
    case perLoad
    case perLitre
    
    var displayName: String {
        switch self {
        case .hourly: return "Hourly Rate"
        case .daily: return "Daily Rate"
        case .perLoad: return "Per Load"
        case .perLitre: return "Per Litre"
        }
    }
}

struct PaymentSettings: Codable {
    var method: PaymentMethod
    var rate: Double
    var currency: String = "EUR"
    
    var formattedRate: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        return formatter.string(from: NSNumber(value: rate)) ?? "\(currency)\(rate)"
    }
}
