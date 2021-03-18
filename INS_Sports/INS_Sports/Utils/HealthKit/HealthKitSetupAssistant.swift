//
//  HealthKitSetupAssistant.swift
//  HealthKit_Learning
//
//  Created by Flamingo on 2021/3/6.
//

import HealthKit

class HealthKitSetupAssistant {
    
    private enum HealthkitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
    }
    
    class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
        //1. Check to see if HealthKit Is Available on this device
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthkitSetupError.notAvailableOnDevice)
            return
        }
        
        //3. Prepare a list of types you want HealthKit to read and write
        var healthKitTypesToRead: Set<HKObjectType>
        var healthKitTypesToWrite: Set<HKSampleType>
        //2. Prepare the data types that will interact with HealthKit
        if #available(iOS 14.0, *) {
            guard let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
                  let height = HKObjectType.quantityType(forIdentifier: .height),
                  let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
                  let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount),
                  let distanceWalkingRunning = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning),
                  let walkingSpeed = HKObjectType.quantityType(forIdentifier: .walkingSpeed),
                  let walkingStepLength = HKObjectType.quantityType(forIdentifier: .walkingStepLength) else {
                
                completion(false, HealthkitSetupError.dataTypeNotAvailable)
                return
            }
            healthKitTypesToRead = [bodyMassIndex, height, bodyMass, stepCount, distanceWalkingRunning, walkingSpeed, walkingStepLength]
            healthKitTypesToWrite = [bodyMassIndex, height, bodyMass]
        } else {
            guard let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
                  let height = HKObjectType.quantityType(forIdentifier: .height),
                  let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
                  let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount),
                  let distanceWalkingRunning = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) else {
                
                completion(false, HealthkitSetupError.dataTypeNotAvailable)
                return
            }
            healthKitTypesToRead = [bodyMassIndex, height, bodyMass, stepCount, distanceWalkingRunning]
            healthKitTypesToWrite = [bodyMassIndex, height, bodyMass]
        }
        
        //4. Request Authorization
        HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead, completion: { (success, error) in
            completion(success, error)
        })
    }
}
