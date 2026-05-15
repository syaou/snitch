//
//  MainTabView.swift
//  Snitch
//
//  Created by Sana Yousefi on 29/4/2026.
//

import SwiftUI

struct MainTabView: View {
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(AppColours.ink)
        appearance.shadowColor = .clear

        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(AppColours.orange).withAlphaComponent(0.65)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(AppColours.orange).withAlphaComponent(0.65)
        ]
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppColours.orange)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(AppColours.orange)
        ]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView {
            FeedView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Feed")
                }

            GoalsView()
                .tabItem {
                    Image(systemName: "target")
                    Text("Goals")
                }

            UploadProofView()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Upload")
                }

            LeaderboardView()
                .tabItem {
                    Image(systemName: "trophy")
                    Text("Leaderboard")
                }

            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
    }
}
