//
//  Pre-Workout View.swift
//  GymBuddySwiftUI
//
//  Created by Freddie Kohn on 19/04/2023.
//

import SwiftUI

struct PreWorkout: View {
    @State private var workoutTitle: String = ""
    @State private var workoutDescription: String = ""
    //@State private var reps: [Exercise] = []
    @State private var isRecordingViewPresented: Bool = false
    @State private var creatingWorkout: Bool = false
    @AppStorage("accountId") private var accountId: Int?
    @State private var exerciseTypeRows: [ExerciseTypeRow] = []
    @State private var startTime = Date()
    

    var body: some View {
        NavigationView {
            if !creatingWorkout {
                Button (action: {
                    creatingWorkout = true
                    startTime = Date()
                    print(startTime)
                    createWorkout()
                }) {
                    Text("Start a workout")
                        .padding(.all, 10)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
            } else {
                VStack {
                    HStack {
                        TextField("Workout Title \(Image(systemName: "pencil"))", text: $workoutTitle)
                            .frame(width: 200)
                            .font(.system(size: 25))
                            .fontWeight(.bold)
                        Spacer()
//                        Button(action: {
//                            print(getLatestSquatFiles())
////                            uploadExerciseData(
////                                accountId: accountId!,
////                                exerciseType: "squat",
////                                datetime: "\(Date())",
////                                videoURL: globalVideoURL!,
////                                csvURL: globalCsvURL!
////                            ) { result in
////                                switch result {
////                                case .success(let exercise):
////                                    print("Exercise uploaded successfully: \(exercise)")
////                                case .failure(let error):
////                                    print("Error uploading exercise: \(error.localizedDescription)")
////                                }
////                            }
////                            DonaldView.uploadVideo(globalVideoURL!)
//
//                        }) {
//                            Text("+")
//                        }
                        Button(action: {
                            //done
                        }) {
                            Text("Finish")
                                .foregroundColor(Color(.white))
                                .padding(.all, 8)
                                .background(Color(.systemBlue))
                                .cornerRadius(10)
                        }
                        Button(action: {
                            let exerciseTypeRow = ExerciseTypeRow(exerciseName: "", timestamp: Date(), exerciseReps: [])
                            exerciseTypeRows.append(exerciseTypeRow)
                        }) {
                            Image(systemName: "plus")
                                .scaledToFill()
                                .scaleEffect(1.4)
                                .padding(.all, 10)
                                .background(Color(.systemGray5))
                                .cornerRadius(10)
                        }
                    }.padding(.all, 15)
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(exerciseTypeRows.indices, id: \.self) { index in
                                ExerciseTypeRowView(exerciseTypeRowIndex: index, exerciseTypeRows: $exerciseTypeRows)
                            }
                        }
                    }
                    .padding()
                    

                    Button(action: {
                        isRecordingViewPresented = true
                    }) {
                        Text("Record")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.all, 15)
                    
                    .sheet(isPresented: $isRecordingViewPresented) {
                        ViewControllerWrapper()
                    }
                }
            }
//            .navigationBarTitle("New Workout", displayMode: .inline)
//            .navigationBarItems(trailing: Button(action: {
//                createWorkout()
//            }) {
//                Text("Create Workout")
//            })
        }
    }

    func createWorkout() {
        // Set the value of start_time to be the current datetime
        // Add your workout creation logic here
//        let workoutCreation = Workout(id: -1, account: accountId!, startTime: ISO8601DateFormatter().string(from: Date()), endTime: ISO8601DateFormatter().string(from: Date()), title: workoutTitle, description: "description goes here...", xp: 0)
//
//            guard let url = URL(string: "http://\(ip):8000/api/workouts/\(accountId!)") else { return }
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//            do {
//                let jsonData = try JSONEncoder().encode(workoutCreation)
//                request.httpBody = jsonData
//            } catch {
//                print("Error encoding workout data: \(error)")
//                return
//            }
//
//            URLSession.shared.dataTask(with: request) { data, response, error in
//                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//                    print("Error creating workout: \(error?.localizedDescription ?? "Unknown error")")
//                    return
//                }
//
//                print("Workout created successfully")
//            }.resume()
        let workoutStartTime = Date()
        print(workoutStartTime)
        
    }
    
    func getLatestSquatFiles() -> (videoURL: URL?, csvURL: URL?) {
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Error: Could not find the app's documents directory")
            return (nil, nil)
        }
        
        do {
            let files = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: [])
            let sortedFiles = files.sorted(by: { $0.lastPathComponent > $1.lastPathComponent })
            
            let videoFile = sortedFiles.first(where: { $0.pathExtension == "mov" || $0.pathExtension == "mp4" })
            let csvFile = sortedFiles.first(where: { $0.pathExtension == "csv" })
            
            return (videoFile, csvFile)
        } catch {
            print("Error: Could not get the contents of the documents directory: \(error)")
            return (nil, nil)
        }
    }
}

