//
//  SeasonTitleCell.swift
//  assessmentApp
//
//  Created by Waqas Ashraf on 9/2/24.
//

import UIKit

class SeasonTitleCell: UICollectionViewCell {
    
    static let identifier = "SeasonTitleCell"

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bottomLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(data: SeasonModel?){
        let isSelected = data?.isSelected == true
        titleLbl.text = "\(data?.name ?? "")     "
        bottomLine.backgroundColor = isSelected ? .clr_white_1 : .clear
        titleLbl.font = isSelected ? .systemFont(ofSize: 17, weight: .bold) : .systemFont(ofSize: 17, weight: .regular)
        titleLbl.textColor = isSelected ? .clr_white_1 : .clr_gray_1
    }

}
