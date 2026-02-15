//
//  SavedMedia.swift
//  WandWatch
//
//  Created by Engin Zafer Sönmez on 13.01.2026.
//

import Foundation
import SwiftData


// @Model: Bu sınıfın bir veritabanı tablosu olduğunu söyler.
@Model
class SavedMedia {
    @Attribute(.unique) var id: Int
    var title: String
    var overview: String
    var posterPath: String?
    var voteAverage: Double
    var mediaType: String // "Movie" veya "TV"
    
    // --- DURUM BİLGİLERİ ---
    var isWatched: Bool = false
    
    // --- KULLANICI GÜNLÜĞÜ ---
    var startDate: Date?
    var finishDate: Date?
    var userRating: Int?
    var userReview: String?
    
    var savedDate: Date
    
    
    
    init(id: Int,
         title: String,
         overview: String,
         posterPath: String?,
         voteAverage: Double,
         mediaType: String,
         isWatched: Bool = false,
         startDate: Date? = nil,
         finishDate: Date? = nil,
         userRating: Int? = nil,
         userReview: String? = nil,
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.voteAverage = voteAverage
        self.mediaType = mediaType
        self.isWatched = isWatched
        self.startDate = startDate
        self.finishDate = finishDate
        self.userRating = userRating
        self.userReview = userReview
        
        self.savedDate = Date()
    }
    
    
    //Model Dönüşümü
    func toMedia() -> Media {
        let type = MediaType(rawValue: self.mediaType) ?? .unknown
        return Media(
            id: self.id,
            title: self.title,
            name: self.title,
            overview: self.overview,
            posterPath: self.posterPath,
            mediaType: type,
            voteAverage: self.voteAverage,
            releaseDate: nil,
            firstAirDate: nil,
            platform: nil
        )
    }
}
