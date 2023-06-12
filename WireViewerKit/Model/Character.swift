//
//  Character.swift
//  WireViewerKit
//
//  Created by Meder iZimov on 6/11/23.
//

import Foundation

struct Character: Codable {
    let heading: String
    let relatedTopics: [RelatedTopic]
    
    enum CodingKeys: String, CodingKey {
        case heading = "Heading"
        case relatedTopics = "RelatedTopics"
    }
}

struct RelatedTopic: Codable {
    let icon: Icon
    let characterFullDescription: String
    
    enum CodingKeys: String, CodingKey {
        case icon = "Icon"
        case characterFullDescription = "Text"
    }
}

struct Icon: Codable {
    let characterImgUrl: String
    
    enum CodingKeys: String, CodingKey {
        case characterImgUrl = "URL"
    }
}
