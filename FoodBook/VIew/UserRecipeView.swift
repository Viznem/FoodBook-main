//
//  UserRecipeView.swift
//  FoodBook
//
//  Created by Thinh, Nguyen Truong on 09/09/2022.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore


struct UserRecipeView: View {
    @ObservedObject var foods = FoodViewModel()
    @Binding var isOpen : Bool
    @State private var showCRUDview = false
    
    
    init(isOpen: Binding<Bool>) {
        _isOpen = isOpen
        foods.getFood()        
    }
    
    var body: some View {
        ZStack{
                NavigationView{
                    List{
                        ForEach(foods.foodList){
                            food in NavigationLink{
                                RecipeDetailView(food: food)
                            } label: {
                                Text(food.name)
                            }
                        }
                    }
                }//ZStack
                .navigationTitle("User's list of recipe")
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button{
                            showCRUDview.toggle()
                        }label: {
                            Text("Add a new recipe")
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
