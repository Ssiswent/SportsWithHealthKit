//
//  INSForgetView.swift
//  INS_Sports
//
//  Created by Flamingo on 2021/3/15.
//

import UIKit
import SwiftEntryKit

class INSForgetView: UIView {
    
    @IBOutlet weak var phoneTextF: UITextField!
    @IBOutlet weak var codeTextF: UITextField!
    @IBOutlet weak var pwdTextF: UITextField!
    
    @IBOutlet weak var phoneTextView: UIView!
    @IBOutlet weak var codeTextView: UIView!
    @IBOutlet weak var pwdTextView: UIView!
    
    @IBOutlet private weak var getCodeBtn: SSVerifyBtn!
    @IBOutlet weak var confirmBtn: UIButton!
    
    var picCode: String!
    
    var resetBlock: (() -> Void)?
    
    var getCodeBtnCount: Bool = false
    
    public init() {
        super.init(frame: UIScreen.main.bounds)
        setup()
        
        set(.height,
            of: 367,
            priority: .defaultHigh)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setup() {
        fromNib()
        
        initialize()
    }
    
    func initialize()
    {
        let placeholderAtt = [NSAttributedString.Key.foregroundColor : UIColor(hexString: "#AAAAAA")]
        phoneTextF.attributedPlaceholder = NSAttributedString(string: localizableStr("账号"), attributes: placeholderAtt)
        codeTextF.attributedPlaceholder = NSAttributedString(string: localizableStr("验证码"), attributes: placeholderAtt)
        pwdTextF.attributedPlaceholder = NSAttributedString(string: localizableStr("密码"), attributes: placeholderAtt)
        
        phoneTextF.textColor = UIColor(hexString: "#333333")
        codeTextF.textColor = UIColor(hexString: "#333333")
        pwdTextF.textColor = UIColor(hexString: "#333333")
        
        setGetCodeBtn()
        setTextView()
        setTextF()
        setConfirmBtn()
        confirmBtn.isEnabled = false
    }
    
    func setGetCodeBtn() {
        getCodeBtn.layer.cornerRadius = 10
        getCodeBtn.layer.masksToBounds = true
        let normalImg = UIImage.imageWithColor(color: UIColor(hexString: "#3D8249"))
        let disableImg = UIImage.imageWithColor(color: UIColor(hexString: "#EAF0FD"))
        getCodeBtn.setBackgroundImage(normalImg, for: .normal)
        getCodeBtn.setBackgroundImage(disableImg, for: .disabled)
        
        getCodeBtn.setTitleColor(.white, for: .normal)
        getCodeBtn.setTitleColor(UIColor(hexString: "#3D8249"), for: .disabled)
        
        getCodeBtn.setTitle(localizableStr("get code"), for: .normal)
        getCodeBtn.setTitle("second s", for: .disabled)
    }
    
    func setTextView() {
        phoneTextView.layer.borderWidth = 2
        phoneTextView.layer.borderColor = UIColor(hexString: "#D8E0EE").cgColor
        phoneTextView.backgroundColor = .clear
        codeTextView.layer.borderWidth = 2
        codeTextView.layer.borderColor = UIColor(hexString: "#D8E0EE").cgColor
        codeTextView.backgroundColor = .clear
        pwdTextView.layer.borderWidth = 2
        pwdTextView.layer.borderColor = UIColor(hexString: "#D8E0EE").cgColor
        pwdTextView.backgroundColor = .clear
    }
    
    func setTextF() {
        phoneTextF.tintColor = UIColor(hexString: "#76859C")
        phoneTextF.delegate = self
        codeTextF.tintColor = UIColor(hexString: "#76859C")
        codeTextF.delegate = self
        pwdTextF.tintColor = UIColor(hexString: "#76859C")
        pwdTextF.delegate = self
        
        phoneTextF.addTarget(self, action: #selector(setConfirmBtnState), for: .editingChanged)
        codeTextF.addTarget(self, action: #selector(setConfirmBtnState), for: .editingChanged)
        pwdTextF.addTarget(self, action: #selector(setConfirmBtnState), for: .editingChanged)
    }
    
    func setConfirmBtn() {
        confirmBtn.layer.cornerRadius = 10
        confirmBtn.layer.masksToBounds = true
        let normalImg = UIImage.imageWithColor(color: UIColor(hexString: "#3D8249"))
        let disableImg = UIImage.imageWithColor(color: UIColor(hexString: "#EAF0FD"))
        confirmBtn.setBackgroundImage(normalImg, for: .normal)
        confirmBtn.setBackgroundImage(disableImg, for: .disabled)
        
        confirmBtn.setTitleColor(.white, for: .normal)
        confirmBtn.setTitleColor(UIColor(hexString: "#3D8249"), for: .disabled)
    }
    
    @IBAction func getCodeBtnClicked(_ sender: Any) {
        if phoneTextF.text?.count == 11 {
            var attributes = EKAttributes()
            attributes = .float
            attributes.windowLevel = .normal
            attributes.position = .center
            attributes.displayDuration = .infinity
            attributes.entranceAnimation = .init(
                translate: .init(
                    duration: 0.65,
                    anchorPosition: .bottom,
                    spring: .init(damping: 1, initialVelocity: 0)
                )
            )
            attributes.exitAnimation = .init(
                translate: .init(
                    duration: 0.65,
                    anchorPosition: .top,
                    spring: .init(damping: 1, initialVelocity: 0)
                )
            )
            attributes.popBehavior = .animated(
                animation: .init(
                    translate: .init(
                        duration: 0.65,
                        spring: .init(damping: 1, initialVelocity: 0)
                    )
                )
            )
            attributes.entryInteraction = .absorbTouches
            attributes.screenInteraction = .dismiss
            attributes.entryBackground = .color(color: .standardBackground)
            attributes.screenBackground = .color(color: EKColor(light: UIColor(white: 50.0/255.0, alpha: 0.3), dark: UIColor(white: 0, alpha: 0.5)))
            attributes.border = .value(
                color: UIColor(white: 0.6, alpha: 1),
                width: 1
            )
            attributes.shadow = .active(
                with: .init(
                    color: .black,
                    opacity: 0.3,
                    radius: 3
                )
            )
            attributes.scroll = .enabled(
                swipeable: false,
                pullbackAnimation: .jolt
            )
            attributes.statusBar = .light
            attributes.positionConstraints.keyboardRelation = .bind(
                offset: .init(
                    bottom: 15,
                    screenEdgeResistance: 0
                )
            )
            attributes.positionConstraints.maxSize = .init(
                width: .constant(value: UIScreen.main.minEdge),
                height: .intrinsic
            )
            
            let customView = INSCaptchaView()
            customView.clickCancelBlock = {
                SwiftEntryKit.dismiss()
            }
            customView.clickConfirmBlock = { code in
                self.picCode = code
                self.sendRegisterCode()
            }
            customView.getPicCode()
            attributes.precedence.priority = .max
            attributes.lifecycleEvents.didDisappear = {
                var attributes = EKAttributes()
                attributes = .toast
                attributes.roundCorners = .top(radius: 10)
                attributes.displayMode = .inferred
                attributes.windowLevel = .normal
                attributes.position = .bottom
                attributes.displayDuration = .infinity
                attributes.entranceAnimation = .init(
                    translate: .init(
                        duration: 0.65,
                        spring: .init(damping: 1, initialVelocity: 0)
                    )
                )
                attributes.exitAnimation = .init(
                    translate: .init(
                        duration: 0.65,
                        spring: .init(damping: 1, initialVelocity: 0)
                    )
                )
                attributes.popBehavior = .animated(
                    animation: .init(
                        translate: .init(
                            duration: 0.65,
                            spring: .init(damping: 1, initialVelocity: 0)
                        )
                    )
                )
                attributes.entryInteraction = .absorbTouches
                attributes.screenInteraction = .dismiss
                attributes.entryBackground = .color(color: .white)
                attributes.shadow = .active(
                    with: .init(
                        color: .black,
                        opacity: 0.3,
                        radius: 3
                    )
                )
                attributes.screenBackground = .color(color: EKColor(light: UIColor(white: 50.0/255.0, alpha: 0.3), dark: UIColor(white: 0, alpha: 0.5)))
                attributes.scroll = .edgeCrossingDisabled(swipeable: true)
                attributes.statusBar = .light
                attributes.positionConstraints.keyboardRelation = .bind(
                    offset: .init(
                        bottom: 0,
                        screenEdgeResistance: 0
                    )
                )
                attributes.positionConstraints.maxSize = .init(
                    width: .constant(value: UIScreen.main.bounds.minEdge),
                    height: .intrinsic
                )
                
                let customView  = INSForgetView()
                customView.phoneTextF.text = self.phoneTextF.text
                customView.codeTextF.text = self.codeTextF.text
                customView.pwdTextF.text = self.pwdTextF.text
                if self.getCodeBtnCount {
                    customView.getCodeBtn.countdown = true
                }
                SwiftEntryKit.display(entry: customView, using: attributes, presentInsideKeyWindow: true)
            }
            SwiftEntryKit.display(entry: customView, using: attributes, presentInsideKeyWindow: true)
        } else {
            SVProgressHUD.gp_showInfo(withStatus: localizableStr("Please input the correct number"), delay: 1)
        }
    }
    
    
    @IBAction func changePwdBtnClicked(_ sender: Any) {
        if let pwdText = pwdTextF.text {
            if pwdText.count >= 6 && pwdText.count <= 16 {
                resetPwdRequest()
            } else {
                SVProgressHUD.gp_showInfo(withStatus: localizableStr("Password length should be 6~16 - bit"), delay: 1)
            }
        }
    }
    
    public func becomeFirstResponder() {
        phoneTextF.becomeFirstResponder()
    }
    
    @objc func setConfirmBtnState() {
        if phoneTextF.text?.count == 11 && codeTextF.text?.count != 0 && pwdTextF.text?.count != 0 {
            confirmBtn.isEnabled = true
        } else {
            confirmBtn.isEnabled = false
        }
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 108 {
            phoneTextView.layer.borderColor = UIColor(hexString: "#76859C").cgColor
//            phoneTextView.backgroundColor = UIColor(hexString: "#F4F9FC")
        } else if textField.tag == 109 {
            codeTextView.layer.borderColor = UIColor(hexString: "#76859C").cgColor
//            codeTextView.backgroundColor = UIColor(hexString: "#F4F9FC")
        } else if textField.tag == 110 {
            pwdTextView.layer.borderColor = UIColor(hexString: "#76859C").cgColor
//            pwdTextView.backgroundColor = UIColor(hexString: "#F4F9FC")
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 108 {
            phoneTextView.layer.borderColor = UIColor(hexString: "#D8E0EE").cgColor
            phoneTextView.backgroundColor = .clear
        } else if textField.tag == 109 {
            codeTextView.layer.borderColor = UIColor(hexString: "#D8E0EE").cgColor
            codeTextView.backgroundColor = .clear
        } else if textField.tag == 110 {
            pwdTextView.layer.borderColor = UIColor(hexString: "#D8E0EE").cgColor
            pwdTextView.backgroundColor = .clear
        }
        return true
    }
}

extension INSForgetView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 110 {
            if phoneTextF.text?.count != 11 {
                SVProgressHUD.gp_showInfo(withStatus: localizableStr("Please input the correct number"), delay: 1)
                return true
            }
            if codeTextF.text?.count == 0 {
                SVProgressHUD.gp_showInfo(withStatus: localizableStr("Please input verification code"), delay: 1)
                return true
            }
            if let pwdText = pwdTextF.text {
                if pwdText.count >= 6 && pwdText.count <= 16 {
                    resetPwdRequest()
                }
                else {
                    SVProgressHUD.gp_showInfo(withStatus: localizableStr("Password length should be 6~16 - bit"), delay: 1)
                }
            }
        }
        return true
    }
}

// MARK: Network request
extension INSForgetView {
    func sendRegisterCode()
    {
        weak var weakSelf = self
        let params = [
            "phone": phoneTextF.text ?? "",
            "type": 3,
            "project": Project.sport1,
            "code": picCode ?? ""
        ] as [String : Any]
        SSNetwork.shared.POST(URLStr: API.sendCode, params: params).success { (result) in
            if let dict = result as? [String:Any]
            {
                if dict["success"] as? Bool ?? false {
                    SwiftEntryKit.dismiss()
                    weakSelf?.getCodeBtnCount = true
                }
                else {
                    SVProgressHUD.gp_show(withStatus: dict["msg"] as? String ?? "error", delay: 2)
                }
            }
        }.failed { (error) in
            SVProgressHUD.gp_showInfo(withStatus: localizableStr("Network error"), delay: 1)
        }
    }
    
    func resetPwdRequest()
    {
        weak var weakSelf = self
        let params = [
            "phone": phoneTextF.text ?? "",
            "newPassword": pwdTextF.text ?? "",
            "confirmPassword": pwdTextF.text ?? "",
            "code": codeTextF.text ?? "",
            "project": Project.sport1
        ] as [String : Any]
        SSNetwork.shared.POST(URLStr: API.resetPwd, params: params).success { (result) in
            if let dict = result as? [String:Any]
            {
                if dict["success"] as? Bool ?? false {
                    SwiftEntryKit.dismiss()
                    if weakSelf?.resetBlock != nil
                    {
                        weakSelf?.resetBlock!()
                    }
                    SVProgressHUD.gp_showSuccess(withStatus: localizableStr("Change password successfully"), delay: 1)
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
