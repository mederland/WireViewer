//
//  APIHelper.swift
//  WireViewerKit
//
//  Created by Meder iZimov on 6/11/23.
//

import Foundation

typealias FetchCharacterCompletionHandler = (Character?, APIError?) -> Void
typealias FetchDataCompletionHandler = (Data?, URLResponse?, Error?) -> Void

class APIHelper {
    static let shared = APIHelper()
    
    private init() {}
    
    func fetchCharacters(completionHandler: @escaping FetchCharacterCompletionHandler) {
        guard let url = URL(string: AppConfiguration.apiURL) else { return completionHandler(nil, .incorrectURL) }
        
        self.fetchData(from: url) { (data, response, error) in
            guard let dataResponse = data, error == nil else { return completionHandler(nil, .responseError) }
            
            do {
                let fetchedData = try JSONDecoder().decode(Character.self, from: dataResponse)
                completionHandler(fetchedData, nil)
            } catch {
                return completionHandler(nil, .parsingJSONError)
            }
        }
    }
    
    func fetchData(from url: URL, completion: @escaping FetchDataCompletionHandler) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
