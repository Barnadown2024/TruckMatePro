//
//  TruckMateProApp.swift
//  TruckMatePro
//
//  Created by Diarmuid on 27/12/2024.
//

import SwiftUI

@main
struct TruckMateProApp: App {
    @StateObject private var userManager = UserManager()
    
    var body: some Scene {
        WindowGroup {
            if userManager.isAuthenticated {
                MainTabView()
                    .environmentObject(userManager)
            } else {
                LoginView()
                    .environmentObject(userManager)
            }
        }
    }
}
