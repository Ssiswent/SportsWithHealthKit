//
//  INSLoginViewController.swift
//  CashAndFancyBooks
//
//  Created by Ssiswent on 11/24/20.
//

import UIKit
import JXSegmentedView

class INSLoginViewController: UIViewController {

    @IBOutlet weak var loginView: UIView!
    
//    @IBOutlet weak var loginViewT: NSLayoutConstraint!
    //    @IBOutlet weak var segViewT: NSLayoutConstraint!
    @IBOutlet weak var segView: UIView!
    
    @IBOutlet private weak var loginBtn: UIButton!
//    @IBOutlet private weak var registerBtn: UIButton!
//    @IBOutlet private weak var forgetBtn: UIButton!
    
    var viewModel: INSLoginVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        if !KIsXSeries {
//            loginViewT.constant = 30 * KHeightScale
//        }
        viewModel = INSLoginVM(segView: segView, loginView: loginView, loginBtn: loginBtn, view: view)
        viewModel.initialize()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.startAnimation()
    }

    @objc func applicationDidBecomeActive(notification: NSNotification) {
        viewModel.startAnimation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.segmentedView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        viewModel.listContainerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    @IBAction func closeBtnClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
