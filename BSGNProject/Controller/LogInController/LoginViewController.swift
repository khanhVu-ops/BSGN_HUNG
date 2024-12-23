//
//  LoginViewController.swift
//  BSGNProject
//
//  Created by Linh Thai on 13/08/2024.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet private weak var passWordTextField: UITextField!
    @IBOutlet private weak var passWordView: UIView!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var emailView: UIView!
    @IBOutlet private weak var introImageView: UIImageView!
    @IBOutlet private var hotlineButton: UIButton!
    @IBOutlet private var translateButton: UIButton!
    @IBOutlet private var continueLoginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar(with: "", with: false)
        self.navigationController?.navigationBar.backgroundColor = .clear
        view.sendSubviewToBack(introImageView)
        
        
        emailTextField.delegate = self
        
        emailView.layer.cornerRadius = 10
        passWordView.layer.cornerRadius = 10
        
        continueLoginButton.titleLabel?.font = UIFont(name: "NunitoSans-SemiBold", size: 17)
        continueLoginButton.layer.opacity = 0.3
        continueLoginButton.setTitleColor(.white, for: .disabled)
        continueLoginButton.isEnabled = false
        
        let text = "Hotline 1900 6036 893"
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: 7))

        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 44/255, green: 134/255, blue: 103/255, alpha: 1), range: NSRange(location: 8, length: 11))
        
        if let font = UIFont(name: "NunitoSans-SemiBold", size: 17) {
            attributedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: attributedString.length))
        }
        
        hotlineButton.setAttributedTitle(attributedString, for: .normal)
        hotlineButton.titleLabel?.font = UIFont(name: "NunitoSans-SemiBold", size: 17)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)
        createDoneButton()
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        emailView.layer.borderColor = UIColor(red: 44/255, green: 134/255, blue: 103/255, alpha: 1).cgColor
        emailView.layer.borderWidth = 1.5
        passWordView.layer.borderColor = UIColor(red: 44/255, green: 134/255, blue: 103/255, alpha: 1).cgColor
        passWordView.layer.borderWidth = 1.5
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        emailView.layer.borderColor = UIColor(red: 238/255, green: 239/255, blue: 244/255, alpha: 1).cgColor
        emailView.layer.borderWidth = 1
        passWordView.layer.borderColor = UIColor(red: 238/255, green: 239/255, blue: 244/255, alpha: 1).cgColor
        passWordView.layer.borderWidth = 1
    }
    //Hàm xử lý textField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let currentText = emailTextField.text {
            if (currentText.count > 2
//                && updatedText.first != "0" && updatedText.allSatisfy({$0.isNumber})) || (updatedText.count == 10 && updatedText.first == "0" && updatedText.allSatisfy({$0.isNumber})
                ) {
                continueLoginButton.layer.opacity = 1
                continueLoginButton.isEnabled = true
            } else {
                continueLoginButton.layer.opacity = 0.3
                continueLoginButton.isEnabled = false
                continueLoginButton.setTitleColor(.white, for: .disabled)
            }
        }
        return true
    }
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
    }
    @objc func keyboardWillHide(_ notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {

        }
    }
    
    @IBAction func didTapCustomButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapLoginButton(_ sender: Any) {
        loginAndFetchUserAttributes(email: emailTextField.text ?? "", password: passWordTextField.text ?? "")
    }

 
    @IBAction func buttonTapped() {
        continueLoginButton.layer.opacity = 0.3
        continueLoginButton.isEnabled = false
        continueLoginButton.setTitleColor(.white, for: .disabled)
    }
    func createDoneButton() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            
        toolbar.items = [flexibleSpace, doneButton]
            
        emailTextField.inputAccessoryView = toolbar
        passWordTextField.inputAccessoryView = toolbar
    }

    @objc func doneButtonTapped() {
            view.endEditing(true)
    }
    func loginAndFetchUserAttributes(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Login failed: \(error.localizedDescription)")
                return
            }
            
            guard let userId = authResult?.user.uid else { return }
            let ref = Database.database().reference()
            
            ref.child("users").child("doctors").child(userId).observeSingleEvent(of: .value) { (snapshot) in
                if snapshot.exists() {

                    self.fetchDoctorAttributes(userId: userId)
                    let Vc = DoctorHomeViewController()
                    Vc.navigationController?.navigationBar.isHidden = true
                    self.navigationController?.viewControllers = [Vc]
                } else {
                    ref.child("users").child("patients").child(userId).observeSingleEvent(of: .value) { (snapshot) in
                        if snapshot.exists() {
                            self.fetchPatientAttributes(userId: userId)
                            let VC = TabbarController()
                            VC.navigationController?.navigationBar.isHidden = true
                            self.navigationController?.viewControllers = [VC]
                        } else {
                            print("User data not found in either doctors or patients.")
                        }
                    }
                }
            }
        }
    }

    func fetchDoctorAttributes(userId: String) {
        let ref = Database.database().reference()
        ref.child("users").child("doctors").child(userId).observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.value as? [String: Any] else {
                print("Doctor data not found.")
                return
            }
            
            print("Doctor's attributes:")
            print("First Name: \(data["firstName"] ?? "")")
            print("Last Name: \(data["lastName"] ?? "")")
            print("Date of Birth: \(data["dateOfBirth"] ?? "")")
            print("Gender: \(data["gender"] ?? "")")
            print("Phone Number: \(data["phoneNumber"] ?? "")")
            print("Uni/College: \(data["education"] ?? "")")
            print("District: \(data["district"] ?? "")")
            print("City: \(data["city"] ?? "")")
            print("Street: \(data["street"] ?? "")")
            print("Address: \(data["address"] ?? "")")
            print("Degree: \(data["degree"] ?? "")")
            print("Training Place: \(data["training_place"] ?? "")")
            print("Major: \(data["major"] ?? "")")
            print("Avatar: \(data["avatar"] ?? "")")
            print("Balance: \(data["balance"] ?? "")")
        }
    }

    func fetchPatientAttributes(userId: String) {
        let ref = Database.database().reference()
        ref.child("users").child("patients").child(userId).observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.value as? [String: Any] else {
                print("Patient data not found.")
                return
            }
            
            print("Patient's attributes:")
            print("First Name: \(data["name"] ?? "")")
            print("Last Name: \(data["lastName"] ?? "")")
            print("Date of Birth: \(data["dateOfBirth"] ?? "")")
            print("Gender: \(data["sex"] ?? "")")
            print("Phone Number: \(data["phoneNumber"] ?? "")")
            print("District: \(data["district"] ?? "")")
            print("Province: \(data["province"] ?? "")")
            print("xa: \(data["xa"] ?? "")")
            print("Address: \(data["address"] ?? "")")
            print("Blood Name: \(data["blood"] ?? "")")
        }
    }
}
