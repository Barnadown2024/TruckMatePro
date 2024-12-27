import SwiftUI

struct AddTimeEntryView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: TimeTrackingViewModel
    @State private var showingError = false
    @State private var errorMessage = ""
    
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var notes = ""
    @State private var breakDuration: Double = 0
    
    private var isValidEntry: Bool {
        if endTime < startTime {
            errorMessage = "End time must be after start time"
            return false
        }
        
        let duration = endTime.timeIntervalSince(startTime)
        if duration > 24 * 3600 {
            errorMessage = "Time entry cannot exceed 24 hours"
            return false
        }
        
        if breakDuration * 60 >= duration {
            errorMessage = "Break duration cannot be longer than total time"
            return false
        }
        
        return true
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Time")) {
                    DatePicker("Start Time", selection: $startTime)
                    DatePicker("End Time", selection: $endTime)
                }
                
                Section(header: Text("Break")) {
                    Picker("Break Duration", selection: $breakDuration) {
                        Text("No Break").tag(0.0)
                        Text("15 minutes").tag(15.0)
                        Text("30 minutes").tag(30.0)
                        Text("45 minutes").tag(45.0)
                        Text("1 hour").tag(60.0)
                    }
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Add Time Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if isValidEntry {
                            let entry = TimeEntry(
                                date: startTime,
                                startTime: startTime,
                                endTime: endTime,
                                breakDuration: breakDuration * 60,
                                notes: notes.isEmpty ? nil : notes
                            )
                            viewModel.addTimeEntry(entry)
                            dismiss()
                        } else {
                            showingError = true
                        }
                    }
                }
            }
            .alert("Invalid Entry", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
}

#Preview {
    AddTimeEntryView(viewModel: TimeTrackingViewModel())
}
