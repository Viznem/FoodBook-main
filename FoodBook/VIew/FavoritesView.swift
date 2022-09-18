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

struct FavoritesView: View {
    @Binding var isOpen: Bool
    
    var body: some View {
        ZStack{
            Color(.white).ignoresSafeArea()
            
            NavigationView{
                VStack{
                    ScrollView{
                        Text("Favorites Page")
                    }
                }//VStack
            }//NavigationView
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            
        }//ZStack
        .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .rotation3DEffect(.degrees(isOpen ? 30: 0), axis: (x: 0, y: -1, z: 0))
        .offset(x: isOpen ? 265 : 0)
        .scaleEffect(isOpen ? 0.9 : 1)
        .ignoresSafeArea()
        
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(isOpen: .constant(false))
    }
}
