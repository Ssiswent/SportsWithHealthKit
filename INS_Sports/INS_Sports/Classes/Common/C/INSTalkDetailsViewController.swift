//
//  INSTalkDetailsViewController.swift
//  CashAndFancyBooks
//
//  Created by Ssiswent on 11/24/20.
//

import UIKit

class INSTalkDetailsViewController: INSBaseViewController {
    
    @IBOutlet weak var replyView: UIView!
    @IBOutlet weak var replyTextFBgView: UIView!
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var replyTextF: UITextField!
    
    var isMineDynamic = false
    
    var replyViewBottomConstant: CGFloat = KBottomSafeAreaValue
    
    fileprivate lazy var dataSource = [INSCommentModel]()
    var newsModel: INSTalkModel?
    var talkId:String?
    
    var isRightBarBtnHidden: Bool = false
    
    var rowIndex: Int!
    
    var popBackBlock: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        
        archiveViewedTalk()
    }
    
    func initialize()
    {
        setTitle(localizableStr("Details"))
        
        view.backgroundColor = .white
        
        talkId = "\(newsModel?.id ?? 0)"
        
        setUpNav()
        setTableView()
        requestData()
        
        setUpReplyView()
        
        addClickViewGes()
    }
    
    func setUpReplyView()
    {
        replyView.backgroundColor = .white
        replyView.setShadow(color: UIColor.black, opacity: 0.1, radius: 5, offset: CGSize(width: 0, height: 0))
        replyTextFBgView.backgroundColor = UIColor(hexString: "#F3F3F3")
        replyTextFBgView.setRadius(4)
        
        let placeholderAtt = [NSAttributedString.Key.foregroundColor : AppGlobalThemeColor]
        replyTextF.attributedPlaceholder = NSAttributedString(string: localizableStr("Say something..."), attributes: placeholderAtt)
        replyTextF.textColor = UIColor(hexString: "#333333")
        
        sendBtn.backgroundColor = UIColor(hexString: "#F3F3F3")
        sendBtn.setTitleColor(AppGlobalThemeColor, for: .normal)
        sendBtn.setTitle(localizableStr("Send"), for: .normal)
        sendBtn.setRadius(4)
    }
    
    fileprivate func setUpNav() {
        let shieldBtn = UIBarButtonItem.init(image: #imageLiteral(resourceName: "block_btn_light").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(shieldBtnClick))
        let reportBtn = UIBarButtonItem.init(image: #imageLiteral(resourceName: "report_btn_light").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(reportBtnClick))
        
        if !isRightBarBtnHidden {
            navigationItem.rightBarButtonItems = [reportBtn, shieldBtn]
        }
    }
    
    @objc fileprivate func reportBtnClick() {
        if !INSAccountManager.shared.isLogin {
            SVProgressHUD.gp_showInfo(withStatus: "Please login first", delay: 1)
            let vc = INSLoginViewController()
            present(vc, animated: true, completion: nil)
            return
        }
        let reportVC = INSReportViewController()
        reportVC.talkId = "\(newsModel?.id ?? 0)"
        present(reportVC, animated: true, completion: nil)
    }
    
    @objc fileprivate func shieldBtnClick() {
        if !INSAccountManager.shared.isLogin {
            SVProgressHUD.gp_showInfo(withStatus: "Please login first", delay: 1)
            let vc = INSLoginViewController()
            present(vc, animated: true, completion: nil)
            return
        }
        blockTalkRequest()
    }
    
    fileprivate func setTableView() {
        addTableView()
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.backgroundColor = .white
        registerCell(cell: INSTalkDetailContentCell.self)
        registerCell(cell: INSTalkDetailCommentCell.self)
        view.bringSubviewToFront(replyView)
    }
    
    func addClickViewGes() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewClicked))
        view.addGestureRecognizer(tap)
    }
    
    @objc func viewClicked() {
        hideReplyView()
    }
    
    func hideReplyView() {
        replyTextF.resignFirstResponder()
        
        var hideFrame = replyView.frame
        hideFrame.origin.y = KScreenHeight
        UIView.animate(withDuration: 0.5) {
            self.replyView.frame = hideFrame
        }
    }
    
    func showReplyView() {
        var showFrame = replyView.frame
        showFrame.origin.y = KScreenHeight - (replyViewBottomConstant + showFrame.size.height);
        UIView.animate(withDuration: 0.5) {
            self.replyView.frame = showFrame
        }
    }
    
    @IBAction func sendBtnClicked(_ sender: Any) {
        leaveComment()
    }
    
    func leaveComment()
    {
        if !INSAccountManager.shared.isLogin {
            SVProgressHUD.gp_showInfo(withStatus: "Please login first", delay: 1)
            let vc = INSLoginViewController()
            present(vc, animated: true, completion: nil)
            return
        }
        if replyTextF.text?.isEmpty ?? true {
            SVProgressHUD.gp_showInfo(withStatus: "Comment cannot be empty", delay: 1)
            return
        }
        commentRequest()
    }
    
    func archiveViewedTalk()
    {
        if UserDefaults.standard.object(forKey: "VIEWEDTALK") == nil
        {
            var footArray = [INSTalkModel]()
            footArray.append(newsModel!)
            
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(footArray) {
                UserDefaults.standard.set(data, forKey: "VIEWEDTALK")
            }
        }
        else
        {
            let decoder = JSONDecoder()
            // swiftlint:disable force_cast
            if let data = UserDefaults.standard.object(forKey: "VIEWEDTALK"), let footArray = try? decoder.decode([INSTalkModel].self, from: data as! Data)
            // swiftlint:enable force_cast
            {
                var footArr = footArray
                var hasViewed: Bool = false
                for model in footArr {
                    if model.id == newsModel?.id
                    {
                        hasViewed = true
                        break
                    }
                }
                if !hasViewed
                {
                    footArr.append(newsModel!)
                    let encoder = JSONEncoder()
                    if let data = try? encoder.encode(footArr) {
                        UserDefaults.standard.set(data, forKey: "VIEWEDTALK")
                    }
                }
            }
        }
    }
    
    func archiveBlockedTalk()
    {
        blockedTalks.append(newsModel!)
        
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(blockedTalks) {
            UserDefaults.standard.set(data, forKey: "SHIELDTALK")
        }
    }
}

