//
//  INSMeVM.swift
//  INS_Sports
//
//  Created by Flamingo on 2021/3/2.
//

import UIKit

class INSMeVM: INSBaseViewModel {
    
    private weak var nameLabel: UILabel!
    private weak var sigLabel: UILabel!
    private weak var avatarImgView: UIImageView!
    
    private weak var editBtn: UIButton!
    private weak var loginBtn: UIButton!
    
    private weak var collectionView: UICollectionView!
    
    var hasClearedCache = false
    
    init(nameLabel: UILabel, sigLabel: UILabel, avatarImgView: UIImageView, editBtn: UIButton, loginBtn: UIButton, collectionView: UICollectionView) {
        super.init()
        self.nameLabel = nameLabel
        self.sigLabel = sigLabel
        self.avatarImgView = avatarImgView
        self.editBtn = editBtn
        self.loginBtn = loginBtn
        
        self.collectionView = collectionView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 125, height: 155)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 15
        layout.scrollDirection = .horizontal
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "INSMineCollectionCell", bundle: nil), forCellWithReuseIdentifier: "INSMineCollectionCell")
    }
    
    func btnAddTarget() {
        editBtn.addTarget(self, action: #selector(pushEditVC), for: .touchUpInside)
        loginBtn.addTarget(self, action: #selector(jumpToLoginViewController), for: .touchUpInside)
    }
    
    @objc func jumpToLoginViewController()
    {
        SVProgressHUD.gp_showInfo(withStatus: localizableStr("Please login first"), delay: 1)
        let vc = INSLoginViewController()
        currentViewController()?.present(vc, animated: true, completion: nil)
    }
    
    func setUserInfo() {
        avatarImgView.sd_setImage(with: URL(string: (INSAccountManager.shared.user?.head)!), placeholderImage: #imageLiteral(resourceName: "pic_user_default"), options: .continueInBackground, completed: nil)
        nameLabel.text = INSAccountManager.shared.user?.nickName
        sigLabel.text = INSAccountManager.shared.user?.signature
    }
    
    @objc func judgeIsLogin() {
        if !INSAccountManager.shared.isLogin {
            loginBtn.isHidden = false
            editBtn.isHidden = true
            nameLabel.isHidden = true
            sigLabel.isHidden = true
            avatarImgView.image = #imageLiteral(resourceName: "pic_user_default")
        }
        else{
            loginBtn.isHidden = true
            editBtn.isHidden = false
            nameLabel.isHidden = false
            sigLabel.isHidden = false
            
            setUserInfo()
        }
    }
    
    @objc func loginSuccess()
    {
        judgeIsLogin()
    }
    
    func clearUser()
    {
        INSAccountManager.shared.isLogin = false
        INSAccountManager.shared.user = nil
        INSAccountManager.shared.userId = ""
        INSAccountManager.shared.account = ""
        INSAccountManager.shared.psw = ""
        judgeIsLogin()
    }
    
    @objc func pushEditVC() {
        let vc = INSEditInfoViewController()
        vc.changeSuccessBlock = refreshUserInfo
        vc.logoutBlock = clearUser
        currentViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushAboutVC() {
        let vc = INSAboutUsViewController()
        currentViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushFeedbackVC() {
        let vc = INSHelpViewController()
        currentViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushTraceVC() {
        let vc = INSTraceViewController()
        currentViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushCollectionVC() {
        let vc = INSCollectedStadiumsViewController()
        currentViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func agreementBtnClicked() {
        let vc = INSPrivacyViewController()
        vc.titleStr = localizableStr("User agreement")
        currentViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func privacyBtnClicked() {
        let vc = INSPrivacyViewController()
        currentViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func clearBtnClicked() {
        if hasClearedCache {
            SVProgressHUD.gp_showInfo(withStatus: localizableStr("No cache temporarily"), delay: 1)
        } else {
            SVProgressHUD.show()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                SVProgressHUD.showSuccess(withStatus: localizableStr("Clear cache successfully"))
                SVProgressHUD.dismiss(withDelay: 1)
            }
            hasClearedCache = true
        }
    }
}

extension INSMeVM: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "INSMineCollectionCell", for: indexPath) as! INSMineCollectionCell
        cell.rowIndex = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            pushCollectionVC()
        case 1:
            pushTraceVC()
        case 2:
            pushFeedbackVC()
        case 3:
            pushAboutVC()
        case 4:
            privacyBtnClicked()
        case 5:
            clearBtnClicked()
        default:
            break
        }
    }
}

// MARK: Network request
extension INSMeVM
{
    /// 更新用户信息
    func refreshUserInfo()
    {
        weak var weakSelf = self
        let params = [
            "userId": INSAccountManager.shared.user?.id ?? "0"
        ]
        SSNetwork.shared.POST(URLStr: API.refreshUserInfo, params: params).success { (result) in
            if let dict = result as? [String:Any]{
                if dict["success"] as? Bool ?? false {
                    if let infoModel = INSUserModel.mj_object(withKeyValues: dict["data"]) {
                        INSAccountManager.shared.user = infoModel
                        weakSelf?.setUserInfo()
                    }
                }
                else {
                    SVProgressHUD.gp_showInfo(withStatus: dict["msg"] as? String ?? "error", delay: 1)
                }
            }
        }.failed { (error) in
            SVProgressHUD.gp_showInfo(withStatus: localizableStr("Network error"), delay: 1)
        }
    }
}
