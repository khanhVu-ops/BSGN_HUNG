//
//  DoctorProfileTableViewCell.swift
//  BSGNProject
//
//  Created by Khánh Vũ on 24/12/24.
//

import UIKit

class DoctorProfileTableViewCell: BaseTableViewCell {

    @IBOutlet weak var bgrView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgrView.backgroundColor = UIColor(hex: "#D7E6DF")
        bgrView.setCornerRadius(30, corners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
