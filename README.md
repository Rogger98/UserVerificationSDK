# VeriffAssignment
   VeriffAssignment implements the document verification SDK to verify document at your application 

# Requirements
  * Xcode 12.4 or later 
  * Swift 5.2 or later 

# VeriffAssignmentSDk 
   the sdk is already there in the project you can simple drag and drop into your project or you can add it in you project's pod by pasting sdk in project directory and just give that path in pod file pod install
 
# How to VeriffAssignment
-----------------------------------------------------------------------------
  
  #### How to use? ####
  
  ``` 
import UIKit
import VeriffAssignment


class ViewController: UIViewController {

    @IBOutlet private var imageView: UIImageView?
    @IBOutlet private var labelDocumentDetails: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func didTapOnLaunchSDK() {
        VFDocumentReader.shared.scanNewDocument(from: self) { (details) in
            DispatchQueue.dispatchHelper {
                
                guard let userImageData = details.userImage else { return }
                self.imageView?.image = userImageData
                self.labelDocumentDetails?.text = details.data
            }
        } errorVerifingDocument: { (doc, error) in
            print(error.errorDescription)
        }

    }
    
}
  
  ```
  


Key             | Use 
--------------- | -----------------------------------
details         | details of document ( user selfie , document text, document imageData )
doc             | document details
error           | error raised while doing verification 
