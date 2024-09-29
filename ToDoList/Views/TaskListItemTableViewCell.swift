//
//  TaskListItemTableViewCell.swift
//  ToDoList
//
//  Created by Argh on 9/28/24.
//

import UIKit

final class TaskListItemTableViewCell: UITableViewCell {
    
    private var titleLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var completedButton = UIButton(type: .custom)
    
    var onCompletionToggle: (()->())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureTableViewCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(title: String, description: String, completed: Bool) {
        self.titleLabel.text = title
        self.descriptionLabel.text = description
        self.completedButton.isSelected = completed
        
        handleState(completed: completed)
    }
    
    private func handleState(completed: Bool) {
        if completed {
            titleLabel.textColor = .systemGray
            descriptionLabel.textColor = .systemGray2
            completedButton.alpha = 0.6 // Make the button appear disabled
        } else {
            titleLabel.textColor = .label
            descriptionLabel.textColor = .secondaryLabel
            completedButton.alpha = 1.0 // Full visibility for active tasks
        }
    }
    
    private func configureTableViewCell() {
        selectionStyle = .none
        configureButton()
        configureLabels()
        
        NSLayoutConstraint.activate([
            completedButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            completedButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            completedButton.heightAnchor.constraint(equalToConstant: 48),
            completedButton.widthAnchor.constraint(equalTo: completedButton.heightAnchor, multiplier: 1),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: completedButton.trailingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8), // Corrected
            
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func configureButton() {
        completedButton.translatesAutoresizingMaskIntoConstraints = false
        completedButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        completedButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        completedButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        contentView.addSubview(completedButton)
    }
    
    @objc private func doneButtonTapped() {
        completedButton.isSelected.toggle()
        onCompletionToggle?()
    }
    
    private func configureLabels() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        contentView.addSubview(titleLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        contentView.addSubview(descriptionLabel)
    }
}
