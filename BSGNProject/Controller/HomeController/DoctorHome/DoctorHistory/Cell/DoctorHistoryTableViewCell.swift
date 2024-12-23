//
//  DoctorHistoryTableViewCell.swift
//  BSGNProject
//
//  Created by Khánh Vũ on 24/12/24.
//

import UIKit

class DoctorHistoryTableViewCell: BaseTableViewCell {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stateButton: UIButton!
    @IBOutlet weak var infoView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        borderView.backgroundColor = UIColor(hex: "#D7E6DF")
        infoView.backgroundColor = UIColor(hex: "#A4E5C7")
    }

    
}
