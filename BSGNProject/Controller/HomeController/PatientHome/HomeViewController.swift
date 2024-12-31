//
//  HomeViewController.swift
//  BSGNProject
//
//  Created by Linh Thai on 16/08/2024.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

enum cellSeperate {
    case book
    case article
    case promotion
    case doctor
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ArticleTableViewCellDelegate, PromotionTableViewCellDelegate {
    
    
    var HomeCells: [cellSeperate] = [
        .book,
        .article,
        .promotion,
        .doctor
    ]
    
    @IBOutlet private var statusLabel: UILabel!
    @IBOutlet private var nameAccLabel: UILabel!
    @IBOutlet private var avatarImageView: UIButton!
    @IBOutlet private var infoButton: UIButton!
    @IBOutlet private var personalImageView: UIImageView!
    @IBOutlet private var homeTableView: UITableView!
    
    var currentUser: Patient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setupUI() {
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.registerNib(cellType: ArticleTableViewCell.self)
        homeTableView.registerNib(cellType: PromotionTableViewCell.self)
        homeTableView.registerNib(cellType: DoctorTableViewCell.self)
        homeTableView.registerNib(cellType: BookTableViewCell.self)
        homeTableView.layer.cornerRadius = 16
        if let userID = Auth.auth().currentUser?.uid {
            GlobalService.shared.fetchUserData(uid: userID, isDoctor: false) { Result in
                switch Result {
                case .success(let user):
                    self.currentUser = (user as! Patient)
                case .failure(let error):
                    print(error)
                    print("============================")
                }
            }
        }
        nameAccLabel.text = currentUser?.phoneNumber
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HomeCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch HomeCells[indexPath.row] {
            
        case .book:
            let cell = homeTableView.dequeue(cellType: BookTableViewCell.self, for: indexPath)
            cell.addTargetToBookingButton(target: self, action: #selector (didTapBook))
            return cell
            
        case .article:
            let cell = homeTableView.dequeue(cellType: ArticleTableViewCell.self, for: indexPath)
            cell.buttonAction = {
                [weak self] in
                self?.navigationArticleList(with: cell.homeData!.articleList)
            }
            cell.delegate = self
            return cell
            
        case .promotion:
            let cell = homeTableView.dequeue(cellType: PromotionTableViewCell.self, for: indexPath)
            cell.buttonAction = {
                [weak self] in
                self?.navigationPromotionList(with: cell.homeData!.promotionList)
                
            }
            cell.delegate = self
            return cell
        case .doctor:
            let cell = homeTableView.dequeue(cellType: DoctorTableViewCell.self, for: indexPath)
            cell.buttonAction = {
                [weak self] in
                self?.navigationDoctorList(with: cell.homeData!.doctorList)
                
            }
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return 243
        }
        else if indexPath.row == 1 || indexPath.row == 2 {
            return 268
        }
        else {
            return 155
        }
    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.backgroundColor = .clear
//        return headerView
//    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0
//    }
    func navigationArticleList(with articles: [Article]) {
        let newVC = ArticleListViewController(nibName: "ArticleListViewController", bundle: nil)
        newVC.configure(with: articles)
        self.navigationController?.pushViewController(newVC, animated: true)
        self.navigationController?.hidesBottomBarWhenPushed = true
        newVC.tabBarController?.tabBar.isHidden = true
        newVC.setupNavigationBar(with: "Tin tức", with: false)
    }
    func navigationPromotionList(with promotions: [Promotion]) {
        let newVC = PromotionListViewController(nibName: "PromotionListViewController", bundle: nil)
        newVC.configure(with: promotions)
        self.navigationController?.pushViewController(newVC, animated: true)
        newVC.tabBarController?.tabBar.isHidden = true
        newVC.setupNavigationBar(with: "Khuyến mãi", with: false)
    }
    func navigationDoctorList(with doctors: [Doctor]) {
        let newVC = DoctorListViewController(nibName: "DoctorListViewController", bundle: nil)
        newVC.configure(with: doctors)
        self.navigationController?.pushViewController(newVC, animated: true)
        newVC.tabBarController?.tabBar.isHidden = true
        newVC.setupNavigationBar(with: "Bác sỹ", with: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let newHeight = max(50, 150 - offsetY)
        personalImageView.frame.size.height = newHeight
        personalImageView.frame.origin.y = 0
    }
    
    
    @IBAction func didTapInfo(_ sender: Any) {
        let newVC = NewPatientFormViewController(nibName: "NewPatientFormViewController", bundle: nil)
        self.navigationController?.pushViewController(newVC, animated: true)
        newVC.setupNavigationBar(with: "Thông tin cá nhân", with: false)
    }
    func upadteAvatar() {
        avatarImageView.layer.cornerRadius = 21
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        
    }
    func collectionViewCellDidSelectItem(at indexPath: IndexPath, in cell: ArticleTableViewCell) {
        let newVC = DetailWebViewController(nibName: "DetailWebViewController", bundle: nil)
        newVC.configure(with: cell.homeData?.articleList[indexPath.row].link ?? "")
        self.navigationController?.pushViewController(newVC, animated: true)
        newVC.tabBarController?.tabBar.isHidden = true
        newVC.setupNavigationBar(with: "Chi tiết Tin tức", with: true)
    }
    func promotionCollectionViewCellDidSelectItem(at indexPath: IndexPath, in cell: PromotionTableViewCell) {
        let newVC = DetailWebViewController(nibName: "DetailWebViewController", bundle: nil)
        newVC.configure(with: cell.homeData?.promotionList[indexPath.row].link ?? "")
        self.navigationController?.pushViewController(newVC, animated: true)
        newVC.tabBarController?.tabBar.isHidden = true
        newVC.setupNavigationBar(with: "Chi tiết Khuyến mãi", with: true)
    }
    @objc func didTapBook() {
        guard Global.patient?.isInAppointment == 0 else {
            ToastApp.show("Bạn đang trong cuộc hẹn, không thể đặt thêm!")
            return
        }
        let bookVC = PatientBookViewController(nibName: "PatientBookViewController", bundle: nil)
        self.navigationController?.pushViewController(bookVC, animated: true)
        bookVC.setupNavigationBar(with: "", with: false)
        bookVC.navigationController?.navigationBar.backgroundColor = .clear
        GlobalService.appointmentData["patientID"] = Auth.auth().currentUser?.uid
        let userRef = Database.database().reference()
            .child("users")
            .child("patients")
            .child(Auth.auth().currentUser?.uid ?? "")
            .child("name")

        userRef.observeSingleEvent(of: .value) { snapshot in
            if let firstName = snapshot.value as? String {
                GlobalService.appointmentData["patientName"] = firstName
                print("Patient name updated: \(firstName)")
            } else {
                print("Failed to retrieve patient's first name")
            }
        }
        
    }
}
