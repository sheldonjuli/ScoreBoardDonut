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
    
    private struct Constants {
        static let StrikeProportion: CGFloat = 0.2
    }
    
    @IBInspectable
    var numPlayer: Int = 4 { didSet { setNeedsDisplay() } }

    let colorOps = [ColorPool.Red, .Yellow, .Blue, .Green, .Yellow]

    override func draw(_ rect: CGRect) {
        
        drawBySections(rect: rect)

    }
    
    private func drawBySections(rect: CGRect) {

        for section in 0...(numPlayer - 1) {
            drawOuterSection(rect: rect, section: section)
            drawScores(rect: rect, section: section)
            //drawOperators(rect: rect, section: section)
        }
        
        drawPause(rect: rect)

    }
    
    func drawPause(rect: CGRect) {
        let circlePath = UIBezierPath(arcCenter: rect.center, radius: 0.5 * CGFloat(rect.maxX - rect.midX), startAngle: CGFloat(0), endAngle: .pi, clockwise: true)
        circlePath.addClip()
        UIColor(hex: ColorPool.LightGrey.rawValue).setFill()
        circlePath.fill()
    }
    
    func drawOuterSection(rect: CGRect, section: Int) {

        let radius: CGFloat = 0.5 * max(rect.width, rect.height)
        let startAngle = .pi * CGFloat(0.5 + (-1 + 2 * CGFloat(section)) / CGFloat(numPlayer))
        let endAngle = .pi * CGFloat(0.5 + (1 + 2 * CGFloat(section)) / CGFloat(numPlayer))
        UIColor(hex: colorOps[section].rawValue).setStroke()
        
        let outerPath = UIBezierPath(arcCenter: rect.center, radius: 0.75 * radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        outerPath.lineWidth = 0.5 * radius
        outerPath.stroke()

    }
    
    func drawScores(rect: CGRect, section: Int) {

        let radius: CGFloat = 0.375 * max(rect.width, rect.height)
        let angle = .pi * CGFloat(0.5 + (2 * CGFloat(section)) / CGFloat(numPlayer))
        let (x, y) = findCoordinatesOnArcWith(angle: angle, radius: radius)
        let score = createAttributedStringForScore(section, fontSize: CGFloat(30))
        score.draw(in: CGRect(x: x - 40, y: y - 20, width: 80, height: 40))

    }
    
    func drawOperators(rect: CGRect, section: Int) {
        let radius: CGFloat = 0.5 * max(rect.width, rect.height)
        let startAngle = .pi * CGFloat(0.5 + (-1 + 2 * CGFloat(section)) / CGFloat(numPlayer))
        let endAngle = .pi * CGFloat(0.5 + (1 + 2 * CGFloat(section)) / CGFloat(numPlayer))
        let (startX, startY) = findCoordinatesOnArcWith(angle: startAngle, radius: radius)
        let (endX, endY) = findCoordinatesOnArcWith(angle: endAngle, radius: radius)
        
        let distance = findDistanceBetween(pointA: CGPoint(x: startX, y: startY), pointB: CGPoint(x: endX, y: endY))

        let strikeLen = distance * Constants.StrikeProportion

        let plusStrikeStart = CGPoint(x: (startX - endX) / Constants.StrikeProportion, y: (startY - endY) / Constants.StrikeProportion)
        let plusStrikeEnd = CGPoint(x: plusStrikeStart.x + strikeLen, y: plusStrikeStart.y + startY)

        let plusPath = UIBezierPath()
        plusPath.lineWidth = 5
        plusPath.move(to: CGPoint(x: startX, y: startY))
        plusPath.addLine(to: CGPoint(x: endX, y: endY))
        UIColor.gray.setStroke()
        plusPath.stroke()

    }
    
    private func findCoordinatesOnArcWith(angle: CGFloat, radius: CGFloat) -> (CGFloat, CGFloat) {
        let x = radius * cos(angle) + bounds.midX
        let y = radius * sin(angle) + bounds.midY
        return (x, y)
    }
    
    private func findDistanceBetween(pointA: CGPoint, pointB: CGPoint) -> CGFloat {
        let xDist = pointA.x - pointB.x
        let yDist = pointA.y - pointB.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
    
    private func createAttributedStringForScore(_ score: Int, fontSize: CGFloat) ->NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: "\(score)", attributes:[.paragraphStyle: paragraphStyle, .font: font])
    }
}

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
