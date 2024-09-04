//
//  FactoryService.swift
//  assessmentApp
//
//  Created by Waqas Ashraf on 9/2/24.
//

import Foundation

class ServicesInitilizationManager: ServicesInitilizationInterface {
    
    var listManager: AppPlistInterface
    var appVCs: AppUIViewControllersInteface
    
    init(listManager: AppPlistInterface, appVCs: AppUIViewControllersInteface) {
        self.listManager = listManager
        self.appVCs = appVCs
    }
    
}

protocol ServicesInitilizationInterface {
    
    var listManager: AppPlistInterface { get set }
    var appVCs: AppUIViewControllersInteface { get set }
    
}
