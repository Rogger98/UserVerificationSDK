//
//  DocumentTypesViewController.swift
//  VeriffAssignment
//
//  Created by psagc on 31/03/22.
//

import UIKit

class DocumentTypesViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var tableView: UITableView?
    
    let viewModel: DocumentTypesViewModelType
    var arrayDocuments: [VFDocumentType] = []
    init(viewModel: DocumentTypesViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: DocumentTypesViewController.className, bundle: Bundle.shared)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    func setupUI() {
        let docs = VFDocumentType.allCases.filter({$0 != .selfie})
        arrayDocuments.append(contentsOf: docs)
        title = StringConstants.DocumentTypesScreen.title.localized
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }

}
extension DocumentTypesViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayDocuments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.getCell(DocumentTypeCell.self) else { return UITableViewCell() }
        cell.document = VFDocumentType.allCases[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectedDocument(arrayDocuments[indexPath.row])
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let scanController = ScanViewController(VFDocumentType.allCases[indexPath.row])
            navigationController?.pushViewController(scanController, animated: true)
        } else {
            showAlert(title: StringConstants.AlertTitle.noCamera.localized, message: StringConstants.AlertMessages.cameraNotAvailable.localized)
        }
        
    }
}
