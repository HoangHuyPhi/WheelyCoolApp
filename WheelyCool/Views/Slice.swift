//
//  Slice.swift
//  WheelyCool
//
//  Created by Huy Hoang Phi  on 13/3/2022.
//

import Foundation
import UIKit

class Slice: CAShapeLayer {
    
    let textSlice: String?
    var startAngle: CGFloat
    var endAngle: CGFloat
    
    init(text: String?, centerPoint: CGPoint, start: CGFloat, end: CGFloat, fillColor: CGColor, radius: CGFloat) {
        self.textSlice = text
        self.startAngle = start
        self.endAngle = end
        super.init()
        drawSlice(centerPoint, radius, start, end, fillColor)
        generateSliceLabel(start, end, centerPoint, radius)
    }
    
    private func drawSlice(_ centerPoint: CGPoint, _ radius: CGFloat, _ start: CGFloat, _ end: CGFloat, _ fillColor: CGColor) {
        let arc = UIBezierPath(arcCenter: centerPoint, radius: radius, startAngle: start, endAngle: end, clockwise: true)
        arc.addLine(to: centerPoint)
        arc.close()
        path = arc.cgPath
        strokeColor = UIColor.lightGray.cgColor
        self.fillColor = fillColor
    }

    
    private func generateSliceLabel(_ start: CGFloat,_ end: CGFloat,_ centerPoint: CGPoint,_ radius: CGFloat) {
        if let textSlice = textSlice {
            let label = CATextLayer()
            // calculate center point of slice
            let middleAngle = start - (start - end) / 2
            let arcCenterX = centerPoint.x + cos(middleAngle) * radius
            let arcCenterY = centerPoint.y + sin(middleAngle) * radius
            let labelX = (arcCenterX + centerPoint.x) / 2
            let labelY = (arcCenterY + centerPoint.y) / 2
            //
            let width: CGFloat = radius - 24
            let height: CGFloat = 30
            //
            label.frame = CGRect(x: labelX - width / 2, y: labelY - height / 2, width: width, height: height)
            label.setAffineTransform(CGAffineTransform(rotationAngle: (start + end) / 2))
            label.string = textSlice
            label.fontSize = 20
            label.alignmentMode = .center
            label.foregroundColor = UIColor.black.cgColor
            addSublayer(label)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
