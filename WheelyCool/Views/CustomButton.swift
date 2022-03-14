//
//  CustomButton.swift
//  WheelyCool
//
//  Created by Huy Hoang Phi  on 13/3/2022.
//

import UIKit

class WheelyButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(title: String) {
        self.init(frame: .zero)
        set(title)
    }
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func set(_ title: String) {
        backgroundColor = .red
        titleLabel?.font = UIFont.systemFont(ofSize: 17)
        setTitle(title, for: .normal)
        setTitleColor(UIColor.white, for: .normal)
        setTitleColor(UIColor.white, for: .disabled)
        layer.cornerRadius = 10
    }
}
