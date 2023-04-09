//
//  ProfileView.swift
//  GymBuddySwiftUI
//
//  Created by Freddie Kohn on 08/04/2023.
//

import SwiftUI

struct UserProfileView: View {
    @State private var userProfile = sampleUserProfileData
    @State private var searchText = ""

    var body: some View {
        NavigationView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Image(systemName: userProfile.profilePicture)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .scaleEffect(1.1)
                            .padding(.leading)
                            //.animation(Animation.easeInOut(duration: 0.5).delay(0.5))
                        
                        VStack(alignment: .leading) {
                            Text(userProfile.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(Color("accent"))

                            Text("Age: \(userProfile.age)")
                                .font(.headline)
                                .foregroundColor(Color("buttons"))
                            
                            Text("XP: \(userProfile.age*230)")
                                .font(.headline)
                                .foregroundColor(Color("buttons"))
                        }
                        .padding(.leading)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top)
                    .padding(.bottom)
                    .background(Color("text"))
                    .clipShape(RoundedRectangle(cornerRadius:15))

                    Text("Recent Workouts")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    ScrollView {
                        ForEach(userProfile.workouts) { workout in
                            WorkoutRow(workout: workout)
                                .padding(.bottom, 10)
                        }
                    }
            }
            .padding()
            .navigationBarTitle("Profile", displayMode: .inline)
            .background(Color("tabs"))//Color.black.edgesIgnoringSafeArea(.all))
        }
    }
}

struct WorkoutRow: View {
    let workout: Workout

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(workout.exerciseName)
                    .font(.headline)
                    .fontWeight(.bold)

                Text("\(workout.sets) sets x \(workout.reps) reps - \(workout.weight) lbs")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text("Notes: \(workout.notes)")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
    }
}

// Sample data
struct UserProfile {
    let name: String
    let age: Int
    let profilePicture: String
    let workouts: [Workout]
}

let sampleUserProfileData = UserProfile(name: "John Doe", age: 20, profilePicture: "person.fill", workouts: [Workout(exerciseName: "Bench Press", sets: 4, reps: 8, weight: 185, date: "2023-04-01", duration: 60, caloriesBurned: 350, notes: "Felt strong today."), Workout(exerciseName: "Bench Press", sets: 4, reps: 8, weight: 185, date: "2023-04-01", duration: 60, caloriesBurned: 350, notes: "Felt strong today."), Workout(exerciseName: "Bench Press", sets: 4, reps: 8, weight: 185, date: "2023-04-01", duration: 60, caloriesBurned: 350, notes: "Felt strong today."), Workout(exerciseName: "Bench Press", sets: 4, reps: 8, weight: 185, date: "2023-04-01", duration: 60, caloriesBurned: 350, notes: "Felt strong today.")])

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
