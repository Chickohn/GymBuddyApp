//
//  CameraView.swift
//  GymBuddySwiftUI
//
//  Created by Freddie Kohn on 08/04/2023.
//

import SwiftUI
import AVFoundation
import Foundation
import Combine

struct CameraView: View {
    @State private var workoutStatus = 0
    @State private var workoutCounter = 0
    @State private var playButtonTapped = false
    
    private let workoutColors = [Color.red, Color.green, Color.orange]
    private let workoutNames = ["No workout detected", "Running", "Cycling"]
    
    var body: some View {
        ZStack {
            CameraPreviewView()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(workoutColors[workoutStatus])
                        .frame(width: 150, height: 40)
                        .overlay(
                            Text(workoutNames[workoutStatus])
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        )
                        .padding(.leading)
                    
                    Spacer()
                    
                    Button(action: incrementCounter) {
                        Text("\(workoutCounter)")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding()
                    }
                    .padding(.trailing)
                }
                .padding(.top)
                
                Spacer()
                
                Button(action: togglePlayButton) {
                    Image(systemName: playButtonTapped ? "stop.fill" : "play.fill")
                        .font(.system(size: 60))
                        .foregroundColor(Color.orange)
                        .padding()
                }
                .background(Color.black.opacity(0.5).blur(radius: 20))
                .clipShape(Circle())
                .padding(.bottom)
            }
        }
    }
    
    private func togglePlayButton() {
        playButtonTapped.toggle()
        // Add haptic feedback here
    }
    
    private func incrementCounter() {
        workoutCounter += 1
        // Add haptic feedback here
    }
}

struct CameraPreviewView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            return view
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return view }
        captureSession.addInput(input)
        captureSession.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) { }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
