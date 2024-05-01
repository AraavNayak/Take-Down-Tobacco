//
//  ContentView.swift
//  LoginScreen
//
//  Created by Federico on 13/11/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var wrongUsername: Float = 0
    @State private var wrongPassword: Float  = 0
    @State private var showingLoginScreen = false
    
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.black, Color(red: 34/255, green: 17/255, blue: 77/255)]), startPoint: .top, endPoint: .bottom)
                                .edgesIgnoringSafeArea(.all)
//                Color(red: 26/255, green: 13/255, blue: 60/255)
//                    .ignoresSafeArea()
//                Circle()
//                    .scale(1.7)
//                    .foregroundColor(.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white.opacity(0))

                VStack {
                    Text("Welcome!")
                        //.foregroundColor(.white)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .bold()
                        .padding()
                    
                    Text("P3 APCS Attendance App")
                        .padding()
                        .frame(width: 300, height: 50)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongUsername))
                        
                        
                    
                    Text("Developer: Araav Nayak")
                        .padding()
                        .frame(width: 300, height: 50)
                        .foregroundColor(Color.white)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongPassword))
                    
                    Button("Begin") {
                        //authenticateUser(username: username, password: password)
                        let vc = ViewController()
                        UIApplication.shared.windows.first?.rootViewController?.present(vc, animated: true, completion: nil)
                                        
                        }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
                    
                    NavigationLink(destination: Text("You are logged in @\(username)"), isActive: $showingLoginScreen) {
                        EmptyView()
                    }
                }
            }.navigationBarHidden(true)
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
