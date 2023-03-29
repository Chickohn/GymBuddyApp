//
//  ContentView.swift
//  GymBuddySwiftUI
//
//  Created by Freddie Kohn on 12/03/2023.
//

import SwiftUI
import CoreData

struct Workout: Hashable{
    let title: String
    let duration: Int
    let calories: Int
    let exercises: [Exercise]
}

struct Exercise: Hashable{
    let name: String
    let sets: Int
    let reps: Int
    let weight: Int
}

struct WorkoutView: View {
    let workout: Workout

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(workout.title)
                .font(.title)

            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.gray)

                Text("\(workout.duration) min")
            }

            HStack {
                Image(systemName: "flame")
                    .foregroundColor(.gray)

                Text("\(workout.calories) cal")
            }

            Text("Exercises:")
                .font(.headline)

            //ForEach(workout.exercises, id: \.self) {exercise in
                VStack(alignment: .leading) {
                    Text("workout title")//exercise.title)
                        .font(.subheadline)
                        .foregroundColor(.blue)

                    HStack {
                        Text("Sets: ")//\(exercise.sets)")
                        Text("Reps: ")//\(exercise.reps)")
                        Text("Weight: ")//\(exercise.weight)")
                    }
                }
            //}

            Spacer()
        }
        .padding()
        .navigationTitle("Workout Details")
    }
}

func friendCard(username: String, pfp: String, recentTime: Float) -> some View {

    Button(action: {
        WorkoutView(workout: Workout(title: "Morning Workout", duration: 20, calories: 203, exercises: [Exercise(name: "Squats", sets: 3, reps: 8, weight: 120)]))
    }) {
        VStack(spacing: 8) {
            // Title
            Text(username)
                .font(.system(size: 18, weight: .bold))


            // Image
            Image(systemName: pfp)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)

            // Timestamp label
            Text(String(recentTime)+"hrs ago")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color("text"))
        .cornerRadius(10)
        .shadow(color: .gray, radius: 2, x: 0, y: 2)
    }
}


struct SwiftUIView: View {
    init() {
        // Customize the appearance of the tab bar
        UITabBar.appearance().barTintColor = UIColor.blue
        UITabBar.appearance().unselectedItemTintColor = UIColor.black
        UITabBar.appearance().backgroundColor = UIColor.darkGray
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        //UITabBar.appearance().layer.borderWidth = 1
        //UITabBar.appearance().layer.borderColor = UIColor.black.cgColor
    }
    
    @State private var selectedTab = 0
    @State private var selection = 0
    @State var mainColor = Color("background")
    @State var secondaryColor = Color("accent")
    @State var thirdColor = Color("buttons")
    @State var fourthColor = Color("text")
    @State var fifthColor = Color("inputs")
    @State var sixthColor = Color("tabs")


