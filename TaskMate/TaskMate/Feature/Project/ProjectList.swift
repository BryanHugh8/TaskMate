//
//  ProjectList.swift
//  TaskMate
//
//  Created by Stella Shania Mintara on 05/04/23.
//

import SwiftUI
import CoreData

struct projectCard: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var project: ProjectEntity
    
    var progress: Double {
        let tasks = project.tasks?.allObjects as? [TaskEntity] ?? []
        let completedTasks = tasks.filter { $0.isChecked }
        return Double(completedTasks.count) / Double(tasks.count)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            NavigationLink(destination: ProjectDetail(project: project)
                .navigationBarBackButtonHidden(true),
                           label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(project.name ?? "No Name").font(.system(size: 18)).bold()
                    Spacer()
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.gray)
                            .font(.system(size: 15))
                            .background(.white)
                            .clipShape(Circle())
                        Text("Deadline").foregroundColor(.gray)
                            .font(.system(size: 15))
                        Text("-").foregroundColor(.gray)
                            .font(.system(size: 15))
                        Text(project.deadline?.formatted(
                            Date.FormatStyle()
                                .day(.defaultDigits)
                                .month(.wide)
                                .year(.defaultDigits)
                        ) ?? "-")
                        .font(.system(size: 15))
                    }
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .trim(from: 0, to: CGFloat(progress))
                        .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                        .foregroundColor(Color.black)
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(progress.isNaN || progress.isInfinite ? 0 : Int(progress * 100))%")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                }
                .frame(width: 48, height: 48)
            }
            })
            .accentColor(.black)
            Divider()
            
            VStack {
                List {
                    ForEach((project.tasks?.allObjects as? [TaskEntity] ?? []).sorted(by: { lhs, rhs in
                        if lhs.isChecked == rhs.isChecked {
                            return !lhs.isPriority && rhs.isPriority
                        } else {
                            return !lhs.isChecked && rhs.isChecked
                        }
                    }), id: \.id) { task in
                        HStack {
                            let binding = Binding(
                                get: { task.isChecked },
                                set: { isChecked in
                                    task.isChecked = isChecked
                                    try? self.moc.save()
                                    
                                    moc.refreshAllObjects()
                                }
                            )
                            Image(systemName: "circle.fill")
                                .resizable()
                                .frame(width: 7, height: 7)
                                .font(.system(size: 14))
                                .foregroundColor(task.isChecked ? .gray : .black)
                            Text(task.name ?? "No name")
                                .font(.system(size: 14))
                                .strikethrough(task.isChecked)
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    binding.wrappedValue.toggle()
                                }
                            }) {
                                Image(systemName: task.isChecked ? "checkmark.square" : "square")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(task.isChecked ? .gray : .black)
                            }
                            
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .frame(minHeight: 120)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 4)
    }
}

struct ProjectList: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \ProjectEntity.deadline, ascending: true)
        ]
    ) var projects: FetchedResults<ProjectEntity>
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(projects) { project in
                    projectCard(project: project)
                }
            }
            .padding()
        }
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
        .navigationBarTitle(Text("Projects"),
                            displayMode: .inline)
    }
}

struct ProjectList_Previews: PreviewProvider {
    static var previews: some View {
        ProjectList()
    }
}
