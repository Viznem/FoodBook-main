//
//  AddMessageView.swift
//  FoodBook
//
//  Created by Thinh, Nguyen Truong on 16/09/2022.
//

import SwiftUI
import SDWebImageSwiftUI

class AddMessageViewModel: ObservableObject {
    
    @Published var users = [ChatUser]()
        @Published var errorMessage = ""

        init() {
            fetchAllUsers()
        }

        private func fetchAllUsers() {
            FirebaseManager.shared.firestore.collection("users")
                .getDocuments { documentsSnapshot, error in
                    if let error = error {
                        self.errorMessage = "Failed to fetch users: \(error)"
                        print("Failed to fetch users: \(error)")
                        return
                    }
                
                    documentsSnapshot?.documents.forEach({ snapshot in
                        let data = snapshot.data()
                   
                        let user = ChatUser(data: data)
                        
                        if user.uid != FirebaseManager.shared.auth.currentUser?.uid {
                            self.users.append(.init(data: data))
                        }
                    })
                }
        }
}

struct AddMessageView: View {
    
    let selectChatUser: (ChatUser) -> ()
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var vm = AddMessageViewModel()

       var body: some View {
           NavigationView {
               ScrollView {
                   Text(vm.errorMessage)
                   
                   ForEach(vm.users) { user in
                       Button {
                           presentationMode.wrappedValue.dismiss()
                           selectChatUser(user)
                           
                       } label: {
                           HStack(spacing: 16) {
                               WebImage(url: URL(string: user.profileImageUrl))
                                   .resizable()
                                   .scaledToFill()
                                   .frame(width: 50, height: 50)
                                   .clipped()
                                   .cornerRadius(50)
                                   .overlay(RoundedRectangle(cornerRadius: 50)
                                               .stroke(Color(.label), lineWidth: 2)
                                   )
                               Text(user.email)
                                   .foregroundColor(Color(.label))
                               Spacer()
                           }.padding(.horizontal)
                       }
                       Divider()
                           .padding(.vertical, 8)
                   }
               }.navigationTitle("New Message")
                   .toolbar {
                       ToolbarItemGroup(placement: .navigationBarLeading) {
                           Button {
                               presentationMode.wrappedValue.dismiss()
                           } label: {
                               Text("Cancel")
                           }
                       }
                   }
           }
       }
}

struct AddMessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView(isOpen: .constant(false))
    }
}
