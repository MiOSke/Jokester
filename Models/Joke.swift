//
//  Joke.swift
//  Jokester
//
//  Created by Michael Kampouris on 11/1/22.
//

import Foundation

public struct Joke: Decodable {
    let category: String?
    let jokeText: String?
    let type: String?
    let setup: String?
    let delivery: String?
    
    enum CodingKeys: String, CodingKey {
        case jokeText = "joke"
        case category, type, setup, delivery
    }
}
