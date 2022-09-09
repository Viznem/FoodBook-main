//
//  FavoritesView.swift
//  FoodBook
//
//  Created by Thinh, Nguyen Truong on 09/09/2022.
//

import SwiftUI

struct FavoritesView: View {
    @Binding var isOpen: Bool
    
    var body: some View {
        ZStack{
            Color(.white).ignoresSafeArea()
            
            VStack{
                
                HStack{
                    
                    Text("Favorites Recipes")
                    
                    
                }//HStack
                
            }//VStack
            
        }//ZStack
        .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .rotation3DEffect(.degrees(isOpen ? 30: 0), axis: (x: 0, y: -1, z: 0))
        .offset(x: isOpen ? 265 : 0)
        .scaleEffect(isOpen ? 0.9 : 1)
        .ignoresSafeArea()
        
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(isOpen: .constant(false))
    }
}
