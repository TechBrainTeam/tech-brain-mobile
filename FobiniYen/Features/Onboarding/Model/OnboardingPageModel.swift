//
//  OnboardingPageModel.swift
//  FobiniYen
//
//  Created by Serhat  Şimşek  on 1.08.2025.
//

import UIKit

struct OnboardingPageModel {
    let pageTopIcon: UIImage?
    let pageTitle: String?
    let pageSubtitle: String?
    let pageDescription: String?
    let features: [String]?
    let pageBottomIcons: [UIImage]?
    let backgroundColor: UIColor
    let buttonTitle: String
}

// MARK: - Sample Data
extension OnboardingPageModel {
    static let pages: [OnboardingPageModel] = [
        
        OnboardingPageModel(
            pageTopIcon: UIImage(systemName: "shield.fill")!,
            pageTitle: "Korkularını Yen",
            pageSubtitle: "Güvenli bir ortamda",
            pageDescription: "Fobi uygulaması ile korkularınızla yüzleşmeyi öğrenin ve güvenli bir şekilde üstesinden gelin.",
            features: [
                "Kademeli maruz kalma terapisi",
                "Güvenli öğrenme ortamı",
                "Uzman onaylı teknikler"
            ],
            pageBottomIcons: [
                UIImage(systemName: "star.fill")!,
                UIImage(systemName: "gearshape.fill")!,
                UIImage(systemName: "heart.fill")!
            ],
            backgroundColor: UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1.0),
            buttonTitle: "Devam Et"
        ),
        
        OnboardingPageModel(
            pageTopIcon: UIImage(systemName: "heart.fill")!,
            pageTitle: "Nefes Al, Sakinleş",
            pageSubtitle: "Anksiyete kontrolü",
            pageDescription: "Rehberli nefes egzersizleri ile anksiyetenizi kontrol altına alın ve iç huzurunuzu bulun.",
            features: [
                "4-7-8 nefes tekniği",
                "Anında sakinleştirme",
                "Günlük pratik rutinleri"
            ],
            pageBottomIcons: [
                UIImage(systemName: "star.fill")!,
                UIImage(systemName: "gearshape.fill")!,
                UIImage(systemName: "heart.fill")!
            ],
            backgroundColor: UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1.0),
            buttonTitle: "Devam Et"
        ),
        
        OnboardingPageModel(
            pageTopIcon: UIImage(systemName: "chart.line.uptrend.xyaxis")!,
            pageTitle: "İlerlemenizi İzleyin",
            pageSubtitle: "Motivasyon ve başarı",
            pageDescription: "Gelişiminizi takip edin, hedeflerinizi belirleyin ve her adımda kendinizi ödüllendirin.",
            features: [
                "Detaylı ilerleme raporu",
                "Başarı rozetleri",
                "Kişisel hedef belirleme"
            ],
            pageBottomIcons: [
                UIImage(systemName: "star.fill")!,
                UIImage(systemName: "gearshape.fill")!,
                UIImage(systemName: "heart.fill")!
            ],
            backgroundColor: UIColor(red: 175/255, green: 82/255, blue: 222/255, alpha: 1.0),
            buttonTitle: "Başlayalım"
        )
    ]
}
