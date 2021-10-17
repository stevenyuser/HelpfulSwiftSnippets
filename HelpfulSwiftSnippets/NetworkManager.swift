//
//  NetworkingManager.swift
//  HelpfulSwiftSnippets
//
//  Created by Steven Yu on 10/10/21.
//

import Foundation
import Combine

// A generic Networking Manager that deals with downloading data from the internet
/*
 1) Call NetworkingManager.download
 2) decode into the custom type (probably with JSONDecoder)
 3) sink it with handleComletion and set your data to the outputted data
 
 Example Usage:
 @Published var allCoins: [CoinModel] = []
 
 coinSubscription = NetworkingManager.download(url: url)
     .decode(type: [CoinModel].self, decoder: JSONDecoder())
     .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCoins) in
     self?.allCoins = returnedCoins
     self?.coinSubscription?.cancel()
     })
 */

class NetworkingManager {
    
    // enum of possible errors
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url): return "[🔥] Bad response from URL: \(url)"
            case .unknown: return "[⚠️] Unknown error occured"
            }
        }
    }
    
    // function that downloads a URL and outputs a Combine Publisher that you can then call .sink on to use the data
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ try handleURLResponse(output: $0, url: url)})
            .retry(3)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // handles the URL Response and checks that the response is valid (2xx), otherwise throws a bad url response
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badURLResponse(url: url)
        }
        return output.data
    }
    
    // handles .sink completion
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
}
