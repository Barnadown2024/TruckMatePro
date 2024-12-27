import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @State private var showingCurrencyPicker = false
    @FocusState private var focusedField: FocusField?
    
    enum FocusField {
        case rate
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Payment Settings")) {
                    Picker("Payment Method", selection: $viewModel.paymentSettings.method) {
                        ForEach(PaymentMethod.allCases, id: \.self) { method in
                            Text(method.displayName)
                                .tag(method)
                        }
                    }
                    
                    HStack {
                        Text("Rate")
                        Spacer()
                        TextField("Rate", value: $viewModel.paymentSettings.rate, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused($focusedField, equals: .rate)
                            .frame(width: 100)
                    }
                    
                    Button {
                        showingCurrencyPicker = true
                    } label: {
                        HStack {
                            Text("Currency")
                            Spacer()
                            Text(viewModel.paymentSettings.currency)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section(header: Text("App Settings")) {
                    Toggle("Dark Mode", isOn: $viewModel.isDarkMode)
                    Toggle("Notifications", isOn: $viewModel.notificationsEnabled)
                }
                
                Section(header: Text("Data Management")) {
                    Button("Export Data") {
                        viewModel.exportData()
                    }
                    
                    Button("Clear All Data") {
                        viewModel.showClearDataAlert = true
                    }
                    .foregroundColor(.red)
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(viewModel.appVersion)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Settings")
            .alert("Clear All Data", isPresented: $viewModel.showClearDataAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Clear", role: .destructive) {
                    viewModel.clearAllData()
                }
            } message: {
                Text("This will permanently delete all your data. This action cannot be undone.")
            }
            .sheet(isPresented: $showingCurrencyPicker) {
                CurrencyPickerView(selection: $viewModel.paymentSettings.currency)
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button("Done") {
                        focusedField = nil
                    }
                }
            }
        }
    }
}

class SettingsViewModel: ObservableObject {
    @Published var paymentSettings = PaymentSettings(method: .hourly, rate: 0)
    @Published var isDarkMode = false
    @Published var notificationsEnabled = true
    @Published var showClearDataAlert = false
    
    let appVersion = "1.0.0"
    
    func exportData() {
        // Implementation for data export would go here
    }
    
    func clearAllData() {
        // Implementation for clearing data would go here
    }
}

struct CurrencyPickerView: View {
    @Binding var selection: String
    @Environment(\.dismiss) var dismiss
    
    let currencies = ["EUR", "USD", "GBP", "CAD", "AUD"]
    
    var body: some View {
        NavigationView {
            List(currencies, id: \.self) { currency in
                Button {
                    selection = currency
                    dismiss()
                } label: {
                    HStack {
                        Text(currency)
                        Spacer()
                        if currency == selection {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Select Currency")
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
        }
    }
}

#Preview {
    SettingsView()
}
