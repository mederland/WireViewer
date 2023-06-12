//
//  CharacterListViewController.swift
//  WireViewerKit
//
//  Created by Meder iZimov on 6/11/23.
//

import UIKit

class CharacterListViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    private let viewModel = CharacterListViewModel()
    private var filteredCharacters: [RelatedTopic] = []

    private let tableView = UITableView()
    private var searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchCharacterData()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    private func setupUI() {
        view.backgroundColor = .black
        
        // Create a title label
            let titleLabel = UILabel()
            titleLabel.text = "Character Search"
            titleLabel.textAlignment = .center
            titleLabel.textColor = .white
            titleLabel.font = UIFont.boldSystemFont(ofSize: 20)


        // Create a search bar and embed it in a search controller
        _ = UISearchBar()
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self // Add the delegate
        searchController.searchBar.placeholder = "Search Characters"
        searchController.searchBar.showsCancelButton = false
        
        // Create a container view for the title label and search bar
            let headerView = UIView()
            headerView.addSubview(titleLabel)
            headerView.addSubview(searchController.searchBar)
        tableView.tableHeaderView = headerView

        // Set the search bar as the header view of the table view
        tableView.tableHeaderView = searchController.searchBar

        // Add the table view to the view
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        // Set the constraints for the table view
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        // Set the data source and delegate of the table view
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

    // MARK: - UISearchResultsUpdating

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }

        filterCharacters(with: searchText)
        tableView.reloadData()
    }

    private func filterCharacters(with searchText: String) {
        filteredCharacters = viewModel.characters.filter { character in
            let characterName = character.characterFullDescription.getCharacterName().uppercased()
            let characterDescription = character.characterFullDescription.getCharacterDescription().uppercased()
            let searchQuery = searchText.uppercased()

            return characterName.contains(searchQuery) || characterDescription.contains(searchQuery)
        }
    }
}

// MARK: - UITableViewDataSource

extension CharacterListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchActive() ? filteredCharacters.count : viewModel.characters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let character = isSearchActive() ? filteredCharacters[indexPath.row] : viewModel.characters[indexPath.row]
        cell.textLabel?.text = character.characterFullDescription.getCharacterName()
        return cell
    }

    private func isSearchActive() -> Bool {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }
}

// MARK: - UITableViewDelegate
extension CharacterListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = isSearchActive() ? filteredCharacters[indexPath.row] : viewModel.characters[indexPath.row]
        
        // Dismiss the search controller if it is active
        if searchController.isActive {
            searchController.dismiss(animated: true, completion: nil)
        }
        
        let detailViewController = DetailViewController(characterName: character.characterFullDescription.getCharacterName(), characterDescription: character.characterFullDescription)
        
        if let navigationController = navigationController {
            navigationController.pushViewController(detailViewController, animated: true)
        } else {
            present(detailViewController, animated: true, completion: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
