//
//  APILayer.swift
//  Jokester
//
//  Created by Michael Kampouris on 11/1/22.
//

import Foundation

public final class APILayer {
    
    private var session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
    
    public func getJokeFrom(url: URL) async -> Joke? {
        do {
            let (data, _) = try await session.data(from: url)
            return try JSONDecoder().decode(Joke.self, from: data)
        } catch {
            return nil
        }
        
    }
    
}
