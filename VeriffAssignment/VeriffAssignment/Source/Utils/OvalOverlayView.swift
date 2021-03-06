//
//  OvalOverlayView.swift
//  VeriffAssignment
//
//  Created by psagc on 31/03/22.
//

import UIKit

internal class OvalOverlayView: UIView {

    let screenBounds = UIScreen.main.bounds
    var overlayFrame: CGRect!

    let bgColor: UIColor
    internal init(bgColor: UIColor) {
        self.bgColor = bgColor
        super.init(frame: screenBounds)
        backgroundColor = UIColor.clear
        accessibilityIdentifier = "takeASelfieOvalOverlayView"
        overlayFrame = CGRect(x: (screenBounds.width - 320.0) / 2,
                              y: (screenBounds.height - 500.0) / 2,
                              width: 300.0,
                              height: 450.0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let overlayPath = UIBezierPath(rect: bounds)
        let ovalPath = UIBezierPath(ovalIn: overlayFrame)
        overlayPath.append(ovalPath)
        overlayPath.usesEvenOddFillRule = true
        // draw oval layer
        let ovalLayer = CAShapeLayer()
        ovalLayer.path = ovalPath.cgPath
        ovalLayer.fillColor = UIColor.clear.cgColor
        ovalLayer.strokeColor = UIColor.white.cgColor
        ovalLayer.lineWidth = 1.0
        // draw layer that fills the view
        let fillLayer = CAShapeLayer()
        fillLayer.path = overlayPath.cgPath
        fillLayer.fillRule = CAShapeLayerFillRule.evenOdd
        fillLayer.fillColor = bgColor.cgColor
        // add layers
        layer.addSublayer(fillLayer)
        layer.addSublayer(ovalLayer)
    }

}
