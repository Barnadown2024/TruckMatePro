import Foundation

struct User: Codable {
    let id: UUID
    let email: String
    let name: String
    let companyName: String
    let driverLicense: String
    let companyId: UUID
    let createdAt: Date
    
    init(email: String, name: String, companyName: String, driverLicense: String) {
        self.id = UUID()
        self.email = email
        self.name = name
        self.companyName = companyName
        self.driverLicense = driverLicense
        self.companyId = UUID()
        self.createdAt = Date()
    }
}
