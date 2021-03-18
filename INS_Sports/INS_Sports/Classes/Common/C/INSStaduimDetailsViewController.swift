//
//  INSStaduimDetailsViewController.swift
//  SAKBallSports
//
//  Created by Flamingo on 2020/12/15.
//

import UIKit

class INSStaduimDetailsViewController: INSBaseViewController {
    
    @IBOutlet weak var orderBtn: UIButton!
    var hasOrdered = false
    
    var orderBtnBottomConstant: CGFloat = 10 + KBottomSafeAreaValue
    
    var stadiumModel: INSStadiumModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }
    
    func initialize()
    {
        view.backgroundColor = UIColor(hexString: "#FFFFFF")
        setTitle("场馆详情")
        setTableView()
        view.bringSubviewToFront(orderBtn)
    }
    
    func setTableView()
    {
        addTableView()
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.backgroundColor = .clear
        registerCell(cell: INSStadiumDetailContentCell.self)
        registerCell(cell: INSStadiumDetailRecommendCell.self)
        registerCell(cell: INSStadiumDetailAnnounceCell.self)
    }

    func hideOrderBtn() {
        var hideFrame = orderBtn.frame
        hideFrame.origin.y = KScreenHeight
        UIView.animate(withDuration: 0.5) {
            self.orderBtn.frame = hideFrame
        }
    }
    
    func showOrderBtn() {
        var showFrame = orderBtn.frame
        showFrame.origin.y = KScreenHeight - (orderBtnBottomConstant + showFrame.size.height);
        UIView.animate(withDuration: 0.5) {
            self.orderBtn.frame = showFrame
        }
    }
    
    @IBAction func orderBtnClicked(_ sender: Any) {
        if hasOrdered {
            SVProgressHUD.gp_showInfo(withStatus: "您已预约", delay: 1)
        } else {
            SVProgressHUD.show()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                SVProgressHUD.showSuccess(withStatus: "预约成功")
                SVProgressHUD.dismiss(withDelay: 1)
            }
            hasOrdered = true
        }
    }
}

extension INSStaduimDetailsViewController: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        weak var weakSelf = self
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "INSStadiumDetailContentCell", for: indexPath) as! INSStadiumDetailContentCell
            cell.model = stadiumModel
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "INSStadiumDetailRecommendCell", for: indexPath) as! INSStadiumDetailRecommendCell
            cell.selectedItemBlock = { model in
                let vc = INSStaduimDetailsViewController()
                vc.stadiumModel = model
                weakSelf?.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "INSStadiumDetailAnnounceCell", for: indexPath) as! INSStadiumDetailAnnounceCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0.0001
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0.0001
    }
    
    //预约按钮显示与隐藏
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation: CGPoint = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        
        //下滑显示
        if translation.y > 0 {
            showOrderBtn()
        }
        //上滑隐藏
        else if translation.y < 0 {
            hideOrderBtn()
        }
    }
}

extension INSStaduimDetailsViewController: NavigationBarConfigureStyle
{
    func yp_navigtionBarConfiguration() -> YPNavigationBarConfigurations {
        return [.backgroundStyleOpaque, .backgroundStyleColor, .styleBlack]
    }
    
    func yp_navigationBarTintColor() -> UIColor! {
        .white
    }
    
    func yp_navigationBackgroundColor() -> UIColor! {
        AppGlobalThemeColor
    }
}
