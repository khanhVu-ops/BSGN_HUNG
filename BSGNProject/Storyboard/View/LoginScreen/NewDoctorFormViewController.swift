//
//  NewDoctorFormViewController.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 4/12/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class NewDoctorFormViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewDoctorFormCellDelegate {
    @IBOutlet private weak var formTableView: UITableView!
    
    private let majorData: [String] = [
        "Tim mạch",
        "Da liễu",
        "Thần kinh",
        "Nhi khoa",
        "Chỉnh hình",
        "Nhãn khoa",
        "Tiêu hóa",
        "Hô hấp",
        "Sản khoa",
        "Nội tiết"
    ]
    
    var userInfo: [String: Any] = [
        "id": "",
        "firstName": "",
        "lastName": "",
        "dateOfBirth": "",
        "gender": "",
        "phoneNumber": "",
        "education": "",
        "district": "",
        "address": "",
        "degree": "",
        "training_place": "",
        "major": "",
        "majorID": "",
        "avatar": "0",
        "balance": 0,
        "price": 0,
        "typeOfAccount": 1,
        "isInAppointment": 0
    ]
    var selectedGenderIndex: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        formTableView.delegate = self
        formTableView.dataSource = self
        formTableView.registerNib(cellType: NewDoctorFormTableViewCell.self)
        userInfo["id"] = "\(Auth.auth().currentUser!.uid)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = formTableView.dequeue(cellType: NewDoctorFormTableViewCell.self, for: indexPath)
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1300
    }
    func didTapDoneButton(with data: [String: Any]) {
        userInfo.merge(data) { _, new in new }
        print("Updated userInfo: \(userInfo)")
        guard let user = Auth.auth().currentUser else { return }
        
        let ref = Database.database().reference().child("users").child("doctors").child(user.uid)
        ref.setValue(userInfo) { error, _ in
            if let error = error {
                print("Lỗi khi lưu thông tin: \(error.localizedDescription)")
                return
            }
        }
        let homeVC = LoginViewController()
        self.navigationController?.pushViewController(homeVC, animated: true)
        homeVC.navigationController?.navigationBar.isHidden = true
    }
}
