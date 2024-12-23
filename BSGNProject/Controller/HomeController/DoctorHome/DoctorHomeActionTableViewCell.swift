//
//  DoctorHomeActionTableViewCell.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 22/10/24.
//

import UIKit

class DoctorHomeActionTableViewCell: UITableViewCell, SummaryMethod {

    @IBOutlet private weak var hotlineButton: UIButton!
    @IBOutlet private weak var balanceButton: UIButton!
    @IBOutlet private weak var boodedHistoryButton: UIButton!
    @IBOutlet private weak var boodkedButton: UIButton!
    @IBOutlet private weak var accountButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func addBookedButtonTarget(target: Any, action: Selector) {
        boodkedButton.addTarget(target, action: action, for: .touchUpInside)
    }
    func addBoodedHistoryButtonTarget(target: Any, action: Selector) {
        boodedHistoryButton.addTarget(target, action: action, for: .touchUpInside)
    }
    func addAccountButtonTarget(target: Any, action: Selector) {
        accountButton.addTarget(target, action: action, for: .touchUpInside)
    }
    func addBalanceButtonTarget(target: Any, action: Selector) {
        balanceButton.addTarget(target, action: action, for: .touchUpInside)
    }
    func addHotlineButtonTarget(target: Any, action: Selector) {
        hotlineButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
