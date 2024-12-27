import SwiftUI

struct MainTabView: View {
    @StateObject private var loadsViewModel = LoadsViewModel()
    @StateObject private var timeTrackingViewModel = TimeTrackingViewModel()
    @State private var selectedTab = 0
    @State private var showingAddLoad = false
    @State private var showingAddTimeEntry = false
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        TabView(selection: $selectedTab) {
            LoadsView(viewModel: loadsViewModel)
                .tabItem {
                    Label("Loads", systemImage: "shippingbox.fill")
                }
                .tag(0)
            
            TimeTrackingView(viewModel: timeTrackingViewModel)
                .tabItem {
                    Label("Time", systemImage: "clock.fill")
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(2)
            
            HolidaysView()
                .tabItem {
                    Label("Holidays", systemImage: "calendar")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(4)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    userManager.signOut()
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                }
            }
        }
        .sheet(isPresented: $showingAddLoad) {
            AddLoadView(loadsViewModel: loadsViewModel)
        }
        .sheet(isPresented: $showingAddTimeEntry) {
            AddTimeEntryView(viewModel: timeTrackingViewModel)
        }
        .overlay(alignment: .bottom) {
            if selectedTab == 0 || selectedTab == 1 {
                AddButton(action: {
                    if selectedTab == 0 {
                        showingAddLoad = true
                    } else {
                        showingAddTimeEntry = true
                    }
                })
                .padding(.bottom, 85)
            }
        }
        .accentColor(.blue)
    }
}

struct LoadsView: View {
    @ObservedObject var viewModel: LoadsViewModel
    @State private var showingAddLoad = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.loads) { load in
                    LoadRowView(load: load)
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.deleteLoad(load)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
            .navigationTitle("Loads")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddLoad = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddLoad) {
                AddLoadView(loadsViewModel: viewModel)
            }
        }
    }
}

struct LoadRowView: View {
    let load: Load
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(load.description)
                .font(.headline)
            
            HStack {
                Image(systemName: "mappin.circle.fill")
                    .foregroundColor(.blue)
                Text(load.pickupLocation)
                Image(systemName: "arrow.right")
                    .foregroundColor(.gray)
                Text(load.deliveryLocation)
            }
            .font(.subheadline)
            
            HStack {
                Text(load.date, style: .date)
                Spacer()
                LoadStatusBadge(status: load.status)
            }
            .font(.caption)
        }
        .padding(.vertical, 8)
    }
}

struct AddButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 55, height: 55)
                .foregroundColor(.blue)
                .background(Color.white)
                .clipShape(Circle())
                .shadow(radius: 3)
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        NavigationView {
            Form {
                if let user = userManager.user {
                    Section(header: Text("Personal Information")) {
                        HStack {
                            Text("Name")
                            Spacer()
                            Text(user.name)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("Email")
                            Spacer()
                            Text(user.email)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        userManager.signOut()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Sign Out")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(UserManager())
}
