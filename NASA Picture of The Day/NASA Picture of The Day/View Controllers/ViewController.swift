//
//  ViewController.swift
//  NASA Picture of The Day
//
//  Created by Krishna Gunjal on 02/10/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var topicTitle: UILabel!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var credits: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pictureDescription: UILabel!
    
    let viewModel = ViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.dataViewModelDelegate = self
        viewModel.getDataList()
        
    }
    
    private func setUI(){
        let data = viewModel.albumData
        
        self.topicTitle.text = data.title ?? constant.unknown
        self.picture.loadImage(url: data.url ?? constant.unknown, placeholder: UIImage(named: constant.placeholderImage))
        self.credits.text = data.copyright ?? ""
        self.dateLabel.text = data.date ?? date.getCurrentDate()
        self.pictureDescription.text = data.explanation ?? constant.unknown
    }
    
    @IBAction func shareButton(_ sender: Any) {
        do {
            let imgData = try NSData(contentsOf: URL.init(string: viewModel.albumData.url!)!, options: NSData.ReadingOptions())
            let image = UIImage(data: imgData as Data)
            let imageToShare = [ image! ]
            
            let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
            
            self.present(activityViewController, animated: true, completion: nil)
            
        } catch {
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "Error!", message: "Something went wrong", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}



extension ViewController: DataViewModelDelegate {
    func dataFetchError(error: DataError) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error!", message: "Something went wrong", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func dataRefreshSuccess() {
        DispatchQueue.main.async {
            self.setUI()
            self.reloadInputViews()
        }
    }
}

