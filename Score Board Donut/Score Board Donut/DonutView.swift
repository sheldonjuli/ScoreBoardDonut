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
    
    @IBInspectable
    var numPlayer: Int = 4 { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    var scores: [Int] = [Int]() { didSet { setNeedsDisplay(); setNeedsLayout() } }

    private lazy var scoreLabels: [UILabel] = createScoreLabels(numPlayer: numPlayer)
    
    private func createScoreLabels(numPlayer: Int) -> [UILabel] {
        var scoreLabels: [UILabel] = []
        for _ in 0...numPlayer {
            let newLabel = UILabel()
            scoreLabels.append(newLabel)
            addSubview(newLabel)
        }
        return scoreLabels
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for section in 0...numPlayer - 1 {
            configureScoreLabel(scoreLabels[section], section: section, score: scores[section])
        }
    }

    let colorOps = [ColorPool.Red, .Yellow, .Blue, .Green]

    override func draw(_ rect: CGRect) {
        
        drawBySections(rect: rect)

    }
    
    private func drawBySections(rect: CGRect) {

        for section in 0...(numPlayer - 1) {
            drawOuterSection(rect: rect, section: section)
            //drawOperators(rect: rect, section: section)
        }
    }

    func drawOuterSection(rect: CGRect, section: Int) {

        let radius: CGFloat = 0.5 * findLongerSideLen(rect: rect)
        let startAngle = findStartAngle(numPlayer: numPlayer, section: section)
        let endAngle = findEndAngle(numPlayer: numPlayer, section: section)
        UIColor(hex: colorOps[section].rawValue).setStroke()
        
        let outerPath = UIBezierPath(arcCenter: rect.center, radius: 0.75 * radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        outerPath.lineWidth = 0.5 * radius
        outerPath.stroke()

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
    
    private func createAttributedStringForScore(_ score: Int) ->NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(scoreFontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: "\(score)", attributes:[.paragraphStyle: paragraphStyle, .font: font])
    }
    
    private func configureScoreLabel(_ label: UILabel, section: Int, score: Int) {
        label.attributedText = createAttributedStringForScore(score)
        label.backgroundColor = UIColor(hex: colorOps[0].rawValue)
        let radius: CGFloat = 0.375 * max(bounds.width, bounds.height)
        let angle = .pi * CGFloat(0.5 + (2 * CGFloat(section)) / CGFloat(numPlayer))
        let (x, y) = findCoordinatesOnArcWith(angle: angle, radius: radius)
        let h = Constants.scoreLabelHeightToArcRadiusRatio * radius
        let w = Constants.scoreLabelWidthToHeightRatio * h
        label.frame = CGRect(x: x - w / 2, y: y - h / 2, width: w, height: h)
    }
}

extension DonutView {
    private struct Constants {
        static let StrikeProportion: CGFloat = 0.2
        static let scoreFontSizeToBoundsSizeRatio: CGFloat = 0.06
        static let scoreLabelHeightToArcRadiusRatio: CGFloat = 0.25
        static let scoreLabelWidthToHeightRatio: CGFloat = 2
    }
    
    private var scoreFontSize: CGFloat {
        return bounds.size.height * Constants.scoreFontSizeToBoundsSizeRatio
    }
}
