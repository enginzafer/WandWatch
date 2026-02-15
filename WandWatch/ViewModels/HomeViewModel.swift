//
//  HomeViewModel.swift
//  WandWatch
//
//  Created by Engin Zafer Sönmez on 13.01.2026.
//

import Foundation
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    
    //Trend Filmler
    @Published var trendingMovies: [Media] = []
    
    // Arama Sonuçları
    @Published var searchResults: [Media] = []
    
    // Arama Metni
    @Published var searchText: String = ""
    
    @Published var isLoading: Bool = false // Yükleniyor dönmesi için
    @Published var errorMessage: String? = nil //Hata olursa ekrana basmak için
    @Published var recommendedMovies: [Media] = []
    @Published var recommendationSourceTitle: String = ""
    
    // Arama metnini dinlemek için
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        //İlk açılışta trendleri çek
        
        Task {
            await fetchTrending()
        }
        
        //Kullanıcı yazarken her harfte istek atmasın, yazmayı bitirmesini beklesin (0.5sn)
        $searchText
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                if !query.isEmpty {
                    Task { await self?.performSearch(query: query) }
                } else {
                    self?.searchResults = [] // Arama silinirse sonuçları temizle
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchTrending() async {
        isLoading = true
        do {
            let movies = try await APIServices.shared.fetchPopularMovies()
            self.trendingMovies = movies
            isLoading = false
        } catch {
            self.errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    
    func performSearch(query: String) async {
        //isLoading yapmıyoruz ki trendler kaybolmasın, arama alta gelsin
        do {
            let results = try await APIServices.shared.searchMulti(query: query)
            self.searchResults = results
        } catch {
            print("Arama Hatası: \(error)")
        }
    }
    
    func fetchSmartRecommendations(watchedMovies: [SavedMedia]) async {
        //isWatched == true ve >7 olanları bul
        let likedMovies = watchedMovies.filter { $0.isWatched && ($0.userRating ?? 0) >= 7 }
        
        //Hiç veri yoksa, son izlediğini al. O da yoksa rastgele birini al.
        let sourceMovie = likedMovies.randomElement() ?? watchedMovies.filter { $0.isWatched }.last
        
        guard let seed = sourceMovie else { return } //Hiç izlediği yoksa yapacak bişey yok
        
        do {
            //API'den benzerlerini çek
            let recommendations = try await APIServices.shared.fetchRecommendations(for: seed.id, mediaType: seed.mediaType)
            
            // Ekrana yansıt
            // Zaten izlemiş olduğunu listeden çıkart ki tekrar önermesin
            let watchedIDs = watchedMovies.map { $0.id }
            self.recommendedMovies = recommendations.filter { !watchedIDs.contains($0.id) }
            
            self.recommendationSourceTitle = "\"\(seed.title)\" izlediğin için öneriler"
        } catch {
            print("Öneri hatası: \(error)")
        }
    }
}

