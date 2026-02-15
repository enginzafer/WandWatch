//
//  WandWatchApp.swift
//  WandWatch
//
//  Created by Engin Zafer Sönmez on 12.01.2026.
//

import SwiftUI
import SwiftData
import GoogleMobileAds

@main
struct WandWatchApp: App {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    
    init() {
        MobileAds.shared.start(completionHandler: nil)
    }
    
    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingView()
            }
        }
        .modelContainer(for: SavedMedia.self) // Veritabanı konteynerini tanıt
    }
}
