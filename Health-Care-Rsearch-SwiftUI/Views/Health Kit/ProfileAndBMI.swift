//
//  ProfileAndBMI.swift
//  Health-Care-Rsearch-SwiftUI
//
//  Created by Mayank Rikh on 07/03/21.
//

import HealthKit
import SwiftUI

struct ProfileAndBMI: View {
    
    @EnvironmentObject var profileDataStore : ProfileDataStore
    @State private var showAlert = false
    @State var age : Int?
    @State var sex : String?
    @State var blood : String?
    @State var height : String?
    @State var weight : String?
    @State var bmi : String?
    
    var body: some View {
        List{
            Section(header: Text("User Info")){
                BMIRow(title: "Age", info: "\(age ?? 0)")
                BMIRow(title: "Sex", info: "\(sex ?? "-")")
                BMIRow(title: "Blood Type", info: "\(blood ?? "-")")
            }
            
            Section(header: Text("Weight & Height")){
                BMIRow(title: "Weight", info: "\(height ?? "-")")
                BMIRow(title: "Height", info: "\(weight ?? "-")")
                BMIRow(title: "Body Mass Index (BMI)", info: "\(bmi ?? "-")")
            }
            
            Section{
                HStack{
                    Spacer()
                    Button("Read HealthKit Data") {
                        
                    }
                    Spacer()
                }
            }
            
            Section{
                HStack{
                    Spacer()
                    Button("Save BMI") {
                        
                    }
                    .foregroundColor(.red)
                    Spacer()
                }
            }
        }
        .onAppear{
            do{
                let values = try profileDataStore.getAgeSexAndBloodType()
                age = values.age
                sex = values.biologicalSex.stringRepresentation
                blood = values.bloodType.stringRepresentation
                fetchBodyInfo()
            }catch{
                showAlert = true
            }
        }
        .alert(isPresented: $showAlert){
            Alert(title: Text("Oops"), message: Text("Unable to fetch details"), dismissButton: .default(Text("Okay")))
        }
        .navigationTitle("Profile & BMI")
        .listStyle(GroupedListStyle())
    }
    
    private func fetchBodyInfo(){
        
        let group = DispatchGroup()
        
        var height = 0.0
        var weight = 0.0
        
        group.enter()
        profileDataStore.getMostRecentSample(for: HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!) { (sample, error) in
            if let sample = sample{
                height = sample.quantity.doubleValue(for: .meter())
                let heightFormatter = LengthFormatter()
                  heightFormatter.isForPersonHeightUse = true
                self.height = heightFormatter.string(fromMeters: height)
            }
            
            group.leave()
        }
        
        group.enter()
        profileDataStore.getMostRecentSample(for: HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!) { (sample, error) in

            if let sample = sample{
                weight = sample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
                let weightFormatter = MassFormatter()
                  weightFormatter.isForPersonMassUse = true
                self.weight = weightFormatter.string(fromKilograms: weight)
            }
            
            group.leave()
        }
        
        group.notify(queue: .main) {
            if height > 0{
                bmi = String(format: "%.02f", (weight/(height*height)))
            }
        }
    }
}

struct ProfileAndBMI_Previews: PreviewProvider {
    static var previews: some View {
        ProfileAndBMI()
    }
}
