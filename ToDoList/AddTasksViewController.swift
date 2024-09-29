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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        setupUI()
        addNewTaskField()
        setupFloatingAddButton()
    }
    
    private func setupFloatingAddButton() {
        floatingAddButton = UIButton(type: .system)
        let plusImage = UIImage(systemName: "plus")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        floatingAddButton.setImage(plusImage, for: .normal)
        floatingAddButton.backgroundColor = .systemBlue
        floatingAddButton.layer.cornerRadius = 25
        floatingAddButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(floatingAddButton)
        
        // Set constraints for the floating button
        NSLayoutConstraint.activate([
            floatingAddButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            floatingAddButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            floatingAddButton.widthAnchor.constraint(equalToConstant: 50),
            floatingAddButton.heightAnchor.constraint(equalToConstant: 50)
        ])
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
        print("Save button tapped!")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func cancelButtonTapped() {
        print("Cancel button tapped!")
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupUI() {
        configureScrollView()
        configureContentView()
        configureStackView()
        
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
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    private func configureScrollView() {
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureContentView() {
        contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureStackView() {
        stackView = UIStackView()
        contentView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc private func addMoreTapped() {
        print("Add More button tapped!")
        addNewTaskField()
    }
    
    private func addNewTaskField() {
        let titleField = UITextField()
        titleField.placeholder = "Task Title"
        titleField.borderStyle = .roundedRect
        
        let descriptionField = UITextField()
        descriptionField.placeholder = "Task Description"
        descriptionField.borderStyle = .roundedRect
        
        stackView.addArrangedSubview(titleField)
        stackView.addArrangedSubview(descriptionField)
        
        let separator = UIView()
        separator.backgroundColor = UIColor(white: 0.9, alpha: 0.5)
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        stackView.addArrangedSubview(separator)
        
        taskFields.append((title: titleField, description: descriptionField))
    }
}

