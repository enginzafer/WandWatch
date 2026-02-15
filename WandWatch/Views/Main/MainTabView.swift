//
//  MainTabView.swift
//  WandWatch
//
//  Created by Engin Zafer Sönmez on 13.01.2026.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            //1. Sekme: Keşfet
            HomeView()
                .tabItem {
                    Label("Keşfet", systemImage: "film")
                }
            
            //2. Sekme: Listem
            WatchListView()
                .tabItem {
                    Label("Listem", systemImage: "list.and.film")
                }
            
            //3. Ayarlar
            SettingsView()
                .tabItem {
                    Label("Ayarlar",systemImage: "gear")
                }
        }
        //TabBar'ın rengini belirleyelim (opsiyonel)
        .accentColor(.red)
    }
}

#Preview {
    MainTabView()
}
