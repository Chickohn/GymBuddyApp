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
    @State private var users: [AccountSearch] = []
    @StateObject private var leaderboardAPI = LeaderboardAPI()

    var body: some View {
        NavigationView {
            VStack {
//                Text("Gym Leaderboard")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                    .foregroundColor(Color("GymGreen"))

                Picker("League", selection: $selectedLeague) {
                    ForEach(0..<4) { index in
                        Text(leagues[index]).tag(index)
                    }
                }
                //.background(Color("tabs"))
                .cornerRadius(8)
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: selectedLeague, perform: { _ in
                    updateUsers()
                })

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(users) { user in
                                                    LeaderboardRow(user: user, rank: users.firstIndex(where: { $0.id == user.id })! + 1)
                                                }
                    }
                    .padding(.all)
                }.padding(.bottom, 60)

                Spacer()
            }
            .onAppear(perform: updateUsers)//{
//                leaderboardAPI.fetchLeaderboard { fetchedUsers in
//                    users = fetchedUsers
//                }
//            })
            .offset(y: 70)
            .overlay(
                GeometryReader { proxy in
                    Text("Leaderboard")
                        .font(.title)
                        .foregroundColor(Color("accent"))
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(LinearGradient(gradient: Gradient(
                                    colors: [Color("buttons").opacity(0.6),Color("buttons").opacity(0.3), Color("background").opacity(0.75)]),
                                                     startPoint: UnitPoint(x: 0, y: -2),
                                                     endPoint: UnitPoint(x: 0.55, y: 1))
                                     )
                                .frame(width: 180, height: 40)
                                .shadow(radius: 2, x: -3, y: 3)
                        )
                        .position(x: proxy.safeAreaInsets.leading + 110, y: proxy.safeAreaInsets.top - 10)
                }
//                }
            )
            .navigationBarTitleDisplayMode(.inline)
            .background(Color("inputs").edgesIgnoringSafeArea(.all))
        }
    }
    
    func updateUsers() {
            let query = leagues[selectedLeague].lowercased()
            leaderboardAPI.fetchLeaderboard(query: query) { fetchedUsers in
                users = fetchedUsers
            }
        }
}


struct LeaderboardRow: View {
    let user: AccountSearch
    let rank: Int

    var body: some View {
        HStack {
            Text("\(rank)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color("accent"))

            VStack(alignment: .leading) {
                            Text("\(user.first_name) \(user.last_name)")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color("accent"))

                            HStack {
                                Text("XP: \(user.xp)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)

                                Spacer()

                                // Assuming you have a function to calculate user levels based on XP
                                Text("Level \(1 + Int(floor(Double(user.xp)/100)))")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
            .padding(.leading)

            Spacer()

            ZStack {
                Circle()
                    .fill(Color("buttons").opacity(0.6))
                    .frame(width: 50, height: 50)
                    .shadow(radius:2, x: -1, y: 2)

                Text("\(rank)")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(LinearGradient(gradient: Gradient(
            colors: [Color("buttons").opacity(0.6),Color("buttons").opacity(0.3), Color("background").opacity(0.75)]),
                             startPoint: UnitPoint(x: 0, y: -2),
                             endPoint: UnitPoint(x: 0.55, y: 1))
        ).shadow(color: .black, radius: 2, x: -3, y: 5))
        //.cornerRadius(10)
        
    }
}

class LeaderboardAPI: ObservableObject {
    func fetchLeaderboard(query: String, completion: @escaping ([AccountSearch]) -> ()) {
        guard let url = URL(string: "http://\(ip):8000/api/leaderboard?q=\(query)") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()

                if let leaderboard = try? decoder.decode([AccountSearch].self, from: data) {
                    DispatchQueue.main.async {
                        completion(leaderboard)
                    }
                }
            }
        }.resume()
    }
}


struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}
