//
//  SetValueView.swift
//  HealthKit_Learning
//
//  Created by Flamingo on 2021/3/8.
//

import UIKit
import SwiftEntryKit

class SetValueView: UIView {
    
    var saveOneItemBlock: ((Double) -> Void)?
    var saveTwoItemBlock: ((Double, Double) -> Void)?

    @IBOutlet var view: UIView!
    
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var weightView: UIView!
    
    @IBOutlet weak var heightTextF: UITextField!
    @IBOutlet weak var weightTextF: UITextField!
    @IBOutlet weak var heightTextView: UIView!
    @IBOutlet weak var weightTextView: UIView!
    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var heightViewH: NSLayoutConstraint!
    @IBOutlet weak var heightViewT: NSLayoutConstraint!
    
    @IBOutlet weak var weightViewH: NSLayoutConstraint!
    @IBOutlet weak var weightViewT: NSLayoutConstraint!
    
    var setValueViewH: CGFloat = 274
    
    // 1:只设置身高，2:只设置体重，3:都设置
    var valueType: Int = 3
    
    public init(valueType: Int) {
        super.init(frame: UIScreen.main.bounds)
        fromNib()
        
        setUpView()
        
        self.valueType = valueType
        
        switch valueType {
        case 1:
            weightView.isHidden = true
            weightViewH.constant = 0
            weightViewT.constant = 0
            setValueViewH = 181
        case 2:
            heightView.isHidden = true
            heightViewH.constant = 0
            heightViewT.constant = 0
            setValueViewH = 181
        default:
            break
        }
        
        setupTapGestureRecognizer()
        
        set(.height,
            of: setValueViewH,
            priority: .defaultHigh)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView()
    {
        view.backgroundColor = .clear
        
        setTextView()
        setTextF()
        setConfirmBtn()
        confirmBtn.isEnabled = false
    }
    
    func setTextView() {
        heightTextView.layer.borderWidth = 2
        heightTextView.layer.borderColor = UIColor(hexString: "#D8E0EE").cgColor
        heightTextView.backgroundColor = .clear
        weightTextView.layer.borderWidth = 2
        weightTextView.layer.borderColor = UIColor(hexString: "#D8E0EE").cgColor
        weightTextView.backgroundColor = .clear
    }
    
    func setTextF() {
        heightTextF.tintColor = UIColor(hexString: "#76859C")
        heightTextF.delegate = self
        heightTextF.addTarget(self, action: #selector(setConfirmBtnState), for: .editingChanged)
        weightTextF.tintColor = UIColor(hexString: "#76859C")
        weightTextF.delegate = self
        weightTextF.addTarget(self, action: #selector(setConfirmBtnState), for: .editingChanged)
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
    
    @IBAction func confirmBtnClicked(_ sender: Any) {
        switch valueType {
        case 1:
            let doubleValue = Double(heightTextF.text!)!
            ProfileDataStore.saveHeightSample(height: doubleValue, date: Date())
            if saveOneItemBlock != nil {
                saveOneItemBlock!(doubleValue)
            }
//            heightTextF.resignFirstResponder()
            SwiftEntryKit.dismiss()
        case 2:
            let doubleValue = Double(weightTextF.text!)!
            ProfileDataStore.saveWeightSample(weight: doubleValue, date: Date())
            if saveOneItemBlock != nil {
                saveOneItemBlock!(doubleValue)
            }
//            weightTextF.resignFirstResponder()
            SwiftEntryKit.dismiss()
        default:
            let heightValue = Double(heightTextF.text!)!
            let weightValue = Double(weightTextF.text!)!
            ProfileDataStore.saveHeightSample(height: heightValue, date: Date())
            ProfileDataStore.saveWeightSample(weight: weightValue, date: Date())
            if saveTwoItemBlock != nil {
                saveTwoItemBlock!(heightValue, weightValue)
            }
//            weightTextF.resignFirstResponder()
            SwiftEntryKit.dismiss()
        }
    }
    
    public func becomeFirstResponder() {
        switch valueType {
        case 1:
            heightTextF.becomeFirstResponder()
        case 2:
            weightTextF.becomeFirstResponder()
        default:
            heightTextF.becomeFirstResponder()
        }
    }
    
    @objc func setConfirmBtnState() {
        switch valueType {
        case 1:
            if heightTextF.text?.count != 0 {
                guard let doubleValue = Double(heightTextF.text!) else { return }
                if doubleValue >= 30 && doubleValue <= 300 {
                    confirmBtn.isEnabled = true
                } else {
                    confirmBtn.isEnabled = false
                }
            } else {
                confirmBtn.isEnabled = false
            }
        case 2:
            if weightTextF.text?.count != 0 {
                guard let doubleValue = Double(weightTextF.text!) else { return }
                if doubleValue >= 2.268 && doubleValue <= 362.873 {
                    confirmBtn.isEnabled = true
                } else {
                    confirmBtn.isEnabled = false
                }
            } else {
                confirmBtn.isEnabled = false
            }
        default:
            if weightTextF.text?.count != 0 && heightTextF.text?.count != 0 {
                guard let heightValue = Double(heightTextF.text!) else { return }
                guard let weightValue = Double(weightTextF.text!) else { return }
                let rightHeight = heightValue >= 30 && heightValue <= 300
                let rightWeight = weightValue >= 2.268 && weightValue <= 362.873
                if  rightHeight && rightWeight {
                    confirmBtn.isEnabled = true
                } else {
                    confirmBtn.isEnabled = false
                }
            } else {
                confirmBtn.isEnabled = false
            }
        }
    }
    
    private func setupTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(tapGestureRecognized)
        )
        tapGestureRecognizer.numberOfTapsRequired = 1
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func tapGestureRecognized() {
        endEditing(true)
    }
}

extension SetValueView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 101 {
            heightTextView.layer.borderColor = UIColor(hexString: "#76859C").cgColor
            heightTextView.backgroundColor = UIColor(hexString: "#F4F9FC")
        } else if textField.tag == 102 {
            weightTextView.layer.borderColor = UIColor(hexString: "#76859C").cgColor
            weightTextView.backgroundColor = UIColor(hexString: "#F4F9FC")
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 101 {
            heightTextView.layer.borderColor = UIColor(hexString: "#D8E0EE").cgColor
            heightTextView.backgroundColor = .clear
        } else if textField.tag == 102 {
            weightTextView.layer.borderColor = UIColor(hexString: "#D8E0EE").cgColor
            weightTextView.backgroundColor = .clear
        }
    }
}
