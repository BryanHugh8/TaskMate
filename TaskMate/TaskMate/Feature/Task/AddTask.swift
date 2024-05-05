//
//  AddNewTaskView.swift
//  TudulisApp
//
//  Created by Karen Susanto on 31/03/23.
//

import SwiftUI

struct CheckBoxView: View {
    @Binding var checked: Bool
    
    var body: some View {
        Image(systemName: checked ? "checkmark.square.fill" : "square")
            .foregroundColor(checked ? Color(UIColor.black) : Color.secondary)
            .onTapGesture {
                self.checked.toggle()
            }
    }
}

struct AddTask: View {
    @Environment(\.managedObjectContext) var moc
    @State var showingBottomSheet =  false
    @State private var isAddProjectshown = false
    
    @State var selectedProject: ProjectEntity?
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \ProjectEntity.deadline, ascending: true)
        ]
    ) var projects: FetchedResults<ProjectEntity>
    let buttonIsPressed = State(initialValue: false)
    @State private var selectedButtonIndex: Int?
    
    @State private var taskname: String = ""
    @State private var description: String = ""
    @State private var checked = false
    @State private var date = Date()
    var body: some View {
        
        ZStack{
            VStack (alignment:.leading){
                Spacer()
                Text("Add New Task")
                    .fontWeight(.semibold)
                    .font(.system(size: 23))
                    .frame(width:350)
                    .padding([.bottom],10)
                
                VStack (alignment:.leading){
                    Text("Task Name")
                        .frame(alignment:.topLeading)
                    
                    TextField(
                        "Task Name",
                        text:$taskname
                    )
                    
                    .disableAutocorrection(true)
                    .frame(height:40)
                    .padding([.horizontal],4)
                    .textFieldStyle(PlainTextFieldStyle())
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.2)))
                }
                
                
                VStack (alignment:.leading){
                    Text("Description")
                    TextField(
                        "Task Description...",
                        text:$description
                    )
                    .disableAutocorrection(true)
                    .frame(height:75)
                    .padding([.horizontal],4)
                    .textFieldStyle(PlainTextFieldStyle())
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.2)))
                }
                
                
                
                Text("Date")
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
                    CheckBoxView(checked: $checked)
                    Text("High Priority")
                        .onTapGesture {
                            self.checked.toggle()
                        }
                }
                .padding(.bottom, 15)
                
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
                
                
                Button{
                    let newTask = TaskEntity(context: moc)
                    newTask.id = UUID()
                    newTask.name = taskname
                    newTask.isChecked = false
                    newTask.deadline = date
                    newTask.isPriority = checked
                    newTask.desc = description
                    if selectedProject != nil {
                        newTask.projects = selectedProject
                    }
                    
                    try? moc.save()
                    
                    moc.refreshAllObjects()
                }label:{
                    HStack {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                        Text("Add Task")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .padding(.vertical, 10.0)
                    .background(Color.black)
                    .cornerRadius(15)
                }
                .buttonStyle(.borderedProminent)
                .tint(.black)
                .cornerRadius(16)
                .padding(.vertical,10)
                
            }
            .padding()
            .frame(width:375)
            .presentationDetents([.height(585)])
            .presentationDragIndicator(.visible)
            
            
        }
    }
    
}
//struct AddNewTaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddNewTaskView()
//    }
//}
