//
//  ViewController.swift
//  WheelyCool
//
//  Created by Huy Hoang Phi  on 12/3/2022.
//

import UIKit

class WheelyViewController: UIViewController {
    
    var slices: [String]!
    
    private var wheel: Wheel?
    private var indicator: Indicator?
    private var isSpinning = false
    
    private var spinButton: UIButton?
    
    // to calculate the ending destination of the wheel
    private var rotateTo: CGFloat?
    
    // to display results
    private var resultLabel: UILabel?
    var results: Set<String> = []
    
    init(slices: [String]) {
        super.init(nibName: nil, bundle: nil)
        self.slices = slices
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let centerPointView = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        let radius = view.frame.width / 2 - 40
        
        generateLabel()
        generateSpinButton()
        generateWheel(centerPoint: centerPointView, radius: radius)
        generateIndicator(pointToDraw: CGPoint(x: centerPointView.x + radius - 10, y: centerPointView.y))

    }
    
    @objc private func spinWheel() {
        rotateTo = CGFloat.random(in: 3..<20) * .pi
        guard let rotateTo = rotateTo else {
            return
        }
        wheel?.rotateWheel(toValue: rotateTo, duration: CGFloat.random(in: 5..<15), onCompletion: onWheelStop)
        isSpinning = true
        results = []
        updateButtonsAndLabels()
    }
    
    private func updateButtonsAndLabels() {
        if (isSpinning) {
            spinButton?.isEnabled = false
            resultLabel?.text = "Spinning...!!"
        } else {
            spinButton?.isEnabled = true
            if (results.count == 1) {
                resultLabel?.text = "You won " + Array(results)[0] + " 😀!"
            } else if (results.count == 2) {
                resultLabel?.text = "You won " + Array(results)[0] + " and " + Array(results)[1] + " 😀!"
            }
        }
    }
    
    private func onWheelStop(slices: ([Arc])) -> Void  {
        print("stop wheel")
        for slice in slices {
            let indicatorAngle: CGFloat = 0
            // StartAngle > EndAngle means the pointer is on that slice
            if (slice.startAngle > slice.endAngle) {
                results.insert(slice.textSlice ?? "")
            }
            // if the indicator is pointing on the line, we have two options.
            if (slice.startAngle == indicatorAngle || slice.endAngle == indicatorAngle) {
                results.insert(slice.textSlice ?? "")
            }
        }
        isSpinning = false
        updateButtonsAndLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: -- Generate UI Elements Methods
extension WheelyViewController {
    
    private func generateLabel() {
        resultLabel = UILabel()
        guard let resultLabel = resultLabel else {
            return
        }
        view.addSubview(resultLabel)
        resultLabel.text = "Let's spin the wheel!"
        resultLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120).isActive = true
        resultLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        resultLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    private func generateSpinButton() {
        spinButton = UIButton(type: .system)
        guard let spinButton = spinButton else {
            return
        }
        view.addSubview(spinButton)
        spinButton.backgroundColor = .systemRed
        spinButton.translatesAutoresizingMaskIntoConstraints = false
        spinButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -56).isActive = true
        spinButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        spinButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        spinButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        spinButton.layer.cornerRadius = 10
        spinButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        spinButton.setTitle("Spin", for: .normal)
        spinButton.setTitleColor(UIColor.white, for: .normal)
        
        spinButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(spinWheel)))
    }
    
    private func generateWheel(centerPoint: CGPoint, radius: CGFloat) {
        wheel = Wheel(centerPoint: centerPoint, numOfSlices: slices, radius: radius)
        if let wheel = wheel {
            view.layer.addSublayer(wheel)
            wheel.frame = self.view.bounds
        }
    }
    
    private func generateIndicator(pointToDraw: CGPoint) {
        indicator = Indicator(centerPoint: pointToDraw, start: -.pi / 8, end: .pi / 8, fillColor: UIColor.red.cgColor, radius: 40)
        if let indicator = indicator {
            view.layer.addSublayer(indicator)
        }
    }
}

