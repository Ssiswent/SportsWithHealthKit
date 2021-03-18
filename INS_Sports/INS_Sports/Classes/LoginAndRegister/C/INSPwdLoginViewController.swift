//
//  INSPwdLoginViewController.swift
//  CashAndFancyBooks
//
//  Created by Ssiswent on 11/25/20.
//

import UIKit
import JXSegmentedView

class INSPwdLoginViewController: UIViewController {

    @IBOutlet weak var phoneTextF: UITextField!
    @IBOutlet weak var pwdTextF: UITextField!
    
    @IBOutlet private weak var phoneTextView: UIView!
    @IBOutlet private weak var pwdTextView: UIView!
    
    @IBOutlet private weak var forgetBtn: UIButton!
    
    var viewModel: INSPwdLoginVM!
    
    
    var didLoadBlock: (() -> Void)?
    
    var clickReturnBlock: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear

        viewModel = INSPwdLoginVM(phoneTextF: phoneTextF, pwdTextF: pwdTextF, forgetBtn: forgetBtn, phoneTextView: phoneTextView, pwdTextView: pwdTextView, vc: self)
        viewModel.clickReturnBlock = clickReturnBlock
        viewModel.initialize()
        
        if didLoadBlock != nil {
            didLoadBlock!()
        }
    }
}

extension INSPwdLoginViewController: JXSegmentedListContainerViewListDelegate
{
    func listView() -> UIView {
        view
    }
}
