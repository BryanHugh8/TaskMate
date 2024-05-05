//
//  ProjectDetail.swift
//  TaskMate
//
//  Created by Stella Shania Mintara on 05/04/23.
//

import SwiftUI
import CoreData

struct LineProgressBar: View {
    var percentage: CGFloat
    @State private var currentPercentage: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color(red: 0.88, green: 0.88, blue: 0.88)
                    )
                    
                withAnimation(.linear(duration: 0.5)) {
                    Rectangle()
                        .foregroundColor(Color(red: 0.12, green: 0.12, blue: 0.12)
                        )
                    .frame(width: geometry.size.width * currentPercentage / 100)
                }
                    
            }
            .cornerRadius(10)
        }
        .frame(height: 20)
        .onAppear {
            currentPercentage = percentage
        }
        .onChange(of: percentage) { newValue in
            withAnimation {
                currentPercentage = newValue
            }
        }
    }
}


struct ProjectDetail: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var project: ProjectEntity;
    @Environment(\.managedObjectContext) var moc
    @State var showingNewTaskSheet = false
    
    var progress: Double {
        let tasks = project.tasks?.allObjects as? [TaskEntity] ?? []
        let completedTasks = tasks.filter { $0.isChecked }
        return Double(completedTasks.count) / Double(tasks.count)
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(project.name ?? "No name")
                    .font(.system(size: 30))
                    .foregroundColor(Color(red: 0.18, green: 0.18, blue: 0.18))
                    .fontWeight(.medium)
                Text(project.desc ?? "No description")
                    .font(.system(size: 15))
                    .foregroundColor(Color(red: 0.18, green: 0.18, blue: 0.18)
                    )
                    .padding(.bottom, 2.0)
                
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.gray)
                        .font(.system(size: 20))
                        .background(.white)
                        .clipShape(Circle())
                    Text("Deadline").foregroundColor(Color(red: 0.48, green: 0.47, blue: 0.47)
                    )
                    Text("-").foregroundColor(Color(red: 0.48, green: 0.47, blue: 0.47)
                    )
                    Text(project.deadline?.formatted(
                        Date.FormatStyle()
                            .day(.defaultDigits)
                            .month(.wide)
                            .year(.defaultDigits)
                    ) ?? "-")
                    .fontWeight(.bold)
                    
                    Spacer()
                }
                LineProgressBar(percentage: progress * 100)
                HStack {
                    Text("Progress")
                    Spacer()
                    Text(String(format: "%.f", progress * 100) + "%")
                        .fontWeight(.semibold)
                }
            }
            .padding(/*@START_MENU_TOKEN@*/[.top, .leading, .trailing]/*@END_MENU_TOKEN@*/)
            
            ZStack {
                VStack {
                    List {
                        Text("Task")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 0.25, green: 0.25, blue: 0.25)
)
                        Section {
                            ForEach(project.tasks?.allObjects as? [TaskEntity] ?? [], id: \.id) { task in
                                ProjectDetailTaskRow(task: task)
                            }
                        }
                    }
                    .padding(8)
                    .listStyle(PlainListStyle())
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            showingNewTaskSheet.toggle()
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
                    .sheet(isPresented: $showingNewTaskSheet){
                        AddNewTaskView(project: project)
                    }
                }
                
            }
            .background(.white)
            .cornerRadius(25)
        }
        .background(Color(red: 0.95, green: 0.95, blue: 0.95))
        
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
        .navigationBarTitle(Text("Project Detail"),
                            displayMode: .inline)
    }
}


//struct ProjectDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        ProjectDetail()
//    }
//}

