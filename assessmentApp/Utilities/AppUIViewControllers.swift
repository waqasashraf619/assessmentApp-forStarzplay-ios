//
//  AppUIViewControllers.swift
//  assessmentApp
//
//  Created by Waqas Ashraf on 9/2/24.
//

import UIKit

class AppUIViewControllers: AppUIViewControllersInteface {
    
    func tvShowDetailScreen(viewModel: TvShowDetailViewModelInteface = TvShowDetailViewModel()) -> TvShowDetailScreen {
        let sb = UIStoryboard(name: TvShowDetailScreen.identifier, bundle: nil)
        let vc = sb.instantiateViewController(identifier: TvShowDetailScreen.identifier) { coder in
            TvShowDetailScreen(coder: coder, viewModel: viewModel)
        }
        return vc
    }
    
    func playerScreen(viewModel: PlayerViewModelInterface = PlayerViewModel()) -> PlayerScreen {
        let sb = UIStoryboard(name: PlayerScreen.identifier, bundle: nil)
        let vc = sb.instantiateViewController(identifier: PlayerScreen.identifier) { coder in
            PlayerScreen(coder: coder, viewModel: viewModel)
        }
        return vc
    }
    
}

protocol AppUIViewControllersInteface {
    
    func tvShowDetailScreen(viewModel: TvShowDetailViewModelInteface) -> TvShowDetailScreen
    func playerScreen(viewModel: PlayerViewModelInterface) -> PlayerScreen
    
}
