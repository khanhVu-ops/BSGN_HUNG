//
//  DoctorHomeViewController.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 22/10/24.
//

import UIKit
import FirebaseAuth

enum DoctorHomeCellType: CaseIterable {

    case doctorHome
    case doctorHomeAction
    case none
    case doctorArticle

    static func returnValueFromInt(value: Int) -> DoctorHomeCellType {
        return DoctorHomeCellType.allCases[value]
    }
}

class DoctorHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet private weak var doctorHomeTableView: UITableView!
//    var doctorHomeCellType: [DoctorHomeCellType] = [
//        .doctorHome,
//        .doctorHomeAction
//    ]
//    private var avatarImageView: UIImageView?
    
    var doctorName: String = ""
    var avatarURL: String = ""
    var selectedImage: UIImage? = UIImage(named: "default_doctor")
    lazy var imagePicker: ImagePicker = {
        let picker = ImagePicker(presentationController: self.navigationController, delegate: self)
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        doctorHomeTableView.delegate = self
        doctorHomeTableView.dataSource = self
        doctorHomeTableView.registerNib(cellType: DoctorHomeTableViewCell.self)
        doctorHomeTableView.registerNib(cellType: DoctorHomeActionTableViewCell.self)
        doctorHomeTableView.registerNib(cellType: DoctorArticleTableViewCell.self)
        doctorHomeTableView.backgroundColor = .clear
        setupUI()
        fetchDoctorProfile()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func fetchDoctorProfile() {
        guard let currentUser = Auth.auth().currentUser else {
            print("No user is logged in.")
            return
        }
        
        GlobalService.shared.fetchDoctorProfile(uid: currentUser.uid) { [weak self] result in
            switch result {
            case .success(let (avatarURL, name)):
                self?.avatarURL = avatarURL
                self?.doctorName = name
                DispatchQueue.main.async {
                    self?.doctorHomeTableView.reloadData()
                }
                
            case .failure(let error):
                print("Failed to fetch doctor profile: \(error.localizedDescription)")
            }
        }
    }
    func setting() {
        view.backgroundColor = .clear
        print("setting")
        
        
    }
    func setupUI() {
        if let backgroundImage = UIImage(named: "docback")?.cgImage {
            self.view.layer.contents = backgroundImage
            self.view.layer.contentsGravity = .resizeAspectFill
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DoctorHomeCellType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch DoctorHomeCellType.returnValueFromInt(value: indexPath.row) {
        case .doctorHome:
            let cell = doctorHomeTableView.dequeue(cellType: DoctorHomeTableViewCell.self, for: indexPath)
            cell.parentViewController = self
            cell.doctorAvatarImageView.image = selectedImage
            cell.doctorAvatarImageView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
            cell.doctorAvatarImageView.addGestureRecognizer(tapGesture)
            cell.configureCell(avatarURL: avatarURL, name: doctorName)
            cell.backgroundColor = .clear
            return cell
            
        case .doctorHomeAction:
            let cell = doctorHomeTableView.dequeue(cellType: DoctorHomeActionTableViewCell.self, for: indexPath)
            cell.addBookedButtonTarget(target: self, action: #selector(bookedButtonTapped))
            cell.addAccountButtonTarget(target: self, action: #selector(accountButtonTapped))
            cell.addBoodedHistoryButtonTarget(target: self, action: #selector(hisotryTapped))
            cell.layer.cornerRadius = 15
            cell.clipsToBounds = true
            return cell
        case .doctorArticle:
            let cell = doctorHomeTableView.dequeue(cellType: DoctorArticleTableViewCell.self, for: indexPath)
            cell.backgroundColor = .clear
            return cell
        case .none:
            let cell = UITableViewCell()
            cell.backgroundColor = .clear
            let view = UIView()
            view.backgroundColor = .clear
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch DoctorHomeCellType.returnValueFromInt(value: indexPath.row) {
        case .doctorHome:
            return 250
        case .doctorHomeAction:
            return view.bounds.height / 5
        case .doctorArticle:
            return 700
        case .none:
            return 10
        }
    }
    
    @objc private func accountButtonTapped() {
        GlobalService.shared.loadDoctorWithID(doctorID: Auth.auth().currentUser!.uid) { Result in
            let vc = DoctorProfileViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            vc.setupNavigationBar(with: "Tài khoản", with: false)
            
        }
        
    }
    @objc func didTapImageView() {

        // Sử dụng ImagePickerHelper
        imagePicker.present(for: .photoLibrary, title: "Photos")
    }
    @objc private func bookedButtonTapped() {
        let vc = BookedPatientListViewController()
        navigationController?.pushViewController(vc, animated: true)
        vc.setupNavigationBar(with: "Các ca khám hiện có", with: false)
    }
    
    @objc private func hisotryTapped() {
        
        let vc = DoctorHistoryViewController()
        navigationController?.pushViewController(vc, animated: true)
        vc.setupNavigationBar(with: "Lịch sử", with: false)
    }
    
    @objc private func balanceButtonTapped() {
        
    }
    
}


extension DoctorHomeViewController: ImagePickerDelegate {
    func didSelectFile(fileURL: URL, fileName: String) {
        
    }
    
    func didSelect(image: UIImage?) {
        guard let image = image else {
            return
        }
        self.selectedImage = image
        self.doctorHomeTableView.reloadData()

    }
}
