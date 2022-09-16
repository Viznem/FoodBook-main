//
//  HomePageView.swift
//  FoodBook
//
//  Created by Thinh, Nguyen Truong on 06/09/2022.
//

import SwiftUI

struct HomePageView: View {
    @Binding var isOpen: Bool
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    var body: some View {
        
        ZStack{
            Color(.white).ignoresSafeArea()
            
            NavigationView{
                VStack{
                    ScrollView{
                        HStack{
                            
                            Text("You are signed in")
                            
                            Button {
                                loginViewModel.signOut()
                            } label: {
                                Text("Sign Out")
                                    .frame(width: 80, height: 50)
                                    .background(Color.green)
                                    .foregroundColor(Color.blue)
                            }
                        }//HStack
                    }
                }
            }//NavigationView
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        
        }//ZStack
        .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .rotation3DEffect(.degrees(isOpen ? 30: 0), axis: (x: 0, y: -1, z: 0))
        .offset(x: isOpen ? 265 : 0)
        .scaleEffect(isOpen ? 0.9 : 1)
        .ignoresSafeArea()
        
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView(isOpen: .constant(false))
    }
}
