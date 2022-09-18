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
import Foundation
import Firebase
import FirebaseStorage
import FirebaseCore
import FirebaseFirestore

//class CRUDViewModel: ObservableObject{
//    let auth = Auth.auth()
//    let storage = Storage.storage()
//}

struct CRUDView: View {
//    @EnvironmentObject var CRUDViewModel: CRUDViewModel
    @State private var showCRUDview = false
    @ObservedObject var foods = FoodViewModel()
    @State var list = [Food]()
    @State var recipeFieldText: String = ""
    @State var urlPathFieldText: String = ""
    @State var nameFieldText: String = ""
    @State var descriptionFieldText: String = ""
    @State var typeOfFoodSelection = "Others"
    let type = ["Soup", "Salad", "Main Dish", "Breakfast", "Desserts", "Others"]
    @State var regionOfFoodSelection = "Others"
    let region = ["Vietnamese", "Korean", "Indian", "Chinese", "Italian", "American",  "Mexican", "Others"]
    var body: some View {
        ZStack{
            ScrollView{
                VStack{
                    Text("ADD YOUR OWN FOOD RECIPE!")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    Spacer(minLength: 100)
                    
                    Group{
                        TextField("Food name: ", text: $nameFieldText)
                            .padding()
                            .background(Color.gray.opacity(0.2).cornerRadius(10))
                            .foregroundColor(.blue)
                        
                        Picker("Select the type of the food: ", selection: $typeOfFoodSelection){
                            ForEach(type, id: \.self){
                                Text($0)
                            }
                        }
                        .pickerStyle(.menu)
                        
                        Picker("Select the region of the food: ", selection: $regionOfFoodSelection){
                            ForEach(region, id: \.self){
                                Text($0)
                            }
                        }
                        .pickerStyle(.menu)
                        
                        TextField("Food description: ", text: $descriptionFieldText)
                            .padding()
                            .background(Color.gray.opacity(0.2).cornerRadius(16))
                            .foregroundColor(.blue)
                            
                        
                        TextField("Food recipe: ", text: $recipeFieldText)
                            .padding()
                            .background(Color.gray.opacity(0.2).cornerRadius(16))
                            .foregroundColor(.blue)
                        
                        TextField("Path to the picture: ", text: $urlPathFieldText)
                            .padding()
                            .background(Color.gray.opacity(0.2).cornerRadius(16))
                            .foregroundColor(.blue)
                    }
                    .padding(10)
                    Spacer()
                    Button(action:{
                        foods.addFood(name: nameFieldText, type: typeOfFoodSelection, region: regionOfFoodSelection, description: descriptionFieldText, recipe: recipeFieldText, urlPath: urlPathFieldText)
                    }){
                        Text("Add food")
                            .bold()
                            .foregroundColor(.white)
                            .padding(.all, 20)
                            .background(.blue)
                            .cornerRadius(20)
                    }
                }
            }
        }
    }
}



struct CRUDView_Previews: PreviewProvider {
    static var previews: some View {
        CRUDView()
    }
}
