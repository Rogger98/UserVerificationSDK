//
//  SelfieViewController.swift
//  VeriffAssignment
//
//  Created by psagc on 01/04/22.
//

import UIKit
import Vision

/// takes the responsblity for verifiing user face in picture 
class SelfieViewController: UIViewController {

    @IBOutlet private var imageView: UIImageView?
    @IBOutlet private var buttonFine: UIButton?
    
    
    
    let image: UIImage
    var isMultipleFaces: FacesOnDocument = .none
    private var textRecognitionRequest:VNRecognizeTextRequest?
    private var faceDetection: VNDetectFaceRectanglesRequest?
    let documentType: VFDocumentType
    let overlayView: OvalOverlayView = OvalOverlayView(bgColor: .white)
    var didVerifiedWithText:  ((_ document: DocumentDetails) -> Void)?
    var errorVerifingDocument: ((_ document: DocumentDetails?, _ error: DocumentVerifyError) -> Void)?
    var documentDetails: DocumentDetails
    
    init(documentDetails: DocumentDetails,documentType: VFDocumentType,image: UIImage) {
        self.documentDetails = documentDetails
        self.image = image
        self.documentType = documentType
        super.init(nibName: SelfieViewController.className, bundle: Bundle.shared)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }

    private func setupUI() {
        imageView?.image = image        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.backItem?.title = ""
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .compact)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.barTintColor = .white
        title = documentType.documentName
        buttonFine?.setTitle("My \(documentType.shortName) is Visable.", for: .normal)
        imageView?.addSubview(overlayView)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction private func didTapOnFine() {
        guard let image = imageView?.image else { return  }
        
        setUpFacedetection(image: image) { (face) in
            
            if face == .single {
                self.documentDetails.userImage = self.image
                self.didVerifiedWithText?(self.documentDetails)
                SPAlert.present(title: "Verification Success", message: "Thank you your document looks verfied.", preset: .done, haptic: .success,completion: {
                    self.navigationController?.dismiss(animated: true, completion: nil)
                })
            } else if face == .moreThanOne{
                self.errorVerifingDocument?(self.documentDetails,.faceNotRecognize)
                SPAlert.present(title: "Error recognise face", message: "More than one faces on selfie please try again.", preset: .error, haptic: .error)
            } else {
                self.errorVerifingDocument?(self.documentDetails,.faceNotRecognize)
                SPAlert.present(title: "Error recognise face", message: "Face not visable on your selfie can you please take another", preset: .error, haptic: .error)
            }
        }
    }
}
// MARK: - Helper Methods
extension SelfieViewController {
    
    func setUpFacedetection(image: UIImage, completion: @escaping(_ face: FacesOnDocument) -> Void) {
        
        let request = VNDetectFaceRectanglesRequest { (req, err) in
            if let err = err {
                print("Error in Pic", err)
                return
            }
            if req.results?.count ?? 0 > 1 {
                completion(.moreThanOne)
            } else if req.results?.count ?? 0 == 1 {
                completion(.single)
            } else {
                completion(.none)
            }
            
            req.results?.forEach({ (res) in
                guard let faceObservation = res as? VNFaceObservation else {return}
                print(faceObservation.boundingBox)
                
            })
            
        }
        
        guard let cgImage = image.cgImage else { return  }
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([request])
        } catch let reqErr {
            print("Error", reqErr)
        }
                
    }
}
