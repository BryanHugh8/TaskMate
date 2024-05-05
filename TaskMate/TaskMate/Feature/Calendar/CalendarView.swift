//
//  Calendar.swift
//  TaskMate
//
//  Created by Stella Shania Mintara on 05/04/23.
//

import SwiftUI
import Combine
import CoreData

struct CalendarView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var date = Date()
    
    // *
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \ProjectEntity.deadline, ascending: true)
        ]
    ) var projects: FetchedResults<ProjectEntity>
    
    @State private var selectedDate: Date = Date()
    @State private var filteredTasks: [TaskEntity] = []
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                DatePicker(
                    "Start Date",
                    selection: $date,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .accentColor(.black)
                .onAppear{
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
                }
                .onChange(of: date) { newValue in
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
                }
                
                Divider()
                
//                Text("Friday, 31 March 2023")
//                    .font(.title3)
//                    .fontWeight(.bold)
//                    .foregroundColor(.gray)
//                    .multilineTextAlignment(.leading)
//                    .padding([.top, .leading, .trailing])
                
                Text("\(date.formatted(date:.complete, time: .omitted))")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.leading)
                                    .padding([.top, .leading, .trailing])
                
//                CalendarTaskRow()
                
//                List(filteredTasks) { item in
//                    CalendarTaskRow(task: item)
//                }
                
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
                
                Spacer()
            }
            .padding()
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.black)
                        Text("Home")
                            .foregroundColor(.black)
                    })
            )
        }
    }
}
//
//struct Calendar_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarView()
//    }
//}
