//
//  ContentView.swift
//  TaskMate
//
//  Created by Fico Pangestu on 04/04/23.
//

import SwiftUI

struct ContentView: View {
    @State private var indexPage = 0
    @FetchRequest(
        sortDescriptors: []
    ) var profile: FetchedResults<ProfileEntity>
    
    var body: some View {
          /* Starter Template */
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundColor(.accentColor)
//            Text("Hello, world!")
//        }
//        .padding()
//        LandingPageView(indexPage: $indexPage)
        
        if profile.last != nil {
            Home(profile: profile.last!)
        } else {
            LandingPageView(indexPage: $indexPage)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