struct ExerciseTypeRowView: View {
    let exerciseTypeRowIndex: Int
    @Binding var exerciseTypeRows: [ExerciseTypeRow]
    @State private var reps: Int = 0
    @State private var quality: String = "unchecked"
    var timeFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm:ss a"
            return formatter
        }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                TextField("Exercise Type", text: $exerciseTypeRows[exerciseTypeRowIndex].exerciseName)
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.systemGray2)))
//                Text(exerciseTypeRows[exerciseTypeRowIndex].exerciseName)
//                    .font(.title)
                Spacer()
                let timeString = timeFormatter.string(from: exerciseTypeRows[exerciseTypeRowIndex].timestamp)
                Text(timeString)
                    .font(.headline)
            }
            .padding(.bottom, 10)
            ForEach(exerciseTypeRows[exerciseTypeRowIndex].exerciseReps) { exerciseRep in
                HStack {
                    Text("Rep \(exerciseRep.reps)")
                    Spacer()
                    Spacer()
                    Text(exerciseRep.quality)
                        .padding(.all, 5)
                        .background(Color(exerciseRep.quality == "good" ? .green : .red))
                        .cornerRadius(10)
                    Spacer()
                    Text("\(formatDate(exerciseRep.timestamp))")
                        .font(.subheadline)
                }
                .padding(.all, 5)
                .background(Color(.systemGray5))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.systemGray3)))
            }
            Button(action: {
                reps = reps + 1
                quality = Int.random(in: 1...5) <= 4 ? "good" : "bad"
                let exerciseRep = ExerciseRep(reps: reps, timestamp: Date(), quality: quality)
                exerciseTypeRows[exerciseTypeRowIndex].exerciseReps.append(exerciseRep)
            }) {
                Image(systemName: "plus")
                    .padding()
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "hh:mm:ss a"
        return dateFormatter.string(from: date)
    }
}

struct ExerciseTypeRow: Identifiable {
    var id = UUID()
    var exerciseName: String
    var timestamp: Date
    var exerciseReps: [ExerciseRep]
}

struct ExerciseRep: Identifiable {
    var id = UUID()
    var reps: Int
    var timestamp: Date
    var quality: String
}

struct WorkoutCreation: Codable, Identifiable {
    let id: Int
    let title: String
    let startTime: String
    let reps: [Rep]
}

struct RepRow: View {
    let rep: Rep

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(rep.exerciseType)
                Text(rep.datetime)
            }

            Spacer()

            RoundedRectangle(cornerRadius: 5)
                .fill(backgroundColor(for: rep.quality))
                .frame(width: 50, height: 50)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }

    func backgroundColor(for quality: RepQuality) -> Color {
        switch quality {
        case .unchecked:
            return Color.gray
        case .good:
            return Color.green
        case .bad:
            return Color.red
        }
    }
}

struct Rep: Codable, Identifiable {
    let id: Int
    let exerciseType: String
    let datetime: String
    let quality: RepQuality
}

enum RepQuality: Codable {
    case unchecked
    case good
    case bad
}

struct Pre_Workout_View_Previews: PreviewProvider {
    static var previews: some View {
        PreWorkout()
    }
}
