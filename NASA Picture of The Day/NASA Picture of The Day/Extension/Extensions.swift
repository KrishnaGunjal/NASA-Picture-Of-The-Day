//
//  Extensions.swift
//  NASA Picture of The Day
//
//  Created by Krishna Gunjal on 03/10/21.
//

import Foundation
import UIKit

extension UIImageView {
    /// Loads image from web asynchronosly and caches it, in case you have to load url
    /// again, it will be loaded from cache if available
    func loadImage(url: String, placeholder: UIImage?, cache: URLCache? = nil) {
        
        guard let imageURI = URL(string: url) else {
            print("Image URI not valid = \(url)")
            return
        }
        
        let cache = cache ?? URLCache.shared
        let request = URLRequest(url: imageURI)
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            self.image = image
        } else {
            self.image = placeholder
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }).resume()
        }
    }
}

struct date {
    static func getCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        let currentDate = formatter.string(from: date)
        return currentDate
    }
}
