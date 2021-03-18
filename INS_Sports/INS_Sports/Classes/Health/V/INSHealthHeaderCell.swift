//
//  IFSNewsCell.swift
//  BitBitBit
//
//  Created by Flamingo on 2021/1/11.
//

import UIKit
import HealthKit
import SwiftEntryKit
import Lottie

class INSHealthHeaderCell: UITableViewCell, TableCellInterface {
    var model: TableCellModelInterface?
    
    private enum ProfileDataError: Error {
        
        case missingBodyMassIndex
        
        var localizedDescription: String {
            switch self {
            case .missingBodyMassIndex:
                return "Unable to calculate body mass index with available profile data."
            }
        }
    }
    
    @IBOutlet weak var refreshView: UIView!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var bodyMassIndexLabel: UILabel!
    @IBOutlet weak var stepCountLabel: UILabel!
    @IBOutlet weak var kcalLabel: UILabel!
    @IBOutlet weak var kcalNeededLabel: UILabel!
    @IBOutlet weak var kcalNeededTitleLabel: UILabel!
    
    @IBOutlet weak var footballTitleLabel: UILabel!
    @IBOutlet weak var badmintonTitleLabel: UILabel!
    @IBOutlet weak var pingpongTitleLabel: UILabel!
    @IBOutlet weak var tennisTitleLabel: UILabel!
    
    @IBOutlet weak var footballLabel: UILabel!
    @IBOutlet weak var badmintonLabel: UILabel!
    @IBOutlet weak var pingpongLabel: UILabel!
    @IBOutlet weak var tennisLabel: UILabel!
    
    var lottieView: LOTAnimationView?
    
    @IBOutlet weak var bgViewH: NSLayoutConstraint!
    
    private let userHealthProfile = UserHealthProfile()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        selectionStyle = .none
        
        addLottieView()
        
        bgViewH.constant = ((KScreenWidth - 60) * 536) / 500
        
