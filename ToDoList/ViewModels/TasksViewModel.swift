//
//  TaskListItemViewModel.swift
//  ToDoList
//
//  Created by Argh on 9/28/24.
//

import Foundation

class TasksViewModel {
    
    private var taskListItems: [Item] = []
    
    init() {
        getAllTasks()
    }
    
    var totalNumberOfTasks: Int {
        taskListItems.count
    }
    
    var getPendingTasks: [Item] {
        taskListItems.lazy.filter { !$0.completed }
    }
    
    var getCompletedTasks: [Item] {
        taskListItems.lazy.filter { $0.completed }
    }
    
    func getAllTasks() {
        let tasks = CoreDataManager.shared.getAllTaskItems()
        taskListItems = tasks.compactMap({ taskListItem in
            guard let title = taskListItem.taskTitle,
                  let description = taskListItem.taskDescription,
                  let uuid = taskListItem.taskID else { return nil }
            return Item(title: title, description: description, completed: taskListItem.taskCompleted, id: uuid)
        })
    }
    
    func toggleCompleted(for taskListItem: Item) {
        CoreDataManager.shared.toggleCompleted(id: taskListItem.id)
        getAllTasks()
    }
    
    func deleteTask(_ task: Item) {
        CoreDataManager.shared.deleteTask(with: task.id)
        getAllTasks()
    }
    
    func task(at indexPath: IndexPath) -> Item? {
        if indexPath.section == 0 {
            return getPendingTasks[indexPath.row]
        } else {
            return getCompletedTasks[indexPath.row]
        }
    }
}
