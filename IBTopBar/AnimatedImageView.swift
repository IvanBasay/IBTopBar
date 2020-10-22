//
//  AnimatedImageView.swift
//  TopBar
//
//  Created by Иван Викторович on 13.03.2020.
//  Copyright © 2020 -. All rights reserved.
//

import UIKit

class AnimatedImageView: UIImageView {

    func shake(duration: CGFloat) {
        let rotate = CAKeyframeAnimation(keyPath: "transform.rotation")
        rotate.values = [0, 0.14, 0, -0.14, 0]
        rotate.timingFunctions = [CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut),  CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)]

        let position = CAKeyframeAnimation(keyPath: "position")
        position.values = [ NSValue.init(cgPoint: .zero) , NSValue.init(cgPoint: CGPoint(x: 0, y: -5))  ,  NSValue.init(cgPoint: .zero) ]
        position.timingFunctions = [ CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut),  CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)  ]
        position.isAdditive = true
        position.duration = CFTimeInterval(duration/2)
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [position, rotate]
        groupAnimation.duration = CFTimeInterval(duration)
        self.layer.add(groupAnimation, forKey: nil)
    }
}
