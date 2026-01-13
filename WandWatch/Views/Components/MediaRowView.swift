//
//  MediaRowView.swift
//  WandWatch
//
//  Created by Engin Zafer Sönmez on 13.01.2026.
//

import SwiftUI

struct MediaRowView: View {
    
    let media: Media
    
    var body: some View {
        HStack(spacing: 12) {
            
            // 1. Film Afişi
            AsyncImage(url: media.posterURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                //Resim yüklenirken ne gözüksün
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        ProgressView() // Dönel Yükleniyor simgesi
                    )
            }
            .frame(width: 80,height: 120) //Resim Boyutu
            .cornerRadius(8) //Köşeleri yuvarla
            .clipped()
            
            
            //2. Film Bilgileri(Yazılar)
            VStack(alignment: .leading, spacing: 5) {
                Text(media.displayTitle)
                    .font(.headline) //Başlık fontu
                    .lineLimit(2) // En fazla 2 satır
                
                Text(media.displayOverview)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(3) //Açıklama uzunsa kes
                
                HStack {
                    Image(systemName: "star.fill") //Yıldız İkonu
                        .foregroundStyle(.yellow)
                        .font(.caption)
                    
                    Text(media.displayVote)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.gray)
                }
                .padding(.top, 4)
                
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    MediaRowView(media: Media.mock)
}
