import Foundation
import SwiftUI

class LoadsViewModel: ObservableObject {
    @Published var loads: [Load] = []
    @Published var isLoading = false
    @Published var selectedLoad: Load?
    
    func addLoad(_ load: Load) {
        loads.append(load)
        // In a real app, we would save to persistent storage here
    }
    
    func updateLoad(_ load: Load) {
        if let index = loads.firstIndex(where: { $0.id == load.id }) {
            loads[index] = load
        }
    }
    
    func deleteLoad(_ load: Load) {
        loads.removeAll { $0.id == load.id }
    }
    
    func generatePDFReport() -> Data? {
        // Implementation for PDF generation would go here
        return nil
    }
    
    func calculateEarnings(for load: Load, paymentSettings: PaymentSettings) -> Double {
        switch paymentSettings.method {
        case .hourly:
            // Would need to calculate based on time entries
            return 0
        case .daily:
            return paymentSettings.rate
        case .perLoad:
            return paymentSettings.rate
        case .perLitre:
            // Would need fuel consumption data
            return 0
        }
    }
}
