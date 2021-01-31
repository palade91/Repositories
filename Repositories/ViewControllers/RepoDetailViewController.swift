//
//  RepoDetailViewController.swift
//  Repositories
//
//  Created by Catalin Palade on 29/01/2021.
//

import UIKit
//import CoreData

class RepoDetailViewController: UIViewController {
    
    var coreDataStack: CoreDataStack!
    var repo: Item
    
    init(repo: Item) {
        self.repo = repo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureUI()
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add to Favorite",
            style: .plain,
            target: self,
            action: #selector(addToFavoriteTapped)
        )
    }
    
    @objc func addToFavoriteTapped() {
        // todo save to favorite
        let coreItem = CoreItem(context: coreDataStack.managedContext)
        
        coreItem.id                 = Int64(repo.id)
        coreItem.name               = repo.name
        coreItem.fullName           = repo.fullName
        coreItem.itemDescription    = repo.itemDescription
        coreItem.forks              = Int64(repo.forks)
        coreItem.watchers           = Int64(repo.watchers)
        coreItem.openIssues         = Int64(repo.openIssues)
        coreItem.createdAt          = repo.createdAt
        coreItem.updatedAt          = repo.updatedAt
        coreItem.ownerID            = Int64(repo.owner?.id ?? 0)
        coreItem.ownerName          = repo.owner?.name
        coreItem.ownerAvatarURL     = repo.owner?.avatarURL
        
        self.coreDataStack.saveContext()
    }
    
    private func configureUI() {
        self.view.backgroundColor = .systemBackground
        
        // main stack
        let verticalStack = UIStackView()
        verticalStack.distribution = .equalSpacing
        verticalStack.alignment = .center
        verticalStack.axis = .vertical
        verticalStack.spacing = 20
        
        self.view.addSubview(verticalStack)
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        verticalStack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        verticalStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15).isActive = true
        verticalStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15).isActive = true
        
        // profile image
        let profileImage = UIImageView()
        if let urlString = repo.owner?.avatarURL {
            NetworkManager.shared.downloadImage(fromURLString: urlString) { (image) in
                DispatchQueue.main.async {
                    profileImage.image = image

                }
            }
        }
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        verticalStack.addArrangedSubview(profileImage)
        
        // user name
        let nameLabel = UILabel()
        nameLabel.text = repo.owner?.name
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        nameLabel.textAlignment = .center
        
        verticalStack.addArrangedSubview(nameLabel)
        
        // repo name
        let repoLabel = UILabel()
        repoLabel.text = repo.name
        repoLabel.font = UIFont.systemFont(ofSize: 26, weight: .medium)
        repoLabel.textAlignment = .center
        repoLabel.numberOfLines = 0
        
        verticalStack.addArrangedSubview(repoLabel)
        
        // numbers stack
        let numbersStack = UIStackView()
        numbersStack.distribution = .equalCentering
        numbersStack.alignment = .center
        numbersStack.axis = .horizontal
        numbersStack.spacing = 20
        
        // forks
        let stack1 = UIStackView()
        stack1.distribution = .fillProportionally
        stack1.alignment = .center
        stack1.axis = .vertical
        stack1.spacing = 5
        
        let forkTitle = UILabel()
        forkTitle.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        forkTitle.text = "Forks"
        
        let forksCountLabel = UILabel()
        forksCountLabel.font = UIFont.systemFont(ofSize: 26, weight: .medium)
        forksCountLabel.text = "\(repo.forks)"
        
        stack1.addArrangedSubview(forkTitle)
        stack1.addArrangedSubview(forksCountLabel)
        
        // issuses
        let stack2 = UIStackView()
        stack2.distribution = .fillProportionally
        stack2.alignment = .center
        stack2.axis = .vertical
        stack2.spacing = 5
        
        let issueTitle = UILabel()
        issueTitle.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        issueTitle.text = "Issues"
        
        let issuesCountLabel = UILabel()
        issuesCountLabel.font = UIFont.systemFont(ofSize: 26, weight: .medium)
        issuesCountLabel.text = "\(repo.openIssues)"
        
        stack2.addArrangedSubview(issueTitle)
        stack2.addArrangedSubview(issuesCountLabel)
        
        // watchers
        let stack3 = UIStackView()
        stack3.distribution = .fillProportionally
        stack3.alignment = .center
        stack3.axis = .vertical
        stack3.spacing = 5
        
        let watchersTitle = UILabel()
        watchersTitle.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        watchersTitle.text = "Watchers"
        
        let watchersCountLabel = UILabel()
        watchersCountLabel.font = UIFont.systemFont(ofSize: 26, weight: .medium)
        watchersCountLabel.text = "\(repo.watchers)"
        
        stack3.addArrangedSubview(watchersTitle)
        stack3.addArrangedSubview(watchersCountLabel)
        
        
        numbersStack.addArrangedSubview(stack1)
        numbersStack.addArrangedSubview(stack2)
        numbersStack.addArrangedSubview(stack3)
        
        verticalStack.addArrangedSubview(numbersStack)
        
        // repo description
        let descriptionLabel = UILabel()
        descriptionLabel.text = repo.itemDescription
        descriptionLabel.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        descriptionLabel.textAlignment = .justified
        descriptionLabel.numberOfLines = 0
        
        verticalStack.addArrangedSubview(descriptionLabel)
    }
}
