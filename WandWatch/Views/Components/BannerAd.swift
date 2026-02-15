//
//  BannerAd.swift
//  WandWatch
//
//  Created by Engin Zafer Sönmez on 15.02.2026.
//

import SwiftUI
import GoogleMobileAds

struct BannerAd: UIViewRepresentable {
    
    let adUnitID = "ca-app-pub-1149413374854071/8928780289"
    
    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: AdSizeBanner) // Standart Banner
        banner.adUnitID = adUnitID
        
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            banner.rootViewController = rootVC
        }
        
        banner.load(Request())
        return banner
    }
    
    func updateUIView(_ uiView: BannerView, context: Context) {
        
    }
}

#Preview {
    BannerAd()
}
