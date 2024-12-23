//
//  BookTableViewCell.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 2/10/24.
//

import UIKit

class BookTableViewCell: UITableViewCell, SummaryMethod {
    
    @IBOutlet private weak var findDoctorButton: UIButton!
    @IBOutlet private weak var pharmacyButton: UIButton!
    @IBOutlet private weak var bookingButton: UIButton!
    
    private var homeData: HomeData?
    let home = HomeService()
    override func awakeFromNib() {
        super.awakeFromNib()
        setupShadow()
        home.fetchData(success: { data in
            self.homeData = data
            self.updateUI()
        }
                           , failure: { code, message in
            print("Có lỗi xảy ra: \(code) - \(message)")
        }, path: .homePath)
    }
    private func updateUI() {
        
    }
    private func setupShadow() {
        findDoctorButton.layer.shadowColor = UIColor.black.cgColor
        findDoctorButton.layer.shadowRadius = 10
        findDoctorButton.layer.shadowOpacity = 0.3
        findDoctorButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        pharmacyButton.layer.shadowColor = UIColor.black.cgColor
        pharmacyButton.layer.shadowRadius = 10
        pharmacyButton.layer.shadowOpacity = 0.3
        pharmacyButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        bookingButton.layer.shadowColor = UIColor.black.cgColor
        bookingButton.layer.shadowRadius = 10
        bookingButton.layer.shadowOpacity = 0.3
        bookingButton.layer.shadowOffset = CGSize(width: 4, height: 4)
    }
    func addTargetToBookingButton(target: Any, action: Selector) {
        bookingButton.addTarget(target, action: action, for: .touchUpInside)
    }
    func addTargetToFindDoctorButton(target: Any, action: Selector) {
        findDoctorButton.addTarget(target, action: action, for: .touchUpInside)
    }
    func addTargetToPharmacyButton(target: Any, action: Selector) {
        pharmacyButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
