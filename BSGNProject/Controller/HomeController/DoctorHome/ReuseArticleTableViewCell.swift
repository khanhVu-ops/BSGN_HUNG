//
//  ReuseArticleTableViewCell.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 5/11/24.
//

import UIKit

class ReuseArticleTableViewCell: UITableViewCell, SummaryMethod {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var articleImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        borderView.backgroundColor = UIColor(hex: "#D7E6DF")
        borderView._cornerRadius = 20
        borderView.layer.masksToBounds = true
    }
    
    public func configure(with article: Article) {
        dateLabel.text = article.created_at
        categoryLabel.text = article.category_name
        titleLabel.text = article.title
        articleImageView.image = UIImage(named: article.picture)
    }
}
