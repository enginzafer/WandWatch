import Foundation

// 1. Platform Modeli
struct WatchProvider: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let imageName: String // ARTIK URL DEĞİL, RESİM ADI TUTUYORUZ
}

// 2. Yönetici Sınıf
class PlatformManager {
    static let shared = PlatformManager()
    private let saveKey = "UserSelectedPlatforms"
    
    // Assets klasörüne koyduğun resimlerin isimlerini buraya yazıyoruz
    let availablePlatforms: [WatchProvider] = [
        WatchProvider(id: 8, name: "Netflix", imageName: "logo_netflix"),
        WatchProvider(id: 119, name: "Prime Video", imageName: "logo_prime"),
        WatchProvider(id: 337, name: "Disney+", imageName: "logo_disney"),
        WatchProvider(id: 1899, name: "HBO Max", imageName: "logo_hbo"),
        WatchProvider(id: 350, name: "Apple TV+", imageName: "logo_apple"),
        WatchProvider(id: 1791, name: "Exxen", imageName: "logo_exxen"),
        WatchProvider(id: 1904, name: "TV+", imageName: "logo_tvplus")
    ]
    
    func saveSelection(ids: [Int]) {
        UserDefaults.standard.set(ids, forKey: saveKey)
    }
    
    func getSelectedIDs() -> [Int] {
        return UserDefaults.standard.array(forKey: saveKey) as? [Int] ?? []
    }
    
    func isSubscribed(to providerId: Int) -> Bool {
        let savedIDs = getSelectedIDs()
        return savedIDs.contains(providerId)
    }
}


