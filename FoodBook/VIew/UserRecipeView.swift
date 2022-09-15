////
////  UserRecipeView.swift
////  FoodBook
////
////  Created by Thinh, Nguyen Truong on 09/09/2022.
////
//
//import SwiftUI
//
//struct UserRecipeView: View {
//    @Binding var isOpen: Bool
//    @State private var showCRUDview = false
//
//    var body: some View {
//        ZStack{
//            Color(.white).ignoresSafeArea()
//            VStack{
//                    Button{
//                        showCRUDview.toggle()
//                    }label: {
//                        Text("ADD")
//                    }.sheet(isPresented: $showCRUDview){
//                        CRUDView()
//                    }
//            }//VStack
//        }//ZStack
//        .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
//        .rotation3DEffect(.degrees(isOpen ? 30: 0), axis: (x: 0, y: -1, z: 0))
//        .offset(x: isOpen ? 265 : 0)
//        .scaleEffect(isOpen ? 0.9 : 1)
//        .ignoresSafeArea()
//
//    }
//}
//
//struct UserRecipeView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserRecipeView(isOpen: .constant(false))
//    }
//}
