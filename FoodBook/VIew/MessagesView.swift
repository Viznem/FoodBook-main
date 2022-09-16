//
//  MessagesView.swift
//  FoodBook
//
//  Created by Thinh, Nguyen Truong on 09/09/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChatUser {
    let uid, email, profileImageUrl: String
}

class MessagesViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var user: ChatUser?
    
    init() {
        fetchCurrentUser()
    }
    
    private func fetchCurrentUser() {
       
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }
        
       
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).getDocument { snapshot, error in
                if let error = error {
                    print("Failed to fetch current user:", error)
                    return
                }
                
                guard let data = snapshot?.data() else {
                    self.errorMessage = "No Data"
                    return
                }
                
                let uid = data["uid"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let profileImageUrl = data["profileImageUrl"] as? String ?? ""
                
                self.user = ChatUser(uid: uid, email: email, profileImageUrl: profileImageUrl)
            }
    }
    
}

struct MessagesView: View {
    @State var shouldShowLogOutOptions = false
    @EnvironmentObject var loginViewModel: LoginViewModel
    @ObservedObject var vm = MessagesViewModel()
    @Binding var isOpen: Bool
    
    var body: some View {
        ZStack{
            Color(.white).ignoresSafeArea()
            
            NavigationView {
                VStack(alignment: .leading){
                    
                    customNavBar
                   
                    ScrollView {
                        ForEach(0..<10, id: \.self) { num in
                            VStack{
                                HStack(spacing: 10){
                                    Image(systemName: "person.fill")
                                       .font(.system(size: 32))
                                       .padding(8)
                                       .overlay(RoundedRectangle(cornerRadius: 44)
                                                   .stroke(Color(.label), lineWidth: 1)
                                       )


                                   VStack(alignment: .leading) {
                                       Text("\(vm.user?.email ?? "")")
                                           .font(.system(size: 16, weight: .bold))
                                       Text("Message sent to user")
                                           .font(.system(size: 14))
                                           .foregroundColor(Color(.lightGray))
                                   }
                                   Spacer()

                                   Text("22d")
                                       .font(.system(size: 14, weight: .semibold))
                                }
                                Divider()
                                    .padding(.vertical, 8)
                            }.padding(.horizontal)                        }
                    }.padding(.bottom, 50)
                }//VStack
                
                
            }//NavigationView
            .overlay(
                newMessageButton, alignment: .bottom)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .padding(.bottom, 30)
            
        }//ZStack
        .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .rotation3DEffect(.degrees(isOpen ? 30: 0), axis: (x: 0, y: -1, z: 0))
        .offset(x: isOpen ? 265 : 0)
        .scaleEffect(isOpen ? 0.9 : 1)
        .ignoresSafeArea()
        
    }
    
    private var newMessageButton: some View {
           Button {
            //
           } label: {
               HStack {
                   Spacer()
                   Text("+ New Message")
                       .font(.system(size: 16, weight: .bold))
                   Spacer()
               }
               .foregroundColor(.white)
               .padding(.vertical)
                   .background(Color.blue)
                   .cornerRadius(32)
                   .padding(.horizontal)
                   .shadow(radius: 15)
           }
       }
    
    private var customNavBar: some View {
            HStack(spacing: 16) {
                
                WebImage(url: URL(string: vm.user?.profileImageUrl ?? ""))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .clipped()
                    .cornerRadius(50)
                    .overlay(RoundedRectangle(cornerRadius: 44)
                        .stroke(Color(.label), lineWidth: 1))
                    
                    
                
                VStack(alignment: .leading, spacing: 4) {
                    let userName = vm.user?.email.replacingOccurrences(of: "@gmail.com", with: "") ?? ""
                    
                    Text(userName)
                        .font(.system(size: 24, weight: .bold))

                    HStack {
                        Circle()
                            .foregroundColor(.green)
                            .frame(width: 14, height: 14)
                        Text("online")
                            .font(.system(size: 12))
                            .foregroundColor(Color(.lightGray))
                    }

                }

                Spacer()
                Button {
                    shouldShowLogOutOptions.toggle()
                } label: {
                    Image(systemName: "gear")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(.label))
                }
            }
            .padding()
            .actionSheet(isPresented: $shouldShowLogOutOptions) {
                .init(title: Text("Settings"), message: Text("What do you want to do?"), buttons: [
                    .destructive(Text("Sign Out"), action: {
                        loginViewModel.signOut()
                    }),
                        .cancel()
                ])
            }
        }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView(isOpen: .constant(false))
    }
}
