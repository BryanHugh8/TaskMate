//
//  addproject.swift
//  TaskMate
//
//  Created by Bryan Hugh Giovandi on 07/04/23.
//

import SwiftUI

struct AddProject: View {
    @Environment(\.managedObjectContext) var moc
    
    @State private var date = Date()
    
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 2023, month: 4, day: 1)
        let endComponents = DateComponents(year: 2025, month: 12, day: 30, hour: 23, minute: 59, second: 59)
        return calendar.date(from:startComponents)!
        ...
        calendar.date(from:endComponents)!
    }()
    
    @State private var deadline = Date()
    @State private var showingCredits = false
    @State private var isPriority = false
    @State private var projectName = ""
    @State private var taskDescription = ""
    @State private var priority = ""
    @State private var descrip = ""
    @State private var taskProjectDescription = ""
    @State private var isPopoverShown = false
    @State private var selectedDate = Date()

    var body: some View {
        VStack {
            Spacer()
            Text("New Project")
                .bold()
                .padding()
                .font(.system(size: 17))

            VStack(alignment: .leading, spacing: 10) {
                Text("Project Name")
                    .font(.system(size: 17))
                    .padding(.leading, 20.0)
                TextField("Project Name", text: $projectName)
                    .disableAutocorrection(true)
                    .padding(.horizontal)
                    .textFieldStyle(.roundedBorder)
            }

            VStack(alignment: .leading, spacing: 10){
                Text("Description" )
                    .font(.system(size: 17))
                    .padding(.leading, 4.0)
                TextEditor(text: $taskProjectDescription)
                    .multilineTextAlignment(.leading)
                    .disableAutocorrection(true)
                    .frame(height: 75.0)
                    .multilineTextAlignment(.leading)
                    .disableAutocorrection(true)
                    .frame(width: 350.0, height:75.0)
                    .padding([.horizontal],4)
                //                .textFieldStyle(PlainTextFieldStyle())
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.2))
                    )
                    .overlay(
                        Text("Task Description...")
                            .padding(.leading, -173.0)
                            .padding(.top, -33.0)
                            .foregroundColor(Color(UIColor.placeholderText))
                            .padding(.horizontal)
                            .opacity(taskProjectDescription.isEmpty ? 1 : 0))
            }

            Text("Date")
                .padding(.leading, -170)
            ZStack{
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
            }
            .padding(.leading, -170)
                VStack{
                    Button("+ Add Project") {
                        let newProject = ProjectEntity(context: moc)

                        newProject.id = UUID()
                        newProject.name = projectName
                        newProject.deadline = Date()

                        try? moc.save()
                        showingCredits.toggle()
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 18.0)
                    .padding(.horizontal, 130.0)
                    .background(Color.black)
                    .cornerRadius(15)
                    Spacer()
                }
                .padding(.top, 70.0)
            }
            .padding(.top, 2.0)

//            Spacer()
                .presentationDetents([.height(550), .large])
        }
    }

struct addproject_Previews: PreviewProvider {
    static var previews: some View {
        AddProject()
    }
}


