//
//  Home.swift
//  TaskMate
//
//  Created by Stella Shania Mintara on 05/04/23.
//

import SwiftUI
import Combine
import CoreData

struct Home: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \ProjectEntity.deadline, ascending: true)
        ]
    ) var projects: FetchedResults<ProjectEntity>
    
    @ObservedObject var profile : ProfileEntity
    
    // state
    @State private var selectedDate: Date = Date()
    @State private var filteredTasks: [TaskEntity] = []
    @State private var showAddTaskModal = false
    
    let daysToShow = [
        Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
        Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
        Date(),
        Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
        Calendar.current.date(byAdding: .day, value: 2, to: Date())!
    ]
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Hello,")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.gray)
                        Text(profile.name ?? "No name").bold()
                            .font(.system(size: 20))
                    }
                    Spacer()
                    NavigationLink(destination: CalendarView()
                        .navigationBarBackButtonHidden(true),
                                   label: {
                        Image(systemName: "calendar")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.black)
                    })
                }.padding(.bottom)
                
                // MARK: Schedule
                
                Text("Schedule")
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                
                HStack {
                    ForEach(daysToShow.indices, id: \.self) { index in
                        let date = daysToShow[index]
                        Button {
                            selectedDate = date
                            let startDate = Calendar.current.startOfDay(for: date)
                            let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
                            
                            let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
                            request.predicate = NSPredicate(format: "deadline >= %@ AND deadline < %@", startDate as NSDate, endDate as NSDate)
                            request.sortDescriptors = [
                                NSSortDescriptor(keyPath: \TaskEntity.isChecked, ascending: true),
                                NSSortDescriptor(keyPath: \TaskEntity.isPriority, ascending: false),
                                NSSortDescriptor(keyPath: \TaskEntity.deadline, ascending: true)
                            ]
                            
                            do {
                                filteredTasks = try moc.fetch(request)
                                // print(filteredTasks)
                            } catch {
                                print("Error fetching tasks: \(error)")
                            }
                        } label: {
                            VStack {
                                Text(date.formatted(
                                    Date.FormatStyle()
                                        .day(.defaultDigits)
                                ))
                                .font(.system(size: 16))
                                Text(date.formatted(
                                    Date.FormatStyle()
                                        .month(.abbreviated)
                                ))
                                .font(.system(size: 16))
                            }
                            .padding(10.0)
                            .background( !Calendar.current.isDate(date, inSameDayAs: selectedDate) ? .white : .black)
                            .foregroundColor(!Calendar.current.isDate(date, inSameDayAs: selectedDate) ? .black : .white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        if index != daysToShow.count - 1 {
                            Spacer()
                        }
                    }
                }
                
                // MARK: Tasks
                
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .shadow(radius: 4)
                    if filteredTasks.count == 0 {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Text("Task Empty")
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                    VStack {
                        List {
                            ForEach(filteredTasks, id: \.self) { item in
                                let binding = Binding(
                                    get: { item.isChecked },
                                    set: { isChecked in
                                        item.isChecked = isChecked
                                        try? self.moc.save()
                                        
                                        moc.refreshAllObjects()
                                        
                                        let startDate = Calendar.current.startOfDay(for: selectedDate)
                                        let endDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)!
                                        
                                        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
                                        request.predicate = NSPredicate(format: "deadline >= %@ AND deadline < %@", startDate as NSDate, endDate as NSDate)
                                        request.sortDescriptors = [
                                            NSSortDescriptor(keyPath: \TaskEntity.isChecked, ascending: true),
                                            NSSortDescriptor(keyPath: \TaskEntity.isPriority, ascending: false),
                                            NSSortDescriptor(keyPath: \TaskEntity.deadline, ascending: true)
                                        ]
                                        
                                        do {
                                            filteredTasks = try moc.fetch(request)
                                            // print(filteredTasks)
                                        } catch {
                                            print("Error fetching tasks: \(error)")
                                        }
                                    }
                                )
                                HStack {
                                    Image(systemName: "circle.fill")
                                        .resizable()
                                        .frame(width: 7, height: 7)
                                        .foregroundColor(item.isChecked ? .gray : .black)
                                    
                                    Text(item.name ?? "no name")
                                        .font(.system(size: 16))
                                        .foregroundColor(item.isChecked ? .gray : .primary)
                                        .strikethrough(item.isChecked)
                                    
                                    if item.isPriority {
                                        Image(systemName: "exclamationmark.3")
                                            .resizable()
                                            .frame(width: 18, height: 18)
                                            .foregroundColor(item.isChecked ? .gray : .black)
                                    }
                                    Spacer()
                                    Button(action: {
                                        withAnimation {
                                            binding.wrappedValue.toggle()
                                        }
                                    }) {
                                        Image(systemName: item.isChecked ? "checkmark.square" : "square")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(item.isChecked ? .gray : .black)
                                    }
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                    .padding([.top, .leading, .trailing], 8.0)
                }
                .frame(height: 240)
                .padding(.bottom)
                
                // MARK: Task by Projects
                
                HStack {
                    Text("Task by Projects")
                        .font(.system(size: 20))
                        .fontWeight(.medium)
                    Spacer()
                    NavigationLink(destination: ProjectList()
                        .navigationBarBackButtonHidden(true),
                                   label: {
                        Text("See All")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                    })
                }
                
                if let project = projects.first {
                    projectCard(project: project)
                } else {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Spacer()
                            Text("no projects")
                            Spacer()
                        }
                    }
                    .frame(height: 180)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 4)
                }
                
                // MARK: Add Task Button
                HStack {
                    Spacer()
                    Button(action: {
                        showAddTaskModal.toggle()
                    }) {
                        HStack {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                            Text("Add Task")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(15)
                    }
                    Spacer()
                }
                
                
            }
            .padding()
            .sheet(isPresented: $showAddTaskModal, onDismiss: {
                updateFilteredTask()
                // perform some action here
            }){
                AddTask()
            }
        }
        .onAppear() {
            updateFilteredTask()
        }
    }
    
    func updateFilteredTask() {
        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "deadline >= %@ AND deadline < %@", startDate as NSDate, endDate as NSDate)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \TaskEntity.isChecked, ascending: true),
            NSSortDescriptor(keyPath: \TaskEntity.isPriority, ascending: false),
            NSSortDescriptor(keyPath: \TaskEntity.deadline, ascending: true)
        ]
        
        do {
            filteredTasks = try moc.fetch(request)
            // print(filteredTasks)
        } catch {
            print("Error fetching tasks: \(error)")
        }
    }
}

//struct Home_Previews: PreviewProvider {
//    static var previews: some View {
//        Home()
//    }
//}
