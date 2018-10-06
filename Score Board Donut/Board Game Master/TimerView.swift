//
//  TimerView.swift
//  Board Game Master
//
//  Created by Li Ju on 2018-08-17.
//  Copyright © 2018 Li Ju. All rights reserved.
//

import UIKit

@IBDesignable
class TimerView: UIView {
    
    override func draw(_ rect: CGRect) {
        drawPause(rect: rect)
    }

    func drawPause(rect: CGRect) {
        let circlePath = UIBezierPath(arcCenter: rect.center, radius: CGFloat(rect.maxX - rect.midX), startAngle: CGFloat(0), endAngle: .pi, clockwise: true)
        circlePath.addClip()
        UIColor(hex: ColorPool.LightGrey.rawValue).setFill()
        circlePath.fill()
    }
}
