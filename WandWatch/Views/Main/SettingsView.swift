//
//  SettingsView.swift
//  WandWatch
//
//  Created by Engin Zafer Sönmez on 28.01.2026.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = true
    
    
    var body: some View {
        NavigationStack {
            List {
                Section("Tercihler") {
                    Button(action: {
                        hasCompletedOnboarding = false
                    }) {
                        HStack {
                            Image(systemName: "tv.and.mediabox")
                                .foregroundStyle(.blue)
                            Text("Aboneliklerimi Düzenle")
                                .foregroundStyle(.primary)
                        }
                    }
                }
                
                Section("Uygulama Hakkında") {
                    HStack {
                        Text("Sürüm")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Yapımcı")
                            Spacer()
                        Text("Valus Apps")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Ayarlar")
        }
    }
}

#Preview {
    SettingsView()
}
