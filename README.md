# VeriffAssignment
   VeriffAssignment implements the document verification SDK to verify document at your application 


<img width="500" alt="Screenshot 2022-03-26 at 11 53 54 AM" src="https://user-images.githubusercontent.com/44162605/161282931-bfc06907-a948-404c-95ec-4366b4daf89b.jpeg">

<img width="500" alt="Screenshot 2022-03-26 at 11 53 54 AM" src="https://user-images.githubusercontent.com/44162605/161282979-f4c33ed6-659e-4527-9cb6-c51cd9ef384a.jpeg">

<img width="500" alt="Screenshot 2022-03-26 at 11 53 54 AM" src="https://user-images.githubusercontent.com/44162605/161283128-1825da97-64ee-4082-bd67-0e1b48e8bc5a.jpeg">


<img width="500" alt="Screenshot 2022-03-26 at 11 53 54 AM" src="https://user-images.githubusercontent.com/44162605/161283174-87b911ab-156e-4341-918b-7adca53923e6.jpeg">

<img width="500" alt="Screenshot 2022-03-26 at 11 53 54 AM" src="https://user-images.githubusercontent.com/44162605/161283217-53533e3f-a9a8-47d3-842b-044698728d41.png">


<img width="500" alt="Screenshot 2022-03-26 at 11 53 54 AM" src="https://user-images.githubusercontent.com/44162605/161283277-32b3a72e-b04e-4c77-9a2f-e99cca80c032.png">


<img width="500" alt="Screenshot 2022-03-26 at 11 53 54 AM" src="https://user-images.githubusercontent.com/44162605/161283314-68619078-a452-4dbb-9ccd-40462e8d1092.jpeg">




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
