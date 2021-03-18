//
//  INSPublishViewController.swift
//  CashAndFancyBooks
//
//  Created by Ssiswent on 11/25/20.
//

import UIKit
import AnyImageKit

class INSPublishViewController: INSBaseViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var contentTextV: SSTextView!
    @IBOutlet weak var publishBgView: UIView!
    @IBOutlet weak var pickImgBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var NavTitle: UILabel!
    @IBOutlet weak var publishBtn: UIButton!
    
    var imgURL:String?
    var saveURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavTitle.text = localizableStr("Publish dynanmics")
        initialize()
    }
    
    func initialize() {
        publishBgView.setRadius(5)
        
        bgView.setRadius(10)
        
        deleteBtn.isHidden = true
        
        publishBtn.backgroundColor = AppGlobalThemeColor
        
        contentTextV.placeholder = "给大家分享一些趣事吧~"
        contentTextV.placeholderFont = .systemFont(ofSize: 15, weight: .medium)
        contentTextV.placeholderColor = UIColor(hexString: "#999999")
    }
    
    @IBAction func dismissBtnClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteBtnClicked(_ sender: Any) {
        pickImgBtn.setBackgroundImage(nil, for: .normal)
        deleteBtn.isHidden = true
    }
    
    @IBAction func pickImgBtnClicked(_ sender: Any) {
        presentPhotoView()
    }
    
    func presentPhotoView()
    {
        let photoView = INSPhotoView(frame: CGRect(x: 0, y: 0, width: 345, height: 250))
        photoView.titleLabel.text = "添加图片"
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
    
    @IBAction func publishBtnClicked(_ sender: Any) {
        publishRequest()
    }
}

// MARK: 图片选择器
extension INSPublishViewController: ImagePickerControllerDelegate {
    
    /// 创建并推出图片选择器
    func createAndPresentPicker() {
        var options = PickerOptionsInfo()
        options.selectLimit = 1
        options.photoMaxWidth = 2500
//        options.allowUseOriginalImage = true
        options.selectionTapAction = .openEditor
        options.editorOptions = .photo
        options.saveEditedAsset = false
        
        var editorOptions = EditorPhotoOptionsInfo()
        editorOptions.tintColor = AppGlobalThemeColor
        options.editorPhotoOptions = editorOptions
        
        options.captureOptions.mediaOptions = .photo
        
        let controller = ImagePickerController(options: options, delegate: self)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
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
extension INSPublishViewController: ImageCaptureControllerDelegate {
    
    /// 创建并推出相机
    func createAndPresentCapture() {
        var options = CaptureOptionsInfo()
        options.tintColor = AppGlobalThemeColor
        options.mediaOptions = .photo
        
        var editorOptions = EditorPhotoOptionsInfo()
        editorOptions.tintColor = AppGlobalThemeColor
        options.editorPhotoOptions = editorOptions
        
        let controller = ImageCaptureController(options: options, delegate: self)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
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
extension INSPublishViewController {
    /// 上传图片
    /// - Parameter img: 要上传的图片
    func uploadImg(img: UIImage)
    {
        weak var weakSelf = self
        SSNetwork.shared.UPLOADImg(URLStr: API.uploadImg, image: img).success { (result) in
            weakSelf?.pickImgBtn.setBackgroundImage(img, for: .normal)
            weakSelf?.deleteBtn.isHidden = false
            weakSelf?.saveURL = result as? String
        }.failed { (_) in
            SVProgressHUD.gp_showInfo(withStatus: localizableStr("Network error"))
        }
    }
    
    func publishRequest() {
        weak var weakSelf = self
        if !INSAccountManager.shared.isLogin {
            SVProgressHUD.gp_showInfo(withStatus: localizableStr("Please login first"), delay: 2)
            return
        }
        if contentTextV.text.isEmpty {
            SVProgressHUD.gp_showInfo(withStatus: "The content cannot be empty", delay: 1)
            return
        }
        
        var params = [String:Any]()
        params["userId"] = INSAccountManager.shared.user!.id
        params["content"] = contentTextV.text
        if let picStr = saveURL
        {
            params["picture"] = picStr
        }
        
        SSNetwork.shared.POST(URLStr: API.publishTalk, params: params).success { (result) in
            if let dict = result as? [String:Any] {
                if dict["success"] as? Bool ?? false {
                    weakSelf?.dismiss(animated: true, completion: nil)
                    SVProgressHUD.gp_showSuccess(withStatus: "Publish successfully", delay: 1)
                } else {
                    SVProgressHUD.gp_showInfo(withStatus: dict["msg"] as? String ?? "error", delay: 2)
                }
            }
        }.failed { (_) in
            SVProgressHUD.gp_showInfo(withStatus: localizableStr("Network error"), delay: 2)
        }
    }
}
