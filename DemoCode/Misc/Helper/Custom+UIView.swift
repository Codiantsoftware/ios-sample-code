//
//  Custom+UIView.swift
//  Codiant iOS
//  Created by Codiant iOS on 19/01/2023.
//

import Foundation
import QuartzCore
import UIKit

// swiftlint:disable computed_accessors_order
extension UIView {
  @IBInspectable var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
      layer.masksToBounds = newValue > 0
    }
  }
  
  @IBInspectable var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }
  
  @IBInspectable var borderColor: UIColor? {
    get {
      return UIColor(cgColor: layer.borderColor!)
    }
    set {
      layer.borderColor = newValue?.cgColor ?? UIColor.white.cgColor
    }
  }
  
  @IBInspectable var shadowColor: UIColor? {
    set {
      layer.shadowColor = newValue!.cgColor
    }
    get {
      if let color = layer.shadowColor {
        return UIColor(cgColor: color)
      } else {
        return nil
      }
    }
  }
  
  /* The opacity of the shadow. Defaults to 0. Specifying a value outside the
   * [0,1] range will give undefined results. Animatable. */
  @IBInspectable var shadowOpacity: Float {
    set {
      layer.shadowOpacity = newValue
    }
    get {
      return layer.shadowOpacity
    }
  }
  
  /* The shadow offset. Defaults to (0, -3). Animatable. */
  @IBInspectable var shadowOffset: CGPoint {
    set {
      layer.shadowOffset = CGSize(width: newValue.x, height: newValue.y)
    }
    get {
      return CGPoint(x: layer.shadowOffset.width, y: layer.shadowOffset.height)
    }
  }
  
  /* The blur radius used to create the shadow. Defaults to 3. Animatable. */
  @IBInspectable var shadowRadius: CGFloat {
    set {
      layer.shadowRadius = newValue
    }
    get {
      return layer.shadowRadius
    }
  }
  
  func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
    let animation = CABasicAnimation(keyPath: "transform.rotation")
    animation.toValue = toValue
    animation.duration = duration
    animation.isRemovedOnCompletion = false
    //animation.repeatCount = HUGE
    animation.fillMode = CAMediaTimingFillMode.forwards
    self.layer.add(animation, forKey: nil)
  }
  
  func applyShadow(color: UIColor = .black, cornerRadius: CGFloat = 0, opacity: Float = 0.5, offSet: CGSize = CGSize(width: 0, height: 0), radius: CGFloat = 1, shadowRect: CGRect? = nil) {
    layer.masksToBounds = false
    layer.cornerRadius  = cornerRadius
    layer.shadowColor   = color.cgColor
    layer.shadowOpacity = opacity
    layer.shadowOffset  = offSet
    layer.shadowRadius  = radius
    
    if let shadowRect = shadowRect {
      layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
    }
  }
  
  /* Animate View with fade animation. */
  /* func animateFade(duration : CFTimeInterval) {
   let transition = CATransition()
   transition.duration = duration
   transition.type = CATransitionType.fade
   layer.add(transition, forKey: kCATransition)
   }
   */
}

extension UIView {
  
  func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
    if #available(iOS 11.0, *) {
      clipsToBounds = true
      layer.cornerRadius = radius
      layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
    } else {
      let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
      let mask = CAShapeLayer()
      mask.path = path.cgPath
      layer.mask = mask
    }
  }
  
  func addshadow(radius: CGFloat = 5.0, color: CGColor = UIColor(red: 250/255, green: 140/255, blue: 61/225, alpha: 0.25).cgColor, offset: CGSize = CGSize(width: 0.0, height: 15.0)) {
    
    self.layer.masksToBounds = false
    self.layer.shadowOffset = offset
    self.layer.shadowRadius = radius
    self.layer.shadowOpacity = 2.0
    self.layer.shadowColor = color
    self.layer.cornerRadius = self.frame.height/2
    self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.frame.height/2).cgPath
  }
}

class BottomShadow: UIView {
  
