//
//  FoodBookApp.swift
//  FoodBook
//
//  Created by Thinh, Nguyen Truong on 06/09/2022.
//

import SwiftUI
import Firebase

@main
struct FoodBookApp: App {
 
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            let loginViewModel = LoginViewModel()
            LoginView()
                .environmentObject(loginViewModel)
            
        }
    }
}
