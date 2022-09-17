//
//  ChatView.swift
//  FoodBook
//
//  Created by Thinh, Nguyen Truong on 17/09/2022.
//

import SwiftUI

struct ChatView: View {
    let chatUser: ChatUser?

        @State var chatText = ""

        var body: some View {
            ZStack {
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
                ForEach(0..<20) { num in
                    HStack {
                        Spacer()
                        HStack {
                            Text("FAKE MESSAGE FOR NOW")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }

                HStack{ Spacer() }
                .frame(height: 50)
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
                    TextEditor(text: $chatText)
                        .opacity(chatText.isEmpty ? 0.5 : 1)
                }
                .frame(height: 40)

                Button {

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
