//
//  CalendarTaskRow.swift
//  TaskMate
//
//  Created by Stella Shania Mintara on 05/04/23.
//

import SwiftUI

struct ListItem: Identifiable {
    let id = UUID()
    let name: String
    var isChecked: Bool = false
}

struct CalendarTaskRow: View {
    
    @State var items = [
        ListItem(name: "Class iOS Foundation"),
        ListItem(name: "Create User Persona"),
        ListItem(name: "Meeting With Dosen"),
        ListItem(name: "Meeting With Dosen"),
        ListItem(name: "Class iOS Foundation"),
        ListItem(name: "Create User Persona"),
        ListItem(name: "Meeting With Dosen"),
        ListItem(name: "Meeting With Dosen")
    ]
    
    var body: some View {
        VStack {
            List(items) { item in
                HStack {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 8, height: 8)
                        .foregroundColor(item.isChecked ? .gray : .black)
                    
                    Text(item.name)
                        .foregroundColor(item.isChecked ? .gray : .primary)
                        .strikethrough(item.isChecked)
                    Spacer()
                    Button(action: {
                        self.checkItem(item)
                    }) {
                        Image(systemName: item.isChecked ? "checkmark.square" : "square")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(item.isChecked ? .gray : .black)
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
    }
    
    func checkItem(_ item: ListItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isChecked.toggle()
        }
    }
}

struct iOSCheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
            
        }, label: {
            HStack {
                Image(systemName:"circle.fill")
                    .resizable()
                    .frame(width: 8, height: 8)
                    .foregroundColor(.black)
                
                configuration.label.foregroundColor(.black)
                
                Spacer()
                
                Image(systemName: configuration.isOn ? "checkmark.square" : "square").foregroundColor(.black)
            }
        })
    }
}

struct CalendarTaskRow_Previews: PreviewProvider {
    static var previews: some View {
        CalendarTaskRow()
    }
}
