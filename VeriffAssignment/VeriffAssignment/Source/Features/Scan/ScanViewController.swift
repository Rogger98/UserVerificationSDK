//
//  ScanViewController.swift
//  VeriffAssignment
//
//  Created by psagc on 30/03/22.
//

import UIKit
import CoreLocation
import AVKit

/// takes the responsblity for capturing document part 
class ScanViewController: UIViewController {
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var labelDescription: UILabel!
    
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    private let ovalOverlayView = OvalOverlayView(bgColor: UIColor.black.withAlphaComponent(0.3))
    
    var didVerifiedWithText: ((_ document: DocumentDetails) -> Void)?
    var errorVerifingDocument: ((_ document: DocumentDetails?, _ error: DocumentVerifyError) -> Void)?
    
    var documentType: VFDocumentType
    
    
    init(_ documentType: VFDocumentType) {
        self.documentType = documentType
        super.init(nibName: ScanViewController.className, bundle: Bundle.shared)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation()
    }
    
    private func setupNavigation() {
        navigationController?.isNavigationBarHidden = true
        captureButton.layer.cornerRadius = captureButton.frame.size.width / 2
        captureButton.clipsToBounds = true
    }
    private func setupUI() {
        
        labelDescription.text = documentType.frontDescription
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter
        let position: AVCaptureDevice.Position = documentType == .selfie ? AVCaptureDevice.Position.front : AVCaptureDevice.Position.back
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position) else {
            fatalError("No video device found")
        }
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous deivce object
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object
            captureSession = AVCaptureSession()
            
            // Set the input devcie on the capture session
            captureSession?.addInput(input)
            
            // Get an instance of ACCapturePhotoOutput class
            capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput?.isHighResolutionCaptureEnabled = true
            
            captureSession?.sessionPreset = .photo
            
            
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureSession?.addOutput(capturePhotoOutput!)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the input device
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            
            //Initialise the video preview layer and add it as a sublayer to the viewPreview view's layer
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            
            previewView.layer.addSublayer(videoPreviewLayer!)
            
            //start video capture
            captureSession?.startRunning()
            
            
        } catch {
            //If any error occurs, simply print it out
            print(error)
            return
        }
        setupOverlay()
    }
    private func setupOverlay() {
        let camPreviewBounds = view.bounds
        let cropRect = CGRect(
            x: 10,
            y: 100,
            width: previewView.bounds.width - 20,
            height: 250
        )
        
        let path = UIBezierPath(roundedRect: camPreviewBounds, cornerRadius: 0)
        path.append(UIBezierPath(rect: cropRect))
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillRule = CAShapeLayerFillRule.evenOdd;
        layer.fillColor = UIColor.black.cgColor
        layer.opacity = 0.5;
        
        previewView.layer.addSublayer(layer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapTakePhoto(_ sender: Any) {
        // Make sure capturePhotoOutput is valid
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        
        // Get an instance of AVCapturePhotoSettings class
        let photoSettings = AVCapturePhotoSettings()
        
        // Set photo settings for our need        
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .auto
        // Call capturePhoto method by passing our photo settings and a delegate implementing AVCapturePhotoCaptureDelegate
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    private func moveToPreview(image: UIImage) {
        let documentController: DocumentViewController = DocumentViewController(documentType: documentType,image: image)
        documentController.didVerifiedWithText = didVerifiedWithText
        documentController.errorVerifingDocument = errorVerifingDocument
        self.navigationController?.pushViewController(documentController, animated: true)
    }
    
    private func cropToPreviewLayer(from originalImage: UIImage, toSizeOf rect: CGRect) -> UIImage? {
        guard let cgImage = originalImage.cgImage else { return nil }
        
        // This previewLayer is the AVCaptureVideoPreviewLayer which the resizeAspectFill and videoOrientation portrait has been set.
        guard let outputRect = videoPreviewLayer?.metadataOutputRectConverted(fromLayerRect: rect) else { return nil }
        
        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)
        
        let cropRect = CGRect(x: (outputRect.origin.x * width), y: (outputRect.origin.y * height), width: (outputRect.size.width * width), height: (outputRect.size.height * height))
        
        if let croppedCGImage = cgImage.cropping(to: cropRect) {
            return UIImage(cgImage: croppedCGImage, scale: 1.0, orientation: originalImage.imageOrientation)
        }
        
        return nil
    }
}

extension ScanViewController : AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard error == nil else {
            print("Fail to capture photo: \(String(describing: error))")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else {
            print("Fail to convert pixel buffer")
            return
        }
        
        
        guard let capturedImage = UIImage.init(data: imageData , scale: 1.0) else {
            print("Fail to convert image data to UIImage")
            return
        }
        
        let width = capturedImage.size.width
        let height = capturedImage.size.height
        let origin = CGPoint(x: (width - height)/2, y: (height - height)/2)
        let size = CGSize(width: height, height: height)
        guard let imageRef = capturedImage.cgImage?.cropping(to: CGRect(origin: origin, size: size)) else {
            print("Fail to crop image")
            return
        }
        
        
        let imageToSave = UIImage(cgImage: imageRef, scale: 1.0, orientation: .right)
        
        
        let rect = CGRect(x: (width - height)/2, y: 100, width: (width / 2), height: 350)
        if let croppedImage = self.cropToPreviewLayer(from: imageToSave, toSizeOf: rect) {
            moveToPreview(image: croppedImage)
            
        }
    }
}



extension UIInterfaceOrientation {
    var videoOrientation: AVCaptureVideoOrientation? {
        switch self {
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeRight: return .landscapeRight
        case .landscapeLeft: return .landscapeLeft
        case .portrait: return .portrait
        default: return nil
        }
    }
}


extension AVCaptureVideoPreviewLayer {
    func rectOfInterestConverted(parentRect: CGRect, fromLayerRect: CGRect) -> CGRect {
        let parentWidth = parentRect.width
        let parentHeight = parentRect.height
        let newX = (parentWidth - fromLayerRect.maxX)/parentWidth
        let newY = 1 - (parentHeight - fromLayerRect.minY)/parentHeight
        let width = 1 - (fromLayerRect.minX/parentWidth + newX)
        let height = (fromLayerRect.maxY/parentHeight) - newY
        
        return CGRect(x: newX, y: newY, width: width, height: height)
    }
}
