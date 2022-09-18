//
//  MessagesView.swift
//  FoodBook
//
//  Created by Thinh, Nguyen Truong on 09/09/2022.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

struct RecentMessage: Identifiable {
    
    var id: String { documentId }
    
    let documentId : String
    let text, email: String
    let fromId, toId: String
    let profileImageUrl: String
    let timestamp: Timestamp
    
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.text = data["text"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.fromId = data["fromId"] as? String ?? ""
        self.toId = data["toId"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}

struct ChatUser: Identifiable {
    
    var id: String {uid}
    
    let uid, email, profileImageUrl: String
    
    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
    }
}

class MessagesViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var user: ChatUser?
    @Published var isLogOut = false
    @Published var recentMessages = [RecentMessage]()
    
    init() {
        DispatchQueue.main.async {
            self.isLogOut =
            FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        
        fetchCurrentUser()
        
        fetchRecentMessages()
        
    }
   
    private func fetchRecentMessages() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        
        FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for recent messages: \(error)"
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
                    
                    if let index = self.recentMessages.firstIndex(where: { rm in
                        return rm.documentId == docId
                    }) {
                        self.recentMessages.remove(at: index)
                    }
                    
                    self.recentMessages.insert(.init(documentId: docId, data: change.document.data()), at: 0)
                
                })
                
            }
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
                FirebaseManager.shared.currentUser = ChatUser(data: data)
    
                self.user = ChatUser(data: data)
            }
    }
}

struct MessagesView: View {
    
    @State var shouldShowLogOutOptions = false
    @State var showMessageScreen = false
    @State var navigateToChatView = false
    @State var chatUser: ChatUser?
    
    
    @EnvironmentObject var loginViewModel: LoginViewModel
    @ObservedObject var vm = MessagesViewModel()
    @Binding var isOpen: Bool
    
    var body: some View {
        ZStack{
            Color(.white).ignoresSafeArea()
            
            NavigationView {
                VStack(alignment: .leading){
                    customNavBar
                    
                    messageList
                    
                    NavigationLink("", isActive: $navigateToChatView) {
                        ChatView(chatUser: self.chatUser)
                    }
                    
                    newMessageButton
                }//VStack
                
            }//NavigationView
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
               showMessageScreen.toggle()
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
           .fullScreenCover(isPresented: $showMessageScreen) {
               AddMessageView(selectChatUser: { user in
                   print(user.email)
                   self.navigateToChatView.toggle()
                   self.chatUser = user
               })
           }
       }
    
    
    private var messageList: some View {

        ScrollView {
            ForEach(vm.recentMessages) { recentMessage in
                VStack{
                    Button {
                        showMessageScreen.toggle()
                    } label: {
                        HStack(spacing: 16){
                            WebImage(url: URL(string: recentMessage.profileImageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipped()
                                .cornerRadius(50)
                                .overlay(RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color.black, lineWidth: 1))
                                .shadow(radius: 5)
                           
                           VStack(alignment: .leading, spacing: 8) {
                               Text(recentMessage.email)
                                   .font(.system(size: 16, weight: .bold))
                                   .foregroundColor(Color(.label))
                               Text(recentMessage.text)
                                   .font(.system(size: 14))
                                   .foregroundColor(Color(.lightGray))
                                   .multilineTextAlignment(.leading)
                           }
                           Spacer()

                        }//HStack
                            Divider().padding(.vertical, 8)
                        }
                    
                }//VStack
                .padding(.horizontal)
            }
        }.padding(.bottom, 50)
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
