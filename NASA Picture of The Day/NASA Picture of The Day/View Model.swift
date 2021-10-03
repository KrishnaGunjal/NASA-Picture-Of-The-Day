//
//  View Model.swift
//  NASA Picture of The Day
//
//  Created by Krishna Gunjal on 02/10/21.
//

import Foundation
import UIKit

protocol DataViewModelDelegate {
    func dataRefreshSuccess()
    func dataFetchError(error: DataError)
}

class ViewModel: NSObject {
    
    private var apiServices: ApiService!
    var dataViewModelDelegate: DataViewModelDelegate?
    var albumData = NasaData()
    
    private var persistantDataList = NasaData() {
        didSet {
            setData()
        }
    }
    
    fileprivate func setData() {
        self.albumData = persistantDataList
        self.dataViewModelDelegate?.dataRefreshSuccess()
    }
    
    public func getDataList() -> Void {
       ApiService().getData { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                self.dataViewModelDelegate?.dataFetchError(error: error)
                
            case .success(let dataList):
                self.persistantDataList = dataList
                self.dataViewModelDelegate?.dataRefreshSuccess()
            }
        }
    }
}
