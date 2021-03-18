//
//  INSRegisterVM.swift
//  MVVMForBitCoin
//
//  Created by Flamingo on 2020/12/29.
//

import UIKit
import IQKeyboardManagerSwift
import SwiftEntryKit

class INSRegisterVM: INSBaseViewModel {

    private weak var phoneTextF: UITextField!
    private weak var codeTextF: UITextField!
    private weak var pwdTextF: UITextField!
    
    private weak var phoneTextView: UIView!
    private weak var codeTextView: UIView!
    private weak var pwdTextView: UIView!
    
    private weak var getCodeBtn: SSVerifyBtn!
    
    var picCode: String!
    
    private weak var vc: UIViewController!
    
    var clickReturnBlock: (() -> Void)?
    var returnKeyHander: IQKeyboardReturnKeyHandler!
    
    init(phoneTextF: UITextField, codeTextF: UITextField, getCodeBtn: SSVerifyBtn, pwdTextF: UITextField, phoneTextView: UIView, codeTextView: UIView, pwdTextView: UIView, vc: UIViewController) {
        super.init()
        self.phoneTextF = phoneTextF
        self.codeTextF = codeTextF
        self.pwdTextF = pwdTextF
        self.getCodeBtn = getCodeBtn
        
        self.phoneTextView = phoneTextView
        self.codeTextView = codeTextView
        self.pwdTextView = pwdTextView
        
        self.vc = vc
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func btnAddTarget() {
        getCodeBtn.addTarget(self, action: #selector(getCodeBtnClicked), for: .touchUpInside)
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
        btnAddTarget()
        setTextView()
        setTextF()
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
        
        returnKeyHander = IQKeyboardReturnKeyHandler(controller: vc)
        returnKeyHander.lastTextFieldReturnKeyType = .done
    }

    @objc func getCodeBtnClicked() {
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
            SwiftEntryKit.display(entry: customView, using: attributes, presentInsideKeyWindow: true)
        } else {
            SVProgressHUD.gp_showInfo(withStatus: localizableStr("Please input the correct number"), delay: 1)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 105 {
            phoneTextView.layer.borderColor = UIColor(hexString: "#76859C").cgColor
//            phoneTextView.backgroundColor = UIColor(hexString: "#F4F9FC")
        } else if textField.tag == 106 {
            codeTextView.layer.borderColor = UIColor(hexString: "#76859C").cgColor
//            codeTextView.backgroundColor = UIColor(hexString: "#F4F9FC")
        } else if textField.tag == 107 {
            pwdTextView.layer.borderColor = UIColor(hexString: "#76859C").cgColor
//            pwdTextView.backgroundColor = UIColor(hexString: "#F4F9FC")
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 105 {
            phoneTextView.layer.borderColor = UIColor(hexString: "#D8E0EE").cgColor
            phoneTextView.backgroundColor = .clear
        } else if textField.tag == 106 {
            codeTextView.layer.borderColor = UIColor(hexString: "#D8E0EE").cgColor
            codeTextView.backgroundColor = .clear
        } else if textField.tag == 107 {
            pwdTextView.layer.borderColor = UIColor(hexString: "#D8E0EE").cgColor
            pwdTextView.backgroundColor = .clear
        }
        return true
    }
}

extension INSRegisterVM: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 107 {
            if clickReturnBlock != nil {
                clickReturnBlock!()
            }
        }
        return true
    }
}

// MARK: Network request
extension INSRegisterVM
{
    func sendRegisterCode()
    {
        weak var weakSelf = self
        let params = [
            "phone": phoneTextF.text ?? "",
            "type": 1,
            "project": Project.sport1,
            "code": picCode ?? ""
        ] as [String : Any]
        SSNetwork.shared.POST(URLStr: API.sendCode, params: params).success { (result) in
            if let dict = result as? [String:Any]
            {
                if dict["success"] as? Bool ?? false {
                    SwiftEntryKit.dismiss()
                    //                    weakSelf?.getCodeBtn.maxSecond = 10 // 默认为60
                    weakSelf?.getCodeBtn.countdown = true
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
