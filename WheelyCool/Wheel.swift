//
//  Wheel.swift
//  WheelyCool
//
//  Created by Huy Hoang Phi  on 12/3/2022.
//

import Foundation
import QuartzCore
import UIKit

class Wheel: CAShapeLayer, CAAnimationDelegate {
    
    let totalRadian: CGFloat = 2 * .pi
    var rotateTo: CGFloat?
    
    var slices: [Arc] = []
    
    var onCompletionHandler: ((_ slices: [Arc]) -> Void)?

    init(centerPoint: CGPoint, numOfSlices: [String], radius: CGFloat) {
        super.init()
        generateSlices(numOfSlices, radius, centerPoint)
    }
    
    private func generateSlices(_ numOfSlices: [String],_ radius: CGFloat,_ centerPoint: CGPoint) {
        //  0 <= angle for each slice <= 2 * pi,
        let eachSliceRadian = totalRadian / CGFloat(numOfSlices.count)
        var start: CGFloat = 0
        let sliceColors: [UIColor] = [.yellow, .green, .cyan, .systemGray6]
        for (index, option) in numOfSlices.enumerated() {
            let arc1 = Arc(text: option, centerPoint: centerPoint, start: start, end: start + eachSliceRadian, fillColor: sliceColors[index % 4].cgColor, radius: radius)
            arc1.frame = self.bounds
            slices.append(arc1)
            start += eachSliceRadian
        }
        
        for arc in slices {
            addSublayer(arc)
        }
    }
    
    func rotateWheel(toValue: CGFloat, duration: CGFloat, onCompletion: @escaping (_ slices: [Arc]) -> Void ) {
        // Creating animation
        let rotate = CABasicAnimation.init(keyPath: "transform.rotation")
        rotate.fromValue = 0
        rotate.toValue = toValue
        rotate.fillMode = .forwards
        rotate.isRemovedOnCompletion = false
        rotate.duration = duration
        rotate.delegate = self
        rotate.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        //
        rotateTo = toValue
        onCompletionHandler = onCompletion
        add(rotate, forKey: "rotateWheel")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let rotateTo = rotateTo else {
            return
        }
        // calculate last position of slices
        for slice in slices {
            let startAngle = (slice.startAngle + rotateTo).truncatingRemainder(dividingBy: 2 * .pi)
            let endAngle = (slice.endAngle + rotateTo).truncatingRemainder(dividingBy: 2 * .pi)
            slice.startAngle = startAngle
            slice.endAngle = endAngle
        }
        onCompletionHandler?(slices)
        onCompletionHandler = nil
        resetSlicesPosition()  // this is to avoid issues when users spin the second time afterwards, CALayers will automatically reset to the initial position
    }
    
    private func resetSlicesPosition() {
        let eachSliceRadian = totalRadian / CGFloat(slices.count)
        var start: CGFloat = 0
        for slice in slices {
            slice.startAngle = start
            slice.endAngle = start + eachSliceRadian
            start += eachSliceRadian
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class Arc: CAShapeLayer {
    
    let textSlice: String?
    var startAngle: CGFloat
    var endAngle: CGFloat
    
    init(text: String?, centerPoint: CGPoint, start: CGFloat, end: CGFloat, fillColor: CGColor, radius: CGFloat) {
        self.textSlice = text
        self.startAngle = start
        self.endAngle = end
        super.init()
        let arc = UIBezierPath(arcCenter: centerPoint, radius: radius, startAngle: start, endAngle: end, clockwise: true)
        arc.addLine(to: centerPoint)
        arc.close()
        path = arc.cgPath
        strokeColor = UIColor.black.cgColor
        self.fillColor = fillColor
        generateSliceLabel(start: start, end: end, centerPoint: centerPoint, radius: radius)
    }
    
    private func generateSliceLabel(start: CGFloat, end: CGFloat, centerPoint: CGPoint, radius: CGFloat) {
        if let textSlice = textSlice {
            let label = CATextLayer()
            // calculate center point of slice
            let middleAngle = start - (start - end) / 2
            let arcCenterX = centerPoint.x + cos(middleAngle) * radius
            let arcCenterY = centerPoint.y + sin(middleAngle) * radius
            let labelX = (arcCenterX + centerPoint.x) / 2
            let labelY = (arcCenterY + centerPoint.y) / 2
            // calculate width, height
            let width: CGFloat = radius - 24
            let height: CGFloat = 30
            // configure label
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

class Indicator: Arc {
    
    init(centerPoint: CGPoint, start: CGFloat, end: CGFloat, fillColor: CGColor, radius: CGFloat) {
        super.init(text: nil, centerPoint: centerPoint, start: start, end: end, fillColor: fillColor, radius: radius)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
