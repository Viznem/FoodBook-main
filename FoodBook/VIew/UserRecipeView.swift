//
//  UserRecipeView.swift
//  FoodBook
//
//  Created by Thinh, Nguyen Truong on 09/09/2022.
//

import SwiftUI

struct UserRecipeView: View {
    @Binding var isOpen: Bool
    @Binding var foods: [Food]
    @State private var showCRUDview = false
    
    var body: some View {
        ZStack{
                NavigationView{
//                    List{
//                        ForEach(0...foods.count-1, id: \.self){
//                            food in NavigationLink{
//                                RecipeDetailView(food: $foods[food])
//                            } label: {
//                                Text(food.name)
//                            }
//                        }
//                    }
                }//ZStack
                .navigationTitle("User's list of recipe")
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button{
                            showCRUDview.toggle()
                        }label: {
                            Text("ADD")
                        }.sheet(isPresented: $showCRUDview){
                            CRUDView()
                        }
                    }
                }
        }
            .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .rotation3DEffect(.degrees(isOpen ? 30: 0), axis: (x: 0, y: -1, z: 0))
            .offset(x: isOpen ? 265 : 0)
            .scaleEffect(isOpen ? 0.9 : 1)
            .ignoresSafeArea()
    }
}
