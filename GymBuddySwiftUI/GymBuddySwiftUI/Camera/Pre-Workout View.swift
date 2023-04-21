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
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("accountId") private var accountId: Int?
    @State private var exerciseTypeRows: [ExerciseTypeRow] = []
    @State private var startTime = ""
    @State private var endTime = ""
    @State private var countdown = 5
    @State private var showCountdown = false

    var body: some View {
        NavigationView {
            if !creatingWorkout {
                    Button (action: {
                        creatingWorkout = true
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        startTime = dateFormatter.string(from: Date())
                        print(startTime)
                    }) {
                        Text("Start a workout")
                            .padding(.all, 10)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                    .overlay(
                        GeometryReader { proxy in
                            Text("Workout")
                                .font(.title)
                                .foregroundColor(Color("accent"))
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(LinearGradient(gradient: Gradient(
                                            colors: [Color("buttons").opacity(0.6),Color("buttons").opacity(0.3), Color("background").opacity(0.75)]),
                                                             startPoint: UnitPoint(x: 0, y: -2),
                                                             endPoint: UnitPoint(x: 0.55, y: 1))
                                             )
                                        .frame(width: 130, height: 40)
                                        .shadow(radius: 2, x: -3, y: 3)
                                )
                                .position(x: proxy.safeAreaInsets.leading - 57, y: proxy.safeAreaInsets.top - 330)
                        })
            } else {
                VStack {
                    HStack {
                        TextField("Workout Title \(Image(systemName: "pencil"))", text: $workoutTitle)
                            .foregroundColor(Color(.white).opacity(0.8))
                            .frame(width: 200)
                            .font(.system(size: 25))
                            .fontWeight(.bold)
                            .cornerRadius(10)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        Spacer()
//                        Button(action: {
//                            let exerciseTypeRow = ExerciseTypeRow(exerciseName: "", timestamp: Date(), exerciseReps: [])
//                            exerciseTypeRows.append(exerciseTypeRow)
//                        }) {
//                            Image(systemName: "plus")
//                                .scaledToFill()
//                                .scaleEffect(1.4)
//                                .padding(.all, 10)
//                                .background(Color(.systemGray5))
//                                .cornerRadius(10)
//                        }
                    }
                    .padding(.all, 15)
                    .background(Color("background"))
                    
                    HStack {
                        TextField("Workout Description...", text: $workoutDescription)//CustomTextEditor()//GrowingTextEditor()
                            
                            .foregroundColor(Color(.white).opacity(0.8))
                            .frame(height: 200, alignment: .topLeading)
                            .padding(.all)
                            .background(Color("background"))
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.black).opacity(0.6)))
                            .shadow(radius: 4)
                    }.padding(.horizontal, 10)
                    //.background(Color(.systemGray2))
//                    ScrollView {
//                        VStack(alignment: .leading, spacing: 10) {
//                            ForEach(exerciseTypeRows.indices, id: \.self) { index in
//                                ExerciseTypeRowView(exerciseTypeRowIndex: index, exerciseTypeRows: $exerciseTypeRows)
//                            }
//                        }
//                    }
                    HStack {
                        Text("Duration:").font(.title).fontWeight(.bold).offset(y: 1)
                        TimerView()
                    }.padding(.top)
                    
                    Button(action: {
                        //done
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        endTime = dateFormatter.string(from: Date())
                        print(endTime)
                        DonaldView.uploadWorkout(workout: ["account" : accountId ?? 1,
                                                           "startTime" : startTime,
                                                           "endTime" : endTime,
                                                           "title": workoutTitle == "" ? "Workout" : workoutTitle,
                                                           "description": workoutDescription,
                                                           "xp" : Int.random(in: 20..<50)])
                        creatingWorkout = false
                    }) {
                        Text("END WORKOUT")
                            .frame(width: 200, height: 50)
                            .foregroundColor(Color(.white))
                            .fontWeight(.bold)
                            .padding(.all, 8)
                            .background(Color("accent"))
                            .cornerRadius(10)
                    }
                    .padding()
                    
                    Spacer()
                    
                    Text("Press \"Record\" to start filming your workout").padding()

                    Button(action: {
                        startCountdown()
                        showCountdown = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            isRecordingViewPresented = true
                        }
                    }) {
                        Text("Record")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("accent"))
                            .cornerRadius(10)
                    }
                    .padding(.all, 15)
                    
                    .sheet(isPresented: $isRecordingViewPresented) {
                        ViewControllerWrapper()
                    }
                }.background(Color("inputs"))
                    .overlay(
                        showCountdown ?
                            AnyView(
                                Text("\(countdown)")
                                    .font(.system(size: 60))
                                    .bold()
                                    .foregroundColor(.black)
                            )
                        : AnyView(Text(""))
                    )
            }
