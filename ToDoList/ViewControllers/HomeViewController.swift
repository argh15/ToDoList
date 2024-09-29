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
    private var viewModel: TasksViewModel?
    weak var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureTableView()
        
        viewModel = TasksViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel?.getAllTasks()
        tasksTableView.reloadData()
    }
    
    private func configureNavBar() {
        title = "To-Do List"
        
        let addTaskButton = UIBarButtonItem(title: "Add Tasks", style: .plain, target: self, action: #selector(addTasksTapped))
        navigationItem.rightBarButtonItem = addTaskButton
    }
    
    @objc private func addTasksTapped() {
        let addTaskVC = AddTasksViewController()
        addTaskVC.coordinator = self.coordinator
        addTaskVC.taskAdded = { [weak self] in
            self?.viewModel?.getAllTasks()
            self?.tasksTableView.reloadData()
        }
        let navigationController = UINavigationController(rootViewController: addTaskVC)
        coordinator?.present(navigationController, animated: true, completion: nil)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Pending" : "Completed"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel?.getPendingTasks.count ?? 0  // Pending tasks count
        } else {
            return viewModel?.getCompletedTasks.count ?? 0  // Completed tasks count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListItemTableViewCell") as? TaskListItemTableViewCell else { return UITableViewCell() }
        
        
        let item: Item
        
        if indexPath.section == 0 {
            guard let taskListItemPending = viewModel?.getPendingTasks[indexPath.row] else {
                return UITableViewCell()
            }
            item = taskListItemPending
        } else {
            guard let taskListItemCompleted = viewModel?.getCompletedTasks[indexPath.row] else {
                return UITableViewCell()
            }
            item = taskListItemCompleted
        }
        
        cell.setData(title: item.title, description: item.description, completed: item.completed)
        
        cell.onCompletionToggle = { [weak self] in
            self?.handleToggleCompletion(for: item)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let itemToDelete = viewModel?.task(at: indexPath) else { return }
            
            viewModel?.deleteTask(itemToDelete)
            
            tasksTableView.reloadData()
        }
    }
    
    private func handleToggleCompletion(for item: Item) {

        let isCompleted = item.completed
        self.viewModel?.toggleCompleted(for: item)
        
        self.viewModel?.getAllTasks()
        
        updateTableView(for: item, wasCompleted: isCompleted)
    }
    
    private func updateTableView(for item: Item, wasCompleted: Bool) {
        if wasCompleted {
            if let index = viewModel?.getCompletedTasks.firstIndex(where: { $0.id == item.id }) {
                let indexPath = IndexPath(row: index, section: 1)
                tasksTableView.performBatchUpdates({
                    tasksTableView.deleteRows(at: [indexPath], with: .automatic)
                }, completion: nil)
            }
        } else {
            if let index = viewModel?.getPendingTasks.firstIndex(where: { $0.id == item.id }) {
                let indexPath = IndexPath(row: index, section: 0)
                tasksTableView.performBatchUpdates({
                    tasksTableView.deleteRows(at: [indexPath], with: .automatic)
                }, completion: nil)
            }
        }
        
        tasksTableView.reloadData()
    }
}

