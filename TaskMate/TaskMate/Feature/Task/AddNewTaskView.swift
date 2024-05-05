//
//  AddNewTaskView.swift
//  TudulisApp
//
//  Created by Karen Susanto on 31/03/23.
//

import SwiftUI


struct AddNewTaskView: View {
    @Environment(\.managedObjectContext) var moc
    @State var showingBottomSheet =  false
    
    @ObservedObject var project: ProjectEntity
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
                
                Button{
                    //                    showingBottomSheet.toggle()
                    
                    let newTask = TaskEntity(context: moc)
                    newTask.id = UUID()
                    newTask.name = taskname
                    newTask.isChecked = false
                    newTask.deadline = date
                    newTask.isPriority = checked
                    newTask.desc = description
                    newTask.projects = project
                    
                    try? moc.save()
                    
                    moc.refreshAllObjects()
                }label:{
                    Text("Create Task")
                        .padding(.horizontal,107.5)
                        .padding(.top,10)
                        .padding(.bottom,10)
                        .font(.system(size: 20))
                }
                .buttonStyle(.borderedProminent)
                .tint(.black)
                .cornerRadius(16)
                .padding([.top],10)
                
            }
            .padding()
            .frame(width:375)
            .presentationDetents([.height(470)])
            .presentationDragIndicator(.visible)
            
            
        }
    }
}

//struct AddNewTaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddNewTaskView()
//    }
//}
