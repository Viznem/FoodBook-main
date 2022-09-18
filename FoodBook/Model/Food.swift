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

struct Food: Identifiable{
    
    var id: String
    var name: String
    var type: String
    var region: String
    var description: String
    var recipe: String
    var isLike: Bool
    var urlPath: String
    
    
}
