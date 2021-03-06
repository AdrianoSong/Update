//
//  InformationView.swift
//  Update
//
//  Created by Lucas Farah on 2/18/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI

struct InformationRow: View {
    var text: String
    @Binding var value: Int
    @Binding var valuePercentage: Double
    var font: Font = .title
    
    var body: some View {
        VStack {
            HStack {
                    Text("\( Int(Double(self.value) * self.valuePercentage))")
                        .font(self.font)
                        .fontWeight(.bold)
                        .foregroundColor(Color.gray)
                        .frame(width: 70)
                        .animation(nil)
                
                Text(text)
                    .font(font)
                    .foregroundColor(Color.gray)
            }
        }
    }
}

struct InformationView: View {
    @Binding var readPostCount: Int
    @Binding var unreadPostCount: Int
    @State var valuePercentage: Double = 0
    var font: Font = .title
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Spacer()
            
            InformationRow(text: "Read posts today", value: $readPostCount, valuePercentage: $valuePercentage, font: font)
            InformationRow(text: "Unread posts left", value: $unreadPostCount, valuePercentage: $valuePercentage, font: font)
            
            Spacer()
        }
        .onAppear {
            self.updateLabel()
        }
        .frame(maxHeight: 120)
    }
    
    func updateLabel() {
        // TODO: Fix this animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.valuePercentage += 0.2
            if self.valuePercentage < 1 {
                self.updateLabel()
            }
        })
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView(readPostCount: .constant(200), unreadPostCount: .constant(20))
    }
}
