//
//  LottieView.swift
//  FoodBook
//
//  Created by Khang Nguyen Manh on 18/09/2022.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    var name: String
    func makeUIView(context: Context) -> some UIView {
        let view = AnimationView(name: name, bundle: Bundle.main)
        view.loopMode = .loop
        view.play()
        return view
    }
}