extension INSTalkDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return newsModel == nil ? 0 : 1
        }
        else {
            return dataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "INSTalkDetailContentCell", for: indexPath) as! INSTalkDetailContentCell
            cell.model = newsModel
            weak var weakSelf = self
            if !isMineDynamic
            {
                cell.headBlock = {
                    let vc = INSDynamicViewController()
                    vc.userModel = weakSelf?.newsModel?.user
                    weakSelf?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "INSTalkDetailCommentCell", for: indexPath) as! INSTalkDetailCommentCell
            cell.model = dataSource[indexPath.row]
            return cell
        }
        // swiftlint:enable force_cast
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0.0001
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0.0001
    }
    
    //发送按钮显示与隐藏
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation: CGPoint = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        
        //上滑显示
        if translation.y > 0 {
            showReplyView()
        }
        //下滑隐藏
        else if translation.y < 0 {
            hideReplyView()
        }
    }
}

// MARK:API
extension INSTalkDetailsViewController
{
    func blockTalkRequest()
    {
        archiveBlockedTalk()
        navigationController?.popViewController(animated: true)
        if popBackBlock != nil {
            popBackBlock!()
        }
        NotificationCenter.default.post(name:Notification.Name("deleteBlockedCell"), object: rowIndex)
        SVProgressHUD.gp_showSuccess(withStatus: "Block successfully", delay: 1)
    }
    
    fileprivate func requestData() {
        weak var weakSelf = self
        let params = [
            "pageNumber": pageNumber,
            "userId": "\(newsModel?.user?.id ?? "0")" as Any
        ]
        SSNetwork.shared.GET(URLStr: API.getCommentByUserId, params: params).success { (result) in
            if let dict = result as? [String: Any] {
                if dict["success"] as? Bool ?? false {
                    if let arr = INSCommentModel.mj_objectArray(withKeyValuesArray:(dict["data"] as? [String: Any])?["list"]) as? [INSCommentModel] {
                        if weakSelf?.pageNumber == 1 {
                            weakSelf?.dataSource.removeAll()
                            weakSelf?.dataSource += arr
                        } else {
                            if arr.count > 0 {
                                weakSelf?.dataSource += arr
                            } else {
                                weakSelf?.pageNumber -= 1
                            }
                        }
                        weakSelf?.tableView?.reloadData()
                    }
                } else {
                    SVProgressHUD.gp_showInfo(withStatus: dict["msg"] as? String ?? "error", delay: 2)
                }
            }
        }.failed { (error) in
            SVProgressHUD.gp_showInfo(withStatus: "Network error", delay: 1)
        }
    }
    
    func commentRequest()
    {
        //        let commentM = INSCommentModel()
        //        commentM.content = replyTextF.text!
        //        commentM.user = INSAccountManager.shared.user!
        //        dataSource.append(commentM)
        //        tableView?.reloadSections(IndexSet(integer: 1), with: .automatic)
        //        SVProgressHUD.gp_showSuccess(withStatus: "Comment successfully", delay: 1)
        //        replyTextF.text = ""
        //        hideReplyView()
        weak var weakSelf = self
        let params = [
            "userId": Int(INSAccountManager.shared.userId)!,
            "talkId": Int(talkId!)!,
            "content": replyTextF.text ?? ""
        ] as [String : Any]
        SSNetwork.shared.POST(URLStr: API.commentTalk, params: params).success { (result) in
            if let dict = result as? [String:Any] {
                if dict["success"] as? Bool ?? false {
                    SVProgressHUD.gp_showInfo(withStatus: "Comment successfully", delay: 1)
                    weakSelf?.hideReplyView()
                    weakSelf?.requestData()
                } else {
                    SVProgressHUD.gp_showInfo(withStatus: dict["msg"] as? String ?? "error", delay: 2)
                }
            }
        }.failed { (error) in
            SVProgressHUD.gp_showInfo(withStatus: "Network error", delay: 1)
        }
    }
}

extension INSTalkDetailsViewController: NavigationBarConfigureStyle
{
    func yp_navigtionBarConfiguration() -> YPNavigationBarConfigurations {
        [.backgroundStyleColor, .backgroundStyleOpaque, .styleBlack]
    }
    
    func yp_navigationBarTintColor() -> UIColor! {
        .white
    }
    
    func yp_navigationBackgroundColor() -> UIColor! {
        AppGlobalThemeColor
    }
}
