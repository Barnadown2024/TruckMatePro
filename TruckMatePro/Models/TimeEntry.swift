import Foundation

struct TimeEntry: Identifiable, Codable {
    let id: UUID
    var date: Date
    var startTime: Date
    var endTime: Date?
    var breakDuration: TimeInterval
    var notes: String?
    var loadId: UUID?
    
    var duration: TimeInterval {
        if let endTime = endTime {
            return endTime.timeIntervalSince(startTime) - breakDuration
        } else {
            return Date().timeIntervalSince(startTime) - breakDuration
        }
    }
    
    var isActive: Bool {
        endTime == nil
    }
    
    var formattedDuration: String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        return String(format: "%02d:%02d", hours, minutes)
    }
    
    init(
        id: UUID = UUID(),
        date: Date = Date(),
        startTime: Date = Date(),
        endTime: Date? = nil,
        breakDuration: TimeInterval = 0,
        notes: String? = nil,
        loadId: UUID? = nil
    ) {
        self.id = id
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.breakDuration = breakDuration
        self.notes = notes
        self.loadId = loadId
    }
}
