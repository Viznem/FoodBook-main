//
//  RecipeDetailView.swift
//  FoodBook
//
//  Created by An Pham Hoang Thien on 14/09/2022.
//

import SwiftUI
import Foundation
import Firebase
import FirebaseStorage
import FirebaseCore
import FirebaseFirestore
import Kingfisher

struct RecipeDetailView: View {
    var food: Food
    
    var body: some View {
        ZStack {
            ScrollView{
                VStack {
                    KFImage(URL(string: food.urlPath)!)
                        .resizable()
                        .frame(width: 450, height: 250, alignment: .center)
                    Spacer()
                    
                    Text(food.name)
                        .font(.system(size: 30))
                        .bold()
                        .foregroundColor(.blue)
                        .font(.title)
                    
                    Group{
                        Text("Type: \(food.type)")
                            .fontWeight(.heavy)
                        Text("Region of food: \(food.region)")
                            .fontWeight(.heavy)
                    }
                    .font(.system(size:15))
                    
                    
                    Group{
                        Text("DESCRIPTION: \(food.description)")
                            
                        Text("RECIPE: \(food.recipe)")
                            
                        }.padding(10)
                        .font(.system(size:15))
                        
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
    }
}

