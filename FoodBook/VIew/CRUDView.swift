////
////  CRUDView.swift
////  FoodBook
////
////  Created by An Pham Hoang Thien on 13/09/2022.
////
//
//import SwiftUI
//import Foundation
//import Firebase
//
//struct CRUDView: View {
//    func addFood(name: String, type: String, region: String, description: String){
//        let db = Firestore.firestore()
//
//        db.collection("Food").addDocument(data: ["name": nameFieldText, "type": typeOfFoodSelection, "region": regionOfFoodSelection,"description": descriptionFieldText]){
//            error in
//            if error == nil{
//                self.getData()
//            }
//            else{
//
//            }
//        }
//    }
//
//    func getData(){
//        let db = Firestore.firestore()
//
//        db.collection("Foods").getDocuments{
//            snapshot, error in
//            if error == nil{
//                if let snapshot = snapshot{
//                    DispatchQueue.main.async {
//                        self.list = snapshot.documents.map{
//                            d in
//                            return Food()
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    @State var nameFieldText: String = ""
//    @State var descriptionFieldText: String = ""
//    @State private var typeOfFoodSelection = ""
//        let type = ["Soup", "Salad", "Main Dish", "Breakfast", "Desserts"]
//    @State private var regionOfFoodSelection = " "
//    let region = ["Vietnamese", "Korean", "Indian", "Chinese", "Italian"]
//    var body: some View {
//        ZStack{
//            Rectangle() //background color
//                .foregroundColor(.blue)
//                .opacity(0.55)
//                .ignoresSafeArea()
//
//            VStack{
//                TextField("Food name: ", text: $nameFieldText)
//                    .padding()
//                    .background(Color.gray.opacity(0.2).cornerRadius(10))
//                    .foregroundColor(.blue)
//
//                Picker("Select the type of the food: ", selection: $typeOfFoodSelection){
//                    ForEach(type, id: \.self){
//                        Text($0)
//                    }
//                }
//                .pickerStyle(.menu)
//
//                Picker("Select the region of the food: ", selection: $regionOfFoodSelection){
//                    ForEach(region, id: \.self){
//                        Text($0)
//                    }
//                }
//                .pickerStyle(.menu)
//
//                TextField("Food description: ", text: $descriptionFieldText)
//                    .padding()
//                    .background(Color.gray.opacity(0.2).cornerRadius(10))
//                    .foregroundColor(.blue)
//            }
//        }
//    }
//}
//
//struct CRUDView_Previews: PreviewProvider {
//    static var previews: some View {
//        CRUDView()
//    }
//}
//
