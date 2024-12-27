import SwiftUI

struct LandingView: View {
    @State private var showMainApp = false
    
    var body: some View {
        Group {
            if showMainApp {
                MainTabView()
            } else {
                onboardingView
            }
        }
        .navigationBarHidden(true)
    }
    
    private var onboardingView: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.8), .blue.opacity(0.4)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    // Logo and Title
                    VStack(spacing: 20) {
                        Image(systemName: "truck.box.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.white)
                        
                        Text("TruckMate Pro")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Your Complete Trucking Companion")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.top, 60)
                    
                    // Feature Cards
                    VStack(spacing: 20) {
                        FeatureCard(
                            icon: "shippingbox.fill",
                            title: "Load Tracking",
                            description: "Easily manage and track all your loads in one place"
                        )
                        
                        FeatureCard(
                            icon: "clock.fill",
                            title: "Time Management",
                            description: "Track your work hours and breaks efficiently"
                        )
                        
                        FeatureCard(
                            icon: "dollarsign.circle.fill",
                            title: "Payment Methods",
                            description: "Support for hourly, daily, per load, and per litre payments"
                        )
                        
                        FeatureCard(
                            icon: "calendar.badge.clock",
                            title: "Holiday Requests",
                            description: "Manage your time off with easy holiday requests"
                        )
                    }
                    .padding(.horizontal)
                    
                    // Get Started Button
                    Button {
                        withAnimation(.easeInOut) {
                            showMainApp = true
                        }
                    } label: {
                        Text("Get Started")
                            .font(.title3.bold())
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 20)
                    .padding(.bottom, 50)
                }
            }
        }
    }
}

struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(Color.white.opacity(0.2))
                .cornerRadius(15)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
    }
}

#Preview {
    NavigationView {
        LandingView()
    }
}
