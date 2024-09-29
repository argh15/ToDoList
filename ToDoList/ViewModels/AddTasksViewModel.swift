//
//  AddTasksViewModel.swift
//  ToDoList
//
//  Created by Argh on 9/28/24.
//

import Foundation

class AddTasksViewModel {
    
    func addTasks(tasks: [Item]) {
        CoreDataManager.shared.addTasks(tasks: tasks)
    }
}
