//
//  AddMessageView.swift
//  FoodBook
//
//  Created by Thinh, Nguyen Truong on 16/09/2022.
//

import SwiftUI
import SDWebImageSwiftUI

class AddMessageViewModel: ObservableObject {
    
    @Published var users = [User]()
    @Published var errorMessage = ""
    
    init() {
        fetchAllUsers()
    }
    
    private func fetchAllUsers() {
        FirebaseManager.shared.firestore.collection("users")
            .getDocuments { snapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to fetch users: \(error)"
                    print("Failed to fetch users: \(error)")
                    return
                }
                
                self.errorMessage = "Fetched users successfully"
            }
    }
}

struct AddMessageView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var vm = AddMessageViewModel()

       var body: some View {
           NavigationView {
               ScrollView {
                   Text(vm.errorMessage)
                   
                   ForEach(0..<10) { num in
                       Text("New user")
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
