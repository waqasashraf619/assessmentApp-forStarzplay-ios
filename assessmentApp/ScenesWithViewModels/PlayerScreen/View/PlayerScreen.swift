//
//  PlayerScreen.swift
//  assessmentApp
//
//  Created by Waqas Ashraf on 9/4/24.
//

import UIKit
import AVKit

class PlayerScreen: AVPlayerViewController {
    
    static let identifier = "PlayerScreen"
    
    private var viewModel: PlayerViewModelInterface
    
    init?(coder: NSCoder, viewModel: PlayerViewModelInterface) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setupPlayer()
    }
    
    private func setupPlayer(){
        ActivityIndicator.shared.showActivityIndicator(view: view, topSpacing: getSafeArea(safeAreaInset: .top) + 30)
        viewModel.openMediaFile()
    }
    
    private func playVideoUrl(fileUrl: String?){
        guard let fileUrl, let url = URL(string: fileUrl) else { return }
        let mediaAsset = AVAsset(url: url)
        mediaAsset.loadTracks(withMediaType: .video) { [weak self] tracks, error in
            ActivityIndicator.shared.removeActivityIndicator()
            if let error {
                print("Error loading tracks: \(error.localizedDescription)")
            }
            if let tracks {
                let playerItem = AVPlayerItem(asset: mediaAsset)
                DispatchQueue.main.async {
                    self?.player = AVPlayer(playerItem: playerItem)
                    self?.player?.play()
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        player?.pause()
    }
    
    deinit {
        print("Player screen de-initialized")
    }
    
}

extension PlayerScreen {
    
    private func bindViewModel(){
        viewModel.decodedFileString.bind { [weak self] fileUrl in
            guard let fileUrl else {
                ActivityIndicator.shared.removeActivityIndicator()
                return
            }
            self?.playVideoUrl(fileUrl: fileUrl)
        }
    }
    
}
