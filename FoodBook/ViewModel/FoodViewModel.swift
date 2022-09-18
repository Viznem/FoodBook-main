//
//  FoodViewModel.swift
//  FoodBook
//
//  Created by Khang Nguyen on 15/09/2022.
//

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
        
    }
}

