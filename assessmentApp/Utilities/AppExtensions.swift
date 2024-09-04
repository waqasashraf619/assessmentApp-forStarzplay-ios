//
//  AppExtensions.swift
//  assessmentApp
//
//  Created by Waqas Ashraf on 9/2/24.
//

import UIKit
import SDWebImage

extension UIImageView{
    
    func setRemoteImage(urlString: String?, placeholderImage: UIImage? = .placeholder_img){
        print("Input image url: \(String(describing: urlString))")
        self.sd_setImage(with: URL(string: "\(imageBaseUrl)\(urlString ?? "")"), placeholderImage: placeholderImage)
    }
    
}

extension UIViewController {
    
    func animateView(){
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.view.layoutIfNeeded()
            self?.view.setNeedsLayout()
        })
    }
    
}

extension UIStackView{
    
    func removeAllSubviews(){
        for view in self.arrangedSubviews{
            view.removeFromSuperview()
        }
        self.layoutIfNeeded()
    }
    
}

public protocol NibInstantiatable {
    
    static func nibName() -> String
    
}

extension NibInstantiatable {
    
    static func nibName() -> String {
        return String(describing: self)
    }
    
}

extension NibInstantiatable where Self: UIView {
    
    static func fromNib() -> Self {
        
        let bundle = Bundle(for: self)
        let nib = bundle.loadNibNamed(nibName(), owner: self, options: nil)
        
        return nib!.first as! Self
        
    }
    
}
