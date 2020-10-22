//
//  TopBar.swift
//  TopBar
//
//  Created by Иван Викторович on 12.03.2020.
//  Copyright © 2020 -. All rights reserved.
//

import UIKit

public class TopBar: UIView {
    
    /// Xib outlets
    @IBOutlet private weak var csLeading: NSLayoutConstraint!
    @IBOutlet private weak var csBottom: NSLayoutConstraint!
    @IBOutlet private weak var csTop: NSLayoutConstraint!
    @IBOutlet private weak var csTrailing: NSLayoutConstraint!
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var stackView: UIStackView! {
        didSet {
            stackView.arrangedSubviews[0].removeFromSuperview()
        }
    }
    
    // MARK: - Public Properties
    private var view: UIView?
    private var selectionLayer: CALayer?
    private var currentIndex: Int = 0
    
    // MARK: - Public Properties
    // MARK: Background color when item not selected
    open var useGradient: Bool = false
    
    open var selectedGradientColors: [UIColor]? = []
    
    open var hideTitleWhenUnselected: Bool = false
    
    // MARK: Background color when item is selected
    open var selectedColor: UIColor?
    
    // MARK: Text color when item is selected
    open var selectedTextColor: UIColor? = .white
    
    // MARK: Text color when item not selected
    open var unselectedTextColor: UIColor? = .black
    
    // MARK: Spasing between items
    open var spasing: CGFloat = 20
    
    // MARK: Item Width
    open var itemWidth: CGFloat = 60
    
    open var itemCornerRadius: CGFloat = 0
    
    open var useAnimation: Bool = true
    
    open var padding: UIEdgeInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
    
    // MARK: Background image for TopBarView
    open var backgroundImage: UIImage?
    
    // MARK: - Delegate and DataSourse
    open weak var delegate:TopBarDelegate?
    open weak var dataSource: TopBarDataSource? {
        didSet {
            reloadData()
            self.layoutIfNeeded()
            selectionLayerInit()
        }
    }
    
    // MARK: - Override Properties
    override public var backgroundColor: UIColor? {
        willSet {
            if let view = view {
                view.backgroundColor = newValue
            }
        }
    }
    
