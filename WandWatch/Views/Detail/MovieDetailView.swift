//
//  MovieDetailView.swift
//  WandWatch
//
//  Created by Engin Zafer Sönmez on 13.01.2026.
//
import SwiftUI
import SwiftData

struct MovieDetailView: View {
    let media: Media
    
    // SwiftData bağlantısı
    @Environment(\.modelContext) private var context
    @Query var savedMovies: [SavedMedia]
    
    // YENİ: Bu sayfanın kendi özel ViewModel'i
    @StateObject private var viewModel = MovieDetailViewModel()
    
    @State private var showReviewSheet = false
    
    
    // SwiftData Query Filtresi
    init(media: Media) {
        self.media = media
        let mediaID = media.id
        _savedMovies = Query(filter: #Predicate<SavedMedia> { movie in
            movie.id == mediaID
        })
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // --- BÜYÜK RESİM ALANI ---
                    ZStack(alignment: .bottomLeading) {
                        AsyncImage(url: media.posterURL) { image in
                            image.resizable().aspectRatio(contentMode: .fill)
                        } placeholder: { Rectangle().fill(Color.gray.opacity(0.3)) }
                            .frame(height: 300).clipped()
                        
                        LinearGradient(colors: [.clear, .black.opacity(0.9)], startPoint: .top, endPoint: .bottom)
                        
                        VStack(alignment: .leading) {
                            Text(media.displayTitle)
                                .font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
                                .shadow(radius: 5)
                            
                            if let date = media.releaseDate {
                                Text("Yayınlanma: \(date)")
                                    .font(.caption).foregroundColor(.white.opacity(0.8))
                            }
                        }.padding()
                    }
                    
