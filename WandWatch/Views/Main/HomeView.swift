//
//  HomeView.swift
//  WandWatch
//
//  Created by Engin Zafer Sönmez on 13.01.2026.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    //1. Veritabanından "İzlenmemiş" (isWatched == false) filmleri çek
    @Query(filter: #Predicate<SavedMedia> { $0.isWatched == false }, sort: \.savedDate, order: .reverse)
    var moviesToWatch: [SavedMedia]
    
    @Query(filter: #Predicate<SavedMedia> { $0.isWatched == true })
    var watchedMovies: [SavedMedia]
    
    
    // Klavyenin Açık/kapalı olma durumu
    @FocusState private var isSearchFocused: Bool
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // 1. Arama Çubuğu
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.gray)
                        
                        //Yazı Alanı
                        TextField("Dizi, Film ara...", text: $viewModel.searchText)
                            .focused($isSearchFocused)
                            .submitLabel(.search)
                        
                        
                        
                        //Çarpı (X) Butonu
                        if !viewModel.searchText.isEmpty {
                            Button(action: {
                                viewModel.searchText = ""
                                isSearchFocused = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.gray)
                            }
                            .transition(.scale.combined(with: .opacity)) //animasyonlu geçiş
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .animation(.default, value: viewModel.searchText) //Yazı değişince animasyon çalışsın
                    
                    // --- İÇERİK ---
                    
                    // Durum 1: Arama Yapıldığı zaman
                    if !viewModel.searchText.isEmpty {
                        Text("Arama Sonuçları")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if viewModel.searchResults.isEmpty {
                            ContentUnavailableView(
                                "Sonuç Bulunamadı",
                                systemImage: "magnifyingglass",
                                description: Text("\"\(viewModel.searchText)\" için bir şey bulamadık. Diğer şeyler deneyebilirsin!")
                            )
                        } else {
                            // Arama Sonuçları Listesi
                            LazyVStack {
                                ForEach(viewModel.searchResults) { media in
                                    NavigationLink(destination: MovieDetailView(media: media)) {
                                        MediaRowView(media: media)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    //Durum 2: Normal Ana Sayfa
                    else {
                        //Hoşgeldiniz Mesajı
                        VStack(alignment: .leading, spacing: 5) {
                            Text("WandWatch'a Hoşgeldin! 🪄")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                            
                            Text("Bugün ne izlemek istersin?")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        // --- 1. KULLANICININ İZLEYECEĞİ FİLMLER (SwiftData) ---
                        if !moviesToWatch.isEmpty {
                            VStack(alignment: .leading) {
                                Label("İzleme Listen", systemImage: "bookmark.fill")
                                    .font(.title3).fontWeight(.bold).padding(.horizontal)
                                    .foregroundColor(.blue)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHStack(spacing: 16) {
                                        ForEach(moviesToWatch) { savedMovie in
                                            NavigationLink(destination: MovieDetailView(media: savedMovie.toMedia())) {
                                                TrendingCardView(media: savedMovie.toMedia())
                                            }
                                            .buttonStyle(.plain) // Yazılar siyah kalsın
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        
                        if !viewModel.recommendedMovies.isEmpty {
                            VStack(alignment: .leading) {
                                Text(viewModel.recommendationSourceTitle) // "Matrix izlediğin için..."
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .padding(.horizontal)
                                    .lineLimit(1)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHStack(spacing: 16) {
                                        ForEach(viewModel.recommendedMovies) { movie in
                                            NavigationLink(destination: MovieDetailView(media: movie)) {
                                                TrendingCardView(media: movie)
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        
                        
                        // --- 2. TRENDLER (API) ---
                        VStack(alignment: .leading) {
                            Text("Trendler")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 16) {
                                    ForEach(viewModel.trendingMovies) { movie in
                                        NavigationLink(destination: MovieDetailView(media: movie)) {
                                            TrendingCardView(media: movie)
                                        }
                                        .buttonStyle(.plain) // Yazılar siyah kalsın
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.bottom, 20)
            }
            .navigationBarHidden(true)
            .onAppear {
                if !viewModel.searchText.isEmpty {
                    viewModel.searchText = ""
                    isSearchFocused = false
                }
                
                Task {
                    await viewModel.fetchSmartRecommendations(watchedMovies: watchedMovies)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
