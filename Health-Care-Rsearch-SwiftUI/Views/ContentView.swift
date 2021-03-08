//
//  ContentView.swift
//  Health-Care-Rsearch-SwiftUI
//
//  Created by Mayank Rikh on 07/03/21.
//

import SwiftUI

struct ContentView: View {
    
    enum Tabs{
        case health
        case research
        case care
    }
    
    @State private var current : Tabs = .health
    
    var body: some View {
        TabView(selection : $current){
            NavigationView{
                HealthKitView()
            }
            .tabItem{
                Label("Health Kit", systemImage : current == .health ? "heart.fill" : "heart")
            }
            .tag(Tabs.health)
        }
        .environmentObject(ProfileDataStore())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
