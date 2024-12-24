//
//  MoreTabTableViewCell.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 2/10/24.
//

import UIKit
import FirebaseAuth

class MoreTabTableViewCell: BaseTableViewCell, SummaryMethod {

    @IBOutlet private weak var logOutButton: UIButton!
    @IBOutlet private weak var policyButton: UIButton!
    @IBOutlet private weak var supportCenterButton: UIButton!
    @IBOutlet private weak var changeAddressButton: UIButton!
    @IBOutlet private weak var paymentButton: UIButton!
    @IBOutlet private weak var settingButton: UIButton!
    @IBOutlet private weak var userRabkButton: UIButton!
    @IBOutlet private weak var rewriteButton: UIButton!
    @IBOutlet private weak var rateButton: UIButton!
    @IBOutlet private weak var avatarLabel: UIImageView!
    @IBOutlet private weak var nameAccountLabel: UILabel!
    
    weak var delegate: LogoutCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupShadow()
        setupUI()
    }
    private func setupShadow() {
        rateButton.layer.shadowColor = UIColor.black.cgColor
        rateButton.layer.shadowOpacity = 0.3
        rateButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        rateButton.layer.shadowRadius = 10
        settingButton.layer.shadowColor = UIColor.black.cgColor
        settingButton.layer.shadowOpacity = 0.3
        settingButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        settingButton.layer.shadowRadius = 10
        userRabkButton.layer.shadowColor = UIColor.black.cgColor
        userRabkButton.layer.shadowOpacity = 0.3
        userRabkButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        userRabkButton.layer.shadowRadius = 10
        logOutButton.layer.shadowColor = UIColor.black.cgColor
        logOutButton.layer.shadowOpacity = 0.3
        logOutButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        logOutButton.layer.shadowRadius = 10
    }
    func setupUI() {
        rewriteButton.setTitle("", for: .normal)
        paymentButton.setTitle("", for: .normal)
        changeAddressButton.setTitle("", for: .normal)
        supportCenterButton.setTitle("", for: .normal)
        policyButton.setTitle("", for: .normal)
        rateButton.backgroundColor = .white
        rateButton.layer.cornerRadius = 10
        avatarLabel.layer.cornerRadius = avatarLabel.frame.height / 2
        avatarLabel.clipsToBounds = true
        avatarLabel.layer.borderColor = UIColor.gray.cgColor
        avatarLabel.layer.borderWidth = 0.5
    }
    @IBAction func signOutTapped(_ sender: Any) {
        delegate?.didTapLogout()
    }
}
protocol LogoutCellDelegate: AnyObject {
    func didTapLogout()
}
