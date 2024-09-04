//
//  CustomNavigationBar.swift
//  assessmentApp
//
//  Created by Waqas Ashraf on 9/3/24.
//

import UIKit

class CustomNavigationBar: UIView, NibInstantiatable{
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var leadingImage: UIImageView!
    @IBOutlet weak var trailingLeadingImage: UIImageView!
    @IBOutlet weak var trailingImage: UIImageView!
    @IBOutlet weak var trailingBtn: UIButton!
    @IBOutlet weak var lineSeparatorView: UIView!
    @IBOutlet weak var titleLblTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var navBarBottomConstraint: NSLayoutConstraint!
    
    typealias buttonAction = ((Int, CustomNavigationBar) -> Void)?
    var action : buttonAction = nil
    
    @discardableResult
    class func addNavBar(parentView: UIView, insert: Bool = false, backgroundColor: UIColor? = nil, lineSeparatorColor: UIColor? = nil, leadingImage: String = "", leadImageTintColor: UIColor? = nil, title: String = " ", titleAlignment: NSTextAlignment? = nil, titleColor: UIColor = .black, trailingLeadImage: String = "", trailingLeadImageTintColor: UIColor? = nil, trailingImage: String = "", trailingImageTintColor: UIColor? = nil, trailingBtnMenuItems: [UIAction] = [], topConstraint: CGFloat? = nil, bottomConstraint: CGFloat? = nil, closure: buttonAction) -> CustomNavigationBar{
        
        let trailingImageUi: UIImage? = UIImage(named: trailingImage)
        print("trailing image: \(String(describing: trailingImageUi))")
        let navBar = CustomNavigationBar.fromNib()
        navBar.action = closure
        navBar.backgroundColor = backgroundColor
        if let lineSeparatorColor {
            navBar.lineSeparatorView.backgroundColor = lineSeparatorColor
        }
        navBar.titleLbl.text = title
        if let titleAlignment{
            navBar.titleLbl.textAlignment = titleAlignment
        }
        navBar.titleLbl.textColor = titleColor
        if let topConstraint{
            navBar.titleLblTopConstraint.constant = topConstraint
        }
        if let bottomConstraint{
            navBar.navBarBottomConstraint.constant = bottomConstraint
        }
        if #available(iOS 14.0, *) {
            navBar.trailingBtn.showsMenuAsPrimaryAction = trailingBtnMenuItems.isEmpty ? false : true
            navBar.trailingBtn.menu = trailingBtnMenuItems.isEmpty ? nil : navBar.getMenu(actions: trailingBtnMenuItems)
        } else {
            // Fallback on earlier versions
        }
        navBar.leadingImage.layer.cornerRadius = 8
        if let leadImage = UIImage(named: leadingImage) {
            navBar.leadingImage.image = leadImage
        }
        else {
            navBar.leadingImage.image = UIImage(systemName: leadingImage)
        }
        if let leadImageTintColor {
            navBar.leadingImage.tintColor = leadImageTintColor
        }
        if let trailingImageTintColor {
            navBar.trailingImage.tintColor = trailingImageTintColor
        }
        if let trailingLeadImageTintColor {
            navBar.trailingLeadingImage.tintColor = trailingLeadImageTintColor
        }
        if let trailingImage = UIImage(named: trailingImage) {
            navBar.trailingImage.image = trailingImage
        }
        else {
            navBar.trailingImage.image = UIImage(systemName: trailingImage)
        }
        if let trailingLeadImage = UIImage(named: trailingLeadImage) {
            navBar.trailingLeadingImage.image = trailingLeadImage
        }
        else {
            navBar.trailingLeadingImage.image = UIImage(systemName: trailingLeadImage)
        }
//        navBar.trailingImage.image = UIImage(named: trailingImage)
//        navBar.trailingLeadingImage.image = UIImage(named: trailingLeadImage)
        DispatchQueue.main.async {
            navBar.frame = parentView.bounds
            if let parentStackView = parentView as? UIStackView{
                if insert{
                    parentStackView.insertArrangedSubview(navBar, at: 0)
                }
                else{
                    parentStackView.addArrangedSubview(navBar)
                }
            }
            else{
                parentView.addSubview(navBar)
            }
        }
        return navBar
    }
    
    private func getMenu(actions: [UIAction]) -> UIMenu {
        return UIMenu(title: "", children: actions)
    }
    
    @IBAction func leadBtn(_ sender: Any) {
        if let action = action{
            action(0, self)
        }
    }
    
    @IBAction func trailingLeadBtn(_ sender: Any) {
        if let action = action{
            action(1, self)
        }
    }
    
    @IBAction func trailingBtn(_ sender: Any) {
        if let action = action{
            action(2, self)
        }
        
    }
    
    
}
