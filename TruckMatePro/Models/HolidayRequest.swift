import Foundation

struct HolidayRequest: Identifiable, Codable {
    let id: UUID
    var startDate: Date
    var endDate: Date
    var status: HolidayRequestStatus
    var notes: String?
    var responseDate: Date?
    var responseNotes: String?
    
    init(id: UUID = UUID(), startDate: Date, endDate: Date, status: HolidayRequestStatus = .pending, notes: String? = nil, responseDate: Date? = nil, responseNotes: String? = nil) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.status = status
        self.notes = notes
        self.responseDate = responseDate
        self.responseNotes = responseNotes
    }
}

enum HolidayRequestStatus: String, Codable {
    case pending
    case approved
    case rejected
    
    var color: String {
        switch self {
        case .pending: return "yellow"
        case .approved: return "green"
        case .rejected: return "red"
        }
    }
}
