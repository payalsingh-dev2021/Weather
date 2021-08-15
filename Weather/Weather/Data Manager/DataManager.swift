//
//  DataManager.swift
//  Weather
//
//  Created by Payal Singh on 14/08/21.
//

import Foundation
import CoreData

enum SessionError: Error {
    case unknown
    case failedRequest
    case invalidResponse
}

final class DataManager{
}

extension DataManager{
    typealias SessionResult<T> = (Result<T, SessionError>) -> ()

    func fetchWeatherData<T:Decodable>(by searchType:SearchType, responseType:T.Type ,completion: @escaping SessionResult<T>) {
        let weatherServiceRequestURL = WeatherServiceRequest(searchType: searchType).url
        
        URLSession.shared.dataTask(with: weatherServiceRequestURL){ (data, response, error) in
            DispatchQueue.main.async {
                self.didFetchData(model: T.self, data: data, response: response, error: error, completion: completion)
            }
        }.resume()
    }
    
    private func didFetchData<T:Decodable>(model: T.Type,data: Data?, response: URLResponse?, error: Error?, completion: SessionResult<T>) {
        if let error = error {
            completion(.failure(.failedRequest))
            print("Unable to Fetch Location Data, \(error)")

        } else if let data = data, let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                do {
                    // Create JSON Decoder
                    let decoder = JSONDecoder()
                    
                    // Configure JSON Decoder
                    decoder.dateDecodingStrategy = .secondsSince1970

                    // Decode JSON
                    let locations = try decoder.decode(T.self, from: data)

                    // Invoke Completion Handler
                    completion(.success(locations))

                } catch {
                    completion(.failure(.invalidResponse))
                    print("Unable to Decode Response, \(error)")
                }

            } else {
                completion(.failure(.failedRequest))
            }

        } else {
            completion(.failure(.unknown))
        }
    }
  
}


extension DataManager{
    func addorUpdateRecentSearch(_ searchText:String,_ managedObjectContext:NSManagedObjectContext?){
        guard let managedObjectContext = managedObjectContext  else {
            return
        }
        
        let fetchRequest: NSFetchRequest<RecentSearch> = RecentSearch.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "keyword == %@", searchText)

        managedObjectContext.performAndWait{
            do {
                let res:[RecentSearch] = try fetchRequest.execute()
                if res.count > 0{
                    let result = res[0]
                    result.timestamp = Utility.getCurrentTimeStamp()
                }
                else{
                    let recentSearch = RecentSearch(context:managedObjectContext)
                    recentSearch.keyword = searchText
                    recentSearch.timestamp = Utility.getCurrentTimeStamp()
                }
                
                do {
                    try managedObjectContext.save()
                    
                } catch {
                    print("Unable to Save Search keyword, \(error)")
                }
                
            } catch {
                print("Unable to Execute Fetch Request, \(error)")
            }
        }
        
        
    }
    
    func getRecentSearches(_ managedObjectContext:NSManagedObjectContext?) -> RecentSearchViewModel?{
        guard let managedObjectContext = managedObjectContext  else {
            return nil
        }
        let fetchRequest: NSFetchRequest<RecentSearch> = RecentSearch.fetchRequest()
        var result:RecentSearchViewModel?
        managedObjectContext.performAndWait{
            do {
                let res = try fetchRequest.execute()
                result = RecentSearchViewModel(recentSearches: res)
            } catch {
                print("Unable to Execute Fetch Request, \(error)")
            }
        }
        return result
    }
}
