//
//  LoginView.swift
//  FoodBook
//
//  Created by Thinh, Nguyen Truong on 06/09/2022.
//

import SwiftUI
import Firebase

class LoginViewModel: ObservableObject {
    
    let auth = Auth.auth()
    
    @Published var loggedIn = false
    
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
    
    func register(email: String, password: String) {
        auth.createUser(withEmail: email,
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
    
    func signOut() {
        try? auth.signOut()
        
        self.loggedIn = false
    }
    
}

struct LoginView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    var body: some View {
        NavigationView {
            if loginViewModel.isLoggedIn {
               HomePageView()
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
                
                Text("New User")
                    .foregroundColor(.white)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .offset(x: -70, y: -100)
                    
                
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
                    loginViewModel.register(email: email, password: password)
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
                
            }//VStack
            .frame(width: 350)
        
        }//Zstack
        .ignoresSafeArea()
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

