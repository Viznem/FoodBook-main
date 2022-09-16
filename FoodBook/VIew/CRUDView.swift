//
//  CRUDView.swift
//  FoodBook
//
//  Created by An Pham Hoang Thien on 13/09/2022.
//

import SwiftUI
import Foundation
import Firebase
import FirebaseStorage
import FirebaseCore
import FirebaseFirestore

class CRUDViewModel: ObservableObject{
    let auth = Auth.auth()
    let storage = Storage.storage()
}

struct CRUDView: View {
    @EnvironmentObject var CRUDViewModel: CRUDViewModel
    @State private var showCRUDview = false

    @State var list = [Food]()
    
    func addFood(name: String, type: String, region: String, description: String){
        let food = Food(name: name, type:type, region: region, description: description)
        let db = Firestore.firestore()
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        let foodRef = db.collection("users").document(uid).collection("foods")
        foodRef.addDocument(data: [
            "id": food.id.uuidString,
            "name": food.name,
            "type": food.type,
            "region": food.region,
            "description": food.description])
    }
    func getFood(){
        let db = Firestore.firestore()
        
        db.collection("Food").getDocuments{
            snapshot, error in
            if error == nil{
                if let snapshot = snapshot{
                    DispatchQueue.main.async {
                        self.list = snapshot.documents.map{
                            d in
                            return Food(
                                        name: d["name"] as? String ?? "",
                                        type: d["type"] as? String ?? "",
                                        region: d["region"]as? String ?? "",
                                        description: d["description"] as? String ?? "")
                        }
                    }
                }
                else{
                    
                }
            }
        }
    }
    
    @State var nameFieldText: String = ""
    @State var descriptionFieldText: String = ""
    @State var typeOfFoodSelection = ""
    let type = ["Soup", "Salad", "Main Dish", "Breakfast", "Desserts"]
    @State var regionOfFoodSelection = " "
    let region = ["Vietnamese", "Korean", "Indian", "Chinese", "Italian"]
    var body: some View {
        ZStack{
            Rectangle() //background color
                .foregroundColor(.blue)
                .opacity(0.55)
                .ignoresSafeArea()
            
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
                }
                .padding(10)
                Spacer()
                Button(action:{
                    addFood(name: nameFieldText, type: typeOfFoodSelection, region: regionOfFoodSelection, description: descriptionFieldText)
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

