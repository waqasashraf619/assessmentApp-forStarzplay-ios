//
//  PlayerViewModel.swift
//  assessmentApp
//
//  Created by Waqas Ashraf on 9/4/24.
//

import Foundation

class PlayerViewModel: PlayerViewModelInterface {
    
    private var fileUrl: String?
    var decodedFileString: Bindable<String>
    
    init(fileUrl: String? = nil, decodedFileString: Bindable<String> = Bindable<String>()) {
        self.fileUrl = fileUrl
        self.decodedFileString = decodedFileString
    }
    
    func openMediaFile() {
        guard var fileUrl, let url = URL(string: fileUrl.replacingOccurrences(of: ".mp4", with: ".m3u8")) else { return }
        DispatchQueue.global(qos: .background).async {
            do {
                let fileContents = try String(contentsOf: url, encoding: .ascii)
                print("File contents fetched successfully: \(fileContents)")
                let m3u8COunt: Int = fileUrl.components(separatedBy: ".m3u8").count - 1
                if m3u8COunt < 1 {
                    fileUrl = fileUrl.replacingOccurrences(of: ".m3u8", with: ".mp4")
                }
                self.decodedFileString.value = fileUrl
            } catch {
                print("Some issue occurred: \(error.localizedDescription)")
                fileUrl = fileUrl.replacingOccurrences(of: ".m3u8", with: ".mp4")
                self.decodedFileString.value = fileUrl
            }
        }
        
    }
    
}

protocol PlayerViewModelInterface {
    
    var decodedFileString: Bindable<String> { get set }
    func openMediaFile()
    
}
