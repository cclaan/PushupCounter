//
//  HomeScanHelpView.swift
//  3dScannerApp
//
//  Created by CC Laan on 6/2/23.
//  Copyright © 2023 Laan Labs. All rights reserved.
//

import Foundation

import SwiftUI


struct PushupIntroStep: View {
    
    var body: some View {
//        
//        Image(systemName: "figure.strengthtraining.functional")
//            .resizable()
//            .aspectRatio(contentMode: .fit)
//            .foregroundColor(.orange)
//            .padding(8)
//            .frame(width: 70, height: 70)
        
            //.background(Circle().fill(Color(UIColor.systemGray6)))
        
        Image("Icon-180")
                   .resizable()
                   .scaledToFit()
                   .frame(width: 90, height: 90)
                   .cornerRadius(20)
                   .shadow(color: .purple.opacity(0.7), radius: 50)
        
        
        Text("Pushup Counter App").font(Font.system(size: 32, weight: .bold, design: .rounded))
            .padding(EdgeInsets(top: 10, leading: 4, bottom: 5, trailing: 4))
        
        Text("A stupidly simple pushup counter").font(.title2)
            .foregroundColor(.secondary)
            .italic()
            .padding(EdgeInsets(top: 4, leading: 12, bottom: 10, trailing: 12))
        
//        Text("Count your own pushups.\nView a calendar of your progress").font(.title2)
//            .multilineTextAlignment(.center)
        
//        Text("Tap + or - to add pushups to your current count. Then tap 'Mark Today Done' to record you meeting your goal for the day ").font(.title2)
            .foregroundColor(.secondary)
            .padding(EdgeInsets(top: 4, leading: 22, bottom: 10, trailing: 22))
        
        Divider().padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
        
        
        
        HStack {
            
            Image(systemName: "plus")
                .resizable()
                .aspectRatio(contentMode: .fit)
                //.font(Font.title.weight(.bold))
                .frame(width:24, height: 24)
                .foregroundColor(.secondary)
                .padding(12)
                .background(Circle().fill(Color(UIColor.systemGray6)))
            
            VStack(alignment: .leading, spacing: 8) {
                
                Text("Just count your pushups").font(.title3).bold()
                
                Text("Tap the ⊕ button to add 10\nTap ⊖ to remove one").font(.title3)
                    
                
            }
            .padding(8)
            
            Spacer()
            
        }
        .padding(.leading)
        
        Divider().padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
        
        
        // ==========
        
        
        
        
        HStack {
            //Image(systemName: "cloud.bolt")
            Image(systemName: "person.crop.circle.fill.badge.xmark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                //.font(Font.title.weight(.bold))
                .frame(width:24, height: 24)
                //.foregroundColor(.red)
                .foregroundColor(.secondary)
                .padding(12)
                .background(Circle().fill(Color(UIColor.systemGray6)))
            
            VStack(alignment: .leading, spacing: 8) {
                
                Text("No Signup").font(.title3).bold()
                    //.foregroundStyle(Color.secondary)
                
                Text("It's free and we don't collect your data ").font(.title3)
                
            }
            .padding(8)
            
            Spacer()
            
        }
        .padding(.leading)
        
        Divider().padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
        
        // ==================
        HStack {
            Image(systemName: "sparkles")
                .resizable()
                .shadow(color: Color.white, radius: 5)
                //.font(Font.title.weight(.bold))
                .frame(width:24, height: 24)
                .foregroundColor(.yellow)
                .padding(12)
                .background(Circle().fill(Color(UIColor.systemGray6)))
            
            VStack(alignment: .leading, spacing: 8) {
                
                Text("Auto Counter").font(.title3).bold()
                
                Text("Toggle the switch to auto count using the selfie camera").font(.title3)
                //Text("Be nice").font(.title3)
                
                    //.foregroundColor(.secondary)
                    //.padding(EdgeInsets(top: 4, leading: 32, bottom: 20, trailing: 32))
                
            }
            .padding(8)
            
            Spacer()
            
        }
        .padding(.leading)
        
        
        //Divider().padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
        
        
    }
}







// MARK: -
struct BulletItem : View {
    let imageName : String
    let label : String
    let color : Color
    
    var body: some View {
        
        ZStack {
           
            Path { path in
                path.move(to: CGPoint(x: 3, y: -2))
                path.addLine(to: CGPoint(x: 16, y: 4))
            }
            .stroke(style: StrokeStyle(lineWidth: 28, lineCap: .round, lineJoin: .round))
            .fill(color.opacity(0.12))
            .frame(height: 1)
            
            HStack {
                
                Image(systemName: imageName)
                    .foregroundColor(color)
                    .opacity(0.8)
                
                Text(label)
                //.font(.system(size: 16, weight: .semibold))
                    .fontWeight(.medium)
                //.foregroundStyle(.sec)
                    .multilineTextAlignment(.leading)
                    .padding(5)
                    .padding(.leading, 10)
                
                
                Spacer()
                
            }
            
        }
        .frame(width: 270)
        .padding(.vertical, 8)
            
        
    }
}

struct AutoCountStep: View {
        
