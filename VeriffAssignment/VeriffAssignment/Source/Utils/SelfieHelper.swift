//
//  SelfieHelper.swift
//  VeriffAssignment
//
//  Created by psagc on 31/03/22.
//

import CoreMedia
import UIKit

internal class SelfieHelper {

    class internal func orientation(orientation: UIDeviceOrientation) -> Int {
        switch orientation {
        case .portraitUpsideDown:
            return 8
        case .landscapeLeft:
            return 3
        case .landscapeRight:
            return 1
        case .portrait:
            return 6
        default:
            return 6
        }
    }

    class internal func createFaceImages(sampleBuffer: CMSampleBuffer) -> (CIImage?, UIImage?) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return (nil, nil)
        }
        let faceCIImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        // swiftlint:disable line_length
        guard let faceImage = context.createCGImage(faceCIImage, from: CGRect(x: 0,
                                                                              y: 0,
                                                                              width: CVPixelBufferGetWidth(pixelBuffer),
                                                                              height: CVPixelBufferGetHeight(pixelBuffer))) else {
                                                                                return (nil, nil)
        }
        let faceUIImage = UIImage(cgImage: faceImage,
                                  scale: 0.0,
                                  orientation: UIImage.Orientation.right)
        return (faceCIImage, faceUIImage)
    }

}
