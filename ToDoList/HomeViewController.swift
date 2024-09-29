//
//  ViewController.swift
//  ToDoList
//
//  Created by Arghadeep Chakraborty on 9/28/24.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private var tasksTableView: UITableView!
    private var taskListItems: [TaskListItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureTableView()
        
        taskListItems = getTaskListItems()
    }
    
    private func configureNavBar() {
        title = "To-Do List"
        
        let addTaskButton = UIBarButtonItem(title: "Add Tasks", style: .plain, target: self, action: #selector(addTasksTapped))
        navigationItem.rightBarButtonItem = addTaskButton
    }
    
    @objc private func addTasksTapped() {
        print("Add Tasks Tapped!")
        let addTaskVC = AddTasksViewController()
        let navigationController = UINavigationController(rootViewController: addTaskVC)
        present(navigationController, animated: true, completion: nil)
    }
    
    private func configureTableView() {
        layoutTableView()
        
        tasksTableView.register(TaskListItemTableViewCell.self, forCellReuseIdentifier: "TaskListItemTableViewCell")
        
        tasksTableView.rowHeight = UITableView.automaticDimension
        tasksTableView.estimatedRowHeight = 80
        
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
    }
    
    private func layoutTableView() {
        tasksTableView = UITableView()
        view.addSubview(tasksTableView)
        
        tasksTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tasksTableView.topAnchor.constraint(equalTo: view.topAnchor),
            tasksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tasksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tasksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskListItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListItemTableViewCell") as? TaskListItemTableViewCell else { return UITableViewCell() }
        let taskListItem = taskListItems[indexPath.row]
        cell.setData(title: taskListItem.title, description: taskListItem.description, completed: taskListItem.completed)
        cell.selectionStyle = .none
        return cell
    }
    
}

extension HomeViewController {
    
    private func getTaskListItems() -> [TaskListItem] {
        return [
            TaskListItem(title: "Grocery Shopping", description: "Buy fruits, vegetables, and snacks.", completed: true),
            TaskListItem(title: "Pick Up Dry Cleaning", description: "Collect the dry cleaning from the local shop. Collect the dry cleaning from the local shop. Collect the dry cleaning from the local shop. Collect the dry cleaning from the local shop. Collect the dry cleaning from the local shop.", completed: true),
            TaskListItem(title: "Walk the Dog", description: "Take the dog for a walk in the park.", completed: false),
            TaskListItem(title: "Visit the Bank", description: "Deposit the paycheck and check the balance.", completed: true),
            TaskListItem(title: "Buy Birthday Gift", description: "Purchase a gift for Sarah's birthday.", completed: true),
            TaskListItem(title: "Return Library Books", description: "Return the overdue books to the library.", completed: false),
            TaskListItem(title: "Attend Doctor Appointment", description: "Go for the scheduled check-up at 3 PM.", completed: true),
            TaskListItem(title: "Clean the House", description: "Dust and vacuum all rooms in the house.", completed: true),
            TaskListItem(title: "Send Package", description: "Mail the package to Grandma.", completed: true),
            TaskListItem(title: "Fill Up Gas Tank", description: "Refuel the car at the nearest gas station.", completed: true)
        ]
    }
}

