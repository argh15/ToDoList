//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Argh on 9/28/24.
//

import CoreData
import Foundation

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskListItems")
        container.loadPersistentStores { _, error in
            if let error = error as? NSError {
                fatalError("Unresolved Error: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                print("Error Saving Changes in CoreData: \(error), \(error.userInfo)")
            }
        }
    }
    
    func getAllTaskItems() -> [TaskListItem] {
        var taskItems = [TaskListItem]()
        
        let fetchRequest: NSFetchRequest<TaskListItem> = TaskListItem.fetchRequest()
        
        do {
            taskItems = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Error Fetching Task Items in CoreData: \(error.localizedDescription)")
        }
        
        return taskItems
    }
    
    func addTasks(tasks: [Item]) {
        let dict: [[String: Any]] = tasks.map({ item in
            return [
                "taskTitle": item.title,
                "taskDescription": item.description,
                "taskCompleted": item.completed,
                "taskID": UUID()
            ]
        })
        let batchInsert = NSBatchInsertRequest(entityName: "TaskListItem", objects: dict)
        
        do {
            try context.execute(batchInsert)
            saveContext()
        } catch let error as NSError {
            print("Error Inserting Task Items in CoreData: \(error.localizedDescription)")
        }
    }
    
    func toggleCompleted(id: UUID) {
        let fetchRequest: NSFetchRequest<TaskListItem> = TaskListItem.fetchRequest()
        let predicate = NSPredicate(format: "taskID=%@", id.uuidString)
        fetchRequest.predicate = predicate
        
        do {
            if let fetchTask = try context.fetch(fetchRequest).first {
                fetchTask.taskCompleted = !fetchTask.taskCompleted
            }
            saveContext()
        } catch let error as NSError {
            print("Error Changing State of Task Items in CoreData: \(error.localizedDescription), \(error.userInfo)")
        }
    }
    
    func deleteTask(with id: UUID) {
        let fetchRequest: NSFetchRequest<TaskListItem> = TaskListItem.fetchRequest()
        let predicate = NSPredicate(format: "taskID == %@", id.uuidString)
        fetchRequest.predicate = predicate
        
        do {
            if let taskToDelete = try context.fetch(fetchRequest).first {
                context.delete(taskToDelete)
            }
            saveContext()
        } catch let error as NSError {
            print("Error Deleting task with ID \(id): \(error.localizedDescription), \(error.userInfo)")
        }
    }
    
    func deleteAllTasks() {
//        let entityNames = ["TaskListItem"]
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskListItem")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            saveContext()
            print("Deleted all objects from entity: TaskListItem")
        } catch let error as NSError {
            print("Error deleting objects from entity TaskListItem: \(error.localizedDescription), \(error.userInfo)")
        }
//        for entityName in entityNames {
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
//            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//            
//            do {
//                try context.execute(deleteRequest)
//                saveContext()
//                print("Deleted all objects from entity: \(entityName)")
//            } catch let error as NSError {
//                print("Error deleting objects from entity \(entityName): \(error.localizedDescription), \(error.userInfo)")
//            }
//        }
    }
}
