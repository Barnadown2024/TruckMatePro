import SwiftUI
import LocalAuthentication
import CryptoKit

class UserManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var user: User?
    @Published var showingError = false
    @Published var errorMessage = ""
    @Published var biometricType: LABiometryType = .none
    
    private let userDefaults = UserDefaults.standard
    private let userKey = "savedUser"
    private let credentialsKey = "userCredentials"
    
    struct Credentials: Codable {
        let email: String
        let passwordHash: String
    }
    
    init() {
        loadUser()
        checkBiometricType()
    }
    
    private func checkBiometricType() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            biometricType = context.biometryType
        } else {
            biometricType = .none
        }
    }
    
    func createAccount(name: String, email: String, password: String, companyName: String, driverLicense: String) -> Bool {
        // Check if email already exists
        if let savedCredentials = loadCredentials(),
           savedCredentials.contains(where: { $0.email.lowercased() == email.lowercased() }) {
            showError("An account with this email already exists")
            return false
        }
        
        // Create new user
        let user = User(
            email: email,
            name: name,
            companyName: companyName,
            driverLicense: driverLicense
        )
        
        // Save user and credentials
        self.user = user
        saveUser(user)
        saveCredentials(email: email, password: password)
        isAuthenticated = true
        
        return true
    }
    
    func signIn(email: String, password: String) -> Bool {
        guard let credentials = loadCredentials(),
              let matchingCredential = credentials.first(where: { $0.email.lowercased() == email.lowercased() }),
              matchingCredential.passwordHash == hashPassword(password) else {
            showError("Invalid email or password")
            return false
        }
        
        if let userData = userDefaults.data(forKey: userKey),
           let user = try? JSONDecoder().decode(User.self, from: userData),
           user.email.lowercased() == email.lowercased() {
            self.user = user
            isAuthenticated = true
            return true
        }
        
        return false
    }
    
    func signOut() {
        isAuthenticated = false
        user = nil
    }
    
    private func loadUser() {
        if let userData = userDefaults.data(forKey: userKey),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            self.user = user
            self.isAuthenticated = true
        }
    }
    
    private func saveUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            userDefaults.set(encoded, forKey: userKey)
        }
    }
    
    private func loadCredentials() -> [Credentials]? {
        guard let data = userDefaults.data(forKey: credentialsKey) else { return [] }
        return try? JSONDecoder().decode([Credentials].self, from: data)
    }
    
    private func saveCredentials(email: String, password: String) {
        var credentials = loadCredentials() ?? []
        let newCredential = Credentials(email: email.lowercased(), passwordHash: hashPassword(password))
        credentials.append(newCredential)
        
        if let encoded = try? JSONEncoder().encode(credentials) {
            userDefaults.set(encoded, forKey: credentialsKey)
        }
    }
    
    private func hashPassword(_ password: String) -> String {
        let inputData = Data(password.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            DispatchQueue.main.async {
                self.showError("Biometric authentication not available: \(error?.localizedDescription ?? "Unknown error")")
            }
            return
        }
        
        let reason = "Log in to TruckMate Pro"
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
            DispatchQueue.main.async {
                if success {
                    self.isAuthenticated = true
                } else if let error = error as? LAError {
                    switch error.code {
                    case .userFallback:
                        // User tapped "Enter Password"
                        break
                    case .userCancel:
                        // User tapped "Cancel"
                        break
                    case .biometryNotEnrolled:
                        self.showError("No Face ID enrolled")
                    case .biometryNotAvailable:
                        self.showError("Face ID is not available")
                    default:
                        self.showError(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func showError(_ message: String) {
        errorMessage = message
        showingError = true
    }
}
