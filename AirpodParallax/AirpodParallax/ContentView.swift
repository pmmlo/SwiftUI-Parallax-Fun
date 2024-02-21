//
//  ContentView.swift
//  AirpodParallax
//
//  Created by Philip Davis on 3/11/22.
//

import SwiftUI
import CoreMotion
import CameraView

struct ContentView: View {
    @State var parallaxMode: ParallaxMode = .device
    @State var pitch: Double = 0.0
    @State var roll: Double = 0.0
    @State var yaw: Double = 0.0
    
    let manager = CMMotionManager()
    
    var body: some View {
        ZStack {
            ProgressView()
            VStack {
                Image("forest")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 340, height: 500)
                    .scaleEffect(1.6)
                    .offset(x: CGFloat(yaw * 90), y: CGFloat(pitch * 90))
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .offset(x: CGFloat(-yaw * 5), y: CGFloat(-pitch * 5))
                    .animation(.linear(duration: 0.1), value: pitch)
                    .animation(.linear(duration: 0.1), value: yaw)
                
                if self.parallaxMode == .airpods {
                    ZStack {
                        CameraView(cameraPosition: .front)
                            .clipShape(Circle())
                            .frame(width: 180, height: 340)
                        
                    }.frame(height: 220)
                }
                
                Button(action: {
                    if self.parallaxMode == .device {
                        self.parallaxMode = .airpods
                    } else {
                        self.parallaxMode = .device
                    }
                }, label: {
                    Image(systemName: self.parallaxMode == .airpods ? "iphone.sizes" : self.parallaxMode == .device ? "airpodspro" : "exclamationmark.triangle.fill").resizable().aspectRatio(contentMode: .fit).frame(width: 40, height: 40).foregroundColor(Color(UIColor.label))
                })
            }

        }.onAppear {
            manager.startDeviceMotionUpdates(to: .main) { (motionData, error) in
                pitch = motionData!.attitude.pitch
                roll = motionData!.attitude.roll
                yaw = motionData!.attitude.yaw
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum ParallaxMode {
    case device, airpods
}
