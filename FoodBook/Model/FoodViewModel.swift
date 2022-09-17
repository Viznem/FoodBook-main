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
                                        description: d["description"] as? String ?? "")
                        }
                    }
                }
                else{
                    
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
                print(foodDelete.id)
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

