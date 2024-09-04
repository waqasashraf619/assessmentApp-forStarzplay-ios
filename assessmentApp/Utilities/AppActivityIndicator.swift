//
//  AppActivityIndicator.swift
//  assessmentApp
//
//  Created by Waqas Ashraf on 9/2/24.
//

import UIKit

class ActivityIndicator{
    
    static let shared = ActivityIndicator()
    
    private init(){}
    
    private var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    private var backgroundView: UIView?
    
    func showActivityIndicator(view: UIView, showBackground: Bool = false, backgroundColor: UIColor? = nil, topSpacing: CGFloat = 0) {
        
        DispatchQueue.main.async {
            
            self.activityIndicatorView.backgroundColor = .clear
            
            if showBackground {
                self.backgroundView = UIView(frame: CGRect(x: 0, y: topSpacing, width: view.bounds.width, height: view.bounds.height))
                self.backgroundView?.backgroundColor = backgroundColor ?? .white
                if let backgroundView = self.backgroundView{
                    view.addSubview(backgroundView)
                }
            }
            else {
                self.backgroundView = UIView(frame: .init(x: 0, y: 0, width: 40, height: 40))
                self.backgroundView?.layer.cornerRadius = 20
                self.backgroundView?.center = .init(x: view.center.x, y: view.center.y + topSpacing)
                self.backgroundView?.backgroundColor = backgroundColor ?? .white
                if let backgroundView = self.backgroundView{
                    view.addSubview(backgroundView)
                }
            }
            
            self.activityIndicatorView.frame = CGRect(x: 0, y: topSpacing, width: view.bounds.width, height: view.bounds.height)
            self.activityIndicatorView.center = .init(x: view.center.x, y: view.center.y + topSpacing)
            view.addSubview(self.activityIndicatorView)
            self.activityIndicatorView.startAnimating()
        }
        
    }
    
    func showActivityIndicatorOnBottom(view: UIView){
        DispatchQueue.main.async {
            let safeAreaBottom = getSafeArea(safeAreaInset: .bottom)
            self.activityIndicatorView.frame = CGRect(x: view.center.x - 30, y: view.frame.height - 100 - safeAreaBottom, width: 60, height: 60)
            self.activityIndicatorView.layer.cornerRadius = 30
            self.activityIndicatorView.backgroundColor = .white
            view.addSubview(self.activityIndicatorView)
            self.activityIndicatorView.startAnimating()
        }
    }
    
    func removeActivityIndicator(){
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.removeFromSuperview()
            self.backgroundView?.removeFromSuperview()
            self.backgroundView = nil
        }
    }
    
    
}
