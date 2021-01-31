//
//  MainViewController.swift
//  Repositories
//
//  Created by Catalin Palade on 29/01/2021.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    var coreDataStack: CoreDataStack!
    
    // DataSource & DataSourceSnapshot typealias
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section {
        case main
    }
    
    var repos: [Item] = []
    var favorite: [Item] { getFavoriteRepos() }
    
    var isFavorite: Bool = false {
        didSet { favoriteChanged() }
    }
    
    var searchText: String = ""
    var page = 1 {
        didSet { getRepos(for: searchText, page: page) }
    }
    
    // Properties
    private var collectionView: UICollectionView!
    private var searchBar: UISearchBar!
    
    private var dataSource: DataSource!
    private var snapshot: DataSourceSnapshot!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationController()
        configureSearchBar()
        configureCollectionView()
        configureCollectionViewDataSource()
        
    }

    private func configureNavigationController() {
        // UINavigationController
        self.title = "Repositories"
        self.navigationController?.navigationBar.barTintColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Favorite",
            style: .plain,
            target: self,
            action: #selector(favoriteTapped)
        )
        
        // View
        self.view.backgroundColor = .systemBackground
    }
    
    @objc func favoriteTapped() {
        isFavorite.toggle()
    }
    
    private func favoriteChanged() {
        if isFavorite {
            self.title = "Favorite"
            self.navigationItem.rightBarButtonItem?.title = "Search"
            
            DispatchQueue.main.async {
                self.applySnapshot(repos: self.favorite)
            }
            
        } else {
            self.title = "Repositories"
            self.navigationItem.rightBarButtonItem?.title = "Favorite"
            
            DispatchQueue.main.async {
                self.applySnapshot(repos: self.repos)
            }
        }
    }
    
    private func configureSearchBar() {
        // UISearchBar
        searchBar = UISearchBar()
        searchBar.placeholder = "Search repoitory name"
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func configureCollectionView() {
        // UICollectionView
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: createLayout())
        collectionView.register(RepositoryCell.self,
                                forCellWithReuseIdentifier: RepositoryCell.identifier)
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        // Item
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        
        // Group
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(100)
            ),
            subitem: item,
            count: 1
        )
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        
        // Return
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureCollectionViewDataSource() {
        dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, repository) -> RepositoryCell? in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RepositoryCell.identifier,
                                                              for: indexPath) as! RepositoryCell
                
                if let repo = self.dataSource.itemIdentifier(for: indexPath) {
                    cell.configure(with: repo)
                }
                
                return cell
            }
        )
    }
    
    private func applySnapshot(repos: [Item]) {
        snapshot = DataSourceSnapshot()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(repos)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func getRepos(for searchText: String, page: Int = 1) {
        if page == 1 { repos.removeAll() }
        NetworkManager.shared.searchRepo(searchText: searchText, page: page) { (result) in
            switch result {
            case .success(let gitResponse):
                
                DispatchQueue.main.async {
                    if let repos = gitResponse.items {
                        self.repos.append(contentsOf: repos)
                        self.applySnapshot(repos: self.repos)
                    }
                }
                
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    fileprivate func getFavoriteRepos() -> [Item] {
        var items = [Item]()
        let itemFetch: NSFetchRequest<CoreItem> = CoreItem.fetchRequest()
        
        do {
            let coreItems = try coreDataStack.managedContext.fetch(itemFetch)
            
            for item in coreItems {
                let item = Item(
                    id: Int(item.id),
                    name: item.name ?? "",
                    fullName: item.fullName ?? "",
                    itemDescription: item.itemDescription ?? "",
                    owner: Owner(id: Int(item.ownerID),
                                 name: item.ownerName ?? "",
                                 avatarURL: item.ownerAvatarURL),
                    createdAt: item.createdAt ?? "",
                    updatedAt: item.updatedAt ?? "",
                    forks: Int(item.forks),
                    openIssues: Int(item.openIssues),
                    watchers: Int(item.watchers)
                )
                items.append(item)
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        return items
    }
}

// MARK: UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let repo = dataSource.itemIdentifier(for: indexPath) else { return }
        
        let detailVC = RepoDetailViewController(repo: repo)
        detailVC.coreDataStack = self.coreDataStack
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row + 1) % 20 == 0 && !isFavorite {
            page += 1
        }
    }
}

// MARK: UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if isFavorite {
            
        } else {
            self.searchText = searchText
            getRepos(for: searchText)
        }
    }
}
