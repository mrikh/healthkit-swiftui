//
//  HealthKitView.swift
//  Health-Care-Rsearch-SwiftUI
//
//  Created by Mayank Rikh on 07/03/21.
//

import SwiftUI

struct HealthKitView: View {
    
    @State private var showAlert = false
    @StateObject private var viewModel = HealthKitViewModel()
    @EnvironmentObject var profileDataStore : ProfileDataStore
    
    var body: some View {
        List{
            Section{
                NavigationLink(destination : ProfileAndBMI()){
                    Text("Profile & BMI")
                }
            }
            
            Section{
                Text("Exercise Workouts")
            }
            
            Section{
                HStack{
                    Spacer()
                    Button("Authorize HealthKit") {
                        viewModel.authorizeHealthKit()
                    }
                    Spacer()
                }
            }
        }
        .onReceive(viewModel.$errorString, perform: { value in
            if !value.isEmpty{
                showAlert = true
            }
        })
        .onAppear{
            viewModel.updateDataStore(profileDataStore)
        }
        .navigationTitle("Exercise Tracker")
        .listStyle(GroupedListStyle())
        .alert(isPresented: $showAlert){
            Alert(title: Text("Oops"), message: Text(viewModel.errorString), dismissButton: .default(Text("Okay")))
        }
    }
}

struct HealthKitView_Previews: PreviewProvider {
    static var previews: some View {
        HealthKitView()
    }
}
