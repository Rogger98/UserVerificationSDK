//
//  ViewController.swift
//  SwiftExample
//
//  Created by psagc on 30/03/22.
//

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
                self.imageView?.image = UIImage(named: "test")
                self.labelDocumentDetails?.text = details.data
            }
        } errorVerifingDocument: { (doc, error) in
            print(error.errorDescription)
        }

    }
    
}

