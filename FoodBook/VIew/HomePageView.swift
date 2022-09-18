/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Author: Pham Hoang Thien An, Nguyen Manh Khang, Nguyen Truong Thinh, Nguyen Dang Quang
  ID: s3818286, s3871126, s3777230, s3741190
  Created  date: 1/09/2022
  Last modified: 18/09/2022
  Acknowledgement: Acknowledge the resources that you use here.
*/

import SwiftUI
import Kingfisher
import FirebaseCore
import FirebaseFirestore

struct HomePageView: View {
    @Binding var isOpen: Bool
    @Environment(\.colorScheme) var colorScheme

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
        foods.getAllFood()
    }
    var body: some View {
        
        ZStack{
            Color(.black).opacity(0.2).ignoresSafeArea()
            NavigationView{
                    ScrollView{
                        VStack {
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
                                            .foregroundColor(.white)
                                    }
                                    .background {
                                        Circle().fill(.black
                                            .opacity(0.15))
                                    }
                                }
                                .padding(.vertical, 10)
                                
                                }
                            .background(
                                NavigationLink(
                                    destination: RecipeDetailView(food: selectedFood), isActive: $isLinkActive) {
                                    EmptyView()
                                })
                            
                    }
                }
//                    .searchable(text: $searchingWord)

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

var tabs = ["All", "Vietnamese", "Korean", "Mexican", "American", "Others"]

struct FilterButton: View {
    @Environment(\.colorScheme) var colorScheme
    var name: String
    @ObservedObject var foods = FoodViewModel()
    @Binding var isSelected: String
    var animation: Namespace.ID
    var body: some View {
        Button(action: {
            withAnimation(.spring(), {
                isSelected = name
                foods.queryFoodByNation(nation: name)
                print(foods.foodList.count)
        
                //query by nation
                
            })
          
        }) {
        Text(name)
            .fontWeight(.semibold)
            .foregroundColor(isSelected == name || colorScheme == .dark  ? .white : .black)
            .padding()
            .padding(.horizontal)
            .background(ZStack {
                if(isSelected == name) {Color(.red)
                    .cornerRadius(12)
                    .matchedGeometryEffect(id: "Tab", in: animation)
                }
            })
            .shadow(color: Color.black.opacity(0.16), radius: 16, x: 4, y: 4)
        }
    }
}

struct CardView: View {
    @State var food: Food
    @ObservedObject var foods = FoodViewModel()

    var body: some View {
        HStack(spacing: 12) {
            KFImage(URL(string: food.urlPath)!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 120)
                .cornerRadius(20)
                .padding()
                
            
            
            VStack(alignment: .leading, spacing: 10) {
                Text(food.name)
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Text(food.type)
                    .font(.system(size:14,design: .rounded))
                    .foregroundColor(.black.opacity(0.9))
                HStack {
                    HStack {
                    Text(food.region)
                        .font(.system(.title3, design: .rounded))
                        .foregroundColor(.black)
                    Image(food.region)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 40)
                    }
                    Spacer()
                    Button( action: {
                        food.isLike.toggle()
                        //save this food to collection
                        foods.addToFavoriteCollection(food: food)
                        print("SAVE!!")
                        
                    }, label: {
                        Image(systemName: food.isLike ? "suit.heart.fill" : "suit.heart")
                            .font(.title2)
                            .foregroundColor(food.isLike ? .red : .gray)
                    })
                    .offset(x: -20,y: 0)
            }
            
            }
        }
        .background(ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous).fill(.black
                .opacity(0.15))
        })
        .overlay(
            HeartLikeView(isLiked: $food.isLike, food: food, taps: 2))
        .background{
            RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(.white)}
        .padding(.bottom, 6)
        .frame(height: 140)
        .shadow(color: .black.opacity(0.14), radius: 5, x: 5, y: 5)
    }
}

struct FilterGroup: View {
    @State var isSelected = tabs[0]
    @Namespace var animation
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 2) {
                ForEach(tabs, id: \.self) { nation in
                    FilterButton(name: nation, isSelected: $isSelected, animation: animation)
                       
                }
            }
            .padding(.vertical)
        }
    }
    
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView(isOpen: .constant(false)).environmentObject(HomePageViewModel())
    }
}
