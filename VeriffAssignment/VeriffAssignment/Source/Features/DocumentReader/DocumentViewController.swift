//
//  DocumentViewController.swift
//  VeriffAssignment
//
//  Created by psagc on 30/03/22.
//

import UIKit

class DocumentViewController: UIViewController {

    @IBOutlet private var imageView: UIImageView!
    
    var viewModel: DocumentViewModelType
    var image: UIImage?
    
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
        guard let image = imageView.image else { return  }
        viewModel.makeRequest(image: image)
    }
    
}