                    // --- DETAYLAR ALANI ---
                    VStack(alignment: .leading, spacing: 5) {
                        
                        // Tür ve Puan
                        HStack {
                            Label(media.displayVote, systemImage: "star.fill")
                                .foregroundColor(.yellow).fontWeight(.bold)
                            
                            Text("•").foregroundColor(.gray)
                            
                            Text(media.mediaType?.rawValue.uppercased() ?? "İÇERİK")
                                .font(.caption).fontWeight(.bold).padding(6)
                                .background(Color.blue.opacity(0.1)).cornerRadius(6)
                        }
                        
                        //Yeni Süre ve Sezon
                        if let detail = viewModel.detail {
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                                
                                // Film ise süreyi, Dizi ise sezonu göster
                                Text(media.mediaType == .movie ? detail.formattedRuntime : detail.formattedSeasons)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)
                            }
                            .transition(.opacity) // Yüklenince yumuşak gelsin
                        }
                        
                        Divider()
                        // --- AKILLI İZLEME PLATFORMLARI ---
                        if viewModel.isLoading {
                            ProgressView().padding()
                        } else {
                            VStack(alignment: .leading, spacing: 15) {
                                
                                // 1. SENİN ABONELİKLERİN (MÜJDE KUTUSU)
                                if !viewModel.myPlatforms.isEmpty {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Label("Aboneliğinde Var! (Ücretsiz)", systemImage: "checkmark.seal.fill")
                                            .font(.headline)
                                            .foregroundColor(.green)
                                        
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 15) {
                                                ForEach(viewModel.myPlatforms) { provider in
                                                    // Linke tıklayınca TMDB sayfasına gider
                                                    Link(destination: URL(string: viewModel.watchLink ?? "")!) {
                                                        VStack {
                                                            AsyncImage(url: provider.logoURL) { image in
                                                                image.resizable()
                                                            } placeholder: { Color.gray }
                                                                .frame(width: 60, height: 60)
                                                                .cornerRadius(12)
                                                                .shadow(color: .green.opacity(0.5), radius: 5) // Yeşil parlama
                                                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.green, lineWidth: 2))
                                                            
                                                            Text(provider.providerName)
                                                                .font(.caption2).foregroundColor(.primary)
                                                                .lineLimit(1).frame(width: 60)
                                                        }
                                                    }
                                                }
                                            }
                                            .padding(5)
                                        }
                                    }
                                    .padding()
                                    .background(Color.green.opacity(0.1)) // Hafif yeşil zemin
                                    .cornerRadius(12)
                                }
                                
                                // 2. DİĞER PLATFORMLAR (Eğer varsa)
                                if !viewModel.otherPlatforms.isEmpty {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(viewModel.myPlatforms.isEmpty ? "İzlenebilecek Platformlar:" : "Diğer Seçenekler:")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 15) {
                                                ForEach(viewModel.otherPlatforms) { provider in
                                                    Link(destination: URL(string: viewModel.watchLink ?? "")!) {
                                                        VStack {
                                                            AsyncImage(url: provider.logoURL) { image in
                                                                image.resizable()
                                                            } placeholder: { Color.gray }
                                                                .frame(width: 50, height: 50)
                                                                .cornerRadius(10)
                                                            
                                                            Text(provider.providerName)
                                                                .font(.caption2).foregroundColor(.primary)
                                                                .lineLimit(1).frame(width: 60)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        Divider()
                        // --------------------------------------------------
                        
                        Text("Özet").font(.headline)
                        Text(media.displayOverview)
                            .font(.body).foregroundColor(.secondary).lineSpacing(4)
                        
                        Divider()
                        
                        // LİSTEME EKLE / ÇIKAR BUTONU
                        if let savedMovie = savedMovies.first {
                            VStack(spacing: 16) {
                                
                                
                                // --- DURUM BİLGİSİ ---
                                HStack {
                                    Image(systemName: savedMovie.isWatched ? "checkmark.seal.fill" : "bookmark.fill")
                                        .foregroundStyle(savedMovie.isWatched ? .green : .blue)
                                    Text(savedMovie.isWatched ? "İzlediklerim Listesinde": "İzlenecekler Listesinde")
                                        .fontWeight(.bold)
                                }
                                
                                // --- KULLANICI İNCELEMESİ ---
                                if savedMovie.userRating != nil || (savedMovie.userReview != nil && !savedMovie.userReview!.isEmpty) {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("İncelemem:")
                                            .font(.headline)
                                            .foregroundStyle(.orange)
                                        
                                        
                                        // Puan Sistemi
                                        if let rating = savedMovie.userRating {
                                            HStack {
                                                ForEach(0..<rating, id:\.self) { _ in
                                                    Image(systemName: "star.fill")
                                                        .foregroundStyle(.yellow)
                                                        .font(.caption)
                                                }
                                                Text("(\(rating)/10")
                                                    .font(.caption)
                                                    .foregroundStyle(.secondary)
                                            }
                                        }
                                        
                                        // Tarih Kısmı
                                        if let finish = savedMovie.finishDate {
                                            Text("İzleme Tarihi: \(finish.formatted(date: .numeric, time: .omitted))")
                                                .font(.caption2)
                                                .foregroundStyle(.gray)
                                        }
                                        
                                        
                                        // Yorum Kısmı
                                        if let review  = savedMovie.userReview, !review.isEmpty {
                                            Text(review)
                                                .font(.body)
                                                .italic()
                                                .padding(8)
                                                .background(Color.gray.opacity(0.1))
                                                .cornerRadius(8)
                                        }
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color(uiColor: .systemBackground)) //Kart Görünümü
                                    .cornerRadius(12)
                                    .shadow(color: .black.opacity(0.1), radius: 2, x:0, y: 1)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                                    )
                                }
                                
                                // AKSİYON BUTONLARI
                                
                                // EĞER İZLENDİ İSE: "İNCELEME" BUTONU
                                if savedMovie.isWatched {
                                    Button(action: {
                                        showReviewSheet = true
                                    }) {
                                        HStack {
                                            //İkon ve Yazı duruma göre değişecek
                                            Image(systemName: "square.and.pencil")
                                            //Eğer yorum varsa "Düzenle", yoksa "Ekle" Yazsın
                                            Text((savedMovie.userRating != nil || savedMovie.userReview != nil) ?
                                                 "İnceleme Düzenle" : "İnceleme Ekle")
                                        }
                                        .font(.subheadline).fontWeight(.bold)
                                        .frame(maxWidth: .infinity).padding(10)
                                        .background(Color.orange).foregroundStyle(.white).cornerRadius(10)
                                    }
                                }
                                
                                HStack(spacing: 15) {
                                    // İzledim / İzlemedim Değiştir
                                    Button(action: {
                                        withAnimation {
                                            savedMovie.isWatched.toggle()
                                        }
                                    }) {
                                        Text(savedMovie.isWatched ? "İzlemedim Olarak İşaretle" : "İzledim Olarak İşaretle")
                                            .font(.caption).fontWeight(.bold)
                                            .frame(maxWidth: .infinity).padding()
                                            .background(Color.gray.opacity(0.2)).foregroundStyle(.primary).cornerRadius(10)
                                    }
                                    
                                    // Sil Butonu
                                    Button(action: {
                                        deleteMovie(savedMovie)
                                    }) {
                                        Label("Çıkar", systemImage: "trash")
                                            .font(.caption).fontWeight(.bold)
                                            .frame(maxWidth: .infinity).padding()
                                            .background(Color.red.opacity(0.1)).foregroundStyle(.red).cornerRadius(10)
                                    }
                                }
                            }
                            
                            //Sheet (Açılır Pencere)
                            .sheet(isPresented: $showReviewSheet) {
                                ReviewEditorView(savedMedia: savedMovie)
                            }
                        } else {
                            HStack(spacing: 15) {
                                //1. İzleyeceğim Butonu
                                Button(action: { addMovie(isWatched: false) }) {
                                    VStack {
                                        Image(systemName: "bookmark")
                                        Text("İzleyeceğim")
                                            .font(.caption).fontWeight(.bold)
                                    }
                                    .frame(maxWidth: .infinity).padding()
                                    .background(Color.blue).foregroundStyle(.white).cornerRadius(10)
                                }
                                
                                
                                //2. İzledim Butonu
                                Button(action: { addMovie(isWatched: true) }) {
                                    VStack {
                                        Image(systemName: "checkmark")
                                        Text("İzledim")
                                            .font(.caption).fontWeight(.bold)
                                    }
                                    .frame(maxWidth: .infinity).padding()
                                    .background(Color.green).foregroundStyle(.white).cornerRadius(10)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            
            Divider()
            BannerAd()
                .frame(height: 50)
                .background(Color.gray.opacity(0.1))
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            // mediaType enum olduğu için rawValue string'e çeviriyoruz
            await viewModel.loadProviders(mediaId: media.id, mediaType: media.mediaType?.rawValue ?? "movie")
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                // iOS 16+ ile gelen yeni ShareLink yapısı
                ShareLink(item: media.shareURL, subject: Text(media.displayTitle), message: Text("Bu yapıma WandWatch uygulamasında göz at!")) {
                    Image(systemName: "square.and.arrow.up") // Paylaş ikonu
                        .foregroundColor(.blue)
                }
            }
        }
    }
    
    // Veritabanı İşlemleri
    func addMovie(isWatched: Bool) {
        let newMovie = SavedMedia(
            id: media.id,
            title: media.displayTitle,
            overview: media.displayOverview,
            posterPath: media.posterPath,
            voteAverage: media.voteAverage ?? 0.0,
            mediaType: media.mediaType?.rawValue ?? "movie",
            isWatched: isWatched,
            startDate: nil,
            finishDate: isWatched ? Date() : nil,
            userRating: nil,
            userReview: nil
        )
        context.insert(newMovie)
    }
    
    func deleteMovie(_ movie: SavedMedia) {
        context.delete(movie)
    }
}

#Preview {
    NavigationStack {
        // Önizlemede context hatası almamak için inMemory kullanıyoruz
        MovieDetailView(media: Media.mock)
            .modelContainer(for: SavedMedia.self, inMemory: true)
    }
}
