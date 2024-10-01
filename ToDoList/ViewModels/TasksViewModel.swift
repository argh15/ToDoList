//
//  TaskListItemViewModel.swift
//  ToDoList
//
//  Created by Argh on 9/28/24.
//

import Foundation

class TasksViewModel {
    
    private var taskListItems: [Item] = []
//    private var filteredTasks: [Item] = []
//    private var isFiltering: Bool = false
    var pendingTasks: Observable<[Item]> = Observable(value: nil)
    var completedTasks: Observable<[Item]> = Observable(value: nil)
    
    
    init() {
        getAllTasks {
            print("Tasks fetched successfully.")
        }
    }
    
    var totalNumberOfTasks: Int {
        taskListItems.count
    }
    
//    var getPendingTasks: [Item] {
//        return isFiltering ? filteredTasks.filter { !$0.completed } : taskListItems.filter { !$0.completed }
//    }
//    
//    var getCompletedTasks: [Item] {
//        return isFiltering ? filteredTasks.filter { $0.completed } : taskListItems.filter { $0.completed }
//    }
    
    func getAllTasks(completion: @escaping () -> ()) {
        let tasks = CoreDataManager.shared.getAllTaskItems()
        taskListItems = tasks.compactMap({ taskListItem in
            guard let title = taskListItem.taskTitle,
                  let description = taskListItem.taskDescription,
                  let uuid = taskListItem.taskID else { return nil }
            return Item(title: title, description: description, completed: taskListItem.taskCompleted, id: uuid)
        })
        
        updateTasksList()
        
        DispatchQueue.main.async {
            completion()
        }
    }
    
    func updateTasksList() {
        pendingTasks.value = taskListItems.filter({ !$0.completed})
        completedTasks.value = taskListItems.filter({ $0.completed})
    }
    
//    func filterTasks(by query: String) {
//        isFiltering = true
//        filteredTasks = taskListItems.filter {
//            $0.title.lowercased().contains(query.lowercased())
//        }
//    }
//    
//    func resetFilteredTasks() {
//        isFiltering = false
//        filteredTasks.removeAll()
//    }
    
    func toggleCompleted(for taskListItem: Item, completion: @escaping () -> ()) {
        CoreDataManager.shared.toggleCompleted(id: taskListItem.id)
        getAllTasks {
            completion()
        }
    }
    
    func deleteTask(_ task: Item, completion: @escaping () -> ()) {
        CoreDataManager.shared.deleteTask(with: task.id)
        getAllTasks {
            completion()
        }
    }
    
    func task(at indexPath: IndexPath) -> Item? {
        if indexPath.section == 0 {
            return pendingTasks.value?[indexPath.row]
        } else {
            return completedTasks.value?[indexPath.row]
        }
    }
}
