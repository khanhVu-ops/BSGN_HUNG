//
//  NewDoctorFormTableViewCell.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 4/12/24.
//

import UIKit

class NewDoctorFormTableViewCell: UITableViewCell, SummaryMethod, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var studyTextField: UITextField!
    @IBOutlet weak var degreeTextField: UITextField!
    @IBOutlet weak var trainingPlaceTextField: UITextField!
    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var priceForOneHourTextField: UITextField!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    @IBOutlet weak var doneButton: UIButton!
    var majorID: Int?
    weak var delegate: NewDoctorFormCellDelegate?
    private let pickerView = UIPickerView()
    private let majorData: [String] = [
        "Tim mạch", "Da liễu", "Thần kinh", "Nhi khoa", "Chỉnh hình",
        "Nhãn khoa", "Tiêu hóa", "Hô hấp", "Sản khoa", "Nội tiết"
    ]
    override func awakeFromNib() {
        super.awakeFromNib()
        [nameTextField, lastNameTextField, dobTextField, phoneNumberTextField,
         addressTextField, studyTextField, degreeTextField,
         majorTextField, priceForOneHourTextField].forEach { textField in
            textField?.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
        
        validateFields()
        setupPickerView()
    }
    
    func validateFields() {
        let isFirstNameValid = !(nameTextField.text?.isEmpty ?? true)
        let isLastNameValid = !(lastNameTextField.text?.isEmpty ?? true)
        let isDobValid = !(dobTextField.text?.isEmpty ?? true)
        let isPhoneNumberValid = !(phoneNumberTextField.text?.isEmpty ?? true)
        let isAddressValid = !(addressTextField.text?.isEmpty ?? true)
        let isStudyValid = !(studyTextField.text?.isEmpty ?? true)
        let isDegreeValid = !(degreeTextField.text?.isEmpty ?? true)
        let isMajorValid = !(majorTextField.text?.isEmpty ?? true)
        let isPriceValid = !(priceForOneHourTextField.text?.isEmpty ?? true)
        
        let allFieldsValid = isFirstNameValid && isLastNameValid && isDobValid &&
            isPhoneNumberValid && isAddressValid && isStudyValid &&
            isDegreeValid && isMajorValid && isPriceValid
        
        doneButton.isEnabled = allFieldsValid
        doneButton.alpha = allFieldsValid ? 1.0 : 0.5
    }

    func addTargettoDoneButton(selector: Selector) {
        doneButton.addTarget(self, action: selector, for: .touchUpInside)
    }
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        let data: [String: Any] = [
            "firstName": nameTextField.text ?? "",
            "lastName": lastNameTextField.text ?? "",
            "dateOfBirth": dobTextField.text ?? "",
            "gender": genderSegment.selectedSegmentIndex == 0 ? "Male" : "Female",
            "phoneNumber": phoneNumberTextField.text ?? "",
            "address": addressTextField.text ?? "",
            "education": studyTextField.text ?? "",
            "degree": degreeTextField.text ?? "",
            "training_place": trainingPlaceTextField.text ?? "",
            "majorID": majorID ?? 0,
            "major": majorTextField.text ?? "",
            "price": Int(priceForOneHourTextField.text ?? "0") ?? 0
        ]
        delegate?.didTapDoneButton(with: data)
    }
    @objc private func textFieldDidChange(_ textField: UITextField) {
        validateFields()
    }
    private func setupPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // Gán pickerView làm inputView cho majorTextField
        majorTextField.inputView = pickerView
        
        // Tạo thanh công cụ (Toolbar) với nút "Done" để đóng pickerView
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissPicker))
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        majorTextField.inputAccessoryView = toolbar
    }
    
    @objc private func dismissPicker() {
        majorTextField.resignFirstResponder()
    }
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // PickerView chỉ có 1 cột
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return majorData.count // Số hàng = số phần tử trong majorData
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return majorData[row] // Hiển thị tên chuyên ngành
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        majorTextField.text = majorData[row] // Cập nhật text của majorTextField
        majorID = row + 1
    }
    
}
protocol NewDoctorFormCellDelegate: AnyObject {
    func didTapDoneButton(with data: [String: Any])
}

