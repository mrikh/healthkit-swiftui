//
//  HealthKitViewModel.swift
//  Health-Care-Rsearch-SwiftUI
//
//  Created by Mayank Rikh on 07/03/21.
//

import Foundation
import HealthKit
import SwiftUI

class HealthKitViewModel: ObservableObject{
    
    @Published var errorString : String = ""
    private var profileDataStore : ProfileDataStore?
    
    func updateDataStore(_ profileDataStore : ProfileDataStore){
        self.profileDataStore = profileDataStore
    }
    
    func authorizeHealthKit(){
        
        guard HKHealthStore.isHealthDataAvailable() else {
            showAlert(.notAvailableOnDevice)
            return
        }
        
        guard let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
              let bloodType = HKObjectType.characteristicType(forIdentifier: .bloodType),
              let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
              let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
              let height = HKObjectType.quantityType(forIdentifier: .height),
              let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
              let activtyEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            
            showAlert(.dataTypeNotAvailable)
            return
        }
        
        let healthKitTypesToWrite: Set<HKSampleType> = [bodyMassIndex, activtyEnergy, HKObjectType.workoutType()]
        
        let healthKitTypesToRead: Set<HKObjectType> = [dateOfBirth, bloodType, biologicalSex, bodyMassIndex, height, bodyMass, HKObjectType.workoutType()]
        
        HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { (success, error) in
            
            DispatchQueue.main.async{
                
                if error != nil{
                    self.errorString = error?.localizedDescription ?? "Access not available"
                }
            }
        }
    }
    
    
    private func showAlert(_ error : HKErrors){
        errorString = error.rawValue
    }
}

extension HealthKitViewModel{
    
    enum HKErrors: String{
        
        case notAvailableOnDevice = "Health Kit is not available on the selected device"
        case dataTypeNotAvailable = "Data Type not available"
    }
}
