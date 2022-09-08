//
//  HomePageView.swift
//  FoodBook
//
//  Created by Thinh, Nguyen Truong on 06/09/2022.
//

import SwiftUI

struct HomePageView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    var body: some View {
        
        HStack{
            Text("Homepage")
            
            Text("You are signed in")
            
            Button {
                loginViewModel.signOut()
            } label: {
                Text("Sign Out")
                    .frame(width: 200, height: 50)
                    .background(Color.green)
                    .foregroundColor(Color.blue)
            }
        }
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
