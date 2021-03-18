//
//  INSRegisterVC.swift
//  CashAndFancyBooks
//
//  Created by Ssiswent on 11/24/20.
//

import UIKit
import JXSegmentedView

class INSRegisterVC: UIViewController {

    @IBOutlet weak var phoneTextF: UITextField!
    @IBOutlet weak var codeTextF: UITextField!
    @IBOutlet weak var pwdTextF: UITextField!
    
    @IBOutlet private weak var phoneTextView: UIView!
    @IBOutlet private weak var codeTextView: UIView!
    @IBOutlet private weak var pwdTextView: UIView!
    
    @IBOutlet private weak var getCodeBtn: SSVerifyBtn!
    
    var loginBlock: (() -> Void)?
    
    var viewModel: INSRegisterVM!
    
    var didLoadBlock: (() -> Void)?
    
    var clickReturnBlock: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear

        viewModel = INSRegisterVM(phoneTextF: phoneTextF, codeTextF: codeTextF, getCodeBtn: getCodeBtn, pwdTextF: pwdTextF, phoneTextView: phoneTextView, codeTextView: codeTextView, pwdTextView: pwdTextView, vc: self)
        viewModel.clickReturnBlock = clickReturnBlock
        viewModel.initialize()
        
        if didLoadBlock != nil {
            didLoadBlock!()
        }
    }
}

extension INSRegisterVC: JXSegmentedListContainerViewListDelegate
{
    func listView() -> UIView {
        view
    }
}
