import Foundation

struct Load: Identifiable, Codable {
    let id: UUID
    let date: Date
    let truckNumber: String
    let loadNumber: String
    let category: LoadCategory
    let pickupLocation: String
    let deliveryLocation: String
    let weight: Double
    let description: String
    var status: LoadStatus
    var earnings: Double?
    
    init(
        id: UUID = UUID(),
        date: Date,
        truckNumber: String,
        loadNumber: String,
        category: LoadCategory,
        pickupLocation: String,
        deliveryLocation: String,
        weight: Double,
        description: String,
        status: LoadStatus = .pending,
        earnings: Double? = nil
    ) {
        self.id = id
        self.date = date
        self.truckNumber = truckNumber
        self.loadNumber = loadNumber
        self.category = category
        self.pickupLocation = pickupLocation
        self.deliveryLocation = deliveryLocation
        self.weight = weight
        self.description = description
        self.status = status
        self.earnings = earnings
    }
}

enum LoadStatus: String, Codable {
    case pending
    case inProgress
    case completed
    case cancelled
}
