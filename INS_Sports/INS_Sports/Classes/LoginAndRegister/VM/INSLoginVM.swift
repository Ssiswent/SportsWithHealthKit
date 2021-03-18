//
//  INSLoginVM.swift
//  MVVMForBitCoin
//
//  Created by Flamingo on 2020/12/29.
//

import UIKit
import JXSegmentedView
import Pastel

class INSLoginVM: INSBaseViewModel {
    
    private weak var segView: UIView!
    private weak var loginView: UIView!
    
    private weak var loginPhoneTextF: UITextField!
    private weak var loginPwdTextF: UITextField!
    
    private weak var registerPhoneTextF: UITextField!
    private weak var codeTextF: UITextField!
    private weak var registerPwdTextF: UITextField!
    
    private weak var loginBtn: UIButton!
    
    private weak var view: UIView!
    private var pastelView: PastelView!
    
    var segmentedView = JXSegmentedView()
    private var dataSource = JXSegmentedTitleDataSource()
    lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    
    init(segView: UIView, loginView: UIView, loginBtn: UIButton, view: UIView) {
        super.init()
        self.segView = segView
        self.loginView = loginView
        self.loginBtn = loginBtn
//        self.registerBtn = registerBtn
//        self.forgetBtn = forgetBtn
        self.view = view
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        setUpSegmentedView()
        btnAddTarget()
        setPastelView()
    }
    
    func setUpSegmentedView()
    {
        segmentedView.delegate = self
        
        listContainerView.scrollView.isScrollEnabled = false
        
        dataSource.titles = [localizableStr("登录"),localizableStr("注册")]
        dataSource.titleNormalColor = UIColor(hexString: "#148442")
        dataSource.titleSelectedColor = UIColor(hexString: "#148442")
        dataSource.titleNormalFont = .systemFont(ofSize: 20, weight: .bold)
        
//        dataSource.itemWidth = 100
//        dataSource.itemSpacing = 20
//        dataSource.isTitleColorGradientEnabled = true
        dataSource.isTitleZoomEnabled = true
        dataSource.titleSelectedZoomScale = 1.2
        dataSource.isSelectedAnimable = true
        
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 37
        indicator.indicatorHeight = 3
        indicator.indicatorColor = UIColor(hexString: "#148442")
//        indicator.verticalOffset = 5
        
        segmentedView.indicators = [indicator]
        
        segmentedView.dataSource = dataSource
        segmentedView.listContainer = listContainerView
        
        segView.addSubview(segmentedView)
        loginView.addSubview(listContainerView)
    }
    
    func btnAddTarget() {
        loginBtn.addTarget(self, action: #selector(loginBtnClicked), for: .touchUpInside)
//        forgetBtn.addTarget(self, action: #selector(forgetBtnClicked), for: .touchUpInside)
    }
    
    func setPastelView() {
        pastelView = PastelView(frame: view.bounds)
        
        // Custom Direction
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        
        // Custom Duration
        pastelView.animationDuration = 2.0
        
        // Custom Color
//        let color1 = UIColor(hexString: "#17EAD9")
//        let color2 = UIColor(hexString: "#6078EA")
        let color1 = UIColor(hexString: "#C6FFDD")
        let color2 = UIColor(hexString: "#FBD786")
        let color3 = UIColor(hexString: "#F7797D")
//        let color4 = UIColor(hexString: "#F64F59")
        pastelView.setColors([color1, color2, color3])
        
        view.insertSubview(pastelView, at: 0)
    }
    
    func startAnimation() {
        pastelView.startAnimation()
    }
    
    @objc func loginBtnClicked() {
        if segmentedView.selectedIndex == 0 {
            login()
        } else {
            register()
        }
    }
    
    func login() {
        if loginPhoneTextF.text?.count == 11 {
            if loginPwdTextF.text?.count != 0 {
                loginWithPwd()
            }
            else {
                SVProgressHUD.gp_showInfo(withStatus: localizableStr("Please input password"), delay: 1)
            }
        }
        else{
            SVProgressHUD.gp_showInfo(withStatus: localizableStr("Please input the correct number"), delay: 1)
        }
    }
    
    func register() {
        if registerPhoneTextF.text?.count != 11 {
            SVProgressHUD.gp_showInfo(withStatus: localizableStr("Please input the correct number"), delay: 1)
            return
        }
        if codeTextF.text?.count == 0 {
            SVProgressHUD.gp_showInfo(withStatus: localizableStr("Please input verification code"), delay: 1)
            return
        }
        if let pwdText = registerPwdTextF.text {
            if pwdText.count >= 6 && pwdText.count <= 16 {
                registerRequest()
            }
            else {
                SVProgressHUD.gp_showInfo(withStatus: localizableStr("Password length should be 6~16 - bit"), delay: 1)
            }
        }
    }
    
    func loginSecceed() {
        NotificationCenter.default.post(name: Notification.Name("LoginSuccess"), object: nil)
        currentViewController()?.dismiss(animated: true, completion: nil)
        SVProgressHUD.gp_showSuccess(withStatus: localizableStr("Login successfully"), delay: 1)
    }
}

extension INSLoginVM: JXSegmentedViewDelegate{
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        if segmentedView.selectedIndex == 0 {
            loginBtn.setTitle("登录", for: .normal)
        } else {
            loginBtn.setTitle("注册", for: .normal)
        }
        if let dotDataSource = dataSource as? JXSegmentedDotDataSource {
            //先更新数据源的数据
            dotDataSource.dotStates[index] = false
            //再调用reloadItem(at: index)
            segmentedView.reloadItem(at: index)
        }
    }
}

