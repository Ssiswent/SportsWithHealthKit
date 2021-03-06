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
            stepCountLabel.text = "\(stepCount) ???"
        }
        
        if let kcal = userHealthProfile.kcal {
            kcalLabel.text = String(format: "%.02f ??????", kcal)
        }
    }
    
    @IBAction func footballBtnClicked(_ sender: Any) {
        let vc = INSClassifiedStadiumVC()
        vc.stadiumType = StadiumType.??????.rawValue
        currentViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func badmintonBtnClicked(_ sender: Any) {
        let vc = INSClassifiedStadiumVC()
        vc.stadiumType = StadiumType.?????????.rawValue
        currentViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func pingpongBtnClicked(_ sender: Any) {
        let vc = INSClassifiedStadiumVC()
        vc.stadiumType = StadiumType.?????????.rawValue
        currentViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tennisClicked(_ sender: Any) {
        let vc = INSClassifiedStadiumVC()
        vc.stadiumType = StadiumType.??????.rawValue
        currentViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
}

extension INSHealthHeaderCell {
    /// ??????????????????
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
            displayAlert(title: nil, message: #"?????????????????????????????????????????????????????????"??????"->"??????"->"???????????????????????????"?????????"#)
        }
    }
    
    /// ????????????
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
    
    /// ????????????
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
    
    /// ????????????????????????BMI
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
            displayAlert(title: nil, message: "???????????????????????????")
            return
        }
        
        guard let height = userHealthProfile.heightInMeters else {
            displayAlert(title: nil, message: "???????????????????????????")
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
    
    /// ????????????
    func loadAndDisplayStepCount() {
        ProfileDataStore.getStepCount() { (stepCount, error) in
            guard let stepCount = stepCount else {
                self.displayAlert(title: nil, message: "???????????????????????????????????????????????????")
                //                if let error = error {
                //                    self.displayAlert(for: error)
                //                }
                return
            }
            
            self.userHealthProfile.stepCount = stepCount
            self.updateLabels()
        }
    }
    
    /// ???????????????
    func loadAndDisplayKcal() {
        guard let weight = userHealthProfile.weightInKilograms else {
            displayAlert(title: nil, message: "???????????????????????????")
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
                self.displayAlert(title: nil, message: "??????????????????????????????????????????????????????????????????")
                return
            }
            
            self.userHealthProfile.kcal = kcal
            self.updateLabels()
            self.caculateExerciseToTake()
        }
    }
    
    /// ????????????????????????
    func caculateExerciseToTake() {
        guard let weight = self.userHealthProfile.weightInKilograms else {
            self.displayAlert(title: nil, message: "???????????????????????????")
            return
        }
        guard let kcal = self.userHealthProfile.kcal else {
            self.displayAlert(title: nil, message: "?????????????????????????????????")
            return
        }
        let kcalNeeded: Double = 200 - kcal
        //?????????
        if kcalNeeded > 0 {
            let showLabelsArr = [kcalNeededLabel, footballLabel, badmintonLabel, pingpongLabel, tennisLabel]
            for label in showLabelsArr {
                label?.isHidden = false
            }
            let changeLabelsArr = [footballTitleLabel, badmintonTitleLabel, pingpongTitleLabel, tennisTitleLabel]
            for label in changeLabelsArr {
                label?.text = "?????????"
            }
            kcalNeededLabel.text = String(format: "%.02f ??????", kcalNeeded)
            kcalNeededTitleLabel.text = "???????????????????????????"
            
            /// ????????????????????????
            func calculatCalTimeFormula(MET: Double) -> Double {
                let kcalPerHour = ((MET * weight * 3.5) / 200) * 60
                return kcalNeeded / kcalPerHour
            }
            //??????????????????
            let footballTime = calculatCalTimeFormula(MET: 7)
            footballLabel.text = String(format: "%.02f h", footballTime)
            
            //?????????????????????
            let badmintonTime = calculatCalTimeFormula(MET: 5.5)
            badmintonLabel.text = String(format: "%.02f h", badmintonTime)
            
            //?????????????????????
            let pingpongTime = calculatCalTimeFormula(MET: 4)
            pingpongLabel.text = String(format: "%.02f h", pingpongTime)
            
            //??????????????????
            let tennisTime = calculatCalTimeFormula(MET: 7.3)
            tennisLabel.text = String(format: "%.02f h", tennisTime)
        } else {
            let hiddenLabelsArr = [kcalNeededLabel, footballLabel, badmintonLabel, pingpongLabel, tennisLabel]
            for label in hiddenLabelsArr {
                label?.isHidden = true
            }
            footballTitleLabel.text = "??????"
            badmintonTitleLabel.text = "?????????"
            pingpongTitleLabel.text = "?????????"
            tennisTitleLabel.text = "??????"
            kcalNeededTitleLabel.text = "????????????????????????????????????????????????"
        }
        
        // ??????????????????
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
//            //??????????????????
//            ProfileDataStore.getAVGValue(for: speedSampleType, isSpeed: true) { (speed, error) in
//                guard let speed = speed else {
//                    if let error = error {
//                        self.displayAlert(for: error)
//                    }
//                    return
//                }
//                if speed.isNaN {
//                    self.displayAlert(title: nil, message: "???????????????????????????????????????????????????")
//                    return
//                }
//                //??????????????????
//                ProfileDataStore.getAVGValue(for: stepLengthSampleType, isSpeed: false) { (stepLength, error) in
//                    guard let stepLength = stepLength else {
//                        if let error = error {
//                            self.displayAlert(for: error)
//                        }
//                        return
//                    }
//                    if stepLength.isNaN {
//                        self.displayAlert(title: nil, message: "?????????????????????????????????????????????")
//                        return
//                    }
//                    let MET = 2.4 + (speed - 2.7) / 0.2 * 0.1
//                    let timeNeeded = kcalNeeded / MET / weight
//                    stepsNeeded = Int(timeNeeded * speed * 1000 / stepLength)
//
//                    print("stepsNeeded:",stepsNeeded)
////                    let message = "??????????????????????????????????????????????????????????????????????????????????????????\(Int(kcalNeeded))?????????????????????????????????????????????????????????????????????????????????\(stepsNeeded)???"
////                    self.displayAlert(title: nil, message: message)
//                }
//            }
//        } else {
//            guard let stepCount = self.userHealthProfile.stepCount else {
//                self.displayAlert(title: nil, message: "???????????????????????????")
//                return
//            }
//            guard let kcal = self.userHealthProfile.kcal else {
//                self.displayAlert(title: nil, message: "?????????????????????????????????")
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
    
    /// ????????????????????????????????????
    /// - Parameter valueType: 1:??????????????????2:??????????????????3:?????????
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
        
        alert.addAction(UIAlertAction(title: "??????",
                                      style: .default,
                                      handler: nil))
        
        currentViewController()?.present(alert, animated: true, completion: nil)
    }
    
    func displayAlert(title: String?, message: String?) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "??????",
                                      style: .default,
                                      handler: nil))
        
        currentViewController()?.present(alert, animated: true, completion: nil)
    }
}
