//
//  MoreTabViewController.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 2/10/24.
//

import UIKit
import FirebaseAuth

class MoreTabViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LogoutCellDelegate {
    

    @IBOutlet private weak var moreTabTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        moreTabTableView.delegate = self
        moreTabTableView.dataSource = self
        moreTabTableView.registerNib(cellType: MoreTabTableViewCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moreTabTableView.dequeue(cellType: MoreTabTableViewCell.self, for: indexPath)
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 800
    }
    
    func didTapLogout() {
        let alert = UIAlertController(title: "Đăng xuất", message: "Bạn có chắc chắn muốn đăng xuất?", preferredStyle: .alert)
        
        // Nút Xác nhận
        alert.addAction(UIAlertAction(title: "Đăng xuất", style: .destructive, handler: { _ in
            // Xử lý đăng xuất
            do {
                try Auth.auth().signOut()
                print("User logged out successfully.")
                
                // Điều hướng về màn hình đăng nhập
                let introViewController = IntroViewController()
                let nav = UIApplication.shared.windows.first?.rootViewController as? UINavigationController

                nav?.viewControllers = [introViewController]
            } catch let signOutError as NSError {
                print("Error signing out: \(signOutError.localizedDescription)")
            }
        }))
        
        // Nút Hủy bỏ
        alert.addAction(UIAlertAction(title: "Hủy", style: .cancel, handler: nil))
        
        // Hiển thị alert
        self.present(alert, animated: true, completion: nil)
    }
}
