//
//  LoadingView.swift
//  FoodBook
//
//  Created by Khang Nguyen Manh on 18/09/2022.
//

import SwiftUI

struct LoadingView: View {
    @State private var isActive = false
    var body: some View {
        if isActive {
            ContentVIew()
        } else {
        LottieView(name: "food-animation")
            .frame(height: UIScreen.main.bounds.height, alignment: .center)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.isActive = true
            }
        }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
