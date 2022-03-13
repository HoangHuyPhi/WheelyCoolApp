//
//  Indicator.swift
//  WheelyCool
//
//  Created by Huy Hoang Phi  on 13/3/2022.
//
import UIKit

class Indicator: Slice {
    
    init(centerPoint: CGPoint, start: CGFloat, end: CGFloat, fillColor: CGColor, radius: CGFloat) {
        super.init(text: nil, centerPoint: centerPoint, start: start, end: end, fillColor: fillColor, radius: radius)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
