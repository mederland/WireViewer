//
//  CharacterListViewModel.swift
//  WireViewerKit
//
//  Created by Meder iZimov on 6/11/23.
//

import Foundation

class CharacterListViewModel {
  
    var characters: [RelatedTopic] = [RelatedTopic]()
    private var filteredCharacterList: [RelatedTopic] = [RelatedTopic]()
    
    var searchText: String = "" {
        didSet {
            self.getFilteredCharacters()
        }
    }
    
    func fetchCharacters(completion: @escaping (APIError?) -> Void) {
        APIHelper.shared.fetchCharacters() { [weak self] (character, error) in
            if let error = error {
                completion(error)
            } else if let character = character {
                DispatchQueue.main.async {
                    self?.characters = character.relatedTopics
                    self?.filteredCharacterList = character.relatedTopics
                    completion(nil)
                }
            }
        }
    }

    func getCharacterListCount() -> Int {
        self.getFilteredCharacters()
        return self.filteredCharacterList.count
    }
    
    func getCharacter(at index: Int) -> RelatedTopic {
        return self.filteredCharacterList[index]
    }
    
    func getCharacterName(at index: Int) -> String {
        return self.getCharacter(at: index).characterFullDescription.getCharacterName()
    }
    
    func getCharacterDescription(at index: Int) -> String {
        return self.getCharacter(at: index).characterFullDescription.getCharacterDescription()
    }
    
    func getFilteredCharacters() {
        if self.searchText.isEmpty {
            self.filteredCharacterList = self.characters
        } else {
            self.filteredCharacterList = self.characters.filter({
                $0.characterFullDescription.getCharacterName().uppercased().contains(self.searchText.uppercased()) || $0.characterFullDescription.getCharacterDescription().uppercased().contains(self.searchText.uppercased())
            })
        }
    }
    
}

extension String {
   
    func getCharacterName() -> String {
        var characterName: String = "Unknown Character Name"
        
        if let index = self.firstIndex(of: "-") {
            let i = self.index(index, offsetBy: -1)
            characterName = String(self[..<i])
        }
        
        return characterName
    }
    
    func getCharacterDescription() -> String {
        var desc: String = "Unknown Character Description"
        
        if let index = self.firstIndex(of: "-") {
            let i = self.index(index, offsetBy: 2)
            desc = String(self[i...])
        }
        
        return desc
    }
}

//extension CharacterListViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Cell at index path \(indexPath) selected")
//        let relatedTopic = viewModel.getCharacter(at: indexPath.row)
//        let detailViewController = DetailViewController(characterDescription: relatedTopic.characterFullDescription)
//        navigationController?.pushViewController(detailViewController, animated: true)
//    }
//}
