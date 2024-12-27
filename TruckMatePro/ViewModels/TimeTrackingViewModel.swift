import SwiftUI

class TimeTrackingViewModel: ObservableObject {
    @Published var timeEntries: [TimeEntry] = []
    @Published var currentEntry: TimeEntry?
    @Published var isTracking = false
    @Published private var timer: Timer?
    @Published var elapsedTimeFormatted: String = "00:00:00"
    
    func startTracking() {
        isTracking = true
        let entry = TimeEntry(startTime: Date())
        currentEntry = entry
        timeEntries.insert(entry, at: 0)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateElapsedTime()
        }
    }
    
    func stopTracking() {
        timer?.invalidate()
        timer = nil
        if var entry = currentEntry {
            entry.endTime = Date()
            if let index = timeEntries.firstIndex(where: { $0.id == entry.id }) {
                timeEntries[index] = entry
            }
        }
        currentEntry = nil
        elapsedTimeFormatted = "00:00:00"
        isTracking = false
    }
    
    func addTimeEntry(_ entry: TimeEntry) {
        timeEntries.append(entry)
    }
    
    func deleteTimeEntry(at offsets: IndexSet) {
        timeEntries.remove(atOffsets: offsets)
    }
    
    func addBreak(duration: TimeInterval) {
        if var entry = currentEntry {
            entry.breakDuration += duration
            if let index = timeEntries.firstIndex(where: { $0.id == entry.id }) {
                timeEntries[index] = entry
            }
            currentEntry = entry
        }
    }
    
    private func updateElapsedTime() {
        guard let entry = currentEntry else { return }
        let elapsed = Date().timeIntervalSince(entry.startTime) - entry.breakDuration
        let hours = Int(elapsed) / 3600
        let minutes = Int(elapsed) / 60 % 60
        let seconds = Int(elapsed) % 60
        elapsedTimeFormatted = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    deinit {
        timer?.invalidate()
    }
}
