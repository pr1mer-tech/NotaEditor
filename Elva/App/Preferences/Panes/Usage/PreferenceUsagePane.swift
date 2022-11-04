//
//  PreferenceUsagePane.swift
//  Elva
//
//  Created by Arthur Guiot on 6/27/22.
//

import SwiftUI
import Preferences
struct PreferenceUsagePane: View {
    
    @Preference(\.completionUsage) var tokenUsage
    @Preference(\.completionLastReset) var lastReset
    @ObservedObject var tokenLimiter: TokenLimiter = .shared
    
    var body: some View {
        Settings.Container(contentWidth: 450) {
            Settings.Section(title: "Usage", bottomDivider: true, verticalAlignment: .top) {
                UsageProgressView(tokenUsage: tokenUsage,
                                  throttleLimit: tokenLimiter.throttleUsage,
                                  maxUsageToken: tokenLimiter.maxUsageToken,
                                  usableTokens: tokenLimiter.usableTokens)
                if let expectedLimit = tokenLimiter.expectedLimitReach(lastReset: lastReset, currentUsage: tokenUsage) {
                    Group {
                        Text("Expected to reach the limit in ").italic() +
                        Text(expectedLimit, style: .offset).italic()
                    }
                    .preferenceDescription()
                    Text("") // Padding
                        .preferenceDescription()
                }
                Text("You can think of tokens as pieces of words, where 1,000 tokens is about 750 words. This paragraph is 26 tokens.")
                    .preferenceDescription()
                Text("") // Padding
                    .preferenceDescription()
                Group {
                    Text("You have ") + Text(String(tokenLimiter.usableTokens - tokenUsage)) + Text(" tokens left.")
                }
                .preferenceDescription()
                
            }
        }
        
    }
}

struct UsageProgressView: View {
    /// Token Usage
    var tokenUsage: Int
    /// Amount of tokens to throttle before hitting the limit
    var throttleLimit: Int
    /// Max free usable token
    var maxUsageToken: Int
    /// Total amount available
    var usableTokens: Int
    
    @ObservedObject var tokenLimiter: TokenLimiter = .shared
    
    var beforeThrottleUsage: CGFloat {
        let max = CGFloat(maxUsageToken - throttleLimit)
        let converted = CGFloat(tokenUsage)
        let standardized = converted > max ? max : converted
        return standardized / CGFloat(usableTokens)
    }
    
    var beforeThrottleWithAdditional: CGFloat {
        let max = CGFloat(usableTokens - throttleLimit)
        let converted = CGFloat(tokenUsage)
        let standardized = converted > max ? max : converted
        return standardized / CGFloat(usableTokens)
    }
    
    struct UsageSection: View {
        var color: Color
        var title: LocalizedStringKey
        var value: Int
        var total: Int
        var containerWidth: CGFloat
        
        @State var hover = false
        
        var body: some View {
            Rectangle()
                .fill(color)
                .frame(maxWidth: containerWidth * max(min(CGFloat(value) / CGFloat(total), 1), 0))
                .onHover { hover in
                    self.hover = hover
                }
                .popover(isPresented: $hover) {
                    VStack {
                        Text(title)
                            .font(.headline)
                        Text("\(value) tokens")
                            .font(.subheadline)
                    }
                    .padding()
                }
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                HStack(spacing: 1) {
                    UsageSection(color: .blue,
                                 title: "Normal Usage",
                                 value: min(tokenUsage,
                                            maxUsageToken),
                                 total: usableTokens - throttleLimit,
                                 containerWidth: geo.size.width * CGFloat(usableTokens - throttleLimit) / CGFloat(usableTokens))
                    UsageSection(color: .orange,
                                 title: "Additional Usage",
                                 value: min(tokenUsage - maxUsageToken,
                                            usableTokens - maxUsageToken - throttleLimit),
                                 total: usableTokens - throttleLimit,
                                 containerWidth: geo.size.width * CGFloat(usableTokens - throttleLimit) / CGFloat(usableTokens))
                    UsageSection(color: .red,
                                 title: "Throttled Usage",
                                 value: tokenUsage - (usableTokens - throttleLimit),
                                 total: usableTokens,
                                 containerWidth: geo.size.width)
                }
                HStack {
                    Spacer()
                        .frame(maxWidth: geo.size.width * CGFloat(usableTokens - throttleLimit) / CGFloat(usableTokens))
                    Divider()
                    Spacer()
                }
            }
        }
        .frame(height: 18)
        .cornerRadius(5)
        .background(
            Rectangle()
                .fill(.clear)
                .visualEffect(material: .underPageBackground)
                .cornerRadius(5)
        )
    }
}

struct PreferenceUsagePane_Previews: PreviewProvider {
    struct UsageProgressViewPreview: View {
        @State var tokenUsage: Float = 0
        var body: some View {
            VStack {
                UsageProgressView(tokenUsage: Int(tokenUsage),
                                  throttleLimit: 10,
                                  maxUsageToken: 50,
                                  usableTokens: 100)
                Slider(value: $tokenUsage, in: 0...100)
            }
            .padding()
        }
    }
    
    static var previews: some View {
        PreferenceUsagePane()
        UsageProgressViewPreview()
    }
}