        loadData()
    }
    
    override func didMoveToWindow() {
        if self.window != nil {
            NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name(rawValue: "TableViewRefresh"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(setHeightAndWeight), name: NSNotification.Name(rawValue: "SetHeightAndWeight"), object: nil)
        }
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        if newWindow == nil {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    @objc func loadData() {
        judgeIfAuthorized()
        loadAndDisplayStepCount()
    }
    
    func addLottieView() {
        lottieView = .init(name: "lottie_refresh")
        lottieView?.frame = .zero
        
        lottieView?.contentMode = .scaleAspectFill
        
        lottieView?.loopAnimation = false
        lottieView?.animationSpeed = 2
        refreshView.addSubview(lottieView!)
        
        lottieView?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        refreshView.sendSubviewToBack(lottieView!)
    }
    
    @IBAction func refreshBtnClicked(_ sender: Any) {
        lottieView?.play()
        loadData()
    }
    
    func updateLabels() {
        if let weight = userHealthProfile.weightInKilograms {
            let weightFormatter = MassFormatter()
            weightFormatter.isForPersonMassUse = true
            weightLabel.text = weightFormatter.string(fromKilograms: weight)
        }
        
        if let height = userHealthProfile.heightInMeters {
            let heightFormatter = LengthFormatter()
            heightFormatter.isForPersonHeightUse = true
            heightLabel.text = heightFormatter.string(fromMeters: height)
        }
        
        if let bodyMassIndex = userHealthProfile.bodyMassIndex {
            bodyMassIndexLabel.text = String(format: "%.02f", bodyMassIndex)
        }
        
        if let stepCount = userHealthProfile.stepCount {
            stepCountLabel.text = "\(stepCount) 步"
        }
        
        if let kcal = userHealthProfile.kcal {
            kcalLabel.text = String(format: "%.02f 大卡", kcal)
        }
    }
    
    @IBAction func footballBtnClicked(_ sender: Any) {
        let vc = INSClassifiedStadiumVC()
        vc.stadiumType = StadiumType.足球.rawValue
        currentViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func badmintonBtnClicked(_ sender: Any) {
        let vc = INSClassifiedStadiumVC()
        vc.stadiumType = StadiumType.羽毛球.rawValue
        currentViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func pingpongBtnClicked(_ sender: Any) {
        let vc = INSClassifiedStadiumVC()
        vc.stadiumType = StadiumType.乒乓球.rawValue
        currentViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tennisClicked(_ sender: Any) {
        let vc = INSClassifiedStadiumVC()
        vc.stadiumType = StadiumType.网球.rawValue
        currentViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
}

extension INSHealthHeaderCell {
    /// 判断是否授权
    func judgeIfAuthorized() {
        guard let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
              let height = HKObjectType.quantityType(forIdentifier: .height),
              let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass) else {
            return
        }
        let objTypes = [bodyMassIndex, height, bodyMass]
        let states = objTypes.map { HKHealthStore().authorizationStatus(for: $0).rawValue }
        print("states:",states)
        if states == [2, 2, 2] {
            loadHeightAndWeightData()
        } else {
            displayAlert(title: nil, message: #"还未获取到相应访问健康数据的权限，请到"设置"->"健康"->"数据访问权限与设备"中开启"#)
        }
    }
    
    /// 获取身高
    func loadAndDisplayMostRecentHeight() {
        //1. Use HealthKit to create the Height Sample Type
        guard let heightSampleType = HKSampleType.quantityType(forIdentifier: .height) else {
            print("Height Sample Type is no longer available in HealthKit")
            return
        }
        
        ProfileDataStore.getMostRecentSample(for: heightSampleType) { (sample, error) in
            
            guard let sample = sample else {
                
                if let error = error {
                    self.displayAlert(for: error)
                } else {
//                    self.showSetValueView(isHeight: true)
                }
                
                return
            }
            
            //2. Convert the height sample to meters, save to the profile model,
            //   and update the user interface.
            let heightInMeters = sample.quantity.doubleValue(for: HKUnit.meter())
            self.userHealthProfile.heightInMeters = heightInMeters
            self.updateLabels()
        }
    }
    
    /// 获取体重
    func loadAndDisplayMostRecentWeight() {
        guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
            print("Body Mass Sample Type is no longer available in HealthKit")
            return
        }
        
        ProfileDataStore.getMostRecentSample(for: weightSampleType) { (sample, error) in
            
            guard let sample = sample else {
                
                if let error = error {
                    self.displayAlert(for: error)
                } else {
//                    self.showSetValueView(isHeight: false)
                }
                return
            }
            
            let weightInKilograms = sample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
            self.userHealthProfile.weightInKilograms = weightInKilograms
            self.updateLabels()
        }
    }
    
    /// 获取或计算并存储BMI
    func loadAndDisplayMostRecentBMI() {
        guard let bodyMassIndexSampleType = HKSampleType.quantityType(forIdentifier: .bodyMassIndex) else {
            print("Body Mass Index Sample Type is no longer available in HealthKit")
            return
        }
        
        ProfileDataStore.getMostRecentSample(for: bodyMassIndexSampleType) { (sample, error) in
            
            guard let sample = sample else {
                if let error = error {
                    self.displayAlert(for: error)
                } else {
                    self.saveBodyMassIndexToHealthKit()
                }
                return
            }
            
            let bodyMassIndex = sample.quantity.doubleValue(for: .count())
            self.userHealthProfile.bodyMassIndex = bodyMassIndex
            self.updateLabels()
        }
    }
    
    func saveBodyMassIndexToHealthKit() {
        guard let weight = userHealthProfile.weightInKilograms else {
            displayAlert(title: nil, message: "还未获取到体重信息")
            return
        }
        
        guard let height = userHealthProfile.heightInMeters else {
            displayAlert(title: nil, message: "还未获取到身高信息")
            return
        }
        
        guard height > 0 else {
            return
        }
        
        let bodyMassIndex = (weight/(height*height))
        
        ProfileDataStore.saveBodyMassIndexSample(bodyMassIndex: bodyMassIndex, date: Date())
        
        self.userHealthProfile.bodyMassIndex = bodyMassIndex
        self.updateLabels()
    }
    
    /// 获取步数
    func loadAndDisplayStepCount() {
        ProfileDataStore.getStepCount() { (stepCount, error) in
            guard let stepCount = stepCount else {
                self.displayAlert(title: nil, message: "没有获取到步数数据，请检查是否授权")
                //                if let error = error {
                //                    self.displayAlert(for: error)
                //                }
                return
            }
            
            self.userHealthProfile.stepCount = stepCount
            self.updateLabels()
        }
    }
    
    /// 获取卡路里
    func loadAndDisplayKcal() {
        guard let weight = userHealthProfile.weightInKilograms else {
            displayAlert(title: nil, message: "还未获取到体重信息")
            return
        }
        ProfileDataStore.calculateKcal(weight: weight) { (kcal, error) in
            guard let kcal = kcal else {
                
                if let error = error {
                    self.displayAlert(for: error)
                }
                return
            }
            
            if kcal == 0 {
                self.displayAlert(title: nil, message: "没有获取到步行或跑步距离数据，请检查是否授权")
                return
            }
            
            self.userHealthProfile.kcal = kcal
            self.updateLabels()
            self.caculateExerciseToTake()
        }
    }
    
    /// 计算需要运动的量
    func caculateExerciseToTake() {
        guard let weight = self.userHealthProfile.weightInKilograms else {
            self.displayAlert(title: nil, message: "还未获取到体重信息")
            return
        }
        guard let kcal = self.userHealthProfile.kcal else {
            self.displayAlert(title: nil, message: "还未获取到已消耗卡路里")
            return
        }
        let kcalNeeded: Double = 200 - kcal
        //未达标
        if kcalNeeded > 0 {
            let showLabelsArr = [kcalNeededLabel, footballLabel, badmintonLabel, pingpongLabel, tennisLabel]
            for label in showLabelsArr {
                label?.isHidden = false
            }
            let changeLabelsArr = [footballTitleLabel, badmintonTitleLabel, pingpongTitleLabel, tennisTitleLabel]
            for label in changeLabelsArr {
                label?.text = "约需："
            }
            kcalNeededLabel.text = String(format: "%.02f 大卡", kcalNeeded)
            kcalNeededTitleLabel.text = "您还需锻炼消耗约："
            
            /// 计算卡路里的公式
            func calculatCalTimeFormula(MET: Double) -> Double {
                let kcalPerHour = ((MET * weight * 3.5) / 200) * 60
                return kcalNeeded / kcalPerHour
            }
            //计算足球时间
            let footballTime = calculatCalTimeFormula(MET: 7)
            footballLabel.text = String(format: "%.02f h", footballTime)
            
            //计算羽毛球时间
            let badmintonTime = calculatCalTimeFormula(MET: 5.5)
            badmintonLabel.text = String(format: "%.02f h", badmintonTime)
            
            //计算乒乓球时间
            let pingpongTime = calculatCalTimeFormula(MET: 4)
            pingpongLabel.text = String(format: "%.02f h", pingpongTime)
            
            //计算网球时间
            let tennisTime = calculatCalTimeFormula(MET: 7.3)
            tennisLabel.text = String(format: "%.02f h", tennisTime)
        } else {
            let hiddenLabelsArr = [kcalNeededLabel, footballLabel, badmintonLabel, pingpongLabel, tennisLabel]
            for label in hiddenLabelsArr {
                label?.isHidden = true
            }
            footballTitleLabel.text = "足球"
            badmintonTitleLabel.text = "羽毛球"
            pingpongTitleLabel.text = "乒乓球"
            tennisTitleLabel.text = "网球"
            kcalNeededTitleLabel.text = "您的当日锻炼量已达标，需要更多吗"
        }
        
        // 计算所需步数
//        var stepsNeeded: Int = 0
//        if #available(iOS 14.0, *) {
//            guard let speedSampleType = HKSampleType.quantityType(forIdentifier: .walkingSpeed) else {
//                print("Walking Speed Sample Type is no longer available in HealthKit")
//                return
//            }
//            guard let stepLengthSampleType = HKSampleType.quantityType(forIdentifier: .walkingStepLength) else {
//                print("Walking Step Length Sample Type is no longer available in HealthKit")
//                return
//            }
//
//            //获取平均速度
//            ProfileDataStore.getAVGValue(for: speedSampleType, isSpeed: true) { (speed, error) in
//                guard let speed = speed else {
//                    if let error = error {
//                        self.displayAlert(for: error)
//                    }
//                    return
//                }
//                if speed.isNaN {
//                    self.displayAlert(title: nil, message: "没有获取到步行速度数据，请检查授权")
//                    return
//                }
//                //获取平均步长
//                ProfileDataStore.getAVGValue(for: stepLengthSampleType, isSpeed: false) { (stepLength, error) in
//                    guard let stepLength = stepLength else {
//                        if let error = error {
//                            self.displayAlert(for: error)
//                        }
//                        return
//                    }
//                    if stepLength.isNaN {
//                        self.displayAlert(title: nil, message: "没有获取到步长数据，请检查授权")
//                        return
//                    }
//                    let MET = 2.4 + (speed - 2.7) / 0.2 * 0.1
//                    let timeNeeded = kcalNeeded / MET / weight
//                    stepsNeeded = Int(timeNeeded * speed * 1000 / stepLength)
//
//                    print("stepsNeeded:",stepsNeeded)
////                    let message = "根据成年人健康生活每天需要运动的量来计算，您需要再运动消耗约\(Int(kcalNeeded))大卡，根据您的平均步速、步长和体重来计算，您需要再走约\(stepsNeeded)步"
////                    self.displayAlert(title: nil, message: message)
//                }
//            }
//        } else {
//            guard let stepCount = self.userHealthProfile.stepCount else {
//                self.displayAlert(title: nil, message: "还未获取到今日步数")
//                return
//            }
//            guard let kcal = self.userHealthProfile.kcal else {
//                self.displayAlert(title: nil, message: "还未获取到已消耗卡路里")
//                return
//            }
//            stepsNeeded = Int(kcalNeeded / (kcal/Double(stepCount)))
//            print("stepsNeeded:",stepsNeeded)
//        }
    }
    
    func loadHeightAndWeightData() {
        guard let heightSampleType = HKSampleType.quantityType(forIdentifier: .height) else {
            print("Height Sample Type is no longer available in HealthKit")
            return
        }
        guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
            print("Body Mass Sample Type is no longer available in HealthKit")
            return
        }
        ProfileDataStore.getMostRecentSample(for: heightSampleType) { (heightSample, error) in
            
            guard let heightSample = heightSample else {
                if let error = error {
                    self.displayAlert(for: error)
                } else {
                    ProfileDataStore.getMostRecentSample(for: weightSampleType) { (weightSample, error) in
                        
                        guard let weightSample = weightSample else {
                            
                            if let error = error {
                                self.displayAlert(for: error)
                            } else {
                                self.showSetValueView(valueType: 3)
                            }
                            return
                        }
                        
                        let weightInKilograms = weightSample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
                        self.userHealthProfile.weightInKilograms = weightInKilograms
                        self.updateLabels()
                        
                        self.showSetValueView(valueType: 1)
                    }
                }

                return
            }
            
            let heightInMeters = heightSample.quantity.doubleValue(for: HKUnit.meter())
            self.userHealthProfile.heightInMeters = heightInMeters
            self.updateLabels()
            
            ProfileDataStore.getMostRecentSample(for: weightSampleType) { (weightSample, error) in
                
                guard let weightSample = weightSample else {
                    
                    if let error = error {
                        self.displayAlert(for: error)
                    } else {
                        self.showSetValueView(valueType: 2)
                    }
                    return
                }
                
                let weightInKilograms = weightSample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
                self.userHealthProfile.weightInKilograms = weightInKilograms
                self.updateLabels()
                self.saveBodyMassIndexToHealthKit()
                self.loadAndDisplayKcal()
            }
        }
    }
    
    @objc func setHeightAndWeight() {
        showSetValueView(valueType: 3)
    }
    
    /// 弹出设置身高或体重的界面
    /// - Parameter valueType: 1:只设置身高，2:只设置体重，3:都设置
    func showSetValueView(valueType: Int) {
        let customView = SetValueView(valueType: valueType)
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
        attributes.statusBar = .dark
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
        attributes.lifecycleEvents.didAppear = {
            customView.becomeFirstResponder()
        }
        if valueType == 1 {
            customView.saveOneItemBlock = { heightValue in
                self.userHealthProfile.heightInMeters = heightValue/100
                self.updateLabels()
                self.saveBodyMassIndexToHealthKit()
                self.loadAndDisplayKcal()
            }
        } else if valueType == 2 {
            customView.saveOneItemBlock = { weightValue in
                self.userHealthProfile.weightInKilograms = weightValue
                self.updateLabels()
                self.saveBodyMassIndexToHealthKit()
                self.loadAndDisplayKcal()
            }
        }
        customView.saveTwoItemBlock = { heightValue, weightValue in
            self.userHealthProfile.heightInMeters = heightValue/100
            self.userHealthProfile.weightInKilograms = weightValue
            self.updateLabels()
            self.saveBodyMassIndexToHealthKit()
            self.loadAndDisplayKcal()
        }
        SwiftEntryKit.display(entry: customView, using: attributes, presentInsideKeyWindow: true)
    }
    
    func displayAlert(for error: Error) {
        
        let alert = UIAlertController(title: nil,
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "确定",
                                      style: .default,
                                      handler: nil))
        
        currentViewController()?.present(alert, animated: true, completion: nil)
    }
    
    func displayAlert(title: String?, message: String?) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "确定",
                                      style: .default,
                                      handler: nil))
        
        currentViewController()?.present(alert, animated: true, completion: nil)
    }
}
