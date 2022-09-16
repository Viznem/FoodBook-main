////
////  UserRecipeView.swift
////  FoodBook
////
////  Created by Thinh, Nguyen Truong on 09/09/2022.
////
//
//import SwiftUI
//
//struct UserRecipeView: View {
//    @Binding var isOpen: Bool
//    @State private var showCRUDview = false
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
                                HStack{
                                Text(food.name)
                                    Button(action: {
                                        foods.deleteFood(foodDelete: food)
                                        }, label: {
                                                Image(systemName: "minus.circle")
                                            })
                                            .buttonStyle(BorderlessButtonStyle())
                                    }
                                }
                            }
                        }
                }
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
            
        }//ZStack
        .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .rotation3DEffect(.degrees(isOpen ? 30: 0), axis: (x: 0, y: -1, z: 0))
        .offset(x: isOpen ? 265 : 0)
        .scaleEffect(isOpen ? 0.9 : 1)
        .ignoresSafeArea()

    }
}

//struct UserRecipeView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserRecipeView(isOpen: .constant(false))
//    }
//}

