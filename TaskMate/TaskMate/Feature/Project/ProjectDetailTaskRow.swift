//
//  ProjectDetailTaskRow.swift
//  TaskMate
//
//  Created by Fico Pangestu on 06/04/23.
//

import SwiftUI
import UIKit

struct ProjectDetailTaskRow: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var task: TaskEntity
    @State var showingEditTaskSheet = false
    
    var body: some View {
        let binding = Binding(
            get: { task.isChecked },
            set: { isChecked in
                task.isChecked = isChecked
                try? self.moc.save()
                
                moc.refreshAllObjects()
            }
        )
        
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                        binding.wrappedValue.toggle()
                }) {
                    Image(systemName: task.isChecked ? "checkmark.square" : "square")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(task.isChecked ? .gray : .black)
                }
                
                Text(task.name ?? "No Name")
                    .font(.system(size: 18))
                    .foregroundColor(task.isChecked ? .gray : .primary)
                    .lineLimit(nil)
                    .fontWeight(.medium)
                    .strikethrough(task.isChecked)
                
                Spacer()
                
                Text(task.deadline?.formatted(
                    Date.FormatStyle()
                        .day(.defaultDigits)
                        .month(.wide)
                ) ?? "")
                .font(.system(size: 14))
            }
            
            Text(task.desc ?? "")
                .font(.system(size: 16))
                .foregroundColor(task.isChecked ? .gray : .primary)
                .lineLimit(1)
                .fontWeight(.light)
                .padding(.leading, 25.0)
        }
        .swipeActions {
            Button(action: {
                moc.delete(task)
                try? moc.save()
                print("deleted!")
            }) {
                Image(systemName: "minus.square")
            }
            .tint(.red)
            Button(action: {
                showingEditTaskSheet.toggle()
                print("Awesome!")
            }) {
                Image(systemName: "pencil")
                    .foregroundColor(.white)
            }
            .tint(.gray)
        }
        .sheet(isPresented: $showingEditTaskSheet){
            EditTaskView(currenttask: task)
        }
    }
}

//struct ProjectDetailTaskRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ProjectDetailTaskRow()
//    }
//}


