//
//  WatchListView.swift
//  WandWatch
//
//  Created by Engin Zafer Sönmez on 13.01.2026.
//

import SwiftUI
import SwiftData


struct WatchListView: View {
    
    //DB'deki kayıltları 'eklenme tarihine' göre sondan başa sırala
    @Query(sort: \SavedMedia.savedDate, order: .reverse) var allMovies: [SavedMedia]
    @Environment(\.modelContext) private var context
    
    //Seçili sekme: 0 -> izleyeceklerim, 1 -> İzlediklerim
    @State private var selectedTab = 0
    
    //Seçili sekmeye göre listeyi filtreleyen hesaplanmış özellik
    var filteredMovies: [SavedMedia] {
        if selectedTab == 0 {
            return allMovies.filter { $0.isWatched == false } // İzlenmemişler
        } else {
            return allMovies.filter { $0.isWatched == true } //İzlenmişler
        }
    }
    
    
    
    var body: some View {
        NavigationStack {
            VStack {
                // --- Segmented Control (Sekmeler)
                Picker("Liste Türü", selection: $selectedTab) {
                    Text("İzleneceklerim").tag(0)
                    Text("İzlediklerim").tag(1)
                }
                .pickerStyle(.segmented)
                .padding()
                
                
                // ---LİSTE---
                if filteredMovies.isEmpty {
                    ContentUnavailableView(
                        selectedTab == 0 ? "Listeniz Boş" : "Henüz bir şey izlemedin.",
                        systemImage: selectedTab == 0 ? "bookmark.slash" : "video.slash",
                        description: Text(selectedTab == 0 ? "İzlemek istediğim filmleri ekle." : "İzlediğin filmleri işaretle.")
                    )
                } else {
                    List {
                        ForEach(filteredMovies) { savedMovie in
                            NavigationLink(destination: MovieDetailView(media: savedMovie.toMedia())) {
                                HStack {
                                    if let path = savedMovie.posterPath,
                                       let url = URL(string: "https://image.tmdb.org/t/p/w200\(path)") {
                                        AsyncImage(url: url) { image in
                                            image.resizable()
                                        } placeholder: {
                                            Color.gray
                                        }
                                        .frame(width: 50, height: 75)
                                        .cornerRadius(8)
                                    }
                                    
                                    
                                    VStack(alignment: .leading) {
                                        Text(savedMovie.title).font(.headline)
                                        if savedMovie.isWatched {
                                            Text("İzlendi").font(.caption).foregroundStyle(.green)
                                        } else {
                                            Text("İzlenecek").font(.caption).foregroundStyle(.blue)
                                        }
                                    }
                                }
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Kütüphanem")
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            // Filtrelenmiş listeden indeksi bulup asıl veriden siliyoruz
            for index in offsets {
                let movieToDelete = filteredMovies[index]
                context.delete(movieToDelete)
            }
        }
    }
}

#Preview {
    WatchListView()
        .modelContainer(for: SavedMedia.self, inMemory: true)
}
