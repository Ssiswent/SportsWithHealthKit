//
//  INSReportViewController.swift
//  CashAndFancyBooks
//
//  Created by Ssiswent on 11/25/20.
//

import UIKit

class INSReportViewController: INSBaseViewController {
    
    @IBOutlet weak var contentBgView: UIView!
    @IBOutlet weak var contentTextV: SSTextView!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var Navtitle: UILabel!
    
    var talkId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Navtitle.text = localizableStr("Report")
        view.backgroundColor = .white
        contentBgView.backgroundColor = UIColor(hexString: "#F2F2F2")
        contentBgView.setRadius(10)
        
        reportButton.setTitle(localizableStr("Confirm"), for: .normal)
       
        contentTextV.placeholder = localizableStr("Details of the report (required 10 words)")
        contentTextV.placeholderFont = .systemFont(ofSize: 15, weight: .medium)
        contentTextV.placeholderColor = UIColor(hexString: "#999999")
    }
    
    @IBAction func dismissBtnClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reportBtnClicked(_ sender: Any) {
        if contentTextV.text.isEmpty {
            SVProgressHUD.gp_showInfo(withStatus: localizableStr("Report Contents cannot be empty"), delay: 2)
            return
        }
        if contentTextV.text.count < 10 {
            SVProgressHUD.gp_showInfo(withStatus: localizableStr("Report Contents cannot be empty"), delay: 2)
            return
        }
        reportRequest()
    }
}

// MARK: API
extension INSReportViewController
{
    func reportRequest()
    {
        weak var weakSelf = self
        let params = [
            "talkId": talkId,
            "userId": INSAccountManager.shared.userId,
            "content": contentTextV.text ?? "",
            "contact": INSAccountManager.shared.account
        ]
        SSNetwork.shared.POST(URLStr: API.reportTalk, params: params).success { (result) in
            if let dict = result as? [String:Any] {
                if dict["success"] as? Bool ?? false {
                    weakSelf?.dismiss(animated: true, completion: nil)
                    SVProgressHUD.gp_showSuccess(withStatus: localizableStr("Report successfully"), delay: 1)
                } else {
                    SVProgressHUD.gp_showInfo(withStatus: dict["msg"] as? String ?? "error", delay: 1)
                }
            }
        }.failed { (error) in
            SVProgressHUD.gp_showInfo(withStatus: localizableStr("Network error"), delay: 1)
        }
    }
}
