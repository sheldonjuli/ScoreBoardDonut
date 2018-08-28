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
    case Green = "4FBA6F"
    
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

func findDistanceBetween(pointA: CGPoint, pointB: CGPoint) -> CGFloat {
    let xDist = pointA.x - pointB.x
    let yDist = pointA.y - pointB.y
    return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
}

func findCoordinatesOnArcWith(bounds: CGRect, angle: CGFloat, radius: CGFloat) -> (CGFloat, CGFloat) {
    let x = radius * cos(angle) + bounds.midX
    let y = radius * sin(angle) + bounds.midY
    return (x, y)
}

func findLongerSideLen(rect: CGRect) -> CGFloat {
    return max(rect.width, rect.height)
}

func findDegreeOffsetBetween(pointA: CGPoint, pointB: CGPoint) -> CGFloat {
    let degreeOffset = atan2(pointA.y - pointB.y, pointA.x - pointB.x)
    return degreeOffset > 0 ? degreeOffset : degreeOffset + 2 * CGFloat.pi
}

func findSectionWidth(numPlayer: Int) -> CGFloat {
    return 2 * CGFloat.pi / CGFloat(numPlayer)
}

func findStartAngle(numPlayer: Int, section: Int) -> CGFloat {
    return .pi * CGFloat(0.5 + (-1 + 2 * CGFloat(section)) / CGFloat(numPlayer))
}

func findEndAngle(numPlayer: Int, section: Int) -> CGFloat {
    return .pi * CGFloat(0.5 + (1 + 2 * CGFloat(section)) / CGFloat(numPlayer))
}
