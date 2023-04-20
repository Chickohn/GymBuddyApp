//
//  SwiftUIView.swift
//  GymBuddySwiftUI
//
//  Created by Freddie Kohn on 11/04/2023.
//

import SwiftUI

struct OLDLoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLogged = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Log in to your account:").padding().font(.system(size: 24))
                    Spacer()
                }
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button(action: {
                    if isValidEmail(email) && isValidPassword(password) {
                        // Valid email and password
                        self.isLogged = true
                    } else {
                        // Invalid email or password
                        // Show an error message or alert
                        errorMessage = "Incorrect email or password"
                    }
                }) {
                    Text("Log In")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                Text(errorMessage).foregroundColor(Color(.red)).padding()
            }
            .background(RoundedRectangle(cornerRadius: 15).fill(Color(.lightGray)).shadow(radius: 5, x: -5, y: 5).background(RoundedRectangle(cornerRadius:15).stroke(Color(.darkGray))))//.stroke(Color(.black)))
            //.navigationBarTitle("Log In")
            .navigationBarItems(leading: Text("GymBuddy").font(.title), trailing:
                                    NavigationLink(destination: SignupView()) {
                Text("Sign Up")
            })
        }
        .fullScreenCover(isPresented: $isLogged) {
            MainView()
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        // Validate email using regular expression or other logic
        // Return true if email is valid, false otherwise
        if email == "" {
            return true
        } else {
            return false
        }
    }
    
    func isValidPassword(_ password: String) -> Bool {
        // Validate password using regular expression or other logic
        // Return true if password is valid, false otherwise
        if password == "" {
            return true
        } else {
            return false
        }
    }
}
            

struct SignupView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    @State private var isLogged = false

    var body: some View {
        Form {
            Section(header: Text("Personal Information")) {
                TextField("First Name", text: $firstName)
                TextField("Last Name", text: $lastName)
            }
            Section(header: Text("Account Information")) {
                TextField("Username", text: $username)
                SecureField("Password", text: $password)
                TextField("Email", text: $email)
            }
            Section {
                Button(action: {
                    // Save the user's information
                    isLogged = true
                    
                }) {
                    Text("Save")
                }
            }
        }
        .navigationTitle("Sign Up")
        .fullScreenCover(isPresented: $isLogged) {
            MainView()
        }
    }
}


struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        OLDLoginView()
    }
}
