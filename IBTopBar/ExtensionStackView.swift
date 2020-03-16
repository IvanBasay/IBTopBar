//
//  ExtesionStackView.swift
//  TopBar
//
//  Created by Иван Викторович on 13.03.2020.
//  Copyright © 2020 -. All rights reserved.
//

import Foundation
import UIKit

internal extension UIStackView {
    
    func removeAllVisibleArrangedSubviews() {
        for subview in self.arrangedSubviews {
            self.removeArrangedSubview(subview)
        }
        self.layoutIfNeeded()
        self.layoutSubviews()
    }
        
}
