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
    func makeRequest(image: UIImage, complition: @escaping(_ face: FacesOnDocument) -> Void) 
    func setUpRequest()
    func setUpFacedetection(image: UIImage, completion: @escaping(_ face: FacesOnDocument) -> Void)
    var recognizedText: String { get set }
}

final class DocumentReaderViewModel : DocumentViewModelType {
    
    
    var isMultipleFaces: FacesOnDocument = .none
    private var textRecognitionRequest:VNRecognizeTextRequest?
    private var faceDetection: VNDetectFaceRectanglesRequest?
    
    var recognizedText = ""
    
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