extension INSLoginVM: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        2
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        switch index {
        case 0:
            let vc = INSPwdLoginViewController()
            vc.didLoadBlock = {
                self.loginPhoneTextF = vc.phoneTextF
                self.loginPwdTextF = vc.pwdTextF
            }
            vc.clickReturnBlock = loginBtnClicked
            return vc
        default:
            let vc = INSRegisterVC()
            vc.didLoadBlock = {
                self.registerPhoneTextF = vc.phoneTextF
                self.codeTextF = vc.codeTextF
                self.registerPwdTextF = vc.pwdTextF
            }
            vc.clickReturnBlock = loginBtnClicked
            return vc
        }
    }
}

// MARK: Network request
extension INSLoginVM
{
    func loginWithPwd() {
        weak var weakSelf = self
        let params = [
            "phone": loginPhoneTextF.text ?? "",
            "password": loginPwdTextF.text ?? "",
            "type": 1,
            "project": Project.sport1,
            "code": 000000
        ] as [String : Any]
        SSNetwork.shared.GET(URLStr: API.login, params: params).success { (result) in
            if let dict = result as? [String:Any] {
                if dict["success"] as? Bool ?? false {
                    if let infoModel = INSUserModel.mj_object(withKeyValues: dict["data"]) {
                        INSAccountManager.shared.user = infoModel
                        INSAccountManager.shared.isLogin = true
                        INSAccountManager.shared.userId = infoModel.id!
                        INSAccountManager.shared.account = infoModel.phone!
                        INSAccountManager.shared.psw = infoModel.password!
                        
                        weakSelf?.loginSecceed()
                    }
                }else {
                    SVProgressHUD.gp_show(withStatus: dict["msg"] as? String ?? "error", delay: 2)
                }
            }
        }.failed { (error) in
            SVProgressHUD.gp_showInfo(withStatus: localizableStr("Network error"), delay: 1)
        }
    }
    
    func registerRequest()
    {
        let params = [
            "phone": registerPhoneTextF.text ?? "",
            "password": registerPwdTextF.text ?? "",
            "confirmPassword": registerPwdTextF.text ?? "",
            "code": codeTextF.text ?? "",
            "type": 1,
            "project": Project.sport1
        ] as [String : Any]
        SSNetwork.shared.POST(URLStr: API.register, params: params).success { (result) in
            if let dict = result as? [String:Any] {
                if dict["success"] as? Bool ?? false {
                    let userDict = dict["data"]
                    if let infoModel = INSUserModel.mj_object(withKeyValues: userDict) {
                        INSAccountManager.shared.user = infoModel
                        INSAccountManager.shared.isLogin = true
                        INSAccountManager.shared.userId = infoModel.id!
                        INSAccountManager.shared.account = infoModel.phone!
                        INSAccountManager.shared.psw = infoModel.password!
                        NotificationCenter.default.post(name: Notification.Name("LoginSuccess"), object: nil)
                        currentViewController()?.dismissToRootViewController()
                        SVProgressHUD.gp_showSuccess(withStatus: localizableStr("注册并登录成功"), delay: 1)
                    }
                }
                else {
                    SVProgressHUD.gp_showInfo(withStatus: dict["msg"] as? String ?? "error", delay: 2)
                }
            }
        }.failed { (error) in
            SVProgressHUD.gp_showInfo(withStatus: localizableStr("Network error"), delay: 1)
        }
    }
}
