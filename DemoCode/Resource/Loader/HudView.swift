//
//  HudView.swift
//  EasyFit
//
//  Created by codiant  on 20/02/23.
//  Copyright © 2017 Codiant. All rights reserved.
//

import UIKit

class HudView: UIView {
    
    static var hudView: HudView?
    
    @IBOutlet weak  var viewContainer: UIView!
    
    var imgViewGif: UIImageView?
    
    static func show() {
        remove()
        hudView = UINib(nibName: "HudView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? HudView
        self.keyWindow()?.addSubview(hudView!)
        hudView!.frame = UIScreen.main.bounds
        
        hudView!.imgViewGif = UIImageView(frame: hudView!.viewContainer.bounds)
        hudView!.imgViewGif!.image = UIImage.gif(name: "Loader")
        if hudView!.imgViewGif!.image == nil {
          hudView!.imgViewGif!.image = UIImage.gif(name: "Loader")
        }
        hudView!.imgViewGif!.contentMode = .scaleAspectFit
        hudView!.viewContainer.addSubview(hudView!.imgViewGif!)
        
        transformHud()
    }
    
    static func transformHud() {        
        hudView?.viewContainer.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: [.curveEaseOut], animations: {
                        
                        hudView?.viewContainer.transform = CGAffineTransform(scaleX: 1, y: 1)
                        hudView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
                        
        }, completion: nil)
    }
    
    // Remove with animation
    static func kill() {
        if Thread.isMainThread {
            hide()
        } else {
            DispatchQueue.main.async {
                hide()
            }
        }
    }
    
    static func hide() {
        if hudView != nil {
            UIView.animate(withDuration: 0.1, animations: {
                hudView!.transform = CGAffineTransform(scaleX: 0, y: 0)
                hudView!.backgroundColor = .clear
            }, completion: { (_: Bool) in
                self.remove()
            })
        }
    }
    
    static func remove() {
      hudView?.imgViewGif?.image = nil
      hudView?.imgViewGif?.removeFromSuperview()
      hudView?.imgViewGif = nil
      hudView?.removeFromSuperview()
      hudView = nil
    }
    
    deinit {
        self.imgViewGif?.image = nil
    }
}
