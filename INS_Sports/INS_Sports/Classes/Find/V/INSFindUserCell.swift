//
//  INSFindUserCell.swift
//  DigitalCash_1117
//
//  Created by Ssiswent on 11/19/20.
//

import UIKit
import ViewAnimator
import Lottie

class INSFindUserCell: UITableViewCell, TableCellInterface {
    
    var model: TableCellModelInterface?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var changeView: UIView!
    var lottieView: LOTAnimationView?
    
    var usersArray = [INSUserModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        selectionStyle = .none
        addLottieView()
        setCollectionView()
        getRecommendUsers()
    }
    
    override func didMoveToWindow() {
        if self.window != nil {
            NotificationCenter.default.addObserver(self, selector: #selector(getRecommendUsers), name: NSNotification.Name(rawValue: "TableViewRefresh"), object: nil)
        }
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        if newWindow == nil {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    func addLottieView() {
        lottieView = .init(name: "lottie_changeUser")
        lottieView?.frame = .zero
        
        lottieView?.contentMode = .scaleAspectFill
        
        lottieView?.loopAnimation = false
//        lottieView?.animationSpeed = 2
        changeView.addSubview(lottieView!)
        
        lottieView?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        changeView.sendSubviewToBack(lottieView!)
    }
    
    
    @IBAction func changeBtnClicked(_ sender: Any) {
        lottieView?.play()
        getRecommendUsers()
    }
    
    func setCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 191)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "INSUserCollectionCell", bundle: nil), forCellWithReuseIdentifier: "INSUserCollectionCell")
    }
}

extension INSFindUserCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if usersArray.count >= 8
        {
            return 8
        }
        else
        {
            return usersArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "INSUserCollectionCell", for: indexPath) as! INSUserCollectionCell
        cell.model = usersArray[indexPath.row]
        return cell
    }
}

// MARK: Network request
extension INSFindUserCell {
    @objc func getRecommendUsers() {
        SVProgressHUD.show()
        weak var weakSelf = self
        SSNetwork.shared.GET(URLStr: API.getRecommandUserList).success { (result) in
            if let dict = result as? [String:Any] {
                if dict["success"] as! Bool {
                    if let arr = INSUserModel.mj_objectArray(withKeyValuesArray:dict["data"]) as? [INSUserModel] {
                        weakSelf?.usersArray = arr
                        SVProgressHUD.dismiss()
                        weakSelf?.collectionView.reloadSections(IndexSet(integer: 0))
                        if let cells = weakSelf?.collectionView.visibleCells(in: 0) {
                            UIView.animate(views: cells,
                                           animations: BaseTableViewModel.Anim.vectorAnim,
                                           duration: 0.5)
                        }
                    }
                }
            }
        }.failed { (error) in
            SVProgressHUD.gp_showInfo(withStatus: localizableStr("Network error"))
            SVProgressHUD.dismiss()
        }
    }
}
