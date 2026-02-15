//
//  ReviewEditorView.swift
//  WandWatch
//
//  Created by Engin Zafer Sönmez on 17.01.2026.
//

import SwiftUI
import SwiftData

struct ReviewEditorView: View {
    // Düzenlenecek film verisi (Binding ile gelmiyor, doğrudan referans alınıyor)
    @Bindable var savedMedia: SavedMedia
    
    
    //Sayfayı kapatmak için
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        NavigationStack {
            Form {
                // --- TARİHLER ---
                Section("İzleme Tarihleri") {
                    //Başlangıç Tarihi
                    DatePicker(
                        "Başlangıç Tarihi",
                        selection: Binding(
                            get: { savedMedia.startDate ?? Date()},
                            set: { savedMedia.savedDate = $0 }
                        ),
                        displayedComponents: .date
                    )
                    
                    
                    //Bitiş Tarihi
                    DatePicker(
                        "Bitiş Tarihi",
                        selection: Binding(
                            get: { savedMedia.finishDate ?? Date() },
                            set: { savedMedia.finishDate = $0 }
                        ),
                        displayedComponents: .date
                    )
                }
                
                // --- PUAN ---
                Section("Puanın") {
                    HStack {
                        Spacer()
                        //1'den 10'a kadar yıldızlar
                        ForEach(1...10, id: \.self) { star in
                            Image(systemName: "star.fill")
                                .foregroundStyle(star <= (savedMedia.userRating ?? 0) ? .yellow : .gray.opacity(0.3))
                                .font(.caption)
                                .onTapGesture {
                                    withAnimation {
                                        savedMedia.userRating = star
                                    }
                                }
                        }
                        Spacer()
                    }
                    
                    if let rating = savedMedia.userRating {
                        HStack {
                            Spacer()
                            Text("\(rating) / 10")
                                .fontWeight(.bold)
                                .foregroundStyle(.yellow)
                            Spacer()
                        }
                    }
                }
                
                
                // --- YORUM ---
                Section("Düşüncelerim") {
                    TextField("Film/Dizi hakkında ne düşünüyorum?", text: Binding(
                        get: { savedMedia.userReview ?? "" },
                        set: { savedMedia.userReview = $0 }
                    ), axis: .vertical)
                    .lineLimit(5...10)
                }
            }
            .navigationTitle("İnceleme Düzenle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Tamam") {
                        dismiss()
                    }
                }
            }
        }
    }
}

