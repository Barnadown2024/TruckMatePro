import SwiftUI

struct AddLoadView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: AddLoadViewModel
    
    init(loadsViewModel: LoadsViewModel) {
        _viewModel = StateObject(wrappedValue: AddLoadViewModel(loadsViewModel: loadsViewModel))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Load Details")) {
                    DatePicker("Date", selection: $viewModel.date, displayedComponents: [.date])
                    
                    TextField("Truck No.", text: $viewModel.truckNumber)
                        .keyboardType(.numberPad)
                    
                    TextField("Load No.", text: $viewModel.loadNumber)
                        .keyboardType(.numberPad)
                    
                    Picker("Category", selection: $viewModel.category) {
                        ForEach(LoadCategory.allCases, id: \.self) { category in
                            Label(category.rawValue, systemImage: category.icon)
                                .tag(category)
                        }
                    }
                }
                
                Section(header: Text("Location")) {
                    TextField("Pickup Location", text: $viewModel.pickupLocation)
                    TextField("Delivery Location", text: $viewModel.deliveryLocation)
                }
                
                Section(header: Text("Details")) {
                    TextField("Weight (kg)", value: $viewModel.weight, format: .number)
                        .keyboardType(.decimalPad)
                    
                    TextField("Description", text: $viewModel.description, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("New Load")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.saveLoad()
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddLoadView(loadsViewModel: LoadsViewModel())
}
