//
//  DocumnetViewModel.swift
//  VeriffAssignment
//
//  Created by psagc on 30/03/22.
//

import UIKit
import Vision
enum FacesOnDocument {
    case none
    case single
    case moreThanOne
}

protocol DocumentViewModelType {
    func makeRequest(image: UIImage)
    func setUpRequest()
    func setUpFacedetection(image: UIImage)
    var isMultipleFaces: FacesOnDocument { get set }
}

final class DocumentReaderViewModel : DocumentViewModelType {
    
    
    var isMultipleFaces: FacesOnDocument = .none
    private var textRecognitionRequest:VNRecognizeTextRequest?
    private var faceDetection: VNDetectFaceRectanglesRequest?
    
    var recognizedText = ""
    
    func setUpRequest() {
        
    }
    
    func setUpFacedetection(image: UIImage) {
        
       
                
    }
    func makeRequest(image: UIImage) {
        
    }
}

