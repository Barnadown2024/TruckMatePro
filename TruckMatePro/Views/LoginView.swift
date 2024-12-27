import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject var userManager: UserManager
    @State private var showingSignUp = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // Logo and Title
                    VStack(spacing: 20) {
                        Image(systemName: "truck.box.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.blue)
                        
                        Text("TruckMate Pro")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                        
                        Text("Your Complete Trucking Companion")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 60)
                    
                    // Login Form
                    VStack(spacing: 20) {
                        TextField("Email", text: $viewModel.email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        SecureField("Password", text: $viewModel.password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textContentType(.password)
                        
                        Button(action: {
                            if userManager.signIn(email: viewModel.email, password: viewModel.password) {
                                viewModel.email = ""
                                viewModel.password = ""
                            }
                        }) {
                            Text("Sign In")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty)
                        
                        Button {
                            userManager.authenticate()
                        } label: {
                            HStack {
                                Image(systemName: "faceid")
                                Text("Sign in with Face ID")
                            }
                            .font(.headline)
                            .foregroundColor(.blue)
                        }
                        
                        Divider()
                            .padding(.vertical)
                        
                        Button {
                            showingSignUp = true
                        } label: {
                            Text("Create New Account")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .alert("Error", isPresented: $userManager.showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(userManager.errorMessage)
            }
            .sheet(isPresented: $showingSignUp) {
                SignUpView()
            }
        }
    }
}

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
}

#Preview {
    LoginView()
        .environmentObject(UserManager())
}
