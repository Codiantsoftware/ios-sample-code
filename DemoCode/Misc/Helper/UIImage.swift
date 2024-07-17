//
//  UIImage.swift
//  Codiant iOS
//  Created by Codiant iOS on 19/01/2023.
//

import Foundation
import UIKit
import ImageIO

extension UIImage {
 
      func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
          let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
          let format = imageRendererFormat
          format.opaque = isOpaque
          return UIGraphicsImageRenderer(size: canvas, format: format).image {
              _ in draw(in: CGRect(origin: .zero, size: canvas))
          }
      }
      func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
          let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
          let format = imageRendererFormat
          format.opaque = isOpaque
          return UIGraphicsImageRenderer(size: canvas, format: format).image {
              _ in draw(in: CGRect(origin: .zero, size: canvas))
          }
      }
 
  func imageWithSize(scaledToSize newSize: CGSize) -> UIImage {
    
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
    self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
    let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return newImage
  }
  
  public class func gif(name: String) -> UIImage? {
    // Check for existance of gif
    guard let bundleURL = Bundle.main
      .url(forResource: name, withExtension: "gif") else {
        print("SwiftGif: This image named \"\(name)\" does not exist")
        return nil
    }
    
    // Validate data
    guard let imageData = try? Data(contentsOf: bundleURL) else {
      print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
      return nil
    }
    
    return gif(data: imageData)
  }
  
  public class func gif(data: Data) -> UIImage? {
    // Create source from data
    guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
      print("SwiftGif: Source for the image does not exist")
      return nil
    }
    
    return UIImage.animatedImageWithSource(source)
  }
  
  public class func gif(url: String) -> UIImage? {
    // Validate URL
    guard let bundleURL = URL(string: url) else {
      print("SwiftGif: This image named \"\(url)\" does not exist")
      return nil
    }
    
    // Validate data
    guard let imageData = try? Data(contentsOf: bundleURL) else {
      print("SwiftGif: Cannot turn image named \"\(url)\" into NSData")
      return nil
    }
    
    return gif(data: imageData)
  }
  
  internal class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
    var delay = 0.6
    
    // Get dictionaries
    let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
    let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
    
    defer {
      gifPropertiesPointer.deallocate()
    }
    if CFDictionaryGetValueIfPresent(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque(), gifPropertiesPointer) == false {
      return delay
    }
    
    let gifProperties:CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
    
    // Get delay time
    var delayObject: AnyObject = unsafeBitCast(
      CFDictionaryGetValue(gifProperties,
                           Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
      to: AnyObject.self)
    if delayObject.doubleValue == 0 {
      delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                       Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
    }
    
    delay = delayObject as? Double ?? 0
    
    if delay < 0.1 {
      delay = 0.1 // Make sure they're not too fast
    }
    
    return 0.06//delay
  }
  
  internal class func gcdForPair( a: Int?,  b: Int?) -> Int {
    var a = a
    var b = b
    // Check if one of them is nil
    if b == nil || a == nil {
      if b != nil {
        return b!
      } else if a != nil {
        return a!
      } else {
        return 0
      }
    }
    
    // Swap for modulo
    if a! < b! {
      let c = a
      a = b
      b = c
    }
    
    // Get greatest common divisor
    var rest: Int
    while true {
      rest = a! % b!
      
      if rest == 0 {
        return b! // Found it
      } else {
        a = b
        b = rest
      }
    }
  }
  
  internal class func gcdForArray(_ array: Array<Int>) -> Int {
    if array.isEmpty {
      return 1
    }
    
    var gcd = array[0]
    
    for val in array {
      gcd = UIImage.gcdForPair(a: val, b: gcd)
    }
    
    return gcd
  }
  
  internal class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
    let count = CGImageSourceGetCount(source)
    var images = [CGImage]()
    var delays = [Int]()
    
    // Fill arrays
    for i in 0..<count {
      // Add image
      if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
        images.append(image)
      }
      
      // At it's delay in cs
      let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                                                      source: source)
      delays.append(Int(delaySeconds * 400.0)) // Seconds to ms
    }
    
    // Calculate full duration
    let duration: Int = {
      var sum = 0
      
      for val: Int in delays {
        sum += val
      }
      
      return sum
    }()
    
    // Get frames
    let gcd = gcdForArray(delays)
    var frames = [UIImage]()
    
    var frame: UIImage
    var frameCount: Int
    for i in 0..<count {
      frame = UIImage(cgImage: images[Int(i)])
      frameCount = Int(delays[Int(i)] / gcd)
      
      for _ in 0..<frameCount {
        frames.append(frame)
      }
    }
    
    // Heyhey
    let animation = UIImage.animatedImage(with: frames,
                                          duration: Double(duration) / 1000.0)
    
    return animation
  }
  
  func fixedOrientation() -> UIImage? {
    
    guard imageOrientation != UIImage.Orientation.up else {
      //This is default orientation, don't need to do anything
      return self.copy() as? UIImage
    }
    
    guard let cgImage = self.cgImage else {
      //CGImage is not available
      return nil
    }
    
    guard let colorSpace = cgImage.colorSpace, let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
      return nil //Not able to create CGContext
    }
    
    var transform: CGAffineTransform = CGAffineTransform.identity
    
    switch imageOrientation {
    case .down, .downMirrored:
      transform = transform.translatedBy(x: size.width, y: size.height)
      transform = transform.rotated(by: CGFloat.pi)
      break
    case .left, .leftMirrored:
      transform = transform.translatedBy(x: size.width, y: 0)
      transform = transform.rotated(by: CGFloat.pi / 2.0)
      break
    case .right, .rightMirrored:
      transform = transform.translatedBy(x: 0, y: size.height)
      transform = transform.rotated(by: CGFloat.pi / -2.0)
      break
    case .up, .upMirrored:
      break
    @unknown default:
      break
    }
    
    //Flip image one more time if needed to, this is to prevent flipped image
    switch imageOrientation {
    case .upMirrored, .downMirrored:
      transform.translatedBy(x: size.width, y: 0)
      transform.scaledBy(x: -1, y: 1)
      break
    case .leftMirrored, .rightMirrored:
      transform.translatedBy(x: size.height, y: 0)
      transform.scaledBy(x: -1, y: 1)
    case .up, .down, .left, .right:
      break
    @unknown default:
      break
    }
    
    ctx.concatenate(transform)
    
    switch imageOrientation {
    case .left, .leftMirrored, .right, .rightMirrored:
      ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
    default:
      ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
      break
    }
    
    guard let newCGImage = ctx.makeImage() else { return nil }
    return UIImage.init(cgImage: newCGImage, scale: 1, orientation: .up)
  }
  
  enum JPEGQuality: CGFloat {
    case lowest  = 0
    case low     = 0.25
    case medium  = 0.5
    case mediumHigh  = 0.65
    case high    = 0.75
    case highest = 1
  }
  
  func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
    return jpegData(compressionQuality: jpegQuality.rawValue)
  }
  
}

class CornerViewImageView: UIImageView {
    
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
