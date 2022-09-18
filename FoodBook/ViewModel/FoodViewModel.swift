
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

import Foundation
import Firebase
import FirebaseFirestore


class FoodViewModel: ObservableObject {
    @Published var foodList = [Food]()
    
    func getFood(){
        let db = Firestore.firestore()
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        db.collection("users").document(uid).collection("foods").getDocuments{
            (snapshot, error) in

            if error == nil{
                if let snapshot = snapshot{
                    DispatchQueue.main.async {
                        self.foodList = snapshot.documents.map{
                            d in
                            //retrieve the info of the food
                            return Food(
                                id: d["id"] as? String ?? "",
                                name: d["name"] as? String ?? "",
                                type: d["type"] as? String ?? "",
                                region: d["region"]as? String ?? "",
                                description: d["description"] as? String ?? "",
                                recipe: d["recipe"]as? String ?? "",
                                isLike: d["isLike"]as? Bool ?? false,
                                urlPath: d["urlPath"]as? String ?? " ")
                        }
                    }
                }
                else{
                    
                }
            }
        }
    }
    
    func getAllFood(){
        // call the database object to access firestore
        let db = Firestore.firestore()
        db.collection("Food").getDocuments{
            snapshot, error in
            if error == nil{
                if let snapshot = snapshot{
                    DispatchQueue.main.async {
                        self.foodList = snapshot.documents.map{
                            d in
                            return Food(
                                id: d["id"] as? String ?? "",
                                name: d["name"] as? String ?? "",
                                type: d["type"] as? String ?? "",
                                region: d["region"]as? String ?? "",
                                description: d["description"] as? String ?? "",
                                recipe: d["recipe"]as? String ?? "",
                                isLike: d["isLike"]as? Bool ?? false,
                                urlPath: d["urlPath"]as? String ?? " ")
                        }
                    }
                }
                else{
                    
                }
            }
        }
    }
    
    func getFavoriteFood() {
        let db = Firestore.firestore()
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        db.collection("users").document(uid).collection("favorite-foods").getDocuments{
            (snapshot, error) in
            if error == nil{
                if let snapshot = snapshot{
                    DispatchQueue.main.async {
                        self.foodList = snapshot.documents.map{
                            d in
                            return Food(
                                id: d["id"] as? String ?? "",
                                name: d["name"] as? String ?? "",
                                type: d["type"] as? String ?? "",
                                region: d["region"]as? String ?? "",
                                description: d["description"] as? String ?? "",
                                recipe: d["recipe"]as? String ?? "",
                                isLike: d["isLike"]as? Bool ?? false,
                                urlPath: d["urlPath"]as? String ?? " ")
                        }
                    }
                }
                else{
                    
                }
            }
        }
        
    }
    
    func addToFavoriteCollection(food: Food) {
        let db = Firestore.firestore()
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        let foodRef = db.collection("users").document(uid).collection("favorite-foods").document(food.id)
        foodRef.setData([
            "id": food.id,
            "name": food.name,
            "type": food.type,
            "region": food.region,
            "isLike": true,
            "description": food.description,
            "recipe": food.recipe,
            "urlPath": food.urlPath])
    }
    
    func removeFromFavoriteCollection(food: Food) {
        let db = Firestore.firestore()
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        // Specify the document to delete
        db.collection("users").document(uid).collection("favorite-foods").document(food.id).delete{ error in
            if error == nil {
                print("Remove suscessfully!")
            } else {
                print("Error removing favorite food")
            }
        }
    }
    
    func queryFoodByNation(nation: String) {
        let db = Firestore.firestore()
        // Specify the document to delete
        db.collection("Food").whereField("region", isEqualTo: nation)
            .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                                DispatchQueue.main.async {
                                self.foodList = querySnapshot!.documents.map{
                                    d in
                                    return Food(
                                        id: d["id"] as? String ?? "",
                                        name: d["name"] as? String ?? "",
                                        type: d["type"] as? String ?? "",
                                        region: d["region"]as? String ?? "",
                                        description: d["description"] as? String ?? "",
                                        recipe: d["recipe"]as? String ?? "",
                                        isLike: d["isLike"]as? Bool ?? false,
                                        urlPath: d["urlPath"]as? String ?? " ")
                            }
                        }
                    }
            }
    }
    
    func addFood(name: String, type: String, region: String, description: String, recipe: String, urlPath: String){
        //create a food variable to add to the list later
        let food = Food(id: UUID().uuidString, name: name, type:type, region: region, description: description, recipe: recipe, isLike: false, urlPath: urlPath)
        let db = Firestore.firestore()
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        
        //add a food document into the collection Food in firebase
        let mainfoodRef = db.collection("Food").document(food.id)
        mainfoodRef.setData([
            "id": food.id,
            "name": food.name,
            "type": food.type,
            "region": food.region,
            "isLike": false,
            "description": food.description,
            "recipe": food.recipe,
            "urlPath": food.urlPath])
        //add another food document into the user's private food collection
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
    
        func deleteFood(foodDelete: Food) {
            // Get a reference to the database
            let db = Firestore.firestore()
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
            // Specify the document to delete
            db.collection("users").document(uid).collection("foods").document(foodDelete.id).delete{ error in
            // Check for errors
            if error == nil {
                // No errors
                // Update the UI from the main thread
                DispatchQueue.main.async {
                    
                    // Remove the todo that was just deleted
                    self.foodList.removeAll { food in
                        // Check for the food to remove
                        return food.name == foodDelete.name
                        
                    }
                }
            }
        }
            //delete the food that is stored in the Food collection
            db.collection("Food").document(foodDelete.id).delete{
                error in
                
                // Check for errors
                if error == nil {
                    // No errors
                    // Update the UI from the main thread
                    DispatchQueue.main.async {
                        
                        // Remove the todo that was just deleted
                        self.foodList.removeAll { food in
                            // Check for the food to remove
                            return food.name == foodDelete.name}
                    }
                }
            }
    }
//    func updateFood(foodUpdate: Food){
//        let db = Firestore.firestore()
//        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
//
//        db.collection("users").document(uid).collection("foods").document
//    }
}

