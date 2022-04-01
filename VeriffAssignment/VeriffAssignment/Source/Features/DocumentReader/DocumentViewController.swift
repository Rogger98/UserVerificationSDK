//
//  DocumentViewController.swift
//  VeriffAssignment
//
//  Created by psagc on 30/03/22.
//

import UIKit
import Vision

public struct DocumentDetails {
    public var data : String?
    public var isPhoteIdentity: Bool?
    public var documentImage: Data?
    public var userImage: UIImage?
}



final class DocumentViewController: UIViewController {
    
    @IBOutlet private var imageView: UIImageView?
    @IBOutlet private var labelDescription: UILabel?
    @IBOutlet private var buttonFine: UIButton?
    
    
    
    let image: UIImage
    var isMultipleFaces: FacesOnDocument = .none
    private var textRecognitionRequest:VNRecognizeTextRequest?
    private var faceDetection: VNDetectFaceRectanglesRequest?    
    var recognizedText = ""
    let documentType: VFDocumentType
    var didVerifiedWithText:  ((_ document: DocumentDetails) -> Void)?
    var errorVerifingDocument: ((_ document: DocumentDetails?, _ error: DocumentVerifyError) -> Void)?
    
    init(documentType: VFDocumentType,image: UIImage) {
        self.image = image
        self.documentType = documentType
        super.init(nibName: DocumentViewController.className, bundle: Bundle.shared)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Lyfe cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        setUpRequest()
    }
    
    private func setupUI() {
        setupNavigationbar()
        imageView?.image = image
        title = documentType.documentName
        if documentType != .selfie {
            labelDescription?.text = "Make sure your \(documentType.shortName) is visable to read, with no blur or glare."
        } else {
            labelDescription?.isHidden = true
        }
        buttonFine?.setTitle("My \(documentType.shortName) is Visable.", for: .normal)
    }
    
    private func setupNavigationbar() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.backItem?.title = ""
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .compact)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.barTintColor = .white
    }
    // MARK: - Action Methods
    @IBAction private func didTapOnRequest() {
        showLoader(title: StringConstants.Common.verifying.localized)
        
        
        guard let image = imageView?.image else { return  }
        
        
        makeRequest(image: image) { (face) in
            self.hideLoader()
            let noOfFace: Bool = face == .single ? true : false
            
            
            if face == .single && !self.recognizedText.isEmpty{
                let model = DocumentDetails(data: self.recognizedText, isPhoteIdentity: noOfFace,documentImage: image.pngData(),userImage: nil)
                self.moveToSelfie(documentDetails: model)
            } else if self.recognizedText.isEmpty {
                self.errorVerifingDocument?(nil,.noDocumentDetails)
                SPAlert.present(title: "Invalid document", message: "Invalid document text no readable. can you re-take.", preset: .error, haptic: .error)
            } else if face == .moreThanOne || face == .none {
                self.errorVerifingDocument?(nil,.noPhotoIdentity)
                SPAlert.present(title: "Error recognise face", message: "Face not visable on document. please try again.", preset: .error, haptic: .error)
            }
        }
        
        
    }
    
    private func moveToSelfie(documentDetails: DocumentDetails) {
        let scanController: TakeSelfieViewController = TakeSelfieViewController(documentDetails)
        scanController.didVerifiedWithText = didVerifiedWithText
        scanController.errorVerifingDocument = errorVerifingDocument
        navigationController?.pushViewController(scanController, animated: true)
    }
    
}
extension DocumentViewController {
    func setUpRequest() {
        textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { (request, error) in
            if let results = request.results, !results.isEmpty {
                if let requestResults = request.results as? [VNRecognizedTextObservation] {
                    self.recognizedText = ""
                    for observation in requestResults {
                        guard let candidiate = observation.topCandidates(1).first else { return }
                        self.recognizedText += candidiate.string
                        self.recognizedText += "\n"
                    }
                    print(" \(self.recognizedText)")
                }
                
            }
        })
    }
    
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
    func makeRequest(image: UIImage, complition: @escaping(_ face: FacesOnDocument) -> Void) {
        guard let request = textRecognitionRequest else {
            return
        }
        request.recognitionLevel = .accurate
        let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print("❌❌❌ \(error.localizedDescription) ❌❌❌")
        }
        self.setUpFacedetection(image: image, completion: complition)
    }
}
