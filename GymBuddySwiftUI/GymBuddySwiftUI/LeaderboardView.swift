//
//  LeaderboardView.swift
//  GymBuddySwiftUI
//
//  Created by Freddie Kohn on 08/04/2023.
//

import SwiftUI

struct LeaderboardView: View {
    @State private var selectedLeague = 0
    let leagues = ["Beginner", "Intermediate", "Advanced", "Elite"]

    var body: some View {
        NavigationView {
            VStack {
                Text("Gym Leaderboard")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("GymGreen"))

                Picker("League", selection: $selectedLeague) {
                    ForEach(0..<4) { index in
                        Text(leagues[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(0..<10) { index in
                            LeaderboardRow(rank: index + 1)
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(Color("BackgroundGray").edgesIgnoringSafeArea(.all))
        }
    }
}

struct LeaderboardRow: View {
    let rank: Int

    var body: some View {
        HStack {
            Text("\(rank)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color("GymGreen"))

            VStack(alignment: .leading) {
                Text("User \(rank)")
                    .font(.headline)
                    .fontWeight(.semibold)

                HStack {
                    Text("XP: 2500")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Spacer()

                    Text("Level 5")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.leading)

            Spacer()

            ZStack {
                Circle()
                    .fill(Color("GymGreen"))
                    .frame(width: 50, height: 50)

                Text("\(rank)")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}
