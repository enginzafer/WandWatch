//
//  Media.swift
//  WandWatch
//
//  Created by Engin Zafer Sönmez on 12.01.2026.
//

import Foundation

enum MediaType: String, Codable {
    case movie = "movie"
    case tv = "tv"
    case unknown // Bilinmeyen gelirse diye
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawString = try? container.decode(String.self)
        self = MediaType(rawValue: rawString ?? "") ?? .unknown
    }
}

struct Media: Identifiable, Codable {
    let id: Int
    let title: String? //Filmler için
    let name: String? //Diziler için
    let overview: String?
    let posterPath: String?
    let mediaType: MediaType? //String yerine Enum yaptık
    let voteAverage: Double?
    let releaseDate: String?
    let firstAirDate: String?
    let platform: [String]? //Tek bir platform değil, birden fazla olabilir.
    
    
    // 2. Adım: Virew Katmanını rahatlatacak yardımcılar (Helpers)
    
    var displayTitle: String {
        return title ?? name ?? "İsimsiz İçerik"
    }
    
    var displayOverview: String {
        return overview ?? "Henüz bir açıklama girilmemiş."
    }
    
    // Puanı formatlı göstermek için (Örn. 7.8)
    var displayVote: String {
        guard let vote = voteAverage else { return "N/A" }
        return String(format: "%.1f", vote)
    }
    
    
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        //NOT: Base URL'i buraya koymak geçici çözümdür. İlerde bunu Config dosyasına taşıyacağız.
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id, title, name, overview, platform
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
    }
}

extension Media {
    static let mock = Media(
        id: 1,
        title: "Inception",
        name: nil,
        overview: "Rüya içinde rüya...",
        posterPath: "/9gk7admal4zl67YRxIo2sR2B656.jpg",
        mediaType: .movie,
        voteAverage: 8.8,
        releaseDate: "2010-07-16",
        firstAirDate: nil,
        platform: ["Netflix","Appple TV"]
    )
}
