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
                        Image(food.region)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 30, alignment: .center)
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

    }
}

