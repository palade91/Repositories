//
//  RepositoryCell.swift
//  GitHub_iOS
//
//  Created by Catalin Palade on 23/01/2021.
//

import UIKit

class RepositoryCell: UICollectionViewCell {
    
    static let identifier = "repository_cell"
    
    var nameLabel = UILabel()
    var ownerNameLabel = UILabel()
    
    var forksCountLabel = UILabel()
    var issuesCountLabel = UILabel()
    var watchersCountLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with repository: Item) {
        nameLabel.text              = repository.name
        ownerNameLabel.text         = repository.owner?.name
        
        forksCountLabel.text        = "\(repository.forks)"
        issuesCountLabel.text       = "\(repository.openIssues)"
        watchersCountLabel.text     = "\(repository.watchers)"
    }
    
    private func configureCellUI() {
        // Background
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.3
        
        // main stack
        let verticalStack = UIStackView()
        verticalStack.distribution = .equalSpacing
        verticalStack.alignment = .fill
        verticalStack.axis = .vertical
        verticalStack.spacing = 5
        
        self.addSubview(verticalStack)
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        verticalStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        verticalStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        verticalStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        verticalStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        
        // repo name and user name stack
        let nameStack = UIStackView()
        nameStack.distribution = .fillProportionally
        nameStack.alignment = .center
        nameStack.axis = .horizontal
        nameStack.spacing = 5
        
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .black)
        
        ownerNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        ownerNameLabel.textAlignment = .right
        
        nameStack.addArrangedSubview(nameLabel)
        nameStack.addArrangedSubview(ownerNameLabel)
        
        verticalStack.addArrangedSubview(nameStack)
        
        // numbers stack
        let numbersStack = UIStackView()
        numbersStack.distribution = .fillEqually
        numbersStack.alignment = .center
        numbersStack.axis = .horizontal
        numbersStack.spacing = 5
        
        // forks
        let stack1 = UIStackView()
        stack1.distribution = .fillEqually
        stack1.alignment = .center
        stack1.axis = .vertical
        stack1.spacing = 5
        
        let forkTitle = UILabel()
        forkTitle.font = UIFont.systemFont(ofSize: 14, weight: .light)
        forkTitle.text = "Forks"
        
        forksCountLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        stack1.addArrangedSubview(forkTitle)
        stack1.addArrangedSubview(forksCountLabel)
        
        // issuses
        let stack2 = UIStackView()
        stack2.distribution = .fillEqually
        stack2.alignment = .center
        stack2.axis = .vertical
        stack2.spacing = 5
        
        let issueTitle = UILabel()
        issueTitle.font = UIFont.systemFont(ofSize: 14, weight: .light)
        issueTitle.text = "Issues"
        
        issuesCountLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        stack2.addArrangedSubview(issueTitle)
        stack2.addArrangedSubview(issuesCountLabel)
        
        // watchers
        let stack3 = UIStackView()
        stack3.distribution = .fillEqually
        stack3.alignment = .center
        stack3.axis = .vertical
        stack3.spacing = 5
        
        let watchersTitle = UILabel()
        watchersTitle.font = UIFont.systemFont(ofSize: 14, weight: .light)
        watchersTitle.text = "Watchers"
        
        watchersCountLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        stack3.addArrangedSubview(watchersTitle)
        stack3.addArrangedSubview(watchersCountLabel)
        
        
        numbersStack.addArrangedSubview(stack1)
        numbersStack.addArrangedSubview(stack2)
        numbersStack.addArrangedSubview(stack3)
        
        verticalStack.addArrangedSubview(numbersStack)
    }
}
