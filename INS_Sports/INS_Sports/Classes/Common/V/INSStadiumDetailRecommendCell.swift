//
//  INSStadiumDetailRecommendCell.swift
//  SAKBallSports
//
//  Created by Flamingo on 2020/12/15.
//

import UIKit
import ViewAnimator

class INSStadiumDetailRecommendCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedItemBlock: ((INSStadiumModel) -> Void)?
    
    var stadiumsArray = [INSStadiumModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        selectionStyle = .none
        
        setCollectionView()
        getStadiumsDataRequest()
    }
    
    func setCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 123, height: 108)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        layout.minimumInteritemSpacing = 13
        layout.scrollDirection = .horizontal
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "INSStadiumDetailRecommendCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "INSStadiumDetailRecommendCollectionViewCell")
    }
}

extension INSStadiumDetailRecommendCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if stadiumsArray.count >= 4
        {
            return 4
        }
        else
        {
            return stadiumsArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "INSStadiumDetailRecommendCollectionViewCell", for: indexPath) as! INSStadiumDetailRecommendCollectionViewCell
        cell.model = stadiumsArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedItemBlock != nil {
            selectedItemBlock!(stadiumsArray[indexPath.row])
        }
    }
}

// MARK: API
extension INSStadiumDetailRecommendCell
{
    func getStadiumsDataRequest() {
        weak var weakSelf = self
        var params = [String:Any]()
        //获取随机数
        let count1: Int = Int(arc4random() % 3) + 1
        params["pageNum"] = count1
        params["pageSize"] = 6
        SSNetwork.shared.GET(URLStr: API.getStadiums, params: params).success { (result) in
            if let dict = result as? [String: Any] {
                if dict["success"] as? Bool ?? false {
                    if let arr = INSStadiumModel.mj_objectArray(withKeyValuesArray: (dict["data"] as? [String: Any])?["list"]) as? [INSStadiumModel] {
                        weakSelf?.stadiumsArray = arr
                        weakSelf?.collectionView.reloadSections(IndexSet(integer: 0))
                        let zoomAnimation = AnimationType.zoom(scale: 0.2)
                        let rotateAnimation = AnimationType.rotate(angle: CGFloat.pi/6)
                        if let cells = weakSelf?.collectionView.visibleCells(in: 0) {
                            UIView.animate(views: cells,
                                           animations: [zoomAnimation, rotateAnimation],
                                           duration: 0.5)
                        }
                    }
                }
            }
        }.failed { (error) in
            SVProgressHUD.gp_showInfo(withStatus: "网络错误", delay: 1)
        }
    }
}