    // MARK: - Override Methonds
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        self.clipsToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        self.clipsToBounds = true
    }
    
    override public func layoutIfNeeded() {
        super.layoutIfNeeded()
        configPadding()
    }
    
    // MARK: - Public Methonds
    open func reloadData() {
        stackView.removeAllVisibleArrangedSubviews()
        loadData()
    }
    
    open func cornerRadius(corners: UIRectCorner, radius: CGFloat) {
        self.roundCorners(corners: corners, radius: radius)
    }
    
    // MARK: - Private Methonds
    private func loadData() {
        imageView.image = backgroundImage
        imageView.contentMode = .scaleAspectFill
        stackView.spacing = spasing
        stackView.distribution = .equalSpacing
        
        if let itemCount = dataSource?.numberOfItemsIn(topBar: self) {
            for i in 0..<itemCount {
                let item = createItem(tag: i,
                                      icon: dataSource?.imagesForItemIn?(topBar: self, at: i),
                                      title: dataSource?.titlesForItemIn?(topBar: self, at: i),
                                      font: dataSource?.fontForItemIn?(topBar: self, at: i))
                stackView.addArrangedSubview(item)
                stackView.layoutIfNeeded()
            }
        }
    }
    
    private func getCurrentIndex() -> Int {
        return currentIndex
    }
    
    private func configPadding() {
        csTop.constant = padding.top
        csBottom.constant = padding.bottom
        csLeading.constant = padding.left
        csTrailing.constant = padding.right
    }
    
    // MARK: Init items
    private func createItem(tag: Int, icon: UIImage?, title: String?, font: UIFont?) -> TopBarItem {
        let item = TopBarItem()
        self.translatesAutoresizingMaskIntoConstraints = false
        item.tag = tag
        if item.tag != currentIndex {
            item.icon.tintColor = unselectedTextColor
            item.titleColor = unselectedTextColor
        } else {
            item.icon.tintColor = selectedTextColor
            item.titleColor = selectedTextColor
        }
        item.title = title
        item.name.isHidden = !(currentIndex == tag) && hideTitleWhenUnselected
        item.iconImage = icon
        item.titleFont = font
        if (itemWidth*CGFloat(dataSource!.numberOfItemsIn(topBar: self)))+(spasing * CGFloat(dataSource!.numberOfItemsIn(topBar: self))-1) > self.frame.width {
            let itemsCount: CGFloat = CGFloat(dataSource!.numberOfItemsIn(topBar: self))
            let avalibleWidth: CGFloat = self.frame.width - 40
            itemWidth = (avalibleWidth-(spasing*(itemsCount-1)))/itemsCount
        }
        item.widthAnchor.constraint(equalToConstant: itemWidth).isActive = true
        item.cornerRadius = itemCornerRadius
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectItem(_:)))
        item.isUserInteractionEnabled = true
        item.addGestureRecognizer(tap)
        
        return item
    }

    // MARK: Xib init
    private func commonInit() {
        let bundle = Bundle.init(for: TopBar.self)
        if let viewsToAdd = bundle.loadNibNamed("TopBar", owner: self, options: nil), let contentView = viewsToAdd.first as? UIView {
            view = contentView
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleHeight,
                                            .flexibleWidth]
        }
    }
    
    private func selectionLayerInit() {
        if useGradient {
            selectionLayer = SelectionGradientLayer(layer: self.layer)
            guard let selectionLayer = selectionLayer as? CAGradientLayer else {return}
            selectionLayer.colors = selectedGradientColors?.map({ $0.cgColor })
        } else {
            selectionLayer = SelectionFillLayer(layer: self.layer)
            selectionLayer?.backgroundColor = selectedColor?.cgColor
        }
        guard let selectionLayer = selectionLayer, let firstItem = stackView.arrangedSubviews.first as? TopBarItem else {return}
        layoutIfNeeded()
        print(firstItem.frame)
        selectionLayer.frame = firstItem.bounds
        selectionLayer.cornerRadius = firstItem.layer.cornerRadius
        stackView.layer.insertSublayer(selectionLayer, at: 0)
    }
    
    @objc private func selectItem(_ sender: UITapGestureRecognizer) {
        guard let previusView = self.stackView.arrangedSubviews[self.currentIndex] as? TopBarItem else {return}
        if let currentView = sender.view as? TopBarItem {
            UIView.transition(with: currentView.name, duration: 0.3, options: .transitionCrossDissolve, animations: {
                currentView.titleColor = self.selectedTextColor
                previusView.titleColor = self.unselectedTextColor
                
                if self.hideTitleWhenUnselected {
                    currentView.name.isHidden = false
                    previusView.name.isHidden = true
                }
            })
            UIView.transition(with: currentView.icon, duration: 0.3, options: .transitionCrossDissolve, animations: {
                currentView.icon.tintColor = self.selectedTextColor
                previusView.icon.tintColor = self.unselectedTextColor
            }, completion: { (finished) in
                if self.useAnimation {
                    currentView.icon.shake(duration: 0.4)
                }
            })
            

            currentView.isUserInteractionEnabled = false
            previusView.isUserInteractionEnabled = true
        }
        self.layoutIfNeeded()
        currentIndex = sender.view!.tag
        delegate?.didSelect?(topBar: self, at: currentIndex)
        UIView.animate(withDuration: 0.2) {
            self.selectionLayer?.frame.origin = self.stackView.arrangedSubviews[self.currentIndex].frame.origin
        }
    }
}

@objc public protocol TopBarDelegate: class {
    @objc optional func didSelect(topBar: TopBar, at index: Int)
}

@objc public protocol TopBarDataSource: class {
    func numberOfItemsIn(topBar: TopBar) -> Int
    
    @objc optional func titlesForItemIn(topBar: TopBar, at index: Int) -> String?
    @objc optional func imagesForItemIn(topBar: TopBar, at index: Int) -> UIImage?
    @objc optional func fontForItemIn(topBar: TopBar, at index: Int) -> UIFont?
}