//            .navigationBarTitle("New Workout", displayMode: .inline)
//            .navigationBarItems(trailing: Button(action: {
//                createWorkout()
//            }) {
//                Text("Create Workout")
//            })
        }
    }
    
    func startCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                    if countdown > 0 {
                        countdown -= 1
                        showCountdown = true
                    } else {
                        timer.invalidate()
                        withAnimation(.easeInOut(duration: 0.5)) {
                            showCountdown = false
                            countdown = 5
                        }
                    }
                }
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

struct TimerView: View {
    @State private var timer: Timer? = nil
    @State private var secondsElapsed = 0
    
    var minutes: Int {
        secondsElapsed / 60
    }
    
    var seconds: Int {
        secondsElapsed % 60
    }
    
    var body: some View {
        Text(String(format: "%02d:%02d", minutes, seconds))
            .font(.largeTitle)
            .onAppear {
                startTimer()
            }
            .onDisappear {
                timer?.invalidate()
            }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            secondsElapsed += 1
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
    var i: Int = 0
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("\(exerciseTypeRows[exerciseTypeRowIndex].exerciseName)")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(width: 200, alignment: .leading)
                    .foregroundColor(Color(.white).opacity(0.8))
                    //.background(Color(.systemGray5))
                    //.cornerRadius(10)
                    //.overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.systemGray2)))
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
                        .background(Color(exerciseRep.quality == "good" ? .green : .red).opacity(0.5))
                        .cornerRadius(10)
                    Spacer()
                    Text("\(formatDate(exerciseRep.timestamp))")
                        .font(.subheadline)
                }
                .padding(.all, 5)
                .background(Color(.systemGray5))
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.systemGray3)))
            }
//            Button(action: {
//                reps = reps + 1
//                quality = Int.random(in: 1...5) <= 4 ? "good" : "bad"
//                let exerciseRep = ExerciseRep(reps: reps, timestamp: Date(), quality: quality)
//                exerciseTypeRows[exerciseTypeRowIndex].exerciseReps.append(exerciseRep)
//            }) {
//                Image(systemName: "plus")
//                    .padding()
//            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 25)
            .fill(LinearGradient(gradient: Gradient(
                colors: [Color("buttons").opacity(0.4),Color("buttons").opacity(0.2), Color("background").opacity(0.75)]),
                                 startPoint: UnitPoint(x: 0.5, y: 0),
                                 endPoint: UnitPoint(x: 0.5, y: 1))
            ))
        .cornerRadius(10)
        .shadow(radius: 4)
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "hh:mm:ss a"
        return dateFormatter.string(from: date)
    }
    
//    func capitalize(_ myString: String) -> String {
//        if let firstLetter = myString.prefix(1).capitalized.first {
//            if myString.first != firstLetter {
//                myString.replaceSubrange(myString.startIndex...myString.startIndex, with: String(firstLetter))
//            }
//        }
//    }
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

struct GrowingTextEditor: View {
    @State private var text: String = ""
    @State private var isEditing: Bool = false
    @State private var editorHeight: CGFloat = 40
    
    private let maxLength: Int = 140
    private let minHeight: CGFloat = 40
    private let maxHeight: CGFloat = 100
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                if text.isEmpty && !isEditing {
                    Text("Start typing...")
                        .foregroundColor(Color(.placeholderText))
                        .padding(.leading, 10)
                }
                TextEditor(text: $text)
                    .onChange(of: text) { value in
                        if text.count > maxLength {
                            text = String(text.prefix(maxLength))
                        }
                        updateHeight()
                    }
                    .onTapGesture {
                        isEditing = true
                    }
                    .frame(minHeight: editorHeight, maxHeight: maxHeight)
                    .padding(.leading, 5)
                    //.background(Color(.systemGray2))
                    //.overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.black)))
            }
            .frame(minHeight: minHeight, maxHeight: maxHeight)
            //.background(Color(.systemGray6))//.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding()
            .shadow(radius: 4, x: -2, y: 2)
            .onAppear(perform: updateHeight)
        }.overlay(!isEditing ? Text("Enter Description") : Text(""))
    }
    
    private func updateHeight() {
        let newSize = CGSize(width: UIScreen.main.bounds.width - 32, height: CGFloat.infinity)
        let currentHeight = text.height(containerWidth: newSize.width)
        editorHeight = max(minHeight, min(currentHeight, maxHeight))
    }
}

extension String {
    func height(containerWidth: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 17)
        let constraintBox = CGSize(width: containerWidth, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintBox, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: font], context: nil)
        
        return boundingBox.height
    }
}


struct CustomTextEditor: View {
    @State private var text = ""
    
    private let lineHeight: CGFloat = 20
    private let maxLines: CGFloat = 3
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.clear.opacity(0.1))
            
            TextEditor(text: $text)
                .font(.system(size: lineHeight))
                .foregroundColor(Color("text"))
                .background(Color.clear)
                .frame(height: lineHeight * maxLines)
                .padding(8)
                .onAppear {
                    UITextView.appearance().backgroundColor = .clear
                }
                .onDisappear {
                    UITextView.appearance().backgroundColor = nil
                }
        }
        .frame(height: lineHeight * maxLines + 16)
        .cornerRadius(10)
    }
}
