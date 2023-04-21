//
//  ProfileView.swift
//  GymBuddySwiftUI
//
//  Created by Freddie Kohn on 08/04/2023.
//

import SwiftUI
import Foundation

struct UserProfileView: View {
    @AppStorage("accountId") private var accountId: Int?
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @State private var account: Account?

    var body: some View {
        NavigationView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .scaleEffect(1.1)
                            .padding(.leading)
                            .opacity(0.7)
                            //.animation(Animation.easeInOut(duration: 0.5).delay(0.5))
                        
                        VStack(alignment: .leading) {
                            Text(account?.username ?? "")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(Color("accent"))

                            Text("\(account?.first_name ?? "") \(account?.last_name ?? "")")
                                .font(.headline)
                                .foregroundColor(Color("text").opacity(0.75))
                            
                            HStack {
                                VStack (alignment: .leading, spacing: -2) {
                                    Text("Level: \(1 + Int(floor(Double(account?.xp ?? 0)/100)))")
                                        .frame(width: 100, alignment: .leading)
                                        .font(.headline)
                                        .foregroundColor(Color("text"))
                                    
                                    ZStack(alignment: .leading) {
                                        Capsule()
                                            .frame(width: 125, height: 10) 
                                            .foregroundColor(.gray)
                                        Capsule()
                                            .frame(width: CGFloat((account?.xp ?? 0)%100) * 1.25, height: 10)
                                            .foregroundColor(.green)
                                        //.animation(.linear(duration: 0.1))
                                    }
                                }
                                
                                Image(systemName: "flame")
                                    .foregroundColor(Color("buttons"))
                                    .overlay(Image(systemName: "flame")
                                    .foregroundColor(Color(.white).opacity(0.2)))
                                
                                Text("\(account?.streak ?? 0)")
                                    .foregroundColor(Color("buttons"))
                                    .overlay(Text("\(account?.streak ?? 0)")
                                    .foregroundColor(Color(.white).opacity(0.2)))
                                    .offset(x: -5)
                            }
                        }
                        .padding(.leading)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top)
                    .padding(.bottom)
                    .background(RoundedRectangle(cornerRadius: 25)
                        .fill(LinearGradient(gradient: Gradient(
                            colors: [Color("buttons").opacity(0.6),Color("buttons").opacity(0.3), Color("background").opacity(0.75)]),
                                             startPoint: UnitPoint(x: 0, y: -1),
                                             endPoint: UnitPoint(x: 0.55, y: 1.5))
                        ))
                    .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color("text").opacity(0.4)))
                    //.clipShape(RoundedRectangle(cornerRadius:15))

                    Text("Recent Workouts")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top)
                        .foregroundColor(Color("accent"))
                    
                    RecentWorkouts()
                    
            }
//            .navigationBarItems(trailing:
//                                    Button("Refetch account info") {
//                fetchAccountInfo()
//                //print(accountId!)
//                print(account ?? "none")
//            }.foregroundColor(Color("accent")).padding(3).background(Color("icons")).clipShape(RoundedRectangle(cornerRadius:15)).padding()
//            )
                .offset(y: 70)
            .padding()
            .background(Color("background"))
            .onAppear {
                fetchAccountInfo()
            }
            .overlay(
                GeometryReader { proxy in
                    Text("Profile")
                        .font(.title)
                        .foregroundColor(Color("accent"))
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(LinearGradient(gradient: Gradient(
                                    colors: [Color("buttons").opacity(0.6),Color("buttons").opacity(0.3), Color("background").opacity(0.75)]),
                                                     startPoint: UnitPoint(x: 0, y: -2),
                                                     endPoint: UnitPoint(x: 0.55, y: 1))
                                     )
                                .frame(width: 104, height: 40)
                                .shadow(radius: 2, x: -3, y: 3)
                        )
                        .position(x: proxy.safeAreaInsets.leading + 72, y: proxy.safeAreaInsets.top - 10)
                }
//                }
            )
        }
    }
    
    func fetchAccountInfo() {
        guard let url = URL(string: "http://\(ip):8000/api/account/\(accountId ?? 1)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                // Handle error
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let fetchedAccount = try decoder.decode(Account.self, from: data)
                DispatchQueue.main.async {
                    account = fetchedAccount
                }
            } catch {
                // Handle error
                print("Could not fetch account")
            }
        }.resume()
    }
}

struct RecentWorkouts: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("accountId") private var accountId: Int?
    @State private var workouts: [Workout] = []
    @State private var deleteMe: Bool = false

    var body: some View {
        ScrollView {
            VStack {
                ForEach(workouts) { workout in
                    // Output workout info here
                    WorkoutRows(workout: workout, deleteMe: $deleteMe)
                }
            }
        }.padding(.bottom, 60)
        .onAppear() {
            fetchWorkouts()
        }
        .onChange(of: deleteMe) { _ in
            fetchWorkouts()
            deleteMe = false
        }
    }

    func fetchWorkouts() {
        guard let url = URL(string: "http://\(ip):8000/api/workouts/\(accountId ?? 1)/") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                // Handle error
                print("first error")
                return
            }

            let decoder = JSONDecoder()
            do {
                let fetchedWorkouts = try decoder.decode([Workout].self, from: data)
                DispatchQueue.main.async {
                    workouts = fetchedWorkouts
                }
            } catch {
                // Handle error
                print("Couldn't decode workouts \n\(error)")
            }
        }.resume()
    }
}


struct WorkoutRows: View {
    let workout: Workout
    @Binding var deleteMe: Bool

    var body: some View {
        NavigationLink(destination: ExerciseView(workout: workout)) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("\(workout.title)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color("accent"))
                        
                        Spacer()
                        
                        Text("\(String(workout.startTime.prefix(16).suffix(5)))")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color("text"))
                    }
                    HStack {
                        VStack (alignment: .leading, spacing: 5){
                            Text("\(workout.description)")
                                .font(.subheadline)
                                .foregroundColor(Color("text"))
                            
                            if let startTime = ISO8601DateFormatter().date(from: workout.startTime),
                               let endTime = ISO8601DateFormatter().date(from: workout.endTime) {
                                let duration = endTime.timeIntervalSince(startTime) / 60
                                Text("At: \(duration, specifier: "%.0f") minutes")
                                    .font(.footnote)
                                    .foregroundColor(Color("text"))
                            }
                        }
                        Spacer()
                        DeleteWorkoutButton(workout: workout.id, deleteMe: $deleteMe)
                    }
                }
                Spacer()
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10)
                .fill(LinearGradient(gradient: Gradient(
                    colors: [Color("buttons").opacity(0.6),Color("buttons").opacity(0.3), Color("background").opacity(0.75)]),
                                     startPoint: UnitPoint(x: 0, y: -2),
                                     endPoint: UnitPoint(x: 0.55, y: 1))
                ))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("text")))
            .cornerRadius(10)
            .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
        }
    }
}

struct DeleteWorkoutButton: View {
    let workout: Int
    @Binding var deleteMe: Bool

    var body: some View {
        Button(action: {
            guard let url = URL(string: "http://\(ip):8000/api/workout/\(workout)") else {
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error deleting workout: \(error.localizedDescription)")
                } else if let response = response as? HTTPURLResponse, response.statusCode != 204 {
                    print("Error deleting workout: status code \(response.statusCode)")
                } else {
                    print("Workout deleted successfully")
                    deleteMe = true
                }
            }.resume()
        }) {
            Image(systemName: "trash")
                .foregroundColor(.red)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