    var body: some View {
        
        TabView(selection: $selection) {
            
            ZStack (alignment: .center) {
                
                ScrollView (showsIndicators: false) {
                    
                    VStack(alignment: .center, spacing: 25) {

                        Button(action: {
                            selection = 2
                        }) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(thirdColor)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(color: .black, radius: 2, x: -3, y: 5)
                                .frame(width: 370, height: 100)
                                .overlay(
                                    Text("Get Started")
                                        .font(.system(size: 25, weight: .bold))
                                        .padding()
                                        .foregroundColor(secondaryColor)
                                )
                        }
                        VStack(alignment: .leading, spacing: 20) {
                                    Text("Friends")
                                        .font(.system(size: 30, weight: .bold))
                                        .foregroundColor(secondaryColor)
                                        .padding(.horizontal)
                                        .padding(.top)
                                    Text("See what everyone's been getting up to...")
                                        .font(.system(size: 18))
                                        .foregroundColor(secondaryColor)
                                        .padding(.horizontal)
                                    HStack(spacing: 3) {
                                        friendCard(username: "Cbum",pfp: "person.fill", recentTime: 2.4)
                                        friendCard(username: "Arnold",pfp: "person.fill", recentTime: 3.1)
                                        friendCard(username: "Zyzz",pfp: "person.fill", recentTime: 6.8)
                                        //friendCard
                                    }
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(10)
                                    .padding()
                                }
                                .frame(width: 370, height: 275)
                                .background(RoundedRectangle(cornerRadius: 10)
                            .fill(thirdColor)
                            .shadow(color: .black, radius: 2, x: -3, y: 5)
                            .frame(width: 370, height: 275))
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(thirdColor)
                            .shadow(color: .black, radius: 2, x: -3, y: 5)
                            .frame(width: 370, height: 200)
                            .overlay(Text("Tab 3")
                                .foregroundColor(secondaryColor)
                            )
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(thirdColor)
                            .shadow(color: .black, radius: 2, x: -3, y: 5)
                            .frame(width: 370, height: 200)
                            .overlay(Text("Tab 4")
                                .foregroundColor(secondaryColor)
                            )
                        
                    }
                    
                    //.background(mainGray)
                    .padding(.vertical, 90)
                    .padding(.horizontal, 10)
                    
                }
                
                .background(fourthColor)
                .frame(width:200, height:709)
                .padding(.leading, 0)
                .padding()
                .padding(.horizontal, 0)
                .position(x:196, y:355)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(mainColor, lineWidth: 2)
                        .shadow(color: .black,
                                    radius: 2, x: 0, y: 5)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 15)
                        ).offset(y:-3)
//                        .shadow(color: Color.white, radius: 2, x: -2, y: -2)
//                        .clipShape(
//                            RoundedRectangle(cornerRadius: 15)
//                        )
                )

                
                Text("Home")
                    .font(.title)
                    .foregroundColor(secondaryColor)
                    .padding([.leading, .trailing], 0)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(mainColor)
                            .frame(width: 100, height: 40)
                            .shadow(radius: 2, x: -3, y: 3)
                    )
                    .offset(x: -130, y: -320)
                
                
                Button(
                    action: {
                    // Cycle through the three color sets
                    if mainColor == Color("mainGray") {
                        mainColor = Color("deepBlue")
                        secondaryColor = Color("babyBlue")
                        thirdColor = Color("steel")
                        fourthColor = Color("fog")
                        fifthColor = Color("silver")
                    } else if mainColor == Color("deepBlue") {
                        mainColor = Color("nearBlack")
                        secondaryColor = Color("mainOrange")
                        thirdColor = Color("steel")
                        fourthColor = Color("fog")
                        fifthColor = Color("silver")
                    } else {
                        mainColor = Color("mainGray")
                        secondaryColor = Color("mainOrange")
                        thirdColor = Color("steel")
                        fourthColor = Color("fog")
                        fifthColor = Color("silver")
                    }
                    
                }
                )
                {
                    
                    Text("Theme")
                        .padding()
                    
                }
                
                    .background(RoundedRectangle(cornerRadius: 10)
                            .fill(mainColor)
                            .frame(width: 100, height: 40)
                            .shadow(radius: 2, x: -3, y: 3))
                    .foregroundColor(secondaryColor)
                    .padding()
                    .position(x: 330, y: 34)
            }
            
            .background(mainColor)
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            .tag(0)
            
            // Second tab
            Text("Second Tab")
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Social")
                }
                .tag(1)
            
            // Third tab
            ZStack {
                
                Text("FormAR")
                    .font(.title)
                    .foregroundColor(secondaryColor)
                    .padding([.leading, .trailing], 0)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(mainColor)
                            .frame(width: 110, height: 40)
                            .shadow(radius: 2, x: -3, y: 3)
                    )
                    .offset(x: -115, y: -320)
            }
            .tabItem {
                Image(systemName: "camera")
                Text("FormAR")
            }
            .tag(2)
            
            // Fourth tab
            Text("Fourth Tab")
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Leaderboard")
                }
                .tag(3)
            
            // Fifth tab
            Text("Fifth Tab")
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile ")
                }
                .tag(4)
        }
        .background(mainColor)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
