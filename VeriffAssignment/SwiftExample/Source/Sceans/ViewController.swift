//
//  ViewController.swift
//  SwiftExample
//
//  Created by psagc on 30/03/22.
//

import UIKit
import VeriffAssignment


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func didTapOnScan() {
        VFDocumentReader.shared.scanNewDocument(from: self)
    }
    
    @IBAction func didTapOnManually() {
        
    }
}

