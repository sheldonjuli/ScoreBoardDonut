//
//  DonutView.swift
//  Score Board Donut
//
//  Created by Li Ju on 2018-08-11.
//  Copyright © 2018 Li Ju. All rights reserved.
//

import UIKit

@IBDesignable
class DonutView: UIView {
    
    @IBInspectable var numPlayer: Int = 4

    override func draw(_ rect: CGRect) {
        drawOuterSection(rect: rect, section: 0, color: ColorPool.Red.rawValue)
        drawOuterSection(rect: rect, section: 1, color: ColorPool.Yellow.rawValue)
        drawOuterSection(rect: rect, section: 2, color: ColorPool.Blue.rawValue)
        drawOuterSection(rect: rect, section: 3, color: ColorPool.Green.rawValue)
    }
    
    func drawOuterSection(rect: CGRect, section: Int, color: String) {

        let startAngle = CGFloat(.pi * (0.25 + 0.5 * Double(section)))
        let endAngle = CGFloat(.pi * (0.75 + 0.5 * Double(section)))
        let radius: CGFloat = 0.5 * max(bounds.width, bounds.height)
        UIColor(hex: color).setStroke()

        let outerPath = UIBezierPath(arcCenter: rect.center, radius: 0.75 * radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        outerPath.lineWidth = 0.5 * radius
        outerPath.stroke()

    }
}

enum ColorPool : String {
    case White = "FFFFFF"
    case LightGrey = "F0F0F0"
    case Red = "FF0000"
    case Yellow = "FFFF00"
    case Blue = "0000FF"
    case Green = "008000"
    
}

extension CGRect {
    var center: CGPoint { return CGPoint(x: midX, y: midY) }
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
