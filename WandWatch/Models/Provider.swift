//
//  Provider.swift
//  WandWatch
//
//  Created by Engin Zafer Sönmez on 13.01.2026.
//

import Foundation
import Combine

// API'den gelen cevap karmaşık bir yapıda (JSON içinde JSON). Bu yüzden iç içe struct'lar kullanacağız.

// 1. Ana cevap

struct ProviderResponse: Codable {
    let results: [String: CountryProvider]?
    
}

struct CountryProvider: Codable {
    let link: String?               // TMDB'nin yönlendirme linki
    let flatrate: [Provider]?       // "Abonelik" ile izlenenler (Netflix, Disney+ vs)
    let rent: [Provider]?           // "Kiralananlar" (Apple TV, Google Play vs)
    let buy: [Provider]?            // "Satın alınanlar"
}


// 3. Tekil Platform Bilgisi
struct Provider: Codable, Identifiable {
    let providerId: Int
    let providerName: String
    let logoPath: String?
    
    var id: Int {
        providerId
    }
    
    
    // Logo URL'i
    var logoURL: URL? {
        guard let path = logoPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/original\(path)")
    }
    
    
    enum CodingKeys: String, CodingKey {
        case providerId = "provider_id"
        case providerName = "provider_name"
        case logoPath = "logo_path"
    }
}