    let videoUrl = Bundle.main.url(forResource: "pushup-help", withExtension: "mp4")!
    
    var body: some View {
        
        Image(systemName: "sparkles")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.orange)
            .padding(6)
            .frame(width: 60, height: 60)

        
        Text("Auto Counter Mode").font(Font.system(size: 34, weight: .bold, design: .rounded))
            .padding(EdgeInsets(top: 2, leading: 4, bottom: 1, trailing: 4))
        
        Text("Uses the front-facing depth sensor to count")
            .foregroundStyle(.secondary)
            .italic()
        
        EnhancedVideoPlayer([videoUrl], endAction: .loop)
            .disabled(true)
            .frame(height:220)
            .padding(.bottom, 7)
        
        
        BulletItem(imageName: "switch.2", label: "Toggle the switch to enable", color: .green)
        
        BulletItem(imageName: "lock.fill", label: "Allow Camera Permissions", color: .orange)
        
        
        BulletItem(imageName: "iphone.landscape", label: "Place phone screen up on the floor under chest", color: .purple)
        
        BulletItem(imageName: "chart.xyaxis.line", label: "Check the height graph", color: .teal)
        
        /*
        HStack {
            Image(systemName: "iphone.landscape")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.secondary)
                .padding(10)
                .frame(width: 48, height:48)
                .background(Circle().fill(Color(UIColor.systemGray6)))
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Place Phone").font(.title3).bold()
                Text("Put your phone screen up on the floor under your chest").font(.title3)
                
            }
            .padding(8)
            
            Spacer()
            
        }
        .padding(.leading)
        
        Divider().padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
        
        HStack {
            Image(systemName: "chart.xyaxis.line")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.teal)
                .padding(11)
                .frame(width: 48, height:48)
                .background(Circle().fill(Color(UIColor.systemGray6)))
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Do Pushups").font(.title3).bold()
                Text("Check the depth graph to see when a pushup is counted").font(.title3)
                
            }
            .padding(8)
            
            Spacer()
            
        }
        .padding(.leading)
        */
        
        //Divider().padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
        
        
        
    }
}




// MARK: -

struct PushupAppHelpView: View {
    
    @Binding var showingHelp : Bool
    
    @State var currentStep = 0
    static let numSteps = 2
    
    //var parentViewController : UIViewController? = nil
    
    var body: some View {
        
        
        VStack {
            
            // Video or Image
            if currentStep == 0 {
                
                PushupIntroStep()
                
            } else if currentStep == 1 {
                               
                AutoCountStep()
            
                
            }
            
            Spacer()
            
            HStack {
                ForEach(0..<Self.numSteps) { step in
                    
                    Circle().fill(step == self.currentStep ? Color.blue : Color(UIColor.systemGray4) )
                        .frame(width: 10, height: 10)
                }
            }
            
            ZStack {
                
                if currentStep > 0 {
                    Button {
                        self.gotoPreviousStep()
                    } label: {
                        Text("Back")
                    }.padding(.trailing)
                        .offset(x: -130, y: 0)
                }
                
                Button {
                    self.close()
                } label: {
                    Text("Close")
                }.padding(.trailing)
                    .offset(x: 130, y: 0)
                
                /*
                if self.currentStep < Self.numSteps-1 {
                    Button {
                        self.parentViewController?.dismiss(animated: true, completion: nil)
                    } label: {
                        Text("Skip")
                    }.padding(.trailing)
                        .offset(x: 130, y: 0)
                }
                */
                
            Button {
                
                //withAnimation {
                    self.gotoNextStep()
                //}
                
            } label: {
                Text(self.currentStep == Self.numSteps-1 ? "Let's Go!" : "Next")
                    .font(.title3).bold()
                    .frame(minWidth: 130)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    //.background(self.currentStep == Self.numSteps-1 ? Color.green : Color.blue)
                        //LinearGradient(gradient: Gradient(colors: [Color.blue, Color.teal]), startPoint: .top, endPoint: .bottom))
                    .cornerRadius(40)
                
            }
            
            }.padding()
            
        }
    }
    
    func close() {
        //self.parentViewController?.dismiss(animated: true, completion: nil)
        self.showingHelp = false
    }
    
    func gotoNextStep() {
        var step = self.currentStep
        step += 1
        if step >= Self.numSteps  {
            self.close()
            return;
        }
        currentStep = step
    }
    
    func gotoPreviousStep() {
        var step = self.currentStep
        step -= 1
        if step < 0  {
            step = 0
        }
        currentStep = step
    }
}


#Preview {
    PushupAppHelpView(showingHelp: .constant(false))
}
