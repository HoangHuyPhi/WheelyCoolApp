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
    
    private let totalRadian: CGFloat = 2 * .pi
    private var rotateTo: CGFloat?
    
    private var slices: [Slice] = []
    
    private var onCompletionHandler: ((_ slices: [Slice]) -> Void)?

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
            let arc1 = Slice(text: option, centerPoint: centerPoint, start: start, end: start + eachSliceRadian, fillColor: sliceColors[index % 4].cgColor, radius: radius)
            arc1.frame = self.bounds
            slices.append(arc1)
            start += eachSliceRadian
        }
        
        for arc in slices {
            addSublayer(arc)
        }
    }
    
    func rotateWheel(toValue: CGFloat, duration: CGFloat, onCompletion: @escaping (_ slices: [Slice]) -> Void ) {
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
        resetSlicesPosition()  // this is to avoid issues when users spin the second time afterwards, CALayers will automatically reset to the initial position after starting another animation
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

