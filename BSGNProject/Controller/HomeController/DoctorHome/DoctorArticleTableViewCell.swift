//
//  DoctorArticleTableViewCell.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 5/11/24.
//

import UIKit

class DoctorArticleTableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate, SummaryMethod {

    @IBOutlet private weak var doctorArticleTableView: UITableView!
    
    let customArticle : [Article] = [
        Article(
            id: 824,
            category_id: 1,
            title: "10 Tips for a Healthier Lifestyle",
            slug: "social-media-impact",
            picture: "",
            picture_caption: "In-depth look",
            created_at: "2024-04-14 07:05:10",
            category_name: "Technology",
            link: "https://example.com/2",
            detail: "A guide to achieving a healthier lifestyle through simple daily habits."
        ),
        Article(
            id: 750,
            category_id: 1,
            title: "The Future of AI in Healthcare",
            slug: "ai-healthcare",
            picture: "",
            picture_caption: "Exploring the topic",
            created_at: "2024-07-16 07:05:10",
            category_name: "Technology",
            link: "https://example.com/1",
            detail: "A guide to achieving a healthier lifestyle through simple daily habits."
        ),
        Article(
            id: 468,
            category_id: 4,
            title: "10 Tips for a Healthier Lifestyle",
            slug: "quantum-computing",
            picture: "",
            picture_caption: "A new perspective",
            created_at: "2024-06-16 07:05:10",
            category_name: "Lifestyle",
            link: "https://example.com/5",
            detail: "A guide to achieving a healthier lifestyle through simple daily habits."
        )
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    private func setupUI() {
        contentView.backgroundColor = .clear
        doctorArticleTableView.dataSource = self
        doctorArticleTableView.delegate = self
        doctorArticleTableView.registerNib(cellType: ReuseArticleTableViewCell.self)
        doctorArticleTableView.backgroundColor = .clear
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return customArticle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = doctorArticleTableView.dequeue(cellType: ReuseArticleTableViewCell.self, for: indexPath)
        cell.configure(with: customArticle[indexPath.section])
        cell.layer.cornerRadius = 15
        cell.clipsToBounds = true
        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
