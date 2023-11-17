//
//  ViewController.swift
//  GestureTraining
//
//  Created by Ilya Pavlov on 11.11.2023.
//

import UIKit

class ViewController: UIViewController {
    
    private let zView = newView()
    
    private let viewTapGestureRecognizer = UITapGestureRecognizer()
    
    private let pinchGestureRecognizer = UIPinchGestureRecognizer()
    private let zTapGestureRecognizer = UITapGestureRecognizer()
    private let longPressGestureRecognizer = UILongPressGestureRecognizer()
    
    private var scale: CGFloat = 1.0 {
        didSet {
            scaleZView()
        }
    }
    
    private var pinchGestureAnchorScale: CGFloat?
    
    private var cornerRadius: CGFloat? = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(viewTapGestureRecognizer)
        self.view.backgroundColor = .clear
        
        setupZView()
        setupGestureReconizers()
    }
    
}

extension ViewController {
    
    private func setupZView() {
        zView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        zView.center = view.center
        view.addSubview(zView)
        
        zView.backgroundColor = .purple
        
        zView.addGestureRecognizer(pinchGestureRecognizer)
        zView.addGestureRecognizer(zTapGestureRecognizer)
        zView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    private func setupGestureReconizers() {
        pinchGestureRecognizer.addTarget(self, action: #selector(handlePinchGesture(_:)))
        zTapGestureRecognizer.addTarget(self, action: #selector(handleTapGesture(_:)))
        longPressGestureRecognizer.addTarget(self, action: #selector(handleLongpressGesture(_:)))
        
        viewTapGestureRecognizer.addTarget(self, action: #selector(handleViewTapGesture(_:)))
        
        zTapGestureRecognizer.delegate = self
        zTapGestureRecognizer.cancelsTouchesInView = false
        viewTapGestureRecognizer.cancelsTouchesInView = false
    }
    
    @objc private func handlePinchGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
        guard pinchGestureRecognizer === gestureRecognizer else { return }
        
        switch gestureRecognizer.state {
        case .began:
            pinchGestureAnchorScale = gestureRecognizer.scale
        case .changed:
            guard let pinchGestureAnchorScale = pinchGestureAnchorScale else { return }
            let gestureScale = gestureRecognizer.scale
            
            scale += gestureScale - pinchGestureAnchorScale
            self.pinchGestureAnchorScale = gestureScale
            
        case .ended, .cancelled:
            pinchGestureAnchorScale = nil
        case .failed, .possible:
            break
        @unknown default:
            print(" ")
        }
    }
    
    @objc private func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        zView.backgroundColor = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1.0)
        print("color changed")
    }
    
    @objc private func handleLongpressGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let newCornerRadius: CGFloat = self.zView.layer.cornerRadius > 19 ? 0 : 20
            
            UIView.animate(withDuration: 0.5) {
                self.zView.layer.cornerRadius = newCornerRadius
            }
        }
    }
    
    @objc func handleViewTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        
        print("main view tapped")
    }
    
    private func scaleZView() {
        zView.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)
        print("scaled")
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


class newView: UIView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("zView touch began")
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        print("zView touch cancelled")
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        print("zView touch ended")
    }
}
