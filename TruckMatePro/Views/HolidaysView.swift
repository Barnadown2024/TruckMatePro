import SwiftUI

struct HolidaysView: View {
    @StateObject private var viewModel = HolidaysViewModel()
    @State private var showingAddHoliday = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.holidayRequests) { request in
                    HolidayRequestRow(request: request)
                        .swipeActions {
                            if request.status == .pending {
                                Button(role: .destructive) {
                                    viewModel.deleteRequest(request)
                                } label: {
                                    Label("Cancel", systemImage: "xmark.circle")
                                }
                            }
                        }
                }
            }
            .navigationTitle("Holiday Requests")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddHoliday = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddHoliday) {
                AddHolidayView(viewModel: viewModel)
            }
        }
    }
}

struct HolidayRequestRow: View {
    let request: HolidayRequest
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(dateRangeText)
                    .font(.headline)
                Spacer()
                StatusBadge(status: request.status)
            }
            
            if let notes = request.notes {
                Text(notes)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if let responseDate = request.responseDate {
                Divider()
                VStack(alignment: .leading, spacing: 4) {
                    Text("Response: \(responseDate, style: .date)")
                        .font(.caption)
                    if let responseNotes = request.responseNotes {
                        Text(responseNotes)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    private var dateRangeText: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return "\(formatter.string(from: request.startDate)) - \(formatter.string(from: request.endDate))"
    }
}

struct StatusBadge: View {
    let status: HolidayRequestStatus
    
    var body: some View {
        Text(status.rawValue.capitalized)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(status.color).opacity(0.2))
            .foregroundColor(Color(status.color))
            .clipShape(Capsule())
    }
}

class HolidaysViewModel: ObservableObject {
    @Published var holidayRequests: [HolidayRequest] = []
    
    func addRequest(_ request: HolidayRequest) {
        holidayRequests.append(request)
        // In a real app, we would save to persistent storage here
    }
    
    func deleteRequest(_ request: HolidayRequest) {
        holidayRequests.removeAll { $0.id == request.id }
    }
}

struct AddHolidayView: View {
    @ObservedObject var viewModel: HolidaysViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Date Range")) {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("New Holiday Request")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Submit") {
                    let request = HolidayRequest(
                        startDate: startDate,
                        endDate: endDate,
                        notes: notes.isEmpty ? nil : notes
                    )
                    viewModel.addRequest(request)
                    dismiss()
                }
            )
        }
    }
}

#Preview {
    HolidaysView()
}
