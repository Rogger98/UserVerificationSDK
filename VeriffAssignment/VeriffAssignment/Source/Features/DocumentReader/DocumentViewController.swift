//
//  DocumentViewController.swift
//  VeriffAssignment
//
//  Created by psagc on 30/03/22.
//

import UIKit

public struct DocumentDetails {
    public var data : String?
    public var isPhoteIdentity: Bool?
}

public enum DocumentVerifyError {
    case noPhotoIdentity
    case noDocumentDetails
}

class DocumentViewController: UIViewController {

    @IBOutlet private var imageView: UIImageView?
    @IBOutlet private var labelDescription: UILabel?
    @IBOutlet private var buttonFine: UIButton?
    @IBOutlet private var buttonRetake: UIButton?
    
    var viewModel: DocumentReaderViewModelType
    var image: UIImage?
    var didVerifiedWithText: ((_ document: DocumentDetails) -> Void)?
    var errorVerifingDocument: ((_ document: DocumentDetails?, _ error: DocumentVerifyError) -> Void)?
    let documentType: VFDocumentType
    
    init(viewModel: DocumentReaderViewModelType, documentType: VFDocumentType) {
        self.viewModel = viewModel
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
        setUpBindings()
    }
    
    private func setupUI() {
        imageView?.image = image
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.backItem?.title = ""
        title = documentType.documentName
        if documentType != .selfie {
            labelDescription?.text = "Make sure your \(documentType.shortName) is visable to read, with no blur or glare."
        } else {
            labelDescription?.isHidden = true
        }
        buttonFine?.setTitle("My \(documentType.shortName) is Visable.", for: .normal)
        buttonRetake?.setTitle("Take back side", for: .normal)
    }
    private func setUpBindings() {
        viewModel.setUpRequest()
        
    }
    
    // MARK: - Action Methods
    @IBAction private func didTapOnRequest() {
        showLoader(title: StringConstants.Common.verifying.localized)
        
        
        guard let image = imageView?.image else { return  }
        
        if documentType == .selfie {
            viewModel.setUpFacedetection(image: image) { (face) in
                
                self.hideLoader()
                
                if face == .single {
                    
                } else if face == .moreThanOne{
                    
                } else {
                    
                }
            }
        } else {
            viewModel.makeRequest(image: image) { (face) in
                self.hideLoader()
                let noOfFace: Bool = face == .single ? true : false
                let model = DocumentDetails(data: self.viewModel.recognizedText, isPhoteIdentity: noOfFace)
                
                if face == .single && !self.viewModel.recognizedText.isEmpty{
                    self.didVerifiedWithText?(model)
                    self.moveToSelfie()
                } else if self.viewModel.recognizedText.isEmpty {
                    self.errorVerifingDocument?(model,.noDocumentDetails)
                } else if face == .moreThanOne || face == .none {
                    self.errorVerifingDocument?(model,.noPhotoIdentity)
                }
            }
        }
       
    }
    
    private func moveToSelfie() {
        let scanController: ScanViewController = ScanViewController(.selfie)
        navigationController?.pushViewController(scanController, animated: true)
    }
    
}
