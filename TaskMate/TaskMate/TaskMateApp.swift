//
//  TaskMateApp.swift
//  TaskMate
//
//  Created by Fico Pangestu on 04/04/23.
//

import SwiftUI

@main
struct TaskMateApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
