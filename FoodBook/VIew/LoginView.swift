//
//  LoginView.swift
//  FoodBook
//
//  Created by Thinh, Nguyen Truong on 06/09/2022.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseCore
import FirebaseFirestore



class LoginViewModel: ObservableObject {
    
    let auth = Auth.auth()
    let storage = Storage.storage()
    
    @Published var loggedIn = false
    @Published var loginStatusMessage = ""
    
    var isLoggedIn: Bool {
        return auth.currentUser != nil
    }
    
    func login(email: String, password: String) {
        auth.signIn(withEmail: email,
                    password: password) { [weak self] result, error in
            
            guard result != nil, error == nil else {
                return
            }
            //Success
            DispatchQueue.main.async {
                self?.loggedIn = true
            }
        }
    }
    
    func register(email: String, password: String, image: UIImage) {
        auth.createUser(withEmail: email,
                        password: password) { [weak self] result, error in
            
            guard result != nil, error == nil else {
                self?.loginStatusMessage = "Failed to create user! Email/Password already exist"
                return
            }
            //Success
            DispatchQueue.main.async {

                let db = Firestore.firestore()
                
                self?.loginStatusMessage = "Successfully Create User!"
                self?.loggedIn = true
                self?.persistImageToStorage(image: image)
                guard let uid = self?.auth.currentUser?.uid else {return}
                // Add a new document with a generated ID
                var ref: DocumentReference? = nil
                ref = db.collection("users").addDocument(data: [
                    "uid": uid,
                    "recipes": [],
                    "favorites": []
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                    }
                }
                
            }
            
        }
    }
    
    func persistImageToStorage(image: UIImage) {
        guard let uid = auth.currentUser?.uid else {return}
        let ref = storage.reference(withPath: uid)
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            return
        }
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                self.loginStatusMessage = "Failed to push image to Storage: \(error)"
                return
            }
            
            ref.downloadURL { url, error in
                if let error = error {
                    self.loginStatusMessage = "Failed to retrieve downloadURL: \(error)"
                    return
                }
                self.loginStatusMessage = "Successfully stored image: \(url?.absoluteString ?? "")"
            }
            
        }
        
    }
    
    func signOut() {
        try? auth.signOut()
        
        self.loggedIn = false
    }
    
}

struct LoginView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    var body: some View {
        
        NavigationView{
            if loginViewModel.isLoggedIn {
                ContentVIew()
            }
            else {
                SignIn()
            }
        }
        .onAppear{
            loginViewModel.loggedIn = loginViewModel.isLoggedIn
        }
    }
}

//Sign In View
struct SignIn: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    var body: some View {
        ZStack{
            Color.black
            
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(.linearGradient(colors: [.pink, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 1000, height: 400)
                .rotationEffect(.degrees(135))
                .offset(y: -350)
                
            
            VStack(spacing: 20){
                
                Text("Welcome")
                    .foregroundColor(.white)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .offset(x: -70, y:-90)
                
                    
                
                TextField("Email", text: $email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: email.isEmpty) {
                                 Text("Email")
                                    .foregroundColor(.white)
                                    .bold()
                    }
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                    
                
                SecureField("Password", text: $password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: password.isEmpty) {
                            Text("Password")
                                .foregroundColor(.white)
                                .bold()
                    }
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                // SIGN UP BUTTON
                Button {
                    loginViewModel.login(email: email, password: password)
                }label: {
                     Text("Sign In")
                        .bold()
                        .frame(width: 200, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.linearGradient(colors: [.pink, .red], startPoint: .top, endPoint: .bottomTrailing))
                               
                        )
                        .foregroundColor(.white)
                }// SIGN UP BUTTON
                .padding(.top)
                .offset(y: 110)
                
                HStack{
                    Text("Don't have an account?")
                        .bold()
                        .foregroundColor(.white)
                    
                    NavigationLink("Create", destination: SignUp())
                }
                .padding(.top)
                .offset(y: 110)
               
                
                
            }//VStack
            .frame(width: 350)
        
        }//Zstack
        .ignoresSafeArea()
    }
}

//Sign Up View
struct SignUp: View {
    @State private var email = ""
    @State private var password = ""
    @State private var image: UIImage?
    @State private var shouldShowImagePicker = false
    
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    let defaultImage = UIImage(named: "defaultIcon")
    
    var body: some View {
        ZStack{
            Color.black
            
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(.linearGradient(colors: [.pink, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 1000, height: 400)
                .rotationEffect(.degrees(135))
                .offset(y: -350)
                
            
            VStack(spacing: 20){
                
                Text("New User")
                    .foregroundColor(.white)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .offset(x: -70, y: -100)
                
                Button{
                    shouldShowImagePicker.toggle()
                }label: {
                    
                    VStack {
                        
                        if let image = self.image {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .scaledToFill()
                                .cornerRadius(100)
                            
                        } else {
                            Image(systemName: "person.fill")
                                .font(.system(size: 100))
                                .padding()
                                .foregroundColor(.white)
                        }
                    }
                    .overlay(RoundedRectangle(cornerRadius: 100)
                        .stroke(Color.white, lineWidth: 3)
                    )
                    
                }
                    
                
                TextField("Email", text: $email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: email.isEmpty) {
                                 Text("Email")
                                    .foregroundColor(.white)
                                    .bold()
                    }
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                    
                
                SecureField("Password", text: $password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: password.isEmpty) {
                            Text("Password")
                                .foregroundColor(.white)
                                .bold()
                    }
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                
                // SIGN UP BUTTON
                Button {
                    loginViewModel.register(email: email, password: password, image: (image ?? defaultImage)!)
                }label: {
                     Text("Sign Up")
                        .bold()
                        .frame(width: 200, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.linearGradient(colors: [.pink, .red], startPoint: .top, endPoint: .bottomTrailing))
                               
                        )
                        .foregroundColor(.white)
                }// SIGN UP BUTTON
                .padding(.top)
                .offset(y: 110)
                
                
                Text(loginViewModel.loginStatusMessage)
                    .foregroundColor(.red)
                    .bold()
                
            }//VStack
            .frame(width: 350)
        
        }//Zstack
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let loginViewModel = LoginViewModel()
        LoginView()
            .environmentObject(loginViewModel)
            
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

