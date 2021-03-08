//
//  BMIRow.swift
//  Health-Care-Rsearch-SwiftUI
//
//  Created by Mayank Rikh on 07/03/21.
//

import SwiftUI

struct BMIRow: View {
    
    var title : String
    var info : String
    
    var body: some View {
        HStack{
            Text(title)
            Spacer()
            Text(info)
                .foregroundColor(.gray)
        }
    }
}

struct BMIRow_Previews: PreviewProvider {
    static var previews: some View {
        BMIRow(title: "Age", info: "35")
    }
}
