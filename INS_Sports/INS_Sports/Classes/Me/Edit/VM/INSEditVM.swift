//
//  INSEditVM.swift
//  MVVMForBitCoin
//
//  Created by Flamingo on 2020/12/28.
//

import UIKit
import AnyImageKit
import SwiftEntryKit

class INSEditVM: INSBaseViewModel {
    
    private weak var headImgView: UIImageView!
    private weak var nameLabel: UILabel!
    private weak var signatureLabel: UILabel!
    private weak var avatarBtn: UIButton!
    private weak var photoBtn: UIButton!
    private weak var nameBtn: UIButton!
    private weak var sigBtn: UIButton!
    private weak var changeBtn: UIButton!
    private weak var logoutBtn: UIButton!
    
    private var saveURL: String?
    private var changedName: String?
    private var changedSignature: String?
    
    var changeSuccessBlock: (() -> Void)?
    var logoutBlock: (() -> Void)?
    
    init(headImgView: UIImageView, nameLabel: UILabel, sigLabel: UILabel, avatarBtn: UIButton, photoBtn: UIButton, nameBtn: UIButton, sigBtn: UIButton, changeBtn: UIButton, logoutBtn: UIButton) {
        super.init()
        self.headImgView = headImgView
        self.nameLabel = nameLabel
        self.signatureLabel = sigLabel
        self.avatarBtn = avatarBtn
        self.photoBtn = photoBtn
        self.nameBtn = nameBtn
        self.sigBtn = sigBtn
        self.changeBtn = changeBtn
        self.logoutBtn = logoutBtn
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProfile() {
        headImgView.setRadius(55)
        
        let editImg = UIImage(named: "ic_editAvatar")?.templateImg()
        avatarBtn.tintColor = AppGlobalThemeColor
        avatarBtn.setImage(editImg, for: .normal)
        
        let model = INSAccountManager.shared.user
        headImgView.sd_setImage(with: URL(string: (model?.head)!), placeholderImage: #imageLiteral(resourceName: "pic_user_default"), options: .continueInBackground, completed: nil)
        nameLabel.text = model?.nickName
        signatureLabel.text = model?.signature
    }
    
    func btnAddTarget() {
        avatarBtn.addTarget(self, action: #selector(presentPhotoView), for: .touchUpInside)
        photoBtn.addTarget(self, action: #selector(presentPhotoView), for: .touchUpInside)
        nameBtn.addTarget(self, action: #selector(nameBtnClicked), for: .touchUpInside)
        sigBtn.addTarget(self, action: #selector(signatureBtnClicked), for: .touchUpInside)
        changeBtn.addTarget(self, action: #selector(changePwdBtnClicked), for: .touchUpInside)
        logoutBtn.addTarget(self, action: #selector(logoutBtnClicked), for: .touchUpInside)
    }
    
    @objc func presentPhotoView()
    {
        let photoView = INSPhotoView.init(frame: CGRect(x: 0, y: 0, width: 345, height: 240))
        photoView.titleLabel.text = localizableStr("Change avatar")
        photoView.cancelBlock = photoView.hideCoverView
        photoView.albumBlock = {
            photoView.hideCoverView()
            self.createAndPresentPicker()
        }
        photoView.cameraBlock = {
            photoView.hideCoverView()
            self.createAndPresentCapture()
        }
        photoView.showCoverView()
    }
    
    @objc func nameBtnClicked() {
        let changeInfoView = INSChangeInfoView.init(frame: CGRect(x: 0, y: 0, width: 340, height: 181))
        changeInfoView.titleLabel.text = localizableStr("Change nickname")
        changeInfoView.clickCancelBlock = changeInfoView.hideCoverView
        weak var weakSelf = self
        changeInfoView.clickConfirmBlock = {(textStr) in
            changeInfoView.hideCoverView()
            weakSelf?.changedName = textStr
            weakSelf?.nameLabel.text = textStr
            NotificationCenter.default.post(Notification(name: Notification.Name("ChangeInfoSucceed")))
        }
        changeInfoView.showCoverView()
    }
    
    @objc func signatureBtnClicked() {
        let changeInfoView = INSChangeInfoView.init(frame: CGRect(x: 0, y: 0, width: 340, height: 181))
        changeInfoView.titleLabel.text = localizableStr("Change signature")
        changeInfoView.clickCancelBlock = changeInfoView.hideCoverView
        weak var weakSelf = self
        changeInfoView.clickConfirmBlock = {(textStr) in
            changeInfoView.hideCoverView()
            weakSelf?.changedSignature = textStr
            weakSelf?.signatureLabel.text = textStr
            NotificationCenter.default.post(Notification(name: Notification.Name("ChangeInfoSucceed")))
        }
        changeInfoView.showCoverView()
    }
    
    @objc func changePwdBtnClicked(_ sender: Any) {
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
    
    @objc func logoutBtnClicked() {
        weak var weakSelf = self
        if weakSelf?.logoutBlock != nil
        {
            weakSelf?.logoutBlock!()
        }
        currentViewController()?.navigationController?.popViewController(animated: true)
        SVProgressHUD.gp_showSuccess(withStatus: localizableStr("Logout successfully"), delay: 1)
    }
}

// MARK: 图片选择器
extension INSEditVM: ImagePickerControllerDelegate {
    
    /// 创建并推出图片选择器
    func createAndPresentPicker() {
        var options = PickerOptionsInfo()
        options.photoMaxWidth = 2500
        //        options.allowUseOriginalImage = true
        options.selectLimit = 1
        options.saveEditedAsset = false
        options.selectionTapAction = .openEditor
        options.editorOptions = .photo
        
        var editorOptions = EditorPhotoOptionsInfo()
        editorOptions.tintColor = AppGlobalThemeColor
        editorOptions.toolOptions = [.crop]
        editorOptions.cropOptions = [.custom(w: 1, h: 1)]
        options.editorPhotoOptions = editorOptions
        
        options.captureOptions.mediaOptions = .photo
        
        let controller = ImagePickerController(options: options, delegate: self)
        controller.modalPresentationStyle = .fullScreen
        currentViewController()?.present(controller, animated: true, completion: nil)
    }
    
    /// 取消选择（该方法有默认实现，可以省略）
    func imagePickerDidCancel(_ picker: ImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        SVProgressHUD.gp_showInfo(withStatus: "取消选择", delay: 1)
    }

    /// 完成选择
    /// - Parameters:
    ///   - picker: 图片选择器
    ///   - result: 返回结果对象，内部包含所选中的图片资源
    func imagePicker(_ picker: ImagePickerController, didFinishPicking result: PickerResult) {
        let images: [UIImage] = result.assets.map{ $0.image }
        let selectedImg = images[0]
        // 处理你的业务逻辑
        uploadImg(img: selectedImg)
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: 相机
extension INSEditVM: ImageCaptureControllerDelegate {
    
    /// 创建并推出相机
    func createAndPresentCapture() {
        var options = CaptureOptionsInfo()
        options.tintColor = AppGlobalThemeColor
        options.mediaOptions = .photo
        
        var editorOptions = EditorPhotoOptionsInfo()
        editorOptions.tintColor = AppGlobalThemeColor
        editorOptions.toolOptions = [.crop]
        editorOptions.cropOptions = [.custom(w: 1, h: 1)]
        options.editorPhotoOptions = editorOptions
        
        let controller = ImageCaptureController(options: options, delegate: self)
        controller.modalPresentationStyle = .fullScreen
        currentViewController()?.present(controller, animated: true, completion: nil)
    }
    
    /// 取消拍摄（该方法有默认实现，可以省略）
    func imageCaptureDidCancel(_ capture: ImageCaptureController) {
        capture.dismiss(animated: true, completion: nil)
        SVProgressHUD.gp_showInfo(withStatus: "取消拍照", delay: 1)
    }

    /// 完成拍摄
    /// - Parameters:
    ///   - capture: 采集器
    ///   - result: 返回结果对象，内部包含资源 URL、资源类型
    func imageCapture(_ capture: ImageCaptureController, didFinishCapturing result: CaptureResult) {
        if result.type == .photo {
            guard let data = try? Data(contentsOf: result.mediaURL) else { return }
            guard let image = UIImage(data: data) else { return }
            // 处理你的业务逻辑
            uploadImg(img: image)
            capture.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: API
extension INSEditVM {
    /// 上传图片
    /// - Parameter img: 要上传的图片
    func uploadImg(img: UIImage) {
        weak var weakSelf = self
        SSNetwork.shared.UPLOADImg(URLStr: API.uploadImg, image: img).success { (result) in
            weakSelf?.headImgView.image = img
            weakSelf?.saveURL = result as? String
            NotificationCenter.default.post(Notification(name: Notification.Name("ChangeInfoSucceed")))
        }.failed { (error) in
            SVProgressHUD.gp_showInfo(withStatus: localizableStr("Network error"), delay: 1)
        }
    }
    
    /// 更新用户信息
    @objc func changeUserInfoRequest()
    {
        weak var weakSelf = self
        var params = [String: Any]()
        params["id"] = INSAccountManager.shared.user!.id
        if let nameStr = changedName {
            params["nickName"] = nameStr
        }
        if let signatureStr = changedSignature {
            params["signature"] = signatureStr
        }
        if let headStr = saveURL {
            params["head"] = headStr
        }
        
        SSNetwork.shared.PUTJSON(URLStr: API.changeUserInfo, params: params).success { (result) in
            if let dict = result as? [String: Any] {
                if dict["success"] as? Bool ?? false {
                    if weakSelf?.changeSuccessBlock != nil
                    {
                        weakSelf?.changeSuccessBlock!()
                    }
                    currentViewController()?.navigationController?.popViewController(animated: true)
                    SVProgressHUD.gp_showSuccess(withStatus: localizableStr("Save successfully"), delay: 1)
                } else {
                    SVProgressHUD.gp_show(withStatus: dict["msg"] as? String ?? "error", delay: 2)
                }
            }
        }.failed { (_) in
            SVProgressHUD.gp_showInfo(withStatus: localizableStr("Network error"), delay: 1)
        }
    }
}
