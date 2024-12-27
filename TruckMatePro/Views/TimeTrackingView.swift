import SwiftUI

struct TimeTrackingView: View {
    @ObservedObject var viewModel: TimeTrackingViewModel
    @State private var showingAddTimeEntry = false
    
    var body: some View {
        NavigationView {
            List {
                if viewModel.isTracking, let currentEntry = viewModel.currentEntry {
                    Section(header: Text("Current Session")) {
                        TimeEntryRow(entry: currentEntry)
                            .listRowBackground(Color.blue.opacity(0.1))
                    }
                }
                
                Section(header: Text("Time Entries")) {
                    ForEach(viewModel.timeEntries) { entry in
                        TimeEntryRow(entry: entry)
                    }
                    .onDelete(perform: viewModel.deleteTimeEntry)
                }
            }
            .navigationTitle("Time Tracking")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(viewModel.isTracking ? "Stop" : "Start") {
                        if viewModel.isTracking {
                            viewModel.stopTracking()
                        } else {
                            viewModel.startTracking()
                        }
                    }
                    .foregroundColor(viewModel.isTracking ? .red : .blue)
                }
            }
        }
    }
}

struct TimeEntryRow: View {
    let entry: TimeEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(entry.date, style: .date)
                .font(.headline)
            
            HStack {
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.blue)
                    Text(entry.startTime, style: .time)
                }
                .font(.subheadline)
                
                if let endTime = entry.endTime {
                    Text("to")
                        .foregroundColor(.secondary)
                    Text(endTime, style: .time)
                        .font(.subheadline)
                } else {
                    Text("(Active)")
                        .foregroundColor(.blue)
                        .italic()
                }
            }
            
            if entry.breakDuration > 0 {
                Text("Break: \(Int(entry.breakDuration / 60)) min")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    TimeTrackingView(viewModel: TimeTrackingViewModel())
}
