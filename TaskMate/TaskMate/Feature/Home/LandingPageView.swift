//
//  LandingPageView.swift
//  TaskMate
//
//  Created by Karen Susanto on 11/04/23.
//

import SwiftUI

struct LandingPageView: View {
    @Environment(\.managedObjectContext) var moc
    @State private var isShowingLoginPage = false
    @Binding var indexPage: Int
    
    func navigateToLogin() {
        self.isShowingLoginPage = true
    }
    
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Text("Task*Mate*")
                    .font(.system(size: 24))
                    .fontWeight(.regular)
                    .foregroundColor(.black)
                    .padding(.top, -75.0)
                    .padding(.bottom, 50.0)
                Spacer()
                
                Image("Landing Page")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.top, -160.0)
                    .frame(width: 500, height: 100)
                
                Spacer()
                
                Text("Start Enjoying a More Organized Work Life")
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 95.0)
                    .padding(.top, -75.0)
                
                Text("Start Changing the Timeline of Life Regularly in Order to Increase Your Productivity")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 100.0)
                    .padding(.top, 0)
                    .padding(.bottom, -75)
                
                Spacer()
                
                Button(action: {
                    navigateToLogin()
                }) {
                    HStack {
                        Text("Get Started")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                            .font(.title)
                            .padding(.trailing, 10)
                    }
                    .frame(width: 200, height: 60)
                    .background(Color.black)
                    .cornerRadius(30)
                }
                .padding(.bottom, 25.0)
            }
        }
        .fullScreenCover(isPresented: $isShowingLoginPage, content: {
            LoginView(indexPage: $indexPage)
        })
    }
}

//struct LandingPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        LandingPageView()
//    }
//}
