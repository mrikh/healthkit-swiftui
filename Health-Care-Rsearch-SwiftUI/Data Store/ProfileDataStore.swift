//
//  ProfileDataStore.swift
//  Health-Care-Rsearch-SwiftUI
//
//  Created by Mayank Rikh on 07/03/21.
//

import HealthKit

class ProfileDataStore: ObservableObject{
    
    func getAgeSexAndBloodType() throws -> (age : Int, biologicalSex : HKBiologicalSex, bloodType : HKBloodType){
        
        let healthKitStore = HKHealthStore()
        
        do{
            let birthdayComponents =  try healthKitStore.dateOfBirthComponents()
            let biologicalSex = try healthKitStore.biologicalSex()
            let bloodType = try healthKitStore.bloodType()
            
            let today = Date()
            let calendar = Calendar.current
            let todayDateComponents = calendar.dateComponents([.year], from: today)
            
            let thisYear = todayDateComponents.year!
            let age = thisYear - birthdayComponents.year!
            
            let unwrappedBiologicalSex = biologicalSex.biologicalSex
            let unwrappedBloodType = bloodType.bloodType
            
            return (age, unwrappedBiologicalSex, unwrappedBloodType)
        }
    }
    
    func getMostRecentSample(for sample : HKSampleType, completion: @escaping (HKQuantitySample?, Error?)->()){
        
        let mostRecent = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let limit = 1
        
        let sampleQuery = HKSampleQuery(sampleType: sample, predicate: mostRecent, limit: limit, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            
            DispatchQueue.main.async {
                guard let samples = samples, let mostRecent = samples.first as? HKQuantitySample? else {
                    
                    completion(nil, error)
                    return
                }
                
                completion(mostRecent, nil)
            }
        }
        
        HKHealthStore().execute(sampleQuery)
    }
}

extension HKBloodType {
    
    var stringRepresentation: String {
        switch self {
        case .notSet: return "Unknown"
        case .aPositive: return "A+"
        case .aNegative: return "A-"
        case .bPositive: return "B+"
        case .bNegative: return "B-"
        case .abPositive: return "AB+"
        case .abNegative: return "AB-"
        case .oPositive: return "O+"
        case .oNegative: return "O-"
        @unknown default:
            return ""
        }
    }
}

extension HKBiologicalSex {
    
    var stringRepresentation: String {
        switch self {
        case .notSet: return "Unknown"
        case .female: return "Female"
        case .male: return "Male"
        case .other: return "Other"
        @unknown default:
            return ""
        }
    }
}
