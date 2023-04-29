//
//  SocialView.swift
//  GymBuddySwiftUI
//
//  Created by Freddie Kohn on 08/04/2023.
//

import SwiftUI

struct SocialView: View {
    @State private var friends = sampleFriendsData
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .padding(.top)
                
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(friends.filter { searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText) }) { friend in
                            NavigationLink(destination: WorkoutDetailView(workout: friend.workout)) {
                                FriendWorkoutRow(friend: friend)
                            }
                        }
                    }
                    .padding()
                }
                
                Spacer()
                
//                Button(action: /* add friends */) {
//                    HStack {
//                        Image(systemName: "person.badge.plus")
//                        Text("Add Friends")
//                    }
//                    .padding()
//                    .foregroundColor(.white)
//                    .background(Color.blue)
//                    .cornerRadius(10)
//                }
//                .padding()
            }
            .navigationBarTitle("Social", displayMode: .inline)
        }
    }
}

struct FriendWorkoutRow: View {
    let friend: Friend

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(friend.name)
                    .font(.headline)
                    .fontWeight(.bold)

                Text("\(friend.workout.exerciseName) - \(friend.workout.sets) sets x \(friend.workout.reps) reps - \(friend.workout.weight) lbs")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
    }
}

struct SearchBar: UIViewRepresentable {
    @Binding var text: String

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.delegate = context.coordinator
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }

    class Coordinator: NSObject, UISearchBarDelegate {
        let searchBar: SearchBar

        init(_ searchBar: SearchBar) {
            self.searchBar = searchBar
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            searchBar.text = searchText
        }
    }
}

struct WorkoutDetailView: View {
    let workout: Workout

    var body: some View {
        VStack {
            Text(workout.exerciseName)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Date: \(workout.date)")
                .font(.headline)
                .padding(.top)

            Text("Duration: \(workout.duration) minutes")
                .font(.headline)

            Text("Calories burned: \(workout.caloriesBurned)")
                .font(.headline)

            Text("Notes: \(workout.notes)")
                .font(.headline)
                .padding(.top)

            Spacer()
        }
        .padding()
        .navigationBarTitle("Workout Details", displayMode: .inline)
    }
}

struct Friend: Identifiable {
    let id = UUID()
    let name: String
    let workout: Workout
}

struct Workout: Identifiable {
    let id = UUID()
    let exerciseName: String
    let sets: Int
    let reps: Int
    let weight: Int
    let date: String
    let duration: Int
    let caloriesBurned: Int
    let notes: String
}

let sampleFriendsData = [
Friend(name: "John Doe", workout: Workout(exerciseName: "Bench Press", sets: 4, reps: 8, weight: 185, date: "2023-04-01", duration: 60, caloriesBurned: 350, notes: "Felt strong today.")),
Friend(name: "Jane Smith", workout: Workout(exerciseName: "Squats", sets: 5, reps: 5, weight: 225, date: "2023-04-01", duration: 75, caloriesBurned: 450, notes: "Need to work on form.")),
Friend(name: "Mike Johnson", workout: Workout(exerciseName: "Deadlift", sets: 3, reps: 5, weight: 315, date: "2023-03-31", duration: 45, caloriesBurned: 300, notes: "Grip was an issue."))
]

//struct SocialView_Previews: PreviewProvider {
//    static var previews: some View {
//        SocialView()
//    }
//}
