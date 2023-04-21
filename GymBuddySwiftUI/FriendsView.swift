//
//  FriendsView.swift
//  GymBuddySwiftUI
//
//  Created by Freddie Kohn on 20/04/2023.
//

import SwiftUI
import Combine

struct FriendsView: View {
    @AppStorage("accountId") private var accountId: Int?
    
    @State private var searchText = ""
    @State private var searchResults: [AccountSearch] = []
    @State private var pendingRequests: [AccountSearch] = []
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @State private var account: Account?
    
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    TextField("Search", text: $searchText)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .foregroundColor(Color(.systemGray6))
                        .accentColor(Color(.systemBlue))
                        .padding(.horizontal, 16)
                        .onChange(of: searchText) { newValue in
                            performSearch(query: newValue)
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    ZStack {
                        List {
                            Section(header: Text("Pending Requests")) {
                                ForEach(pendingRequests) { request in
                                    HStack {
                                        Text(request.username)
                                        Spacer()
                                        Button(action: {
                                            sendFriendRequest(account1ID: request.id, account2ID: accountId!)
                                            fetchPendingRequests()
                                        }) {
                                            Image(systemName: "person.badge.plus")
                                        }
                                    }
                                }
                                    
                            }.onAppear(perform: {
                                fetchPendingRequests()
                                
                            })
                                
                            
                            Section(header: Text("Search Results")) {
                                ForEach(searchResults) { result in
                                    HStack {
                                        Text(result.username)
                                        Spacer()
                                        Button(action: {
                                            sendFriendRequest(account1ID: accountId!, account2ID: result.id)
                                        }) {
                                            Image(systemName: "person.badge.plus")
                                        }
                                    }
                                }
                            }
                        }
                        .background(Color(.systemGray2))
                        .listStyle(GroupedListStyle())
                    }.background(Color("inputs"))
                }
                .offset(y: 70)
                .overlay(
                    //                Button(action: {
                    //                    appStorageManager.logout()
                    //                }) {
                    GeometryReader { proxy in
                        Text("Add Friends")
                            .font(.title)
                            .foregroundColor(Color("accent"))
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(LinearGradient(gradient: Gradient(
                                        colors: [Color("buttons").opacity(0.6),Color("buttons").opacity(0.3), Color("background").opacity(0.75)]),
                                                         startPoint: UnitPoint(x: 0, y: -2),
                                                         endPoint: UnitPoint(x: 0.55, y: 1))
                                         )
                                    .frame(width: 170, height: 40)
                                    .shadow(radius: 2, x: -3, y: 3)
                            )
                            .position(x: proxy.safeAreaInsets.leading + 105, y: proxy.safeAreaInsets.top - 10)
                    })
                //            .navigationBarTitle("Add Friends")
                //            .foregroundColor(Color("accent"))
            }.background(Color("inputs"))
        }
    }
    
    private func fetchPendingRequests() {
        let pendingRequestsUrl = "http://\(ip):8000/api/account/\(accountId ?? 1)"

        guard let url = URL(string: pendingRequestsUrl) else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(Account.self, from: data)
                    DispatchQueue.main.async {
                        self.pendingRequests = decodedResponse.pending_requests.map { $0.account }
                    }
                } catch {
                    print("Error decoding response: \(error)")
                }
            } else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }

    
    private func performSearch(query: String) {
        let searchUrl = "http://\(ip):8000/api/search/?q=\(query)"
        
        guard let url = URL(string: searchUrl) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode([AccountSearch].self, from: data)
                    DispatchQueue.main.async {
                        self.searchResults = decodedResponse
                    }
                } catch {
                    print("Error decoding response: \(error)")
                }
            } else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }

    
    private func sendFriendRequest(account1ID: Int, account2ID: Int) {
        print("\(account1ID) \(account2ID)")
        let requestUrl = "http://\(ip):8000/api/friend/request/?account1=\(account1ID)&account2=\(account2ID)"
        
        guard let url = URL(string: requestUrl) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST" // Adjust this according to your API requirements
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error sending friend request: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            DispatchQueue.main.async {
                // Update the pendingRequests list, if necessary
                // You may also want to show an alert or a message to inform the user that the friend request has been sent successfully
                
            }
        }.resume()
    }
}

struct FriendSearchView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
