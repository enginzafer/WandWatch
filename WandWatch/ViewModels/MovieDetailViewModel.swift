//
//  MovieDetailViewModel.swift
//  WandWatch
//
//  Created by Engin Zafer Sönmez on 13.01.2026.
//


import Foundation
import SwiftUI
import Combine

@MainActor
class MovieDetailViewModel: ObservableObject {
    @Published var myPlatforms: [Provider] = []
    @Published var otherPlatforms: [Provider] = []
    @Published var watchLink: String?
    
    // YENİ: Detay verisi (Süre, Sezon vs.)
    @Published var detail: MediaDetail?
    
    @Published var isLoading: Bool = false
    
    func loadProviders(mediaId: Int, mediaType: String) async {
        isLoading = true
        // Temizlik
        self.myPlatforms = []
        self.otherPlatforms = []
        self.watchLink = nil
        self.detail = nil
        
        do {
            // async let ile iki API isteğini (Platformlar ve Detaylar) AYNI ANDA başlatıyoruz.
            // Böylece süre kaybı olmuyor.
            async let providersTask = APIServices.shared.fetchWatchProviders(id: mediaId, mediaType: mediaType)
            async let detailTask = APIServices.shared.fetchMediaDetail(id: mediaId, mediaType: mediaType)
            
            // İkisinin de bitmesini bekle
            let (fetchedProviders, link) = try await providersTask
            let fetchedDetail = try await detailTask
            
            // Verileri kaydet
            self.watchLink = link
            self.detail = fetchedDetail // İşte bu kısım eksikti!
            
            // Platform eşleştirme mantığı
            let userPlatformIDs = PlatformManager.shared.getSelectedIDs()
            self.myPlatforms = fetchedProviders.filter { userPlatformIDs.contains($0.providerId) }
            self.otherPlatforms = fetchedProviders.filter { !userPlatformIDs.contains($0.providerId) }
            
        } catch {
            print("Veri çekme hatası: \(error)")
        }
        isLoading = false
    }
}
