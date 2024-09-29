//
//  AddTasksViewController.swift
//  ToDoList
//
//  Created by Argh on 9/28/24.
//

import UIKit

final class AddTasksViewController: UIViewController {
    
    private var stackView: UIStackView!
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var addTaskButton: UIButton!
    private var taskFields: [(title: UITextField, description: UITextField)] = []
    private var floatingAddButton: UIButton!
    private var viewModel: AddTasksViewModel?
    
    var taskAdded: (() -> ())?
    weak var coordinator: AppCoordinator?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        setupUI()
        addNewTaskField()
        setupFloatingAddButton()
        setupTapGesture()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        viewModel = AddTasksViewModel()
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
    }

    @objc private func keyboardWillHide(notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupFloatingAddButton() {
        floatingAddButton = UIButton(type: .system)
        let plusImage = UIImage(systemName: "plus")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        floatingAddButton.setImage(plusImage, for: .normal)
        floatingAddButton.backgroundColor = .systemBlue
        floatingAddButton.layer.cornerRadius = 25
        floatingAddButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(floatingAddButton)
        view.bringSubviewToFront(floatingAddButton)
        
        NSLayoutConstraint.activate([
            floatingAddButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            floatingAddButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            floatingAddButton.widthAnchor.constraint(equalToConstant: 50),
            floatingAddButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        floatingAddButton.addTarget(self, action: #selector(addMoreTapped), for: .touchUpInside)
    }
    
    private func configureNavBar() {
        title = "Add Task"
        view.backgroundColor = .systemBackground
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    @objc private func saveButtonTapped() {
        var items: [Item] = []
        
        for (index, taskField) in taskFields.enumerated() {
            guard let title = taskField.title.text, !title.isEmpty else {
                showAlert(forMissingTitleAt: index)
                return
            }
            
            let description = taskField.description.text ?? ""
            let newItem = Item(title: title, description: description, completed: false, id: UUID())
            items.append(newItem)
        }
        
        viewModel?.addTasks(tasks: items)
        coordinator?.dismiss(animated: true) { [weak self] in
            self?.taskAdded?()
        }
    }
    
    private func showAlert(forMissingTitleAt index: Int) {
        let alert = UIAlertController(title: "Missing Title",
                                      message: "Please provide a title for Task \(index + 1).",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func cancelButtonTapped() {
        coordinator?.dismiss(animated: true, completion: nil)
    }
    
    private func setupUI() {
        configureScrollView()
        configureContentView()
        configureStackView()
        
        scrollView.isScrollEnabled = true
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20) // Add this line
        ])
    }
    
    private func configureScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
    }
    
    private func configureContentView() {
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
    }
    
    private func configureStackView() {
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
    }
    
    @objc private func addMoreTapped() {
        addNewTaskField()
    }
    
    private func addNewTaskField() {
        let titleField = UITextField()
        titleField.placeholder = "Task Title"
        titleField.borderStyle = .roundedRect
        titleField.delegate = self
        
        let descriptionField = UITextField()
        descriptionField.placeholder = "Task Description"
        descriptionField.borderStyle = .roundedRect
        descriptionField.delegate = self
        
        stackView.addArrangedSubview(titleField)
        stackView.addArrangedSubview(descriptionField)
        
        let separator = UIView()
        separator.backgroundColor = UIColor(white: 0.9, alpha: 0.5)
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        stackView.addArrangedSubview(separator)
        
        taskFields.append((title: titleField, description: descriptionField))
    }
}

extension AddTasksViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Dismiss the keyboard
        return true
    }
}

