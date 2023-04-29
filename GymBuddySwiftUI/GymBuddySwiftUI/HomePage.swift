//
//  HomePage.swift
//  GymBuddySwiftUI
//
//  Created by Freddie Kohn on 08/04/2023.
//

import SwiftUI

struct homePage: View {
    @State var mainColor = Color("background")
    @State var secondaryColor = Color("accent")
    @State var thirdColor = Color("buttons")
    @State var fourthColor = Color("text")
    @State var fifthColor = Color("inputs")
    @State var sixthColor = Color("tabs")
    @Binding var selection: Int
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .center) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .center, spacing: 25) {
                        Button(action: {
                            selection = 2
                        }) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(thirdColor)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(color: .black, radius: 2, x: -3, y: 5)
                                .frame(maxWidth: .infinity, minHeight: 100)
                                .overlay(
                                    Text("Get Started")
                                        .font(.system(size: 40, weight: .bold))
                                        .padding()
                                        .foregroundColor(secondaryColor)
                                )
                        }
                        VStack(alignment: .center, spacing: 15) {
                            Text("Friends")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(secondaryColor)
                                .padding(.horizontal, -20)
                                .padding(.top)
                            Text("See what everyone's been getting up to...")
                                .font(.system(size: 18))
                                .foregroundColor(secondaryColor)
                                .padding(.horizontal, -10)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    friendCard(username: "Cbum", time: 2.4)
                                    friendCard(username: "Arnold",pfp: "person.fill", time: 3.1)
                                    friendCard(username: "Zyzz",pfp: "person.fill", time: 6.8)
                                    friendCard(username: "Freddie",pfp: "person.fill", time: 9.3)
                                }
                            }
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.bottom, 15)
                            .padding(.horizontal, 15)
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity * 0.4)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .fill(thirdColor)
                            .shadow(color: .black, radius: 2, x: -3, y: 5))
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(thirdColor)
                            .shadow(color: .black, radius: 2, x: -3, y: 5)
                            .frame(maxWidth: .infinity, maxHeight: .infinity * 0.2)
                            .overlay(Text("Tab 3")
                                .foregroundColor(secondaryColor)
                            )
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(thirdColor)
                            .shadow(color: .black, radius: 2, x: -3, y: 5)
                            .frame(maxWidth: .infinity, maxHeight: .infinity * 0.2)
                            .overlay(Text("Tab 4")
                                .foregroundColor(secondaryColor)
                            )
                    }
                    .padding(.vertical, 90)
                    .padding(.horizontal, 10)
                }
                .background(fourthColor)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(mainColor, lineWidth: 2)
                        .shadow(color: .black, radius: 2, x: 0, y: 5)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 15)
                        )
                )
            }
            .background(mainColor)
            .overlay(
                GeometryReader { proxy in
                    Text("Home")
                        .font(.title)
                        .foregroundColor(secondaryColor)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(mainColor)
                                .frame(width: 100, height: 40)
                                .shadow(radius: 2, x: -3, y: 3)
                        )
                        .position(x: proxy.safeAreaInsets.leading + 70, y: proxy.safeAreaInsets.top - 10)
                }
            )
        }
    }
}

struct friendCard: View {
    let username: String
    var pfp: String? = "person.fill"
    let time: Float

    var body: some View {
        
    let workout = Workout(exerciseName: "Bench Press", sets: 4, reps: 8, weight: 185, date: "2023-04-01", duration: 60, caloriesBurned: 350, notes: "Felt strong today.")

        NavigationLink(destination: DetailView(username: username, workout: workout)) {
                    VStack(spacing: 8) {
                        // Title
                        Text(username)
                            .font(.system(size: 18, weight: .bold))

                        // Image
                        Image(systemName: pfp!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)

                        // Timestamp label
                        Text(String(time) + " hrs ago")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color("text"))
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
                }
    }
}

struct DetailView: View {
    let username: String
    var workout: Workout
    @State var isShowingWorkout: Bool = false

    var body: some View {
        
        

        VStack(alignment: .leading, spacing: 16) {
            Text(workout.exerciseName)
                .font(.title)

            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.gray)

                Text("\(workout.duration) min")
            }

            HStack {
                Image(systemName: "flame")
                    .foregroundColor(.gray)

                Text("\(workout.caloriesBurned) cal")
            }

            Text("Exercises:")
                .font(.headline)

//            ForEach(workout.exercises, id: \.self) {exercise in
                VStack(alignment: .leading) {
                    Text(workout.exerciseName)
                        .font(.subheadline)
                        .foregroundColor(.blue)

                    HStack {
                        Text("Sets: \(workout.sets)")
                        Text("Reps: \(workout.reps)")
                        Text("Weight: \(workout.weight)")
                    }
                //}

                Spacer()
            }
            .padding()
            .navigationTitle("Workout Details")
        }
            .font(.headline)
            .navigationBarTitle(username)
    }
}

//struct HomePage_Previews: PreviewProvider {
//
//    static var previews: some View {
//        homePage()
//    }
//}
