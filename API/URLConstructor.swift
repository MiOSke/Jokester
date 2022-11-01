//
//  URLConstructor.swift
//  Jokester
//
//  Created by Michael Kampouris on 11/1/22.
//

import Foundation

public enum JokeEndpoint: String, CaseIterable {
    case miscellaneous = "Any"
    case dark = "Dark"
    case programming = "Programming"
    case pun = "Pun"
}

public enum JokeFilter: String, CaseIterable {
    case religious = "religious"
    case sexist = "sexist"
    case political = "political"
    case explicit = "explicit"
    case nsfw = "nsfw"
    case racist = "racist"
}

public struct URLConstructor {

    public func constructURLWith(jokeType: JokeEndpoint, filters: [JokeFilter]?) -> URL? {
        let baseURL = "https://v2.jokeapi.dev/joke"
        var filterString = ""
        if let filters = filters, filters.count > 0 {
            filters.forEach { filter in
                filterString += ",\(filter)"
            }
            return URL(string: "\(baseURL)/\(jokeType)?blacklistFlags=\(filterString.dropFirst())")
        } else {
            return URL(string: "\(baseURL)/\(jokeType)")
        }
        
    }
    
}
