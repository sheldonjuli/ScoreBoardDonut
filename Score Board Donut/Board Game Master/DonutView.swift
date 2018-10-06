//
//  DonutView.swift
//  Board Game Master
//
//  Created by Li Ju on 2018-08-11.
//  Copyright © 2018 Li Ju. All rights reserved.
//

import UIKit

@IBDesignable
class DonutView: UIView {
    
    //MARK: variables
    @IBInspectable
    var numPlayer: Int = 4 {
        didSet {
            setNeedsDisplay(); setNeedsLayout()
            resetScoreLabels()
        }
    }
    
    var scores: [Int] = [Int]() { didSet { setNeedsDisplay(); setNeedsLayout() } }

    private lazy var scoreLabels: [UILabel] = createScoreLabels(numPlayer: numPlayer)
    
    private var newLabelCreated: Int = 0
    
    var orientation: UIDeviceOrientation = .portrait {
        didSet {
            setNeedsDisplay(); setNeedsLayout()
            resetScoreLabels()
        }
    }
    
    private func resetScoreLabels() {
        // recreate all labels
        scoreLabels.forEach({ $0.removeFromSuperview(); setNeedsLayout() })
        newLabelCreated = 0
        scoreLabels = createScoreLabels(numPlayer: numPlayer)
    }
    
    
    //MARK: System functions
    override func layoutSubviews() {
        super.layoutSubviews()
        for section in 0...numPlayer - 1 {
            configureScoreLabel(scoreLabels[section], section: section, score: scores[section])
        }
    }
    
    override func draw(_ rect: CGRect) {
        drawBySections(rect: rect)
    }
    
    
    //MARK: Draw section functions
    private func drawBySections(rect: CGRect) {
        for section in 0...(numPlayer - 1) {
            drawOuterSection(rect: rect, section: section)
        }
    }

    func drawOuterSection(rect: CGRect, section: Int) {

        let radius: CGFloat = 0.5 * findLongerSideLen(rect: rect)
        let startAngle = findStartAngle(numPlayer: numPlayer, section: section)
        let endAngle = findEndAngle(numPlayer: numPlayer, section: section)
        UIColor(hex: Constants.colorOps[section].rawValue).setStroke()
        
        let outerPath = UIBezierPath(arcCenter: rect.center, radius: 0.75 * radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        outerPath.lineWidth = 0.5 * radius
        outerPath.stroke()

    }
        
    //MARK: Draw label/score functions
    private func createScoreLabels(numPlayer: Int) -> [UILabel] {
        
        // create labels
        var newLabels: [UILabel] = []
        for _ in 0...numPlayer - 1 {
            let newLabel = UILabel()
            newLabels.append(newLabel)
            addSubview(newLabel)
        }
        return newLabels
    }
    
    private func createAttributedStringForScore(_ score: Int) ->NSAttributedString {
        let font = UIFont.preferredFont(forTextStyle: .body).withSize(self.bounds.width * 0.1)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: "\(score)", attributes:[.paragraphStyle: paragraphStyle, .font: font])
    }
    
    private func configureScoreLabel(_ label: UILabel, section: Int, score: Int) {
        
        label.attributedText = createAttributedStringForScore(score)
        
        if newLabelCreated < numPlayer {

            let radius: CGFloat = 0.375 * max(bounds.width, bounds.height)
            let angle = .pi * CGFloat(0.5 + (2 * CGFloat(section)) / CGFloat(numPlayer))
            let (x, y) = findCoordinatesOnArcWith(bounds: bounds, angle: angle, radius: radius)
            let h = Constants.scoreLabelHeightToArcRadiusRatio * radius
            let w = Constants.scoreLabelWidthToHeightRatio * h
            label.frame = CGRect(x: x - w / 2, y: y - h / 2, width: w, height: h)
            label.transform = CGAffineTransform.identity
                .rotated(by: CGFloat(section) * (2 * .pi / CGFloat(numPlayer)) )
            
            newLabelCreated += 1
        }
    }
}

extension DonutView {
    
    private struct Constants {

        static let StrikeProportion: CGFloat = 0.2
        static let scoreFontSizeToBoundsSizeRatio: CGFloat = 0.1
        static let scoreLabelHeightToArcRadiusRatio: CGFloat = 0.25
        static let scoreLabelWidthToHeightRatio: CGFloat = 2
        
        static let colorOps = [ColorPool.Red, .Yellow, .Blue, .Green]
    }
    
    private var scoreFontSize: CGFloat {
        return bounds.size.height * Constants.scoreFontSizeToBoundsSizeRatio
    }
}
