import Foundation

enum LoadCategory: String, CaseIterable, Codable {
    case general = "General Freight"
    case refrigerated = "Refrigerated"
    case hazardous = "Hazardous Materials"
    case livestock = "Livestock"
    case construction = "Construction Materials"
    case bulk = "Bulk Materials"
    case container = "Container"
    case automotive = "Automotive"
    
    var icon: String {
        switch self {
        case .general:
            return "shippingbox.fill"
        case .refrigerated:
            return "thermometer.snowflake"
        case .hazardous:
            return "exclamationmark.triangle.fill"
        case .livestock:
            return "leaf.fill"
        case .construction:
            return "building.fill"
        case .bulk:
            return "cylinder.fill"
        case .container:
            return "shippingbox.circle.fill"
        case .automotive:
            return "car.fill"
        }
    }
}
