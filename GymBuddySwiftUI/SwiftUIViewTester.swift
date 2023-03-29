//
//  SwiftUIViewTester.swift
//  GymBuddySwiftUI
//
//  Created by Freddie Kohn on 13/03/2023.
//

import SwiftUI

struct SwiftUIViewTester: View {
    @State var offset: CGFloat = 0
    @State var showTitle = false
    @State var showDescription = false
    var body: some View {
        
        ScrollView {
            VStack(spacing: 20) {
                Image("background")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .blur(radius: offset/10)
                    .offset(y: -offset/2)
                
                Text("Animated Scroll View")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .scaleEffect(showTitle ? 1 : 0.2)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6))
                    .onAppear {
                        self.showTitle = true
                    }
                
                Text("This is a cool animation that uses a scroll view and some other techniques to create a dynamic and engaging user experience.")
                    .font(.headline)
                    .foregroundColor(.white)
                    .opacity(showDescription ? 1 : 0)
                    .animation(.easeInOut(duration: 1))
                    .onAppear {
                        self.showDescription = true
                    }
                
                VStack(spacing: 20) {
                    ForEach(0..<20) { index in
                        Rectangle()
                            .fill(Color.blue)
                            .frame(height: 50)
                            .opacity(1 - Double(index)/20)
                    }
                }
                .offset(y: offset)
                .animation(.easeInOut(duration: 0.5))
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            UIScrollView.appearance().backgroundColor = .clear
        }
        .overlay(
            Text("\(Int(offset))")
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.5))
                .clipShape(Circle())
                .offset(x: UIScreen.main.bounds.width/2 - 40, y: UIScreen.main.bounds.height/2 - 40)
        )
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            withAnimation {
                self.offset = 0
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            withAnimation(.spring()) {
                self.offset = 0
            }
        }
        .simultaneousGesture(
            DragGesture()
                .onChanged { value in
                    self.offset = value.translation.height
                }
                .onEnded { value in
                    withAnimation(.spring()) {
                        if self.offset > 100 {
                            self.offset = 200
                        } else if self.offset < -100 {
                            self.offset = -200
                        } else {
                            self.offset = 0
                        }
                    }
                }
        )
    }
}

//struct SwiftUIViewTester_Previews: PreviewProvider {
//    static var previews: some View {
//        SwiftUIViewTester()
//    }
//}
