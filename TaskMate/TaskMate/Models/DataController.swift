//
//  DataController.swift
//  TaskMate
//
//  Created by Fico Pangestu on 05/04/23.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "TaskDataModel")
    init() {
        container.loadPersistentStores {
            description, error in if let error = error {
                print("Core data failed to load \(error)")
            }
        }
    }
}

//class DataController {
//  static let shared = DataManager()
//  lazy var persistentContainer: NSPersistentContainer = {
//    let container = NSPersistentContainer(name: "TaskEntityDataModel")
//    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//      if let error = error as NSError? {
//        fatalError("Unresolved error \(error), \(error.userInfo)")
//      }
//    })
//    return container
//  }()
//  //Core Data Saving support
//  func save () {
//    let context = persistentContainer.viewContext
//    if context.hasChanges {
//      do {
//          try context.save()
//      } catch {
//          let nserror = error as NSError
//          fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//      }
//    }
//  }
//}

//func project(name: String) -> ProjectEntity {
//  let project = ProjectEntity(context: persistentContainer.viewContext)
//  project.name = name
//  return project
//}
//
//func task(name: String, releaseDate: String, task: TaskEntity) -> TaskEntity {
//  let task = TaskEntity(context: persistentContainer.viewContext)
//  task.name = name
//
//  project.addToTaskEntitys(task)
//  return task
//}
//
//
//func projects() -> [ProjectEntityEntity] {
//  let request: NSFetchRequest<ProjectEntity> = ProjectEntity.fetchRequest()
//  var fetchedProjectEntitys: [ProjectEntity] = []
//  do {
//     fetchedProjectEntitys = try persistentContainer.viewContext.fetch(request)
//  } catch let error {
//     print("Error fetching projects \(error)")
//  }
//  return fetchedProjectEntitys
//}
//func tasks(project: ProjectEntity) -> [TaskEntity] {
//  let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
//  request.predicate = NSPredicate(format: "project = %@", project)
//  request.sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: false)]
//  var fetchedTaskEntitys: [TaskEntity] = []
//  do {
//    fetchedTaskEntitys = try persistentContainer.viewContext.fetch(request)
//  } catch let error {
//    print("Error fetching tasks \(error)")
//  }
//  return fetchedTaskEntitys
//}
