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

    @IBOutlet private var imageView: UIImageView!
    
    var viewModel: DocumentViewModelType
    var image: UIImage?
    var didVerifiedWithText: ((_ document: DocumentDetails) -> Void)?
    var errorVerifingDocument: ((_ document: DocumentDetails?, _ error: DocumentVerifyError) -> Void)?
    
    init(viewModel: DocumentViewModelType) {
        self.viewModel = viewModel
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
        imageView.image = image
    }
    private func setUpBindings() {
        viewModel.setUpRequest()
        
    }
    
    // MARK: - Action Methods
    @IBAction private func didTapOnRequest() {
        showLoader(title: StringConstants.Common.verifying.localized)
        
        guard let image = imageView.image else { return  }
        viewModel.makeRequest(image: image) { (face) in
            self.hideLoader()
            let noOfFace: Bool = face == .single ? true : false
            let model = DocumentDetails(data: self.viewModel.recognizedText, isPhoteIdentity: noOfFace)
            
            if face == .single && !self.viewModel.recognizedText.isEmpty{
                self.didVerifiedWithText?(model)
            } else if self.viewModel.recognizedText.isEmpty {
                self.errorVerifingDocument?(model,.noDocumentDetails)
            } else if face == .moreThanOne || face == .none {
                self.errorVerifingDocument?(model,.noPhotoIdentity)
            }
        }
    }
    
}
