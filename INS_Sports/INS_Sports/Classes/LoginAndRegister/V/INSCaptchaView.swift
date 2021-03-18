//
//  INSCaptchaView.swift
//  Futures-07
//
//  Created by Ssiswent on 2020/8/5.
//

import UIKit

class INSCaptchaView: SSCoverView {

    @IBOutlet var view: UIView!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var codeView: UIView!

    @IBOutlet weak var codeImgView: UIImageView!
    
    lazy var typeView: SSVerifyCodeView = {
        let typeView = SSVerifyCodeView.init(inputTextNum: 4)
        view.addSubview(typeView)
        return typeView
    }()
    
    var codeStr: String = ""
    
    typealias ClickCancelBlock = () -> ()
    typealias ClickConfirmBlock = (String) -> ()
    typealias ClickChangeBlock = () -> ()
    
    var clickCancelBlock: ClickCancelBlock?
    var clickConfirmBlock: ClickConfirmBlock?
    var clickChangeBlock: ClickChangeBlock?
    
    public init() {
        super.init(frame: UIScreen.main.bounds)
        fromNib()

        setUpView()

        set(.height,
            of: 304,
            priority: .defaultHigh)
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        // 加载xib
//        // swiftlint:disable force_cast
//        view = (Bundle.main.loadNibNamed("INSCaptchaView", owner: self, options: nil)?.last as! UIView)
//        // swiftlint:enable force_cast
//        // 设置frame
//        view.frame = frame
//
//        setUpView()
//
//        // 添加上去
//        addSubview(view)
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView()
    {
        view.backgroundColor = .clear
        
        mainView.setRadius(15.5)
        codeView.setRadius(2)
        
        cancelBtn.setTitleColor(UIColor(hexString: "#666666"), for: .normal)
        cancelBtn.backgroundColor = .white
        
        confirmBtn.setTitleColor(UIColor(hexString: "#2B67F4"), for: .normal)
        confirmBtn.backgroundColor = .white
        
        cancelBtn.setTitle(localizableStr("Cancel"), for: .normal)
        confirmBtn.setTitle(localizableStr("Confirm"), for: .normal)
        
        // 监听验证码输入的过程
        typeView.textValueChange = { str in
            // 要做的事情
        }
        
        // 监听验证码输入完成
        typeView.inputFinish = { str in
            // 要做的事情
            self.codeStr = str
        }
        
        typeView.snp.makeConstraints { (make) in
            make.top.equalTo(codeView.snp.bottom).offset(21)
            make.left.right.equalTo(codeView)
            make.centerX.equalToSuperview()
            make.height.equalTo(68)
        }
    }

    @IBAction func cancelBtnClicked(_ sender: Any) {
        if clickCancelBlock != nil
        {
            clickCancelBlock!()
        }
    }
    
    @IBAction func confirmBtnClicked(_ sender: Any) {
        if clickConfirmBlock != nil
        {
            clickConfirmBlock!(codeStr)
        }
    }
    
    @IBAction func changeBtnClicked(_ sender: Any) {
        getPicCode()
    }
}

extension INSCaptchaView {
    func getPicCode()
    {
        weak var weakSelf = self
        SSNetwork.shared.GET(URLStr: API.sendPicCode).success { (result) in
            if let dict = result as? [String:Any]
            {
                if dict["success"] as? Bool ?? false {
                    if let dataStr: String = dict["data"] as? String {
                        let imgData = Data(base64Encoded: dataStr, options: .ignoreUnknownCharacters)
                        let codeImg = UIImage(data: imgData!)
                        weakSelf?.codeImgView.image = codeImg
                    }
                }
                else {
                    SVProgressHUD.gp_show(withStatus: dict["msg"] as? String ?? "error", delay: 2)
                }
            }
        }.failed { (error) in
            SVProgressHUD.gp_showInfo(withStatus: localizableStr("Network error"), delay: 1)
        }
    }
}
