//
//  CommonHeaderView.swift
//  AdmicroHybridEvent
//
//  Created by Khanh Vu on 10/10/24.
//

import Foundation
import UIKit
import SnapKit

class CommonHeaderView: UIView {
    private lazy var icon: UIImageView = {
        let imv = UIImageView()
        return imv
    }()
    
    private lazy var titleLabel: UILabel = {
        return UILabel.build(font: .systemFont(ofSize: 16, weight: .semibold), color: .black, lines: 1, alignment: .left)
    }()
    
    private lazy var seeAllButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Xem tất cả", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        btn.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var titleStackView: UIStackView = {
        return UIStackView.build(axis: .horizontal, distribution: .fill, alignment: .center, spacing: 4, subViews: [icon, titleLabel])
    }()
    
    private lazy var containerStackView: UIStackView = {
        return UIStackView.build(axis: .horizontal, distribution: .equalSpacing, alignment: .center, spacing: 10, subViews: [titleStackView, seeAllButton])
    }()
    
    var onBtnTapped: (() -> Void)?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpUI()
    }
    
    func bind(icon: UIImage? = nil,
              title: String?,
              titleFont: UIFont = .systemFont(ofSize: 16, weight: .semibold),
              titleLine: Int = 1,
              titleColor: UIColor? = .black,
              btnTitle: String = "Xem tất cả",
              btnColor: UIColor? = .black,
              isShowBtn: Bool = false) {
        
        self.icon.isHidden = icon == nil
        self.icon.image = icon
        
        titleLabel.build(font: titleFont, color: titleColor, lines: titleLine, alignment: .left)
        titleLabel.text = title
        
        seeAllButton.isHidden = !isShowBtn
        seeAllButton.setTitle(btnTitle, for: .normal)
        seeAllButton.setTitleColor(btnColor, for: .normal)
    }
    
    func layout(top: CGFloat = 0, leading: CGFloat = 12, trailing: CGFloat = 12, bottom: CGFloat = 0, iconSize: CGFloat = 20) {
        containerStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(top)
            make.bottom.equalToSuperview().offset(bottom)
            make.leading.equalToSuperview().offset(leading)
            make.trailing.equalToSuperview().offset(trailing)
        }
        
        icon.snp.makeConstraints { make in
            make.width.equalTo(icon.snp.height)
            make.height.equalTo(iconSize)
        }
    }
}

private extension CommonHeaderView {
    func setUpUI() {
        addSubview(containerStackView)
    }
    
    @objc func btnTapped() {
        onBtnTapped?()
    }
}
