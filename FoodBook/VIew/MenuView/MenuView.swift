//
//  MenuView.swift
//  FoodBook
//
//  Created by Thinh, Nguyen Truong on 09/09/2022.
//

import SwiftUI
import RiveRuntime

struct MenuView: View {
    // MARK: - PROPERTIES
    @State var selectedMenu: SelectedMenu = .home
    @Binding var menuOption: String
    
    let icon = RiveViewModel(fileName: "icons", stateMachineName: "HOME_interactivity", artboardName: "HOME")
    
    var body: some View {
        VStack{
            HStack{
                Image("Logo")
                    .resizable()
                    .frame(width: 70, height: 50)
                    .mask(Circle())
                    
                    
                
                VStack(alignment: .leading, spacing: 2){
                    Text("FoodBook")
                        .font(.body)
                        .bold()
                    Text("Best Food Recipes")
                        .font(.subheadline)
                        .opacity(0.7)
                }
                Spacer()
                
            }//HStack
            .padding()
            
            VStack{
                
                Rectangle()
                    .frame(height:1)
                    .opacity(0.5)
                    .padding(.horizontal)
                
                HStack{
                   
                }.padding()
                
                    ForEach(menuItems) { item in
                        MenuRow(item: item, selectedMenu: $selectedMenu, menuOption: $menuOption)
                    }
                
            }
             .padding(8)
            
            Spacer()
        }//VStack
        .foregroundColor(.white)
        .frame(maxWidth: 288, maxHeight: .infinity)
        .background(Color("ColorDark"))
        .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}



struct MenuItem: Identifiable {
    var id = UUID()
    var text: String
    var icon: RiveViewModel
    var menu: SelectedMenu
}

var menuItems = [
    MenuItem(text: "Home", icon: RiveViewModel(fileName: "icons", stateMachineName: "HOME_interactivity", artboardName: "HOME"), menu: .home),
    MenuItem(text: "Favorites", icon: RiveViewModel(fileName: "icons", stateMachineName: "STAR_Interactivity", artboardName: "LIKE/STAR"), menu: .favorites),
    MenuItem(text: "User Recipes", icon: RiveViewModel(fileName: "icons", stateMachineName: "USER_Interactivity", artboardName: "USER"), menu: .user),
    MenuItem(text: "Messages", icon: RiveViewModel(fileName: "icons", stateMachineName: "CHAT_Interactivity", artboardName: "CHAT"), menu: .message),
]

enum SelectedMenu: String {
    case home
    case favorites
    case user
    case message
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(menuOption: .constant("Home"))
    }
}
