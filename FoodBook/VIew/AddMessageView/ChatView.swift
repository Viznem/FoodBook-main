//
//  ChatView.swift
//  FoodBook
//
//  Created by Thinh, Nguyen Truong on 17/09/2022.
//

import SwiftUI
import Firebase

struct ChatMessage: Identifiable {
    var id: String { documentId }
    
    let documentId: String
    let fromId, toId, text: String
    
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.fromId = data["fromId"] as? String ?? ""
        self.toId = data["toId"] as? String ?? ""
        self.text = data["text"] as? String ?? ""
    }
}

class ChatViewModel: ObservableObject {
    
    @Published var chatText = ""
    @Published var errorMessage = ""
    @Published var chatMessages = [ChatMessage]()
    @Published var count = 0
    
    let chatUser: ChatUser?
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        
        fetchMessages()
    }
    
    private func fetchMessages() {
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        
        guard let toId = chatUser?.uid else {return}
        
        FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "failed: \(error)"
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        let data = change.document.data()
                        self.chatMessages.append(.init(documentId: change.document.documentID, data: data))
                    }
                })
                
                DispatchQueue.main.async {
                    self.count += 1
                }
            }
    }
    
    func handleSend() {
        print(chatText)
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        
        guard let toId = chatUser?.uid else {return}
        
        let document =
            FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .document()
        
        let messageData = ["fromId": fromId, "toId": toId, "text": self.chatText, "timestamp": Timestamp()]  as [String: Any]
        
        document.setData(messageData) { error in
            if let error = error {
                self.errorMessage = "Failed to save message \(error)"
                return
            }
            print("Send Message Success")
            
            self.persistRecentMessage()
            
            self.chatText = ""
            self.count += 1
        }
        
        let recipientMessageDocument =
            FirebaseManager.shared.firestore
            .collection("messages")
            .document(toId)
            .collection(fromId)
            .document()
        
        recipientMessageDocument.setData(messageData) { error in
            if let error = error {
                self.errorMessage = "Failed to save message \(error)"
                return
            }
            print("Recieve Message Success")
        }
    }
    
    private func persistRecentMessage() {
        
        guard let chatUser = chatUser else { return }
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        
        guard let toId = self.chatUser?.uid else {return}
                
        let document = FirebaseManager.shared.firestore.collection("recent_messages")
            .document(uid)
            .collection("messages")
            .document(toId)
        
        let data = [
            "timestamp": Timestamp(),
            "text": self.chatText,
            "fromId": uid,
            "toId": toId,
            "profileImageUrl": chatUser.profileImageUrl,
            "email": chatUser.email
        ] as [String: Any]
        
        
        
        document.setData(data) { error in
            if let error = error {
                self.errorMessage = "Faile recent message \(error)"
                print("Recent message fail: \(error)")
                return
            }
        }
        
        guard let currentUser = FirebaseManager.shared.currentUser else { return }
                let recipientRecentMessageDictionary = [
                    "timestamp": Timestamp(),
                    "text": self.chatText,
                    "fromId": uid,
                    "toId": toId,
                    "profileImageUrl": currentUser.profileImageUrl,
                    "email": currentUser.email
                ] as [String : Any]

                FirebaseManager.shared.firestore
                    .collection("recent_messages")
                    .document(toId)
                    .collection("messages")
                    .document(currentUser.uid)
                    .setData(recipientRecentMessageDictionary) { error in
                        if let error = error {
                            print("Failed to save recipient recent message: \(error)")
                            return
                        }
                    }
    }
    
}

struct ChatView: View {
    
       
        let chatUser: ChatUser?
        
        init(chatUser: ChatUser?){
            self.chatUser = chatUser
            self.vm = .init(chatUser: chatUser)
        }
    
        @ObservedObject var vm: ChatViewModel
    
        var body: some View {
            ZStack {
                Text(vm.errorMessage)
                
                messagesView
                VStack(spacing: 0) {
                    Spacer()
                    chatBottomBar
                        .background(Color.white.ignoresSafeArea())
                }
            }
            .navigationTitle(chatUser?.email ?? "")
                .navigationBarTitleDisplayMode(.inline)
        }

        private var messagesView: some View {
            ScrollView {
                ScrollViewReader { ScrollViewProxy in
                    ForEach(vm.chatMessages) { message in
                        VStack{
                            if message.fromId ==
                                FirebaseManager.shared.auth.currentUser?.uid {
                                HStack {
                                    Spacer()
                                    HStack {
                                        Text(message.text)
                                            .foregroundColor(.white)
                                    }
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(8)
                                }
                            } else {
                                HStack {
                                    HStack {
                                        Text(message.text)
                                            .foregroundColor(.black)
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    Spacer()
                                }
                            }
                        }//VStack
                        .padding(.horizontal)
                        .padding(.top, 8)
                        
                    }
                    
                    HStack{ Spacer() }
                    .frame(height: 50)
                    .id("Bottom")
                    .onReceive(vm.$count) { _ in
                        withAnimation(.easeOut(duration: 0.5)) {
                            ScrollViewProxy.scrollTo("Bottom", anchor: .bottom)
                        }
                    }
                }
            }
            .background(Color(.init(white: 0.95, alpha: 1)))

        }

        private var chatBottomBar: some View {
            HStack(spacing: 16) {
                Image(systemName: "photo.on.rectangle")
                    .font(.system(size: 24))
                    .foregroundColor(Color(.darkGray))
                ZStack {
                    DescriptionPlaceholder()
                    TextEditor(text: $vm.chatText)
                        .opacity(vm.chatText.isEmpty ? 0.5 : 1)
                }
                .frame(height: 40)

                //SEND BUTTON
                Button {
                    vm.handleSend()
                } label: {
                    Text("Send")
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.blue)
                .cornerRadius(4)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ChatView(chatUser: .init(data: ["uid": "PsLtIGmNVPg9S6BD2PXLCv4tMIG3", "email": "viznem@gmail.com"]))
        }
    }
}

private struct DescriptionPlaceholder: View {
    var body: some View {
        HStack {
            Text("Description")
                .foregroundColor(Color(.gray))
                .font(.system(size: 17))
                .padding(.leading, 5)
                .padding(.top, -4)
            Spacer()
        }
    }
}
