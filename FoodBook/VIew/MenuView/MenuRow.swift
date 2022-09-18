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

struct MenuRow: View {
    // MARK: - PROPERTIES
    var item: MenuItem
    let haptics = UINotificationFeedbackGenerator()
    @Binding var selectedMenu: SelectedMenu
    @Binding var menuOption: String
    
    var body: some View {
        HStack(spacing:14){
            item.icon.view()
                .frame(width: 32, height: 32)
                .opacity(0.6)
            Text(item.text)
                .font(.headline)
        }
         .frame(maxWidth: .infinity, alignment: .leading)
         .padding(12)
         .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.pink)
                .frame(maxWidth: selectedMenu == item.menu ? .infinity : 0)
                .frame(maxWidth: .infinity, alignment: .leading)
         )
         .onTapGesture {
             item.icon.setInput("active", value: true)
             DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                 item.icon.setInput("active", value: false)
             }
             withAnimation(.timingCurve(0.2, 0.8, 0.2, 1)) {
                 selectedMenu = item.menu
                 menuOption = item.text
             }
             haptics.notificationOccurred(.success)
        }
    }
}

struct MenuRow_Previews: PreviewProvider {
    static var previews: some View {
        MenuRow(item: menuItems[0], selectedMenu: .constant(.home), menuOption: .constant("Home"))
    }
}
