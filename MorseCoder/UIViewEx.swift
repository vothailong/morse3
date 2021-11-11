//
//  UIViewEx.swift
//  IDareU
//
//  Created by Dung Do on 6/19/19.
//  Copyright © 2019 Dung Do. All rights reserved.
//

import UIKit

extension UIView {
    var isHiddenX: Bool {
        get {
            return self.isHidden
        }
        set {
//            if newValue == false {//want to show
                self.alpha = newValue ? 0 : 1//real
//            }
            guard newValue != self.isHidden else { return }
            DispatchQueue.main.async {
                if newValue == false {//want to show
                    self.isHidden = false //show
                    self.alpha = 0//start at transparent
                }
                
                  self.alpha = newValue ? 1 : 0
                
                UIView.animate(withDuration: 0.8, animations: {
                    self.alpha = newValue ? 0 : 1 //end value
                }) { (_) in
                    self.isHidden = newValue
                }
            }
        }
    }
    
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame = CGRect(x: newValue, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
        }
    }
    
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame = CGRect(x: self.frame.origin.x, y: newValue, width: self.frame.size.width, height: self.frame.size.height)
        }
    }
    
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: newValue, height: self.frame.size.height)
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.height
        }
        set {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: newValue)
        }
    }
    
    func setRoundedCornersFull() {
        self.layer.cornerRadius = self.frame.size.width / 2
    }
    
    func setBorder(radius: Double, width: Float? = 1.0, color: UIColor? = .clear, clip: Bool? = false) {
        self.clipsToBounds = clip!
        self.layer.cornerRadius = CGFloat(radius)
        self.layer.borderWidth = CGFloat(width!)
        self.layer.borderColor = color!.cgColor
    }
    
    func setBorder(radius: Double, color: UIColor, roundingCorners: UIRectCorner) {
        let rounded = UIBezierPath(roundedRect: self.layer.bounds,
                                   byRoundingCorners: roundingCorners,
                                   cornerRadii: CGSize(width: CGFloat(radius), height: CGFloat(radius)))
        let shape = CAShapeLayer()
        shape.path = rounded.cgPath
        self.layer.mask = shape
    }
    
    func setShadow(radius: Double, opacity: Float = 0.2, color: UIColor = .gray) {
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = CGFloat(radius)
        self.layer.shadowColor = color.cgColor
    }
    
    func setGradient(startColor: UIColor, startPoint: CGPoint, endColor: UIColor, endPoint: CGPoint) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func captureImage() -> UIImage {
        UIGraphicsBeginImageContext(self.frame.size)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func pinEdges(to other: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: other.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: other.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: other.topAnchor, constant: 0).isActive = true
        bottomAnchor.constraint(equalTo: other.bottomAnchor, constant: 0).isActive = true
    }
    
   
    
    
}



class ViewAllowingInteractionOutside: UIView{
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.point(inside: point, with: event) {
            return super.hitTest(point, with: event)
        }
        guard isUserInteractionEnabled, !isHidden, alpha > 0 else {
            return nil
        }
    
        for subview in subviews.reversed() {
            let convertedPoint = subview.convert(point, from: self)
            if let hitView = subview.hitTest(convertedPoint, with: event) {
                return hitView
            }
        }
        return nil
    }
    
     
}
 
