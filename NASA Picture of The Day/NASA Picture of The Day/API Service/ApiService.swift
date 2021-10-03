//
//  ApiService.swift
//  NASA Picture of The Day
//
//  Created by Krishna Gunjal on 02/10/21.
//

import UIKit

enum DataError: Error {
    case networkError
    case parsing
    case invalidURI
}

class ApiService: NSObject {
    
    func getData(completion: @escaping(Result<NasaData, DataError>) -> Void) {
        // The URI can be accepted from ViewModel if API has to be written more generic.
        // Same goes for API response parsing and model class array generation.
        let urlString = constant.apiUrl

        guard let dataURI = URL(string: urlString) else {
            completion(.failure(.invalidURI))
            return
        }

        let dataTask = URLSession.shared.dataTask(with: dataURI, completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil, response != nil else {
                completion(.failure(.networkError))
                return
            }

            do {
                // Decode the json data.
                let decoder = JSONDecoder()
                let response = try decoder.decode(NasaData.self, from: data)
                completion(.success(response))
            } catch {
                print(error)
                completion(.failure(.parsing))
            }
        })

        dataTask.resume()
    }
    
}
