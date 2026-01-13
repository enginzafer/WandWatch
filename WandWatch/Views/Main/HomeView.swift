//
//  HomeView.swift
//  WandWatch
//
//  Created by Engin Zafer Sönmez on 13.01.2026.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    
    
    var body: some View {
        NavigationStack {
            List {
                //Viewmodel içinde 'movies' listesini döneceğiz
                ForEach(viewModel.movies) { movie in
                    MediaRowView(media: movie)
                }
            }
            .listStyle(.plain)
            .navigationTitle("WandWatch")
        }
    }
}

#Preview {
    HomeView()
}
