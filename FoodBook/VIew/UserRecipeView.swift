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

import Kingfisher
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
                        VStack{
                            Button{
                                showCRUDview.toggle()
                            }label: {
                                Text("Add Recipe")
                                Image(systemName: "plus.circle")
                            }
                            .frame(alignment: .trailing)
                            .sheet(isPresented: $showCRUDview){
                                CRUDView()
                            }
                            List{
                                ForEach(foods.foodList){
                                    food in NavigationLink{
                                        RecipeDetailView(food: food)
                                    } label: {
                                        HStack{
                                            KFImage(URL(string: food.urlPath)!)
                                                .resizable()
                                                .frame(width: 120, height: 100, alignment: .leading)
                                                .cornerRadius(15)
                                            VStack{
                                                Text(food.name)
                                                    .font(.title)
                                                Text(food.region)
                                                    .font(.system(size: 10))
                                                Text(food.type)
                                                    .font(.system(size: 10))
                                            }.padding(5)
                                                .frame(height: 80, alignment: .leading)
                                            Spacer()
                                            Button(action: {
                                                foods.deleteFood(foodDelete: food)
                                            }, label: {
                                                Image(systemName: "minus.circle")
                                            })
                                            .buttonStyle(BorderlessButtonStyle())
                                            .frame(width: 50, height: 50, alignment: .trailing)
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
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
    
    struct UserRecipeView_Previews: PreviewProvider {
        static var previews: some View {
            UserRecipeView(isOpen: .constant(false))
        }
    }
    
