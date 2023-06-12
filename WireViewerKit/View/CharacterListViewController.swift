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

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "The Wire Viewer"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Characters"
        searchController.searchBar.showsCancelButton = false
        searchController.hidesNavigationBarDuringPresentation = false
        return searchController
    }()
    
        private lazy var titleStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [titleLabel])
            stackView.axis = .vertical
            stackView.spacing = 8
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
       
        private lazy var searchBarStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [searchController.searchBar])
            stackView.axis = .vertical
            stackView.spacing = 8
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchCharacterData()
        self.extendedLayoutIncludesOpaqueBars = ((self.navigationController?.navigationBar.isTranslucent) != nil)
    }


        private func setupUI() {
            view.backgroundColor = .black

            view.addSubview(titleStackView)
            view.addSubview(searchBarStackView)
            view.addSubview(tableView)

            NSLayoutConstraint.activate([
                titleStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                titleStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                titleStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                
                searchController.searchBar.heightAnchor.constraint(equalToConstant: 80),
                
                searchBarStackView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor),
                searchBarStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                searchBarStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

                tableView.topAnchor.constraint(equalTo: searchBarStackView.bottomAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
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



