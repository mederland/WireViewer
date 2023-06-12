//
//  CharacterListViewModel.swift
//  WireViewerKit
//
//  Created by Meder iZimov on 6/11/23.
//

import Foundation

class CharacterListViewModel {
    
    var characters: [RelatedTopic] = []
    var filteredCharacterList: [RelatedTopic] = []
    var searchText: String = "" {
        didSet {
            filteredCharacterList = getFilteredCharacters(with: searchText)
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
        return filteredCharacterList.count
    }
    
    func getCharacter(at index: Int, isFiltered: Bool) -> RelatedTopic {
        let characterList = isFiltered ? filteredCharacterList : characters
        return characterList[index]
    }

    
    func getFilteredCharacters(with searchText: String) -> [RelatedTopic] {
        if searchText.isEmpty {
            return characters
        } else {
            return characters.filter({
                $0.characterFullDescription.getCharacterName().range(of: searchText, options: .caseInsensitive) != nil ||
                $0.characterFullDescription.getCharacterDescription().range(of: searchText, options: .caseInsensitive) != nil
            })
        }
    }
    
    func getCharacterFromFiltered(at index: Int) -> RelatedTopic {
        return filteredCharacterList[index]
    }

}

extension String {
    func getCharacterName() -> String {
        guard let range = self.range(of: "-") else {
            return self
        }
        let name = self[..<range.lowerBound].trimmingCharacters(in: .whitespaces)
        return String(name)
    }
    
    func getCharacterDescription() -> String {
        guard let range = self.range(of: "-") else {
            return ""
        }
        let description = self[range.upperBound...].trimmingCharacters(in: .whitespaces)
        return String(description)
    }
}
