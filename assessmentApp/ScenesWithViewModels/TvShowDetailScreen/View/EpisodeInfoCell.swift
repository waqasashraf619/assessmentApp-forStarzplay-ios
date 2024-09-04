//
//  EpisodeInfoCell.swift
//  assessmentApp
//
//  Created by Waqas Ashraf on 9/3/24.
//

import UIKit

class EpisodeInfoCell: UITableViewCell {
    
    static let identifier = "EpisodeInfoCell"

    @IBOutlet weak var episodeImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    var closure: (()->())? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(data: EpisodeModel?){
        titleLbl.text = data?.titleDisplay
        episodeImage.setRemoteImage(urlString: data?.stillPath)
    }
    
    @IBAction func downloadBtn(_ sender: Any) {
        if let closure {
            closure()
        }
    }
    
}
