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
        
        db.collection("Food").getDocuments{
            snapshot, error in
            if error == nil{
                if let snapshot = snapshot{
                    DispatchQueue.main.async {
                        self.foodList = snapshot.documents.map{
                            d in
                            return Food(id: d.documentID,
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
}

