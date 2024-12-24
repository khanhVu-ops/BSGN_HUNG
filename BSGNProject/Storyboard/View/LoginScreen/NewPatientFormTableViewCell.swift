//
//  NewPatientFormTableViewCell.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 17/12/24.
//

import UIKit

class NewPatientFormTableViewCell: BaseTableViewCell, SummaryMethod {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var bloodTextField: UITextField!
    @IBOutlet weak var idenTextField: UITextField!
    @IBOutlet weak var xaTextField: UITextField!
    @IBOutlet weak var districtTextField: UITextField!
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var sexSegment: UISegmentedControl!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    
    weak var delegate: NewPatientFormCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        [lastNameTextField, firstNameTextField, dobTextField, phoneNumberTextField, addressTextField, provinceTextField, districtTextField, xaTextField, idenTextField, bloodTextField].forEach { textField in
            textField?.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
        validateFields()
    }
    
    func validateFields() {
        let isFirstNameValid = firstNameTextField.text?.isEmpty ?? true
        let isLastNameValid = lastNameTextField.text?.isEmpty ?? true
        let isDobValid = dobTextField.text?.isEmpty ?? true
        let isPhoneNumberValid = phoneNumberTextField.text?.isEmpty ?? true
        let isAddressValid = addressTextField.text?.isEmpty ?? true
        let isProvinceValid = provinceTextField.text?.isEmpty ?? true
        let isDistrictValid = districtTextField.text?.isEmpty ?? true
        let isXaValid = xaTextField.text?.isEmpty ?? true
        let isIdenValid = idenTextField.text?.isEmpty ?? true
        let isBloodValid = bloodTextField.text?.isEmpty ?? true
        
        let allFieldsValid = !isFirstNameValid && !isLastNameValid && !isDobValid &&
        !isPhoneNumberValid && !isAddressValid && !isProvinceValid && !isDistrictValid && !isXaValid && !isIdenValid && !isBloodValid
        doneButton.isEnabled = allFieldsValid
        doneButton.alpha = allFieldsValid ? 1 : 0.5
    }
    @objc private func textFieldDidChange() {
        validateFields()
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        let data: [String: Any] = [
            "name": firstNameTextField.text ?? "",
            "lastName": lastNameTextField.text ?? "",
            "dateOfBirth": dobTextField.text ?? "",
            "sex": sexSegment.selectedSegmentIndex == 0 ? "Male" : "Female",
            "phoneNumber": phoneNumberTextField.text ?? "",
            "address": addressTextField.text ?? "",
            "province": provinceTextField.text ?? "",
            "district": districtTextField.text ?? "",
            "xa": xaTextField.text ?? "",
            "identifyNumber": idenTextField.text ?? "",
            "blood": bloodTextField.text ?? ""
        ]
        delegate?.didTapDoneButton(with: data)
    }
    
}
protocol NewPatientFormCellDelegate: AnyObject {
    func didTapDoneButton(with data: [String: Any])
}
