//
//  EditTaskView.swift
//  TudulisApp
//
//  Created by Karen Susanto on 05/04/23.
//

import SwiftUI

struct CheckBoxEditTaskView: View {
    @Binding var checked: Bool
    
    var body: some View {
        Image(systemName: checked ? "checkmark.square.fill" : "square")
            .foregroundColor(checked ? Color(UIColor.black) : Color.secondary)
            .onTapGesture {
                self.checked.toggle()
            }
    }
}

struct EditTaskView: View {
    @Environment(\.managedObjectContext) var moc
    @State var showingBottomSheet =  false
    @ObservedObject var currenttask : TaskEntity
    @State private var taskname: String = ""
    @State private var description: String = ""
    @State private var isPriority = false
    @State private var checked = false
    @State private var date = Date()
    
    var body: some View {
        
        ZStack{
            
                VStack (alignment:.leading){
                    Text("Edit Task")
                        .fontWeight(.semibold)
                        .font(.system(size: 23))
                        .frame(width:350)
                        .padding([.bottom],10)
                    
                    Text("Task Name")
                        .frame(alignment:.topLeading)
                    
                    TextField(
                        "\(currenttask.name!)",
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
                        "",
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
                        currenttask.id = UUID()
                        currenttask.name = taskname
                        currenttask.isChecked = false
                        currenttask.deadline = date
                        currenttask.isPriority = checked
                        currenttask.desc = description
                        
                        try? moc.save()
                        
                        moc.refreshAllObjects()
                    }label:{
                        Text("Save")
                            .padding(.horizontal,138)
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


//struct EditTaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditTaskView()
//    }
//}
