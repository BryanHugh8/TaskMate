//
//  AddTask.swift
//  TaskMate
//
//  Created by Stella Shania Mintara on 05/04/23.
//

import SwiftUI
struct CheckBoxView2: View {
    @Binding var checked: Bool
    
    var body: some View {
        Image(systemName: checked ? "checkmark.square.fill" : "square")
            .foregroundColor(checked ? Color(UIColor.black) : Color.secondary)
            .onTapGesture {
                self.checked.toggle()
            }
    }
}

struct AddTask2: View {
    @Environment(\.managedObjectContext) var moc
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    @State private var date = Date()
    @State var selectedProject: ProjectEntity?
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \ProjectEntity.deadline, ascending: true)
        ]
    ) var projects: FetchedResults<ProjectEntity>
    
    let buttonIsPressed = State(initialValue: false)
    @State private var selectedButtonIndex: Int?
    // Present the view controller
    @State private var isPressed = false
    @State private var isAddProjectshown = false
    @State private var showPlusButton = true
    @State private var buttonCount = 1
    @State private var isPopoverShown = false
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    @State private var showingCredits = false
    @State private var taskName = ""
    @State private var taskDescription = ""
    @State private var priority = ""
    @State private var descrip = ""
    @State private var isPriority = false
    @State private var deadline = Date()
    @State private var showingPopover = false
    @State private var projectChosen = ""
    @State private var checked = false
    var body: some View {
        VStack(alignment: .leading) {
            Text("Add New Task")
                .bold()
                .padding(.top, 15)
                .padding(.leading, 130)
                .font(.system(size: 17))
            
            
            Text("Task Name")
                .font(.system(size: 17))
            TextField("Task Name", text: $taskName)
                .disableAutocorrection(true)
            //                    .padding(.horizontal)
                .textFieldStyle(.roundedBorder)
            
            
            Text("Description" )
                .font(.system(size: 17))
            //                    .padding(.leading, 4.0)
            TextField(
                "Task Description...",
                text:$taskDescription
            )
            .disableAutocorrection(true)
            .frame(height:75)
            .padding([.horizontal],4)
            .textFieldStyle(PlainTextFieldStyle())
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.2)))
            
            
            VStack(alignment: .leading, spacing: 10){
                Text("Date")
                    .padding(.leading, 5.0)
                DatePicker(
                    "Date",
                    selection: $date,
                    displayedComponents: [.date]
                )
                .labelsHidden()
                .datePickerStyle(.compact)
                .foregroundColor(.black)
                .frame(width: 120)
                .padding(.bottom, 15)
                .accentColor(.black)
                HStack(){
                    CheckBoxView2(checked: $checked)
                    Text("High Priority")
                        .onTapGesture {
                            self.checked.toggle()
                        }
                }
                
                
                Text("Project")
                
                if projects.isEmpty {
                    Button(action: {
                        isAddProjectshown.toggle()
                    }, label: {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 40, height: 100)
                            .overlay(
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                            )
                    })
                    .sheet(isPresented: $isAddProjectshown){
                        AddProject()
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    HStack{
                        ScrollView(.horizontal){
                            HStack {
                                ForEach(Array(projects.enumerated()), id: \.1.id) { index, project in
                                    Button(action: {
                                        selectedButtonIndex = selectedButtonIndex == index ? nil : index
                                        selectedProject = project
                                    }, label: {
                                        HStack {
                                            Text(project.name ?? "No Name")
                                                .foregroundColor(selectedButtonIndex == index ? .white : .black)
                                        }
                                        .padding(10.0)
                                        .background(selectedButtonIndex == index ? Color.black : Color.gray.opacity(0.2))
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                    })
                                    .buttonStyle(PlainButtonStyle())
                                }
                                Button(action: {
                                    isAddProjectshown.toggle()
                                }, label: {
                                    Circle()
                                        .fill(Color.black)
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Image(systemName: "plus")
                                                .foregroundColor(.white)
                                        )
                                })
                                .sheet(isPresented: $isAddProjectshown){
                                    AddProject()
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    
                }
                
                
                // MARK: Add Task Button
                HStack {
                    Spacer()
                    Button(action: {
                        let newTask = TaskEntity(context: moc)
                        newTask.deadline = selectedDate
                        newTask.id = UUID()
                        newTask.name = taskName
                        newTask.isChecked = false
                        newTask.deadline = date
                        newTask.isPriority = checked
                        newTask.desc = taskDescription
                        if selectedProject != nil {
                            newTask.projects = selectedProject
                        }
                        try? moc.save()
                        
                        moc.refreshAllObjects()
                        
                        showingCredits.toggle()
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
            Spacer()
            
            
        }
        .padding()
        .presentationDetents([.height(470)])
    }
}
//struct AddTask_Previews: PreviewProvider {
//    static var previews: some View {
//        AddTask()
//    }
//}
