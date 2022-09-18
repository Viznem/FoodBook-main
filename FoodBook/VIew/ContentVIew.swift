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
import RiveRuntime

struct ContentVIew: View {
    @State var isOpen = false
    @State var menuOption: String = "Home"
    
    let menuButton = RiveViewModel(fileName: "menu_button", stateMachineName: "State Machine", autoPlay: false)

    var body: some View {
        
        ZStack{
            Color("ColorDark").ignoresSafeArea()
            
            MenuView(menuOption: $menuOption)
                .opacity(isOpen ? 1 : 0)
                .offset(x: isOpen ? 0 : -300)
                .rotation3DEffect(.degrees(isOpen ? 0 : 30), axis: (x: 0, y: -1, z: 0))
            
            switch menuOption{
            case "Home":
               HomePageView(isOpen: $isOpen)
            case "Favorites":
               FavoritesView(isOpen: $isOpen)
            case "User Recipes":
                UserRecipeView(isOpen: $isOpen)
            case "Messages":
               MessagesView(isOpen: $isOpen)
            default:
                Text("404").foregroundColor(Color.white)
            }
            
            //  MENU BUTTON
            menuButton.view()
                .layoutPriority(1)
                .frame(width: 35, height: 35)
                .mask(Circle())
                .shadow(radius: 5)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .onTapGesture {
                    
                    menuButton.setInput("isOpen", value: isOpen)
                    
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)){
                        isOpen.toggle()
                    }
                }
                                
            
        }//ZStack
        
    }
}

struct ContentVIew_Previews: PreviewProvider {
    static var previews: some View {
        ContentVIew()
    }
}
