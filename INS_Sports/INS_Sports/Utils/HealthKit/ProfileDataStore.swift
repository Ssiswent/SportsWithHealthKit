//
//  ProfileDataStore.swift
//  HealthKit_Learning
//
//  Created by Flamingo on 2021/3/6.
//

import HealthKit

class ProfileDataStore {
    
    class func getMostRecentSample(for sampleType: HKSampleType,
                                   completion: @escaping (HKQuantitySample?, Error?) -> Swift.Void) {
        
        //1. Use HKQuery to load the most recent samples.
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast,
                                                              end: Date(),
                                                              options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
                                              ascending: false)
        
        let limit = 1
        
        let sampleQuery = HKSampleQuery(sampleType: sampleType,
                                        predicate: mostRecentPredicate,
                                        limit: limit,
                                        sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            
            //2. Always dispatch to the main thread when complete.
            DispatchQueue.main.async {
                
                guard let samples = samples,
                      let mostRecentSample = samples.first as? HKQuantitySample else {
                    
                    completion(nil, error)
                    return
                }
                completion(mostRecentSample, nil)
            }
        }
        
        HKHealthStore().execute(sampleQuery)
    }
    
    class func saveBodyMassIndexSample(bodyMassIndex: Double, date: Date) {
        
        //1.  Make sure the body mass type exists
        guard let bodyMassIndexType = HKQuantityType.quantityType(forIdentifier: .bodyMassIndex) else {
            fatalError("Body Mass Index Type is no longer available in HealthKit")
        }
        
        //2.  Use the Count HKUnit to create a body mass quantity
        let bodyMassQuantity = HKQuantity(unit: HKUnit.count(),
                                          doubleValue: bodyMassIndex)
        
        let bodyMassIndexSample = HKQuantitySample(type: bodyMassIndexType,
                                                   quantity: bodyMassQuantity,
                                                   start: date,
                                                   end: date)
        
        //3.  Save the same to HealthKit
        HKHealthStore().save(bodyMassIndexSample) { (success, error) in
            
            if let error = error {
                print("Error Saving BMI Sample: \(error.localizedDescription)")
            } else {
                print("Successfully saved BMI Sample")
            }
        }
    }
    
    /// 获取步数
    class func getStepCount(completion: @escaping (Int?, Error?) -> Swift.Void) {
        
        let calendar = Calendar.current
        let now = Date()
        let startDate = calendar.startOfDay(for: now)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)
        let predicateForSamplesToday = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        guard let stepCountQuantityType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            print("Step Count Sample Type is no longer available in HealthKit")
            return
        }
        let query = HKStatisticsQuery(quantityType: stepCountQuantityType, quantitySamplePredicate: predicateForSamplesToday, options: .cumulativeSum) { (query, statics, error) in
            DispatchQueue.main.async {
                guard let statics = statics else {
                    completion(nil, error)
                    return
                }
                let sum = statics.sumQuantity()
                let stepCount = sum?.doubleValue(for: .count())
                completion(Int(stepCount!), nil)
            }
        }
        HKHealthStore().execute(query)
    }
    
    /// 计算步行和跑步的卡路里
    class func calculateKcal(weight: Double, completion: @escaping (Double?, Error?) -> Swift.Void) {
        guard let sampleType = HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            print("Body Mass Sample Type is no longer available in HealthKit")
            return
        }
        
        let calendar = Calendar.current
        let now = Date()
        let startDate = calendar.startOfDay(for: now)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)
        
        let predicateForSamplesToday = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: predicateForSamplesToday, limit: 0, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            DispatchQueue.main.async {
                
                guard let samples = samples else {
                    completion(nil, error)
                    return
                }
                var totalKcal: Double = 0
                for sample in samples {
                    let startTime = sample.startDate
                    let endTime = sample.endDate
                    let calendar = Calendar.current
                    let secTime = calendar.dateComponents([.second], from: startTime, to: endTime).second
                    let quanSam = sample as! HKQuantitySample
                    let distance = quanSam.quantity.doubleValue(for: HKUnit.meter())
                    let minTime = Double(secTime!) / 60
                    let speed = distance / minTime
                    
                    var absOC: Double = 0
                    // 这里判断速度大于7.5km/h则为跑步
                    if speed <= 125 {
                        absOC = speed * 0.1 + 3.5
                    } else {
                        absOC = speed * 0.2 + 3.5
                    }
                    let relOC = absOC * weight / 1000
                    let kcal = relOC * minTime * 5
                    totalKcal += kcal
                }

                completion(totalKcal, nil)
            }
        }
        
        HKHealthStore().execute(sampleQuery)
    }
    
    class func getAVGValue(for sampleType: HKSampleType, isSpeed: Bool, completion: @escaping (Double?, Error?) -> Swift.Void) {
        
        let calendar = Calendar.current
        let now = Date()
        let startDate = calendar.startOfDay(for: now)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)
        
        let predicateForSamplesToday = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: predicateForSamplesToday, limit: 0, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            DispatchQueue.main.async {
                
                guard let samples = samples else {
                    completion(nil, error)
                    return
                }
                
                var totalValue: Double = 0
                for sample in samples {
                    let quanSam = sample as! HKQuantitySample
                    var value: Double = 0
                    if isSpeed {
                        value = quanSam.quantity.doubleValue(for: .init(from: "m/s"))
                        //转换为km/h
                        value = value * 3600 / 1000
                    } else {
                        //步长m
                        value = quanSam.quantity.doubleValue(for: .meter())
                    }
                    totalValue += value
                }
                completion(totalValue / Double(samples.count), nil)
            }
        }
        
        HKHealthStore().execute(sampleQuery)
    }
    
    /// 保存身高信息
    class func saveHeightSample(height: Double, date: Date) {
        
        //1.  Make sure the body mass type exists
        guard let heightType = HKQuantityType.quantityType(forIdentifier: .height) else {
            fatalError("Height Type is no longer available in HealthKit")
        }
        
        //2.  Use the Count HKUnit to create a body mass quantity
        let heightQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: height/100)
        
        let heightSample = HKQuantitySample(type: heightType, quantity: heightQuantity, start: date, end: date)
        
        //3.  Save the same to HealthKit
        HKHealthStore().save(heightSample) { (success, error) in
            
            if let error = error {
                print("Error Saving Height Sample: \(error.localizedDescription)")
            } else {
                print("Successfully saved Height Sample")
            }
        }
    }
    
    /// 保存体重信息
    class func saveWeightSample(weight: Double, date: Date) {
        
        //1.  Make sure the body mass type exists
        guard let weightType = HKQuantityType.quantityType(forIdentifier: .bodyMass) else {
            fatalError("Height Type is no longer available in HealthKit")
        }
        
        //2.  Use the Count HKUnit to create a body mass quantity
        let weightQuantity = HKQuantity(unit: HKUnit.gramUnit(with: .kilo), doubleValue: weight)
        
        let weightSample = HKQuantitySample(type: weightType, quantity: weightQuantity, start: date, end: date)
        
        //3.  Save the same to HealthKit
        HKHealthStore().save(weightSample) { (success, error) in
            
            if let error = error {
                print("Error Saving Weight Sample: \(error.localizedDescription)")
            } else {
                print("Successfully saved Weight Sample")
            }
        }
    }
}
