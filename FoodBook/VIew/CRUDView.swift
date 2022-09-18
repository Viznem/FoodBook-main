
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
    
    @State var list = [Food]()
    
    func addFood(name: String, type: String, region: String, description: String, recipe: String, urlPath: String){
        let food = Food(id: UUID().uuidString, name: name, type:type, region: region, description: description, recipe: recipe, isLike: false, urlPath: urlPath)
        let db = Firestore.firestore()
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        let foodRef = db.collection("users").document(uid).collection("foods").document(food.id)
        foodRef.setData([
            "id": food.id,
            "name": food.name,
            "type": food.type,
            "region": food.region,
            "isLike": false,
            "description": food.description,
            "recipe": food.recipe,
            "urlPath": food.urlPath])
        
        
    }
    
    @State var recipeFieldText: String = ""
    @State var urlPathFieldText: String = ""
    @State var nameFieldText: String = ""
    @State var descriptionFieldText: String = ""
    @State var typeOfFoodSelection = ""
    let type = ["Soup", "Salad", "Main Dish", "Breakfast", "Desserts", "Others"]
    @State var regionOfFoodSelection = ""
    let region = ["Vietnamese", "Korean", "Indian", "Chinese", "Italian", "American","French", "Others"]
    var body: some View {
        ZStack{
            VStack{
                Text("ADD YOUR OWN FOOD RECIPE!")
                    .fontWeight(.bold)
                    .padding()
                Spacer()
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
                    addFood(name: nameFieldText, type: typeOfFoodSelection, region: regionOfFoodSelection, description: descriptionFieldText, recipe: recipeFieldText, urlPath: urlPathFieldText)
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



struct CRUDView_Previews: PreviewProvider {
    static var previews: some View {
        CRUDView()
    }
}
