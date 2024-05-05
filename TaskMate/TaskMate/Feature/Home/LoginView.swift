//
//  LoginView.swift
//  TaskMate
//
//  Created by Karen Susanto on 12/04/23.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.managedObjectContext) var moc
    @State private var username = ""
    @State private var password = ""
    @State private var showingHomePage = false
    @Binding var indexPage: Int

    @FetchRequest(
        sortDescriptors: []
    ) var profile: FetchedResults<ProfileEntity>
    
    var body: some View {
        
        ZStack{
            
            Color.black
             .ignoresSafeArea()
  
            Text("Good to see you,")
            
                .font(.system(size: 30))
                .fontWeight(.semibold)
                .foregroundColor(Color.white)
                .position(x: 125, y: 105)
            
            Text("Let’s tackle those task!")
            
                .font(.system(size: 24))
                .fontWeight(.semibold)
                .foregroundColor(Color.white)
                .position(x: 138, y: 139)
            
            RoundedRectangle(cornerRadius: 70, style: .circular)
                .frame(width: 415, height: 700)
                .position(x: 195, y: 600)
                .ignoresSafeArea()
                .foregroundColor(.white)
            
            VStack{
                
                Text("Login")
                    .font(.system(size: 36))
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.top, 300.0)
               
                Image("LoginPic")
                    .resizable()
                    .frame(width: 400, height: 200)
                    
                TextField("Name", text: $username)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(45)
                    .padding()
                
                Button("   Get Started \(Image(systemName: "arrow.right"))"){
                    
                    let Profile = ProfileEntity (context: moc)
                    Profile.name = username
                    try? moc.save()
                    
                    indexPage = 1
                    
//                    showingHomePage.toggle()
                }
                .foregroundColor(.white)
                .frame(width: 300, height: 50)
                .background(Color.black)
                .cornerRadius(15)
                .padding(.bottom, 3.0)
                
                
                Text("Forgot Password?")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding()
             
            }
            .sheet(isPresented: $showingHomePage){
                Home(profile: profile.last!)
            }
        }
        
    }
    
//    struct tes_Previews: PreviewProvider {
//        static var previews: some View {
//            LoginView()
//        }
//    }
    
}
