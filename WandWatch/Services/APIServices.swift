//
//  APIServices.swift
//  WandWatch
//
//  Created by Engin Zafer Sönmez on 13.01.2026.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
}


class APIServices {
    
    static let shared = APIServices() //Singleton örneği
    
    private init() {} //Başkası yeni bir APIService() oluşturamasın diye private yaptık.
    
    //Popüler Filmleri çeken fonksiyon
    // 'async' -> Bu işlem zaman alır, bekle.
    // 'throws' -> Hata fırlatabilir (İnternet yoksa vs.)
    func fetchPopularMovies() async throws -> [Media] {
        
        //1. URL Hazırlama
        let urlString = "\(APIConstants.baseURL)/movie/popular?api_key=\(APIConstants.apiKey)&language=tr-TR"
        
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        //2. İstek Atma (Network Request)
        //URLSession internete gidip veriyi (data) ve cevabı (response) getirir.
        let (data, response) = try await URLSession.shared.data(from: url)
        
        //Cevabın 200 (Başarılı) olup olmadığını kontrol et (Opsiyonel ama iyi pratik)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.serverError("Sunucu hatası")
        }
        
        
        // 3. Gelen JSON verisini bizim 'Media' modelimize çevirme (Decoding)
        do {
            //TMDB'den gelen veri şuna benzer: { "page": 1, "results": [...filmler...] }
            //Bu yüzden önce bu yapıyı karşılayacak geçici bir Response modeli tanımlıyoruz.
            let decodedResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
            return decodedResponse.results
        } catch {
            print("Decoding Hatası: \(error)") //Hatayı konsolda görmek için
            throw APIError.decodingError
        }
    }
}

// TMDB'den gelen ana cevabı karşılamak için yardımcı struct
// Sadece bu dosyada lazım olduğu için private yapabiliriz veya dışarıda tutabiliriz.
// Şimdilik buraya yazalım.

struct MovieResponse: Codable {
    let results: [Media]
}
