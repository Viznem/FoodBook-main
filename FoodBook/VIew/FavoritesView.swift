//
//  FavoritesView.swift
//  FoodBook
//
//  Created by Thinh, Nguyen Truong on 09/09/2022.
//

import SwiftUI

struct FavoritesView: View {
    @Binding var isOpen: Bool
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var homePageModel: HomePageViewModel
    @ObservedObject var foods = FoodViewModel()
    @State var selectedFood = Food(id: "", name: "", type: "", region: "", description: "", recipe: "", isLike: false, urlPath: "")
    @State var isLinkActive = false
//    @State var searchingWord = ""
//
//    var results: [Food] {
//        if searchingWord.isEmpty {
//            return foods.foodList
//        } else {
//            return foods.foodList.filter{$0.name.contains(searchingWord)}
//        }
//    }
    init(isOpen: Binding<Bool>) {
        _isOpen = isOpen
        foods.getFavoriteFood()
    }
    var body: some View {
        ZStack{
            Color(.white).ignoresSafeArea()
            
            NavigationView{
                VStack{
                    ScrollView{
                        FilterGroup().padding(.horizontal, 10)
                        ForEach(foods.foodList){
                            food in
                            HStack {
                                CardView(food: food)
                                Button {
                                    selectedFood = food
                                    isLinkActive = true
                                } label: {
                                    Image(systemName: "arrow.forward")
                                        .font(.title2)
                                        .foregroundColor(food.isLike ? .red : .gray)
                                }
                            }
                            .padding()
                            
                            }
                        .background(
                            NavigationLink(
                                destination: RecipeDetailView(food: selectedFood), isActive: $isLinkActive) {
                                EmptyView()
                            })
                        
                }
            }
//                .searchable(text: $searchingWord)

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

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(isOpen: .constant(false))
    }
}
