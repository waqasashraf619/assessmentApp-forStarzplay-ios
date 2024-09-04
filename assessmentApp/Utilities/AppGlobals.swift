//
//  AppGlobals.swift
//  assessmentApp
//
//  Created by Waqas Ashraf on 9/2/24.
//

import UIKit

enum UiSafeArea{
    case top
    case bottom
    case left
    case right
}


//MARK: GlobalMethods
func getSafeArea(safeAreaInset: UiSafeArea)-> CGFloat{
    if let safeArea = UIApplication.shared.windows.last(where: { $0.isKeyWindow }){
        switch safeAreaInset {
        case .top:
            return safeArea.safeAreaInsets.top
        case .bottom:
            return safeArea.safeAreaInsets.bottom
        case .left:
            return safeArea.safeAreaInsets.left
        case .right:
            return safeArea.safeAreaInsets.right
        }
    }
    else {
        return 0
    }
    
}

//MARK: GlobalVariables
var servicesInitilizationManager: ServicesInitilizationInterface?
