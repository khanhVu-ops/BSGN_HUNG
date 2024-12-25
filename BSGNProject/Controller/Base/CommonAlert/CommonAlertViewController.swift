//
//  CommonAlertViewController.swift
//  AdmicroHybridEvent
//
//  Created by Khanh Vu on 23/9/24.
//

import UIKit

class CommonAlertViewController: UIViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var noteLabel: UILabel!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var lineVerticalView: UIView!
    @IBOutlet private weak var lineHorizontalView: UIView!
    @IBOutlet private weak var blurView: UIVisualEffectView!
    
    static func present(_ model: Model,
                        _ completion: EmptyClosure?,
                        cancel: EmptyClosure? = nil) {
        let vc = CommonAlertViewController(model: model)
        let topVC = UIApplication.getTopViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.onDoneClick = completion
        vc.onCancelClick = cancel
        if let nav = topVC?.navigationController {
            nav.present(vc, animated: true)
        } else {
            topVC?.present(vc, animated: true)
        }
    }
    
    private var model: Model
    var onDoneClick: EmptyClosure?
    var onCancelClick: EmptyClosure?
    
    init(model: Model) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        log("Deinit Alert!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        bind(model)
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            self?.onCancelClick?()
        }
    }
    
    @IBAction func doneClick(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            self?.onDoneClick?()
        }
    }
}

private extension CommonAlertViewController {
    func setUpUI() {
        titleLabel.font = .systemFont(ofSize: 21, weight: .bold)
        titleLabel.textColor = .white
        
        subtitleLabel.font = .systemFont(ofSize: 15)
        subtitleLabel.textColor = .white
        
        noteLabel.font = .systemFont(ofSize: 15, weight: .regular)
        noteLabel.textColor = UIColor.yellow
        
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        cancelButton.setTitleColor(UIColor.darkGray, for: .normal)
        
        doneButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        doneButton.setTitleColor(UIColor(hex: "#6CDFA9", alpha: 1), for: .normal)
        
        [lineVerticalView, lineHorizontalView].forEach { $0?.backgroundColor = .white.withAlphaComponent(0.2)}
    }
    
    func bind(_ model: Model) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        cancelButton.setTitle(model.cancelTitle, for: .normal)
        doneButton.setTitle(model.doneTitle, for: .normal)
        cancelButton.isHidden = !model.isShowCancel
        lineHorizontalView.isHidden = !model.isShowCancel
        noteLabel.text = model.note
        if model.note == nil || model.note == "" {
            noteLabel.isHidden = true
        }
    }
}

extension CommonAlertViewController {
    struct Model {
        let title: String?
        let subtitle: String?
        let note: String?
        let cancelTitle: String?
        let doneTitle: String?
        let isShowCancel: Bool
        init(title: String?,
             subtitle: String?,
             note: String? = nil,
             cancelTitle: String? = "Cancel",
             doneTitle: String? = "Confirm",
             isShowCancel: Bool = true) {
            
            self.title = title
            self.subtitle = subtitle
            self.note = note
            self.cancelTitle = cancelTitle
            self.doneTitle = doneTitle
            self.isShowCancel = isShowCancel
        }
    }
}
