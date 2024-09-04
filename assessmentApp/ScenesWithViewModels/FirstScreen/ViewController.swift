//
//  ViewController.swift
//  assessmentApp
//
//  Created by Waqas Ashraf on 9/2/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupNavigationBar()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.navigateToRequiredScreen()
        }
        
    }
    
    private func navigateToRequiredScreen(){
        guard let vc = servicesInitilizationManager?.appVCs.tvShowDetailScreen(viewModel: TvShowDetailViewModel(showId: 62852)) else { return }
        self.show(vc, sender: self)
    }
    
    private func setupNavigationBar(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }

}

