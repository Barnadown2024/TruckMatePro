import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = SignUpViewModel()
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Full Name", text: $viewModel.name)
                        .textContentType(.name)
                        .autocapitalization(.words)
                    
                    TextField("Email", text: $viewModel.email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                Section(header: Text("Company Information")) {
                    TextField("Company Name", text: $viewModel.companyName)
                        .textContentType(.organizationName)
                    
                    TextField("Driver License Number", text: $viewModel.driverLicense)
                        .textContentType(.none)
                        .autocapitalization(.allCharacters)
                }
                
                Section(header: Text("Security")) {
                    SecureField("Password", text: $viewModel.password)
                        .textContentType(.newPassword)
                    
                    SecureField("Confirm Password", text: $viewModel.confirmPassword)
                        .textContentType(.newPassword)
                }
                
                if !viewModel.validationMessage.isEmpty {
                    Section {
                        Text(viewModel.validationMessage)
                            .foregroundColor(.red)
                            .font(.callout)
                    }
                }
                
                Section {
                    Button(action: createAccount) {
                        HStack {
                            Spacer()
                            Text("Create Account")
                                .bold()
                            Spacer()
                        }
                    }
                    .disabled(!viewModel.isFormValid())
                }
            }
            .navigationTitle("Create Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Error", isPresented: $viewModel.showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.validationMessage)
            }
        }
    }
    
    private func createAccount() {
        if viewModel.validateInputs() {
            let success = userManager.createAccount(
                name: viewModel.name,
                email: viewModel.email,
                password: viewModel.password,
                companyName: viewModel.companyName,
                driverLicense: viewModel.driverLicense
            )
            
            if success {
                dismiss()
            }
        }
    }
}

class SignUpViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var companyName = ""
    @Published var driverLicense = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var validationMessage = ""
    @Published var showingError = false
    
    private let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    func isFormValid() -> Bool {
        !name.isEmpty &&
        !email.isEmpty &&
        !companyName.isEmpty &&
        !driverLicense.isEmpty &&
        !password.isEmpty &&
        !confirmPassword.isEmpty &&
        password == confirmPassword &&
        password.count >= 8
    }
    
    func validateInputs() -> Bool {
        // Reset validation state
        validationMessage = ""
        
        // Name validation
        if name.trimmingCharacters(in: .whitespaces).isEmpty {
            validationMessage = "Please enter your full name"
            showingError = true
            return false
        }
        
        // Email validation
        if !NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email) {
            validationMessage = "Please enter a valid email address"
            showingError = true
            return false
        }
        
        // Company validation
        if companyName.trimmingCharacters(in: .whitespaces).isEmpty {
            validationMessage = "Please enter your company name"
            showingError = true
            return false
        }
        
        // Driver license validation
        if driverLicense.trimmingCharacters(in: .whitespaces).isEmpty {
            validationMessage = "Please enter your driver license number"
            showingError = true
            return false
        }
        
        // Password validation
        if password.count < 8 {
            validationMessage = "Password must be at least 8 characters"
            showingError = true
            return false
        }
        
        if password != confirmPassword {
            validationMessage = "Passwords do not match"
            showingError = true
            return false
        }
        
        return true
    }
}

#Preview {
    SignUpView()
        .environmentObject(UserManager())
}
