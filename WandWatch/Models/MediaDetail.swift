//
//  MediaDetail.swift
//  WandWatch
//
//  Created by Engin Zafer Sönmez on 27.01.2026.
//

import Foundation

struct MediaDetail: Codable {
    let runtime: Int?
    let numberOfSeasons: Int?
    let numberOfEpisodes: Int?
    
    enum CodingKeys: String, CodingKey {
        case runtime
        case numberOfSeasons = "number_of_seasons"
        case numberOfEpisodes = "number_of_episodes"
    }
    
    var formattedRuntime: String {
        guard let minutes = runtime, minutes > 0 else { return "" }
        let hours = minutes / 60
        let mins = minutes % 60
        return "\(hours)sa \(mins)dk"
    }
    
    var formattedSeasons: String {
        guard let seasons = numberOfSeasons else { return "" }
        let episodes = numberOfEpisodes ?? 0
        return "\(seasons) Sezon • \(episodes) Bölüm"
    }
}

