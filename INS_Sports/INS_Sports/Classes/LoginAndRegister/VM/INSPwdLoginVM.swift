//
//  INSPwdLoginVM.swift
//  MVVMForBitCoin
//
//  Created by Flamingo on 2020/12/29.
//

import UIKit
import SwiftEntryKit
import IQKeyboardManagerSwift

class INSPwdLoginVM: INSBaseViewModel {
    
    private weak var phoneTextF: UITextField!
    private weak var pwdTextF: UITextField!
    
    private weak var phoneTextView: UIView!
    private weak var pwdTextView: UIView!
    
    private weak var forgetBtn: UIButton!
    
    private weak var vc: UIViewController!
    
    var clickReturnBlock: (() -> Void)?
    var returnKeyHander: IQKeyboardReturnKeyHandler!
    
    init(phoneTextF: UITextField, pwdTextF: UITextField, forgetBtn: UIButton, phoneTextView: UIView, pwdTextView: UIView, vc: UIViewController) {
        super.init()
        self.phoneTextF = phoneTextF
        self.pwdTextF = pwdTextF
        
        self.forgetBtn = forgetBtn
        
        self.phoneTextView = phoneTextView
        self.pwdTextView = pwdTextView
        
        self.vc = vc
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func btnAddTarget() {
        forgetBtn.addTarget(self, action: #selector(forgetBtnClicked), for: .touchUpInside)
    }
    
    func initialize()
    {
        let placeholderAtt = [NSAttributedString.Key.foregroundColor : UIColor(hexString: "#AAAAAA")]
        phoneTextF.attributedPlaceholder = NSAttributedString(string: localizableStr("账号"), attributes: placeholderAtt)
        pwdTextF.attributedPlaceholder = NSAttributedString(string: localizableStr("密码"), attributes: placeholderAtt)
        
        phoneTextF.textColor = UIColor(hexString: "#333333")
        pwdTextF.textColor = UIColor(hexString: "#333333")
        
        btnAddTarget()
        
        setTextView()
        setTextF()
    }
    
    func setTextView() {
        phoneTextView.layer.borderWidth = 2
        phoneTextView.layer.borderColor = UIColor(hexString: "#D8E0EE").cgColor
        phoneTextView.backgroundColor = .clear
        pwdTextView.layer.borderWidth = 2
        pwdTextView.layer.borderColor = UIColor(hexString: "#D8E0EE").cgColor
        pwdTextView.backgroundColor = .clear
    }
    
    func setTextF() {
        phoneTextF.tintColor = UIColor(hexString: "#76859C")
        phoneTextF.delegate = self
        pwdTextF.tintColor = UIColor(hexString: "#76859C")
        pwdTextF.delegate = self
        returnKeyHander = IQKeyboardReturnKeyHandler(controller: vc)
        returnKeyHander.lastTextFieldReturnKeyType = .done
    }
    
    @objc func forgetBtnClicked() {
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
        
        let customView = INSForgetView()
        attributes.lifecycleEvents.didAppear = {
            customView.becomeFirstResponder()
        }
        SwiftEntryKit.display(entry: customView, using: attributes, presentInsideKeyWindow: true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 103 {
            phoneTextView.layer.borderColor = UIColor(hexString: "#76859C").cgColor
//            phoneTextView.backgroundColor = UIColor(hexString: "#F4F9FC")
        } else if textField.tag == 104 {
            pwdTextView.layer.borderColor = UIColor(hexString: "#76859C").cgColor
//            pwdTextView.backgroundColor = UIColor(hexString: "#F4F9FC")
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 103 {
            phoneTextView.layer.borderColor = UIColor(hexString: "#D8E0EE").cgColor
            phoneTextView.backgroundColor = .clear
        } else if textField.tag == 104 {
            pwdTextView.layer.borderColor = UIColor(hexString: "#D8E0EE").cgColor
            pwdTextView.backgroundColor = .clear
        }
        return true
    }
}

extension INSPwdLoginVM: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 104 {
            if clickReturnBlock != nil {
                clickReturnBlock!()
            }
        }
        return true
    }
}
