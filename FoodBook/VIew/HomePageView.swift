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
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var homePageModel: HomePageViewModel
    @ObservedObject var foods = FoodViewModel()
    @State var selectedFood = Food(id: "", name: "", type: "", region: "", description: "", recipe: "", isLike: false, urlPath: "")
    @State var isLinkActive = false
    
    init(isOpen: Binding<Bool>) {
        _isOpen = isOpen
        foods.getFood()
    }
    var body: some View {
        
        ZStack{
            Color(.white).ignoresSafeArea()
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

var tabs = ["All", "Vietnamese", "Korean", "Indian", "American", "Others"]

struct FilterButton: View {
    var name: String
    @Binding var isSelected: String
    var animation: Namespace.ID
    var body: some View {
        Button(action: {
            withAnimation(.spring(), {
                isSelected = name
            })
        }) {
        Text(name)
            .fontWeight(.semibold)
            .foregroundColor(isSelected == name ? .white : .black)
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
                .aspectRatio(contentMode: .fit)
                .frame(width: 120)
                .padding()
                .background(ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color("Black").opacity(0.15))
                })
            
            
            VStack(alignment: .leading, spacing: 10) {
                Text(food.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Text(food.type)
                    .font(.system(size:14))
                    .foregroundColor(.black.opacity(0.9))
                HStack {
                    Text(food.region)
                        .font(.title3.bold())
                        .foregroundColor(.black)
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
            }
            
            }
        }
        .overlay(
            HeartLikeView(isLiked: $food.isLike, food: food, taps: 2))
        .background{
            RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(.white)}
        .padding(.bottom, 6)
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
