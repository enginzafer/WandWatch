//
//  OnboardingView.swift
//  WandWatch
//
//  Created by Engin Zafer Sönmez on 24.01.2026.
//

import SwiftUI

struct OnboardingView: View {
    
    @State private var selectedPlatformIDs: Set<Int> = []
    
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    
    let platforms = PlatformManager.shared.availablePlatforms
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "tv.and.mediabox")
                .font(.system(size: 60))
                .foregroundColor(.blue)
                .padding(.bottom, 10)
            
            
            Text("Hangi Platforma Üyesin?")
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
            
            
            Text("Sana uygun içerikleri bulabilmemiz için üye olduğun platformları seç.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            //Platform Listesi Grid Şeklinde
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
                    ForEach(platforms) { platform in
                        PlatformSelectionCard(
                            platform: platform,
                            isSelected: selectedPlatformIDs.contains(platform.id)
                        ) {
                            //Tıklanınca seç/kaldır
                            if selectedPlatformIDs.contains(platform.id) {
                                selectedPlatformIDs.remove(platform.id)
                            } else {
                                selectedPlatformIDs.insert(platform.id)
                            }
                        }
                    }
                }
                .padding()
            }
            
            Spacer()
            
            //Devam Et Butonu
            Button(action: {
                //1. Seçimleri Kaydet
                PlatformManager.shared.saveSelection(ids: Array(selectedPlatformIDs))
                //2. Onboarding Bitti olarak işaretle
                hasCompletedOnboarding = true
            }) {
                Text("Başla")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
        .onAppear {
            let saveIDs = PlatformManager.shared.getSelectedIDs()
            selectedPlatformIDs = Set(saveIDs)
        }
    }
}


struct PlatformSelectionCard: View {
    let platform: WatchProvider
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                // ARTIK ASYNCIMAGE YOK! DIREKT IMAGE VAR.
                // Bu asla hata vermez, yüklenme süresi yoktur.
                Image(platform.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit) // Logoları sığdır
                    .frame(width: 100, height: 100)
                    .background(Color.white) // Şeffaf logolar için beyaz zemin
                    .cornerRadius(24)
                    .shadow(radius: 2) // Hafif gölge ekledik şık dursun
                    .overlay(
                        ZStack {
                            if isSelected {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.blue, lineWidth: 3)
                                
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                                    .background(Color.white.clipShape(Circle()))
                                    .offset(x: 25, y: -25)
                            }
                        }
                    )
                
                Text(platform.name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }
        }
    }
}

#Preview {
    OnboardingView()
}
