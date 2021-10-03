//
//  NasaData.swift
//  NASA Picture of The Day
//
//  Created by Krishna Gunjal on 02/10/21.
//

import Foundation

class NasaData: Decodable {
    let copyright: String?
    let date: String?
    let explanation: String?
    let title: String?
    let url: String?
    
    init() {
            copyright = nil
        date = nil
        explanation = nil
        title = nil
        url = nil
        }
}
