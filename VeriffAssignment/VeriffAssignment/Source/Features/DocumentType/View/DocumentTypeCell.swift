//
//  DocumentTypeCell.swift
//  VeriffAssignment
//
//  Created by psagc on 31/03/22.
//

import UIKit


class DocumentTypeCell: UITableViewCell {

    @IBOutlet private weak var imageViewDocument: UIImageView?
    @IBOutlet private weak var labelDocumentName: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var document: VFDocumentType? {
        didSet {
            labelDocumentName?.text = document?.documentName
            imageViewDocument?.image = document?.documentIcon
        }
    }
    
}
