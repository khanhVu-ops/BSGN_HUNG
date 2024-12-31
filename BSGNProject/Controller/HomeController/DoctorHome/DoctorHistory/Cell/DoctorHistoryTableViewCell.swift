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
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var cancelledButton: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        borderView.backgroundColor = UIColor(hex: "#D7E6DF")
        infoView.backgroundColor = UIColor(hex: "#A4E5C7")
        completedButton.isEnabled = false
        cancelledButton.isEnabled = false

    }

    func bind(_ item: Appointment) {
        completedButton.isHidden = item.status != "completed"
        cancelledButton.isHidden = item.status != "cancelled"
        nameLabel.text = item.patientName
        avatarImageView.loadAvatar(url: "")
    }
}
