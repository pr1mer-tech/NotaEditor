//
//  SelectionWordsView.swift
//  Nota
//
//  Created by Arthur Guiot on 6/22/22.
//

import SwiftUI

struct SelectionWordsView: View {
    var words: Int
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 10, height: 10)
                        .offset(x: -3, y: 3)
                    Spacer()
                }
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 4, height: 38)
                    Rectangle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(height: 38)
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 4, height: 38)
                }
                HStack {
                    Spacer()
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 10, height: 10)
                        .offset(x: 3, y: -3)
                }
            }.padding(.horizontal, 3)
            
            Text("\(words) Words")
                .font(.title)
        }
    }
}

struct SelectionWordsView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionWordsView(words: 3)
    }
}
