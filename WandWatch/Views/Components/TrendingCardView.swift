//
//  TrendingCardView.swift
//  WandWatch
//
//  Created by Engin Zafer Sönmez on 16.01.2026.
//

import SwiftUI

struct TrendingCardView: View {
    let media: Media
    
    
    var body: some View {
        VStack(alignment: .leading) {
            //1. Poster Resmi
            AsyncImage(url: media.posterURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                .fill(Color.gray.opacity(0.3))
                .overlay(ProgressView())
            }
            .frame(width: 140, height: 210) //Standar Poster Boyutu
            .cornerRadius(12)
            .shadow(radius: 4)
            
            
            
            //2. Başlık
            Text(media.displayTitle)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(1)
                .foregroundStyle(.primary)
            
            //3. Puan (Opsiyonal)
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .font(.caption2)
                    .foregroundStyle(.yellow)
                Text(media.displayVote)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 140) //Kartın Genişliği sabit olsun
    }
}

#Preview {
    TrendingCardView(media: Media.mock)
}
