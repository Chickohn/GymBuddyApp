//
//  ExerciseView.swift
//  GymBuddySwiftUI
//
//  Created by Freddie Kohn on 16/04/2023.
//

import SwiftUI

struct ExerciseView: View {
    @AppStorage("accountId") private var accountId: Int?
    @State private var exercises: [Exercise] = []
    
    let workout: Workout
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(exercises) { exercise in
                        ExerciseRow(exercise: exercise)
                    }
                }
                .padding()
            }
            //.frame(width: 400, height: 700)
            .background(RoundedRectangle(cornerRadius: 25)
                .fill(LinearGradient(gradient: Gradient(
                    colors: [Color("tabs"), Color("background").opacity(0.75)]),
                                     startPoint: UnitPoint(x: 0.5, y: 0),
                                     endPoint: UnitPoint(x: 0.5, y: 0.7))))
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .onAppear() {
                fetchExercises()
            }
        }.background(Color("background"))
            .navigationTitle("workout \(workout.id)")
            .toolbarBackground(Color("background"))
            //.navigationBarHidden(true)
    }
    
    func fetchExercises() {
        guard let accountId = accountId, let url = URL(string: "http://\(ip):8000/api/exercises/\(accountId)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                // Handle error
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let fetchedExercises = try decoder.decode([Exercise].self, from: data)
                let workoutStartTime = ISO8601DateFormatter().date(from: workout.startTime)!
                let workoutEndTime = ISO8601DateFormatter().date(from: workout.endTime)!
                
                DispatchQueue.main.async {
                    exercises = fetchedExercises.filter { exercise in
                        if let exerciseTime = ISO8601DateFormatter().date(from: exercise.datetime) {
                            return exerciseTime >= workoutStartTime && exerciseTime <= workoutEndTime
                        } else {
                            return false
                        }
                    }
                }
            } catch {
                // Handle error
                print("Could not fetch exercises. Error: \(error)")
            }
        }.resume()
    }
}

struct ExerciseRow: View {
    let exercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading) {
//            Text(exercise.type)
//                .font(.title2)
//                .bold()
            
            Text("Date: \(exercise.datetime)")
                .font(.footnote)
            
            // Placeholder for the video player
            // Add your video player implementation here
            
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 200)
                .overlay(
                    Text("Video Placeholder")
                        .foregroundColor(.gray)
                )
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}


//struct ExerciseView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExerciseView(workout: Workout)
//    }
//}
