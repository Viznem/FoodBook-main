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
                        .frame(width: 400, height: 350, alignment: .center)
                        .cornerRadius(20)
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
                        Text("DESCRIPTION:")
                            .bold()
                            .padding(.all, 20)
                            .background(.blue)
                            .cornerRadius(20)
                        Text(food.description)
                            .padding(40)
                        Text("RECIPE:")
                            .bold()
                            .padding(.all, 20)
                            .background(.blue)
                            .cornerRadius(20)
                        Text(food.recipe)
                            .padding(40)
                            
                        }
                        .font(.system(size:15))
                        
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
    }
}

