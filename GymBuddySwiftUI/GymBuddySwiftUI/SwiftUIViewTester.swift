//
//  SwiftUIViewTester.swift
//  GymBuddySwiftUI
//
//  Created by Freddie Kohn on 13/03/2023.
//

import SwiftUI
import AVFoundation
import Foundation
import Combine

//struct User: Decodable {
//    let id: Int
//    let name: String
//    let email: String
//}

//class DataFetcher: ObservableObject {
//    @Published var data: [User] = []
//    private var cancellables: Set<AnyCancellable> = []
//
//    init() {
//        fetchData()
//    }
//
//    func fetchData() {
//        guard let url = URL(string: "http://127.0.0.1:8000/") else {
//            print("Invalid URL")
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let session = URLSession.shared
//        let publisher = session.dataTaskPublisher(for: request)
//            .map(\.data)
//            .decode(type: [User].self, decoder: JSONDecoder())
//
//        publisher
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .failure(let error):
//                    print("Error: \(error.localizedDescription)")
//                case .finished:
//                    break
//                }
//            }, receiveValue: { [weak self] data in
//                self?.data = data
//            })
//            .store(in: &cancellables)
//    }
//}


struct SwiftUIViewTester_Previews: PreviewProvider {
    static var previews: some View {
        SwiftView()
    }
}

struct SwiftView: View {
    init() {
        // Customize the appearance of the tab bar
        UITabBar.appearance().barTintColor = UIColor.blue
        UITabBar.appearance().unselectedItemTintColor = UIColor.black
        UITabBar.appearance().backgroundColor = UIColor.darkGray
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
    }
    
    @State private var selection = 0
    //@StateObject var dataFetcher = DataFetcher()
    
    var body: some View {
        
//        List(dataFetcher.data, id: \.id) { item in
//                    Text(item.name)
//                }
//                .onAppear {
//                    dataFetcher.fetchData()
//                }
        
        TabView(selection: $selection) {
            homePage(selection: $selection)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(0)
            
            // Second tab
            SocialView()
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Social")
                }
                .tag(1)
            
            // Third tab
            CameraView()
                .tabItem {
                    Image(systemName: "camera")
                    Text("FormAR")
                }
                .tag(2)
            
            // Fourth tab
            LeaderboardView()
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Leaderboard")
                }
                .tag(3)
            
            // Fifth tab
            UserProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile ")
                }
                .tag(4)
        }
    }
}
