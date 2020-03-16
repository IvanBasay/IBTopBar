//
//  TopBarItem.swift
//  TopBar
//
//  Created by Иван Викторович on 13.03.2020.
//  Copyright © 2020 -. All rights reserved.
//

import UIKit

class TopBarItem: UIView {
    @IBOutlet weak var icon: AnimatedImageView!
    @IBOutlet weak var name: UILabel!
    
    private var view: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        self.clipsToBounds = true
    }
    
    private func commonInit() {
        let bundle = Bundle.init(for: TopBarItem.self)
        if let viewsToAdd = bundle.loadNibNamed("TopBarItem", owner: self, options: nil), let contentView = viewsToAdd.first as? UIView {
            view = contentView
            backgroundColor = .clear
            view?.backgroundColor = .clear
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleHeight,
                                            .flexibleWidth]
        }
    }

    
    var iconImage: UIImage? {
        didSet {
            guard let icon = iconImage else {self.icon.image = UIImage(); return}
            self.icon.image = icon
        }
    }
    
    var title: String? {
        didSet {
            guard let name = title else {self.name.text = ""; return}
            self.name.text = name
        }
    }
    
    var titleFont: UIFont? {
        didSet {
            name.font = titleFont ?? UIFont.systemFont(ofSize: 17)
        }
    }
    
    var titleColor: UIColor? {
        didSet {
            name.textColor = titleColor ?? UIColor.black
        }
    }
    
    var cornerRadius: CGFloat? {
        didSet {
            self.layer.cornerRadius = self.cornerRadius ?? 0
        }
    }
    
    override var backgroundColor: UIColor? {
        willSet {
            if newValue != .clear {
                self.backgroundColor = .clear
                self.view?.backgroundColor = .clear
                print("Cannot change unselected item color")
            }
        }
    }
}
