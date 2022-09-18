//////
//////  Food.swift
//////  FoodBook
//////
//////  Created by An Pham Hoang Thien on 13/09/2022.
//////
////
//import SwiftUI
//import Foundation
//
//struct Food: Codable{
//    var id: String
//    var name: String
//    var type: String
//    var region: String
//    var description: String
//
//}
//
import SwiftUI
import Foundation

struct Food: Identifiable{
    
    var id = UUID()
    var name: String
    var type: String
    var region: String
    var description: String
    
}
