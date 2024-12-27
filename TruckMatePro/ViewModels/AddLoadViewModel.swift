import SwiftUI

class AddLoadViewModel: ObservableObject {
    @Published var date = Date()
    @Published var truckNumber = ""
    @Published var loadNumber = ""
    @Published var category: LoadCategory = .general
    @Published var pickupLocation = ""
    @Published var deliveryLocation = ""
    @Published var weight: Double = 0
    @Published var description = ""
    
    private let loadsViewModel: LoadsViewModel
    
    init(loadsViewModel: LoadsViewModel) {
        self.loadsViewModel = loadsViewModel
    }
    
    var isValidForm: Bool {
        !truckNumber.isEmpty &&
        !loadNumber.isEmpty &&
        !pickupLocation.isEmpty &&
        !deliveryLocation.isEmpty &&
        weight > 0
    }
    
    func saveLoad() {
        let load = Load(
            date: date,
            truckNumber: truckNumber,
            loadNumber: loadNumber,
            category: category,
            pickupLocation: pickupLocation,
            deliveryLocation: deliveryLocation,
            weight: weight,
            description: description
        )
        
        loadsViewModel.addLoad(load)
    }
}
