//
//  ScanViewController.swift
//  VeriffAssignment
//
//  Created by psagc on 30/03/22.
//

import UIKit
import CoreLocation

class ScanViewController: UIViewController {
    // MARK: - Constants
    
    let cameraManager = VFCameraManager()
    
    // MARK: - @IBOutlets
    
    
    @IBOutlet var flashModeImageView: UIImageView!
    @IBOutlet var outputImageView: UIImageView!
    @IBOutlet var cameraTypeImageView: UIImageView!
    
    
    @IBOutlet var cameraView: UIView!
    
    
    
    @IBOutlet var cameraButton: UIButton!
    
    
    let darkBlue = UIColor(red: 4 / 255, green: 14 / 255, blue: 26 / 255, alpha: 1)
    let lightBlue = UIColor(red: 24 / 255, green: 125 / 255, blue: 251 / 255, alpha: 1)
    let redColor = UIColor(red: 229 / 255, green: 77 / 255, blue: 67 / 255, alpha: 1)
    
    // MARK: - UIViewController
    init(settings: Int) {
        super.init(nibName: ScanViewController.className, bundle: Bundle.shared)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCameraManager()
        
        navigationController?.navigationBar.isHidden = true
        
        
        
        
        
        
        let currentCameraState = cameraManager.currentCameraStatus()
        
        if currentCameraState == .notDetermined {
            
        } else if currentCameraState == .ready {
            addCameraToView()
        } else {
            
        }
        
        
        
//        flashModeImageView.image = UIImage(named: "flash_off")
//        if cameraManager.hasFlash {
//            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeFlashMode))
//            flashModeImageView.addGestureRecognizer(tapGesture)
//        }
//
//
//
//        cameraTypeImageView.image = UIImage(named: "switch_camera")
//        let cameraTypeGesture = UITapGestureRecognizer(target: self, action: #selector(changeCameraDevice))
//        cameraTypeImageView.addGestureRecognizer(cameraTypeGesture)
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addCameraToView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        cameraManager.resumeCaptureSession()
        cameraManager.startQRCodeDetection { result in
            switch result {
                case .success(let value):
                    print(value)
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraManager.stopQRCodeDetection()
        cameraManager.stopCaptureSession()
    }
    
    // MARK: - ViewController
    fileprivate func setupCameraManager() {
        cameraManager.shouldEnableExposure = true
        cameraManager.cameraOutputQuality = .high
        cameraManager.writeFilesToPhoneLibrary = false
        cameraManager.cameraOutputMode = .stillImage
        cameraManager.shouldFlipFrontCameraImage = false
        cameraManager.showAccessPermissionPopupAutomatically = false
    }
    
    
    fileprivate func addCameraToView() {
        cameraManager.addPreviewLayerToView(cameraView, newCameraOutputMode: CameraOutputMode.stillImage)
        cameraManager.showErrorBlock = { [weak self] (erTitle: String, erMessage: String) -> Void in
            
            let alertController = UIAlertController(title: erTitle, message: erMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (_) -> Void in }))
            
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - @IBActions
    
    @IBAction func changeFlashMode(_ sender: UIButton) {
        switch cameraManager.changeFlashMode() {
            case .off:
                flashModeImageView.image = UIImage(named: "flash_off")
            case .on:
                flashModeImageView.image = UIImage(named: "flash_on")
            case .auto:
                flashModeImageView.image = UIImage(named: "flash_auto")
        }
    }
    
    @IBAction func didTappedCapture(_ sender: UIButton) {
        cameraManager.capturePictureWithCompletion { result in
            switch result {
                case .failure:
                    self.cameraManager.showErrorBlock("Error occurred", "Cannot save picture.")
                case .success(let content):
                    print("Display Image");
                    let viewModel = DocumentReaderViewModel()
                    let docViewController = DocumentViewController(viewModel: viewModel)
                    docViewController.image = content.asImage
                    self.navigationController?.pushViewController(docViewController, animated: true)
            }
        }
    }
    
    
   
    
    @IBAction func changeCameraDevice() {
        cameraManager.cameraDevice = cameraManager.cameraDevice == CameraDevice.front ? CameraDevice.back : CameraDevice.front
    }
    
    @IBAction func askForCameraPermissions() {
        cameraManager.askUserForCameraPermission { permissionGranted in
            
            if permissionGranted {
                self.addCameraToView()
            } else {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }
   
}

public extension Data {
    func printExifData() {
        let cfdata: CFData = self as CFData
        let imageSourceRef = CGImageSourceCreateWithData(cfdata, nil)
        let imageProperties = CGImageSourceCopyMetadataAtIndex(imageSourceRef!, 0, nil)!
        
        let mutableMetadata = CGImageMetadataCreateMutableCopy(imageProperties)!
        
        CGImageMetadataEnumerateTagsUsingBlock(mutableMetadata, nil, nil) { _, tag in
            print(CGImageMetadataTagCopyName(tag)!, ":", CGImageMetadataTagCopyValue(tag)!)
            return true
        }
    }
}
