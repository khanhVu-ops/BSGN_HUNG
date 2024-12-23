//
//  PatientBookViewController.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 30/10/24.
//

import UIKit

class PatientBookViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return majorData.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        majorTextField.text = majorData[row]
        GlobalService.appointmentData["specialtyID"] = row + 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return majorData[row]
    }
    

    @IBOutlet private weak var findButton: UIButton!
    @IBOutlet private weak var detailMedicalLabel: UILabel!
    @IBOutlet private weak var majorTextField: UITextField!
    @IBOutlet private weak var backgroundImageVIew: UIImageView!
    @IBOutlet private weak var majorPickerView: UIPickerView!
    
    private let majorData: [String] = ["Tim mạch", "Da liễu", "Thần kinh", "Nhi khoa", "Chỉnh hình", "Nhãn khoa", "Tiêu hóa", "Hô hấp", "Sản khoa", "Nội tiết"]
    private var keyboardTextFields: UITextField!
     
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    private func setupUI() {
        majorPickerView.delegate = self
        majorPickerView.dataSource = self
        majorPickerView.isHidden = true
        majorTextField.inputView = majorPickerView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPickerView))
        majorTextField.addGestureRecognizer(tapGesture)
        
        keyboardTextFields = UITextField()
        keyboardTextFields.placeholder = "Mô tả"
        keyboardTextFields.frame = CGRect(x: 0, y: view.bounds.height + 50, width: view.bounds.width + 10, height: 34)
        keyboardTextFields.layer.cornerRadius = 5
        keyboardTextFields.layer.shadowColor = UIColor.black.cgColor
        keyboardTextFields.layer.shadowOffset = CGSize(width: 0, height: 1)
        keyboardTextFields.layer.shadowRadius = 1
        keyboardTextFields.layer.shadowOpacity = 0.5
        
        view.addSubview(keyboardTextFields)
        keyboardTextFields.delegate = self
        keyboardTextFields.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        

        
        let shadowLayer = CAShapeLayer()
        
        shadowLayer.path = UIBezierPath(roundedRect: detailMedicalLabel.bounds, cornerRadius: 10).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowRadius = 3
        
        detailMedicalLabel.layer.insertSublayer(shadowLayer, at: 0)
        shadowLayer.opacity = 0
        detailMedicalLabel.layer.borderColor = UIColor.gray.cgColor
        detailMedicalLabel.layer.borderWidth = 0.4
        detailMedicalLabel.layer.cornerRadius = 10
        findButton.layer.shadowColor = UIColor.black.cgColor
        findButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        findButton.layer.shadowRadius = 4
        findButton.layer.shadowOpacity = 0.5
        
        let labelTapGesture = UITapGestureRecognizer(target: self, action: #selector(showKeyboard))
        detailMedicalLabel.isUserInteractionEnabled = true
        detailMedicalLabel.addGestureRecognizer(labelTapGesture)
        
        addDoneButtonToKeyboard()
    }
    func addDoneButtonToPickerView() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Nút Done
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissPickerView))
        
        // Khoảng trắng để đẩy nút Done sang phải
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        
        // Gắn toolbar vào inputAccessoryView của UITextField
        majorTextField.inputAccessoryView = toolbar
    }
    
    
    // MARK: - UIPickerViewDelegate & UIPickerViewDataSource
    @objc private func dismissPickerView() {
        if majorPickerView.isHidden {
            UIView.animate(withDuration: 0.1) {
                self.majorPickerView.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.1) {
                self.majorPickerView.isHidden = true
            }
        }
    }
    
    @objc private func showKeyboard() {
        print("111")
        self.keyboardTextFields.becomeFirstResponder()
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            // Di chuyển textField lên trên bàn phím
            UIView.animate(withDuration: 0.3) {
                self.keyboardTextFields.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight - 60)
            }
        }
    }
    func addDoneButtonToKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        toolbar.items = [flexSpace, doneButton]
        
        keyboardTextFields.inputAccessoryView = toolbar
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.3) {
            self.keyboardTextFields.transform = .identity
        }
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        detailMedicalLabel.text = keyboardTextFields.text
    }
    @IBAction func didTapFind(_ sender: Any) {
//        let alert = UIAlertController(title: "Thông báo", message: "Bạn có chắc chắn muốn tìm kiếm?", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
//            self.present(<#T##viewControllerToPresent: UIViewController##UIViewController#>, animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alert.addAction(okAction)
//        alert.addAction(cancelAction)
//        present(alert, animated: true, completion: nil)
        if let navController = self.navigationController {
            let mapVC = PositionViewController()
            navController.pushViewController(mapVC, animated: true)
            mapVC.setupNavigationBar(with: "Xác nhận vị trí của bạn", with: false)
            GlobalService.appointmentData["specialty"] = majorTextField.text

            GlobalService.appointmentData["symtoms"] =  detailMedicalLabel.text
        } else {
            print("Navigation controller is nil")
        }

        
    }
}
