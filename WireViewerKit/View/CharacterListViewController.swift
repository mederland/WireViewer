//
//  CharacterListViewController.swift
//  WireViewerKit
//
//  Created by Meder iZimov on 6/11/23.
//

import UIKit

class CharacterListViewController: UIViewController, UISearchResultsUpdating {
    private let viewModel = CharacterListViewModel()
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        
        // Update the search text in the view model
        viewModel.searchText = searchText
        
        // Reload the table view to display the filtered results
        tableView.reloadData()
    }






    
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchCharacterData()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        // Create a container view for the search bar
        let searchBarContainer = UIView()
        searchBarContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBarContainer)
        
        // Add the search bar to the container view
        searchBarContainer.addSubview(searchController.searchBar)
        
        // Configure the search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Characters"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            // Search bar container constraints
            searchBarContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBarContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBarContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // Search bar constraints
            searchController.searchBar.topAnchor.constraint(equalTo: searchBarContainer.topAnchor),
            searchController.searchBar.leadingAnchor.constraint(equalTo: searchBarContainer.leadingAnchor),
            searchController.searchBar.trailingAnchor.constraint(equalTo: searchBarContainer.trailingAnchor),
            searchController.searchBar.bottomAnchor.constraint(equalTo: searchBarContainer.bottomAnchor),
            
            // Table view constraints
            tableView.topAnchor.constraint(equalTo: searchBarContainer.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // Set the title of the view controller
        title = "The Wire Viewer"
    }
    
    private func fetchCharacterData() {
        viewModel.fetchCharacters { [weak self] error in
            if let error = error {
                print("Error fetching character data: \(error.localizedDescription)")
            } else {
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension CharacterListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getCharacterListCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let character = viewModel.getCharacter(at: indexPath.row)
        cell.textLabel?.text = character.characterFullDescription.getCharacterName()
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CharacterListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let relatedTopic = viewModel.getCharacter(at: indexPath.row)
        let detailViewController = DetailViewController(characterName: relatedTopic.characterFullDescription.getCharacterName(), characterDescription: relatedTopic.characterFullDescription)
        
        if let navigationController = navigationController {
            navigationController.pushViewController(detailViewController, animated: true)
        } else {
            present(detailViewController, animated: true, completion: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