  init() {
    super.init(frame: .zero)
    self.addshadow()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class CornerView: UIView {
    
    @IBInspectable var leftTopRadius : CGFloat = 0{
        didSet{
            self.applyMask()
        }
    }
    @IBInspectable var rightTopRadius : CGFloat = 0{
        didSet{
            self.applyMask()
        }
    }
    @IBInspectable var rightBottomRadius : CGFloat = 0{
        didSet{
            self.applyMask()
        }
    }
    
    @IBInspectable var leftBottomRadius : CGFloat = 0{
        didSet{
            self.applyMask()
        }
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.applyMask()
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    /*override func draw(_ rect: CGRect) {
        super.draw(rect)

    }*/
    
    func applyMask()
    {
        let shapeLayer = CAShapeLayer(layer: self.layer)
        shapeLayer.path = self.pathForCornersRounded(rect:self.bounds).cgPath
        shapeLayer.frame = self.bounds
        shapeLayer.masksToBounds = true
        self.layer.mask = shapeLayer
    }
    
    func pathForCornersRounded(rect:CGRect) ->UIBezierPath
    {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0 + leftTopRadius , y: 0))
        path.addLine(to: CGPoint(x: rect.size.width - rightTopRadius , y: 0))
        path.addQuadCurve(to: CGPoint(x: rect.size.width , y: rightTopRadius), controlPoint: CGPoint(x: rect.size.width, y: 0))
        path.addLine(to: CGPoint(x: rect.size.width , y: rect.size.height - rightBottomRadius))
        path.addQuadCurve(to: CGPoint(x: rect.size.width - rightBottomRadius , y: rect.size.height), controlPoint: CGPoint(x: rect.size.width, y: rect.size.height))
        path.addLine(to: CGPoint(x: leftBottomRadius , y: rect.size.height))
        path.addQuadCurve(to: CGPoint(x: 0 , y: rect.size.height - leftBottomRadius), controlPoint: CGPoint(x: 0, y: rect.size.height))
        path.addLine(to: CGPoint(x: 0 , y: leftTopRadius))
        path.addQuadCurve(to: CGPoint(x: 0 + leftTopRadius , y: 0), controlPoint: CGPoint(x: 0, y: 0))
        path.close()
        
        return path
    }
    
}

class DashedLineView : UIView {
    @IBInspectable var perDashLength: CGFloat = 2.0
    @IBInspectable var spaceBetweenDash: CGFloat = 2.0
    @IBInspectable var dashColor: UIColor = UIColor.lightGray


    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let  path = UIBezierPath()
        if height > width {
            let  p0 = CGPoint(x: self.bounds.midX, y: self.bounds.minY)
            path.move(to: p0)

            let  p1 = CGPoint(x: self.bounds.midX, y: self.bounds.maxY)
            path.addLine(to: p1)
            path.lineWidth = width

        } else {
            let  p0 = CGPoint(x: self.bounds.minX, y: self.bounds.midY)
            path.move(to: p0)

            let  p1 = CGPoint(x: self.bounds.maxX, y: self.bounds.midY)
            path.addLine(to: p1)
            path.lineWidth = height
        }

        let  dashes: [ CGFloat ] = [ perDashLength, spaceBetweenDash ]
        path.setLineDash(dashes, count: dashes.count, phase: 0.0)

        path.lineCapStyle = .butt
        dashColor.set()
        path.stroke()
    }

    private var width : CGFloat {
        return self.bounds.width
    }

    private var height : CGFloat {
        return self.bounds.height
    }
}
//MARK : UIView
internal extension UIView {
  static func keyWindow() -> UIWindow? {
    var currentWindow = UIApplication.shared.keyWindow
    
    if currentWindow == nil {
      let frontToBackWindows = Array(UIApplication.shared.windows.reversed())
      
      for window in frontToBackWindows {
        if window.windowLevel == UIWindow.Level.normal {
          currentWindow = window
          break
        }
      }
    }
    
    return currentWindow
  }
}
