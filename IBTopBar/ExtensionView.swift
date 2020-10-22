//
//  ExtensionView.swift
//  TopBar
//
//  Created by Иван Викторович on 12.03.2020.
//  Copyright © 2020 -. All rights reserved.
//

import Foundation
import UIKit

internal extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
