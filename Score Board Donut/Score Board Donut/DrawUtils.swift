//
//  DrawUtils.swift
//  Score Board Donut
//
//  Created by Li Ju on 2018-08-21.
//  Copyright © 2018 Li Ju. All rights reserved.
//

import UIKit

enum ColorPool : String {
    case White = "FFFFFF"
    case LightGrey = "F0F0F0"
    case Red = "FF6D68"
    case Yellow = "FFC843"
    case Blue = "5E96DC"
    case Green = "009638"
    
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
