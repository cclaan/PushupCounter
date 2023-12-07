//
//  ContentView.swift
//  PushupCounter
//
//  Created by CC Laan on 10/14/23.
//

import SwiftUI
import Combine
import ARKit
import SceneKit




extension Date {
    func monthName() -> String {
            let df = DateFormatter()
            df.setLocalizedDateFormatFromTemplate("MMM")
            return df.string(from: self)
    }
}

private func weekdayOfFirstDayInMonth(year: Int, month: Int) -> Int {
    var calendar = Calendar.current
    calendar.firstWeekday = 1 // Sunday = 1, Monday = 2, etc.
    let dateComponents = DateComponents(year: year, month: month)
    let date = calendar.date(from: dateComponents)!
    let weekday = calendar.component(.weekday, from: date)
    return (weekday - calendar.firstWeekday + 7) % 7 // Adjust to have 0 index based
}


extension DateComponents {
    
    var isSaturday : Bool {
        
        // Create a calendar
        let calendar = Calendar.current
        
        // Convert DateComponents to Date
        if let date = calendar.date(from: self) {
            
            // Extract the weekday component
            let weekday = calendar.component(.weekday, from: date)
            
            // Check if it's Saturday
            if weekday == 7 {
                return true
            } else {
                return false
            }
        } else {
            print("Invalid date")
            return false
        }
        
    }
    
}

struct CheckmarkBackground: View {
    var body: some View {
        ZStack {
            Path { path in
                path.move(to: CGPoint(x: 2, y: 10))
                path.addLine(to: CGPoint(x: 16, y: 26))
                path.addLine(to: CGPoint(x: 40, y: 0))
            }
            .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round, lineJoin: .round))
            .fill(Color.blue)
            
            Path { path in
                path.move(to: CGPoint(x: 2, y: 10))
                path.addLine(to: CGPoint(x: 16, y: 26))
                path.addLine(to: CGPoint(x: 40, y: 0))
            }
            .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
            .fill(Color.teal)
        }
        
    }
}

//(Circle()
//                .stroke(Color(UIColor.secondarySystemBackground), lineWidth: 2)
//                .background(Circle().fill(Color.pink))
// 
struct CheckmarkBackground2: View {
    var body: some View {
        ZStack {
            
            Circle()
                .fill(Color.blue.opacity(0.5))
                .frame(width: 19, height: 19)
            
            
            Path { path in
                path.move(to: CGPoint(x: 10, y: 16))
                path.addLine(to: CGPoint(x: 14, y: 20))
                path.addLine(to: CGPoint(x: 20, y: 12))
            }
            .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
            .fill(Color.blue)
            .offset(x:16, y: 3)
            
            Path { path in
                path.move(to: CGPoint(x: 10, y: 16))
                path.addLine(to: CGPoint(x: 14, y: 20))
                path.addLine(to: CGPoint(x: 20, y: 12))
            }
            .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
            .fill(Color.yellow)
            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.5), radius: 3.5)
            //.shadow(color: .black, radius: 3)
            .offset(x:16, y: 3)
            
            
            
            
        }
        //.position(x: 34.0, y: 23.0)
        
    }
}

struct CheckmarkBackground3: View {
    var body: some View {
        ZStack {
            
            Circle()
                .stroke(Color(UIColor.systemBackground), lineWidth: 2)
                .background(
                    Circle().fill(Color.blue)
                )
                .frame(width: 19, height: 19)
            
            Path { path in
                path.move(to: CGPoint(x: 10, y: 16))
                path.addLine(to: CGPoint(x: 14, y: 20))
                path.addLine(to: CGPoint(x: 20, y: 12))
            }
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .fill(Color.white)
            
            
        }
        
    }
}

struct CalendarView: View {
    
    @State private var currentYear: Int = Calendar.current.component(.year, from: Date())
    @State private var currentMonth: Int = Calendar.current.component(.month, from: Date())
    
    @Binding var selectedDates: Set<DateComponents>

    var body: some View {
        VStack {
            
            HStack {
                Button(action: { self.changeMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
                        .padding(12)
                        .background(Circle().fill( Color(UIColor.secondarySystemBackground) ))
                }

                Spacer()

                Text(String(format: "%@ %i", monthName(from: currentMonth), currentYear))
                    .font(.system(size: 16, weight: .semibold, design: .default))
                    .foregroundStyle(Color.primary)
                                
                Spacer()

                Button(action: { self.changeMonth(by: 1) }) {
                    Image(systemName: "chevron.right")
                        .padding(12)
                        .background(Circle().fill( Color(UIColor.secondarySystemBackground) ))
                }
            }
            .padding()
            
            // Days of the week header
            HStack {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day.uppercased())
                        .font(.system(size: 13, weight: .semibold,
                                      design: .rounded))
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.secondary)
                }
            }
                        
            // Calendar grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                
                // Calculate the weekday of the first day of the month and add empty views
                let weekdayOfFirst = weekdayOfFirstDayInMonth(year: currentYear, month: currentMonth)
                ForEach(0..<weekdayOfFirst, id: \.self) { _ in
                    Text("")
                        .frame(width: 30, height: 30)
                }
                
                ForEach(1...daysInMonth(year: currentYear, month: currentMonth), id: \.self) { day in
                    
                    let todayComponents = DateComponents(year: currentYear, month: currentMonth, day: day)
                    
                    let nextDate = DateComponents(year: currentYear, month: currentMonth, day: day+1)
                                        
                    if isSpecialDate(todayComponents) {
                        
                        
                        ZStack {
                            
                            // Connect previous to today for streak
                            if isSpecialDate(nextDate) && !todayComponents.isSaturday {
                                
                                Path { path in
                                    path.move(to: CGPoint(x: 24, y: 15))
                                    path.addLine(to: CGPoint(x: 80, y: 15))
                                }
                                .stroke(style: StrokeStyle(lineWidth: 30, lineCap: .round, lineJoin: .round))
                                .fill(Color.blue)
                            }
                            
                            Text("\(day)")
                                //.fontWeight(.semibold)
                                .font(.system(size: 14, weight: .semibold, 
                                              design: .monospaced))
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color.white)
                                //.background(CheckmarkBackground2())
                                .background(Circle().fill(Color.blue))
                                .overlay(CheckmarkBackground2())
                            
                        }
                            
                    } else {
                        
                        Text("\(day)")
                            .font(.system(size: 15, weight: .regular, 
                                          design: .monospaced))
                            .frame(width: 30, height: 30)
                            //.background()
                    }
                }
            }
        }
        .padding()
    }

    private func changeMonth(by amount: Int) {
        // Adjust the current month
        currentMonth += amount
        if currentMonth > 12 {
            currentMonth = 1
            currentYear += 1
        } else if currentMonth < 1 {
            currentMonth = 12
            currentYear -= 1
        }
    }

    private func daysInMonth(year: Int, month: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }

    private func monthName(from month: Int) -> String {
        
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "LLLL"
        dateFormatter.dateFormat = "MMMM"
        let date = dateFormatter.calendar.date(from: DateComponents(month: month))!
        
        let s = dateFormatter.string(from: date)
        //print(s)
        return s
        
        
    }
    

    private func getDate(year: Int, month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        return Calendar.current.date(from: components) ?? Date()
    }

//    private func isSpecialDate(_ date: Date) -> Bool {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        let dateString = formatter.string(from: date)
//        return specialDates.contains(where: { formatter.string(from: $0) == dateString })
//    }
    private func isSpecialDate(_ dateComponents: DateComponents) -> Bool {
            return selectedDates.contains {
                $0.year == dateComponents.year &&
                $0.month == dateComponents.month &&
                $0.day == dateComponents.day
            }
        }
}


struct CalendarView_Previews: PreviewProvider {
    
    static var sampleDates : Set<DateComponents> {
        //let now = Date().components
        var dates : [DateComponents] = []
        for i in 0...10 {
            dates.append( DateComponents(year: 2023, month: 12, day: 6 + i) )
        }
        return Set(dates)
    }
    
    static var previews: some View {
        CalendarView(selectedDates: .constant(Self.sampleDates))
    }
}


enum FaceState {
    case noFace
    case down
    case middle
    case up
    
    var label : String {
        switch self {
        case .noFace:
            return "No Face"
        case .down:
            return "Down"
        case .middle:
            return "Middle"
        case .up:
            return "Up"
        }
    }
}

struct FaceDistance {
    let distance : Float
    let date : Date
    let isPushup : Bool
}

class FaceDistanceViewModel: ObservableObject {
    
    @Published var phoneOnFloor = false
        
    @Published var faceDistances: [FaceDistance] = []
    
    @Published var faceDistance : Float = 0
    
    @Published var faceState : FaceState = .noFace
    
    let thresholdPassed = PassthroughSubject<Void, Never>()
    
    private var lastDistance: Float = 0.0
        
    private let threshold: Float = 0.25

    
    
    var lastThresholdTime = Date.distantPast
    let debounceTimeSeconds : Double = 0.5
    
    private var stateHistory : [ (FaceState, Date) ] = []
    
    private func getStateForDistance( _ d : Float ) -> FaceState {
        
        // 0    - 0.22  down
        // 0.22 - 0.35  middle
        // 0.35 - 1     up
        
        if d < 0.22 {
            return .down
        } else if d < 0.35 {
            return .middle
        } else if d < 1.0 {
            return .up
        } else {
            return .noFace
        }
    }
    
    private func hasDonePushup() -> Bool {
        if self.stateHistory.count < 3 {
            return false
        } else {
            
            // an issue is you might be holding in 'up' for 5 seconds
            // and we only keep first .up, so the total duration is then > 5 seconds
            // but we need to only consider the last .up in the cycle
            // up....up , down, up
            let lastIdx = self.stateHistory.count - 1
            
            let (state0, d0) = self.stateHistory[lastIdx-2]
            let (state1, _) = self.stateHistory[lastIdx-1]
            let (state2, d2) = self.stateHistory[lastIdx  ]
            
            let duration = abs(d2.timeIntervalSince(d0))
            
            if state0 == .up, state1 == .down, state2 == .up, duration > 0.1, duration < 6.0 {
                return true
            } else {
                return false
            }
            
        }
        
        return false
        
    }
    
    func addNewDistance( _ newDistance : Float ) {
        
        let newState = self.getStateForDistance(newDistance)
        
        self.faceState = newState

        let prevState = stateHistory.last?.0 // nil or something different
        
        if newState != prevState && (newState != .noFace) && (newState != .middle) {
            
            stateHistory.append( (newState, Date()) )
            
            if stateHistory.count > 5 {
                stateHistory.removeFirst()
            }
            
        } else if prevState == .up && newState == .up {
            // update the time?
            //var updated = stateHistory.last!
            let updated : (FaceState, Date) = (.up, Date())
            stateHistory[stateHistory.count-1] = updated
        }
        
        
        // --- Track distances for graph --- //
        if faceDistances.count >= 150 {
            faceDistances.removeFirst()
        }
                
        var isPushup = false
        
        self.faceDistance = newDistance
        
        if self.hasDonePushup() {
            
            // clear history
            self.stateHistory.removeAll()
            thresholdPassed.send()
                    
            isPushup = true
        }
        
        faceDistances.append( .init(distance: newDistance, 
                                    date: Date(), isPushup: isPushup) )
                
    }
    
}

struct LineGraph: View {
    
    var data: [FaceDistance]
    
    private let strokeColor: Color = .blue
    private let lineWidth: CGFloat = 6
    
    //private var frameIndex = 0
    let minDist: Float = 0.12
    //let maxDist: Float = 0.5
    let maxDist: Float = 0.6
    
    func getPushupsPath(from data: [FaceDistance],
                           in geometry: GeometryProxy) -> Path {
        
        var path = Path()

        for (index, info) in data.enumerated() {
            
            let value = info.distance
            //let date = info.date
            
            if !info.isPushup {
                continue
            }
            
            let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index)
            

            var val: Float = abs(value)
            val = (val - minDist) / (maxDist - minDist)
            val = min(max(val, 0.0), 1.0)
            val -= 0.5
            val *= Float(geometry.size.height * 0.9)
            
            let yPosition = geometry.size.height / 2 + CGFloat(val)

            path.move(to: CGPoint(x: xPosition, y: yPosition))
            
            let r : CGFloat = 6
            
            let rect = CGRect(origin: .init(x: xPosition - r*0.5, y: yPosition-r*0.5 ), size: .init(width: r, height: r))
            
            path.addEllipse(in: rect )
            //path.addRoundedRect(in: <#T##CGRect#> )
            
            path.move(to: CGPoint(x: xPosition, y: yPosition))
            path.addLine(to: CGPoint(x: xPosition, y: geometry.size.height))
            
            
        }
        
        return path
    }
    
    func createPath(from data: [FaceDistance], in geometry: GeometryProxy, closePath: Bool) -> Path {
        
        var path = Path()

        for (index, info) in data.enumerated() {
            
            let value = info.distance
            //let date = info.date
            
            let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index)
            
            var val: Float = abs(value)
            val = (val - minDist) / (maxDist - minDist)
            val = min(max(val, 0.0), 1.0)
            val -= 0.5
            val *= Float(geometry.size.height * 0.9)
            
            let yPosition = geometry.size.height / 2 + CGFloat(val)

            if index == 0 {
                path.move(to: CGPoint(x: xPosition, y: yPosition))
            } else {
                path.addLine(to: CGPoint(x: xPosition, y: yPosition))
            }
            
            if index == data.count - 1 {
                path.addLine(to: CGPoint(x: geometry.size.width, y: yPosition))
            }
            
        }
        
        
        
        if closePath {
            path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
            path.addLine(to: CGPoint(x: 0, y: geometry.size.height))
            path.closeSubpath()
        }

        return path
    }
    
    
    var body: some View {
        
        GeometryReader { geometry in
            
            // Using the path in your view
            ZStack {
                
                createPath(from: data, in: geometry, closePath: true)
                    .fill(LinearGradient(gradient: Gradient(colors: [Color(UIColor.systemBackground).opacity(0.7), Color(UIColor.systemBackground).opacity(0.5)]), startPoint: .top, endPoint: .bottom))

                
                createPath(from: data, in: geometry, closePath: true)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.75), Color.blue.opacity(0.0)]), startPoint: .top, endPoint: .bottom))

                // Pushup Strokes
                //let dashPattern: [CGFloat] = [10, 14]

                
                    //.stroke(.orange, lineWidth: lineWidth)
                
                // Graph Stroke
                createPath(from: data, in: geometry, closePath: false)
                    .stroke(strokeColor, lineWidth: lineWidth)
                
                getPushupsPath(from: data, in: geometry)
                    .stroke(.pink, lineWidth: lineWidth)
                    .shadow(radius: 5)
                
//                    .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round, miterLimit: 0, dash: dashPattern))
//                        .foregroundColor(.pink)
                
            }
            
            
            
        }
        
        
    }
}


class ARKitViewController: UIViewController,
                            ARSCNViewDelegate,
                            ARSessionDelegate
{
    var sceneView: ARSCNView!
    
    var faceDistanceViewModel: FaceDistanceViewModel?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize ARSCNView
        sceneView = ARSCNView(frame: view.bounds)
        view.addSubview(sceneView)
        
        self.view.backgroundColor = UIColor.systemBackground
        self.sceneView.backgroundColor = UIColor.systemBackground
        
        //sceneView.frame = .init(x: 0, y: 0, width: 1, height: 0)
        //sceneView.frame = .init(x: 0, y: 0, width: 70, height: 90)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Set the session's delegate
        
        sceneView.session.delegate = self
        sceneView.preferredFramesPerSecond = 30
        
        // Create a new ARFaceTrackingConfiguration
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = false
        configuration.isWorldTrackingEnabled = false
        configuration.maximumNumberOfTrackedFaces = 0
        //configuration.frameSemantics = .sceneDepth
        
        // Run the session with the configuration
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
    
    }

    override func viewDidLayoutSubviews() {
        sceneView.frame = self.view.bounds
    }
    
    private var averageVector : simd_float3 = .one
    private var prevAverageVector : simd_float3 = .zero
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        
        let mat = frame.camera.transform
        let z_col : simd_float4 = mat.columns.2
        
        let z_vec : simd_float3 = .init(x: z_col.x, y: z_col.y, z: z_col.z)
        
        averageVector = averageVector - (averageVector - z_vec) * 0.075
        
        let vecDiff : Float = simd_length( prevAverageVector - averageVector )
        
        prevAverageVector = averageVector
        
        let worldUp : simd_float3 = .init(x: 0, y: -1, z: 0)
        
        let gravity_diff = simd_length(averageVector - worldUp)
                
        let isPhoneOnFloor = (gravity_diff < 0.15) && (vecDiff < 0.0002 )
        
        var avgDepth : Float = 0
        var validPixels : Float = 0
        var hasDepth = false
        
        if let d = frame.capturedDepthData,
           isPhoneOnFloor {
            
            // Only compute average when phone is stationary on floor
            
            assert(d.depthDataType == kCVPixelFormatType_DepthFloat32)
            
            let depthBuffer = d.depthDataMap
            
            avgDepth = DepthChecker.getAverageOfPixels(inRange: depthBuffer, 
                                                       minDepth: 0.05,
                                                       maxDepth: 0.85,
                                                       validPixels: &validPixels )
            
            hasDepth = validPixels > 6_000
            
        }
        
//        if hasDepth {
//            print( String(format: "grav diff %.2f   diff:  %.3f    Z: %.2f     valid:  %.0f ",
//                          gravity_diff, vecDiff , avgDepth, validPixels ))
//        }
        
        DispatchQueue.main.async {
            self.faceDistanceViewModel?.phoneOnFloor = isPhoneOnFloor
            if isPhoneOnFloor && hasDepth {
                self.faceDistanceViewModel?.addNewDistance(avgDepth)
            }
        }
        
    }
    
    /*
     /// Face Anchor method -- not reliable
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        
        guard let faceAnchor = frame.anchors.first as? ARFaceAnchor else {
            DispatchQueue.main.async {
                //print(" no face? ")
                self.faceDistanceViewModel?.faceVisible = false
            }
            return
        }

        //let faceDistance = faceAnchor.transform.columns.3.z
        
        let v = faceAnchor.transform.columns.3
        
        let facePos : simd_float3 = .init(x: v.x, y: v.y, z: v.z)
        
        let faceDistance = simd_length(facePos)
        
        DispatchQueue.main.async {
            
            self.faceDistanceViewModel?.faceVisible = faceAnchor.isTracked
            if faceAnchor.isTracked {
                self.faceDistanceViewModel?.addNewDistance(faceDistance)
            }
        }
        
    }
    */
    
    
}

struct ARKitView: UIViewControllerRepresentable {
    
    
    @ObservedObject var viewModel: FaceDistanceViewModel

    func makeUIViewController(context: Context) -> ARKitViewController {
        
        let viewController = ARKitViewController()
        
        viewController.faceDistanceViewModel = viewModel
        return viewController
    }

    func updateUIViewController(_ uiViewController: ARKitViewController, 
                                context: Context) {
        
    }
}


struct CounterView: View {
    
    @Binding var counter: Int
    @Binding var showingHelp : Bool
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            ZStack {
                
                Text("Pushup Count")
                    .font(.system(size: 22, weight: .semibold, design: .monospaced))
                    //.padding(.top, 8)
                    .foregroundColor(.secondary)
                
                HStack {
                    Spacer()
                    Button {
                        self.showingHelp = true
                    } label: {
                        VStack {
                            //Image(systemName: "questionmark.circle.fill")
                            Text("Help")
                                .padding(.horizontal, 10)
                                //.background(Color.gray)
                                //.underline()
                            //Image(systemName: "questionmark.circle.fill")
                        }
                    }

                    
                }
                
            }
            .padding(.vertical, 7)
            
            
            HStack(spacing: 0) {
                
                
                
                Button(action: {
                    if counter > 0 {
                        counter -= 1
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .resizable()
                        .frame(width: 64, height: 64)
                    
                        .overlay(Circle()
                                        .stroke(Color(UIColor.secondarySystemBackground), lineWidth: 2)
                                        .background(Circle().fill(Color.pink))
                                        //.fill(Color.red)
                                        .frame(width: 24, height: 24)
                                        .overlay(
                                            Text("1")
                                                .font(.system(size: 13, weight: .heavy, design: .rounded))
                                                .foregroundColor(Color(UIColor.secondarySystemBackground))
                                        ),
                                    alignment: .bottomTrailing
                                )
                    
                }
                .foregroundColor(.pink)
                .padding(.leading, 4)
                
                Spacer()
                
                Text("\(counter)")

                    .font(.system(size: 90, weight: .heavy, design: .monospaced))
                    .padding(2)
                
                Spacer()
                
                Button(action: {
                    counter += 10
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 64, height: 64)
                    
                        .overlay(Circle()
                                        .stroke(Color(UIColor.secondarySystemBackground), lineWidth: 2)
                                        .background(Circle().fill(Color.teal))
                                        //.fill(Color.red)
                                 
                                        .frame(width: 24, height: 24)
                                        .overlay(
                                            Text("10")
                                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                                .foregroundColor( Color(UIColor.secondarySystemBackground))
                                        ),
                                            //.position(x:48, y: 46)
                                    alignment: .bottomTrailing
                                )
                    
                }
                .foregroundColor(.teal)
                .padding(.trailing, 4)
                
            }
            //.font(.system(size: 100))
            
        }
        
    }
    
}


// MARK: -

struct PushupCounterView: View {
    
    @AppStorage("counter") var counter: Int = 0
            
    @State var faceTrackingEnabled : Bool = false
    
    @State var showingHelp = false
    @AppStorage("hasSeenHelp") var hasSeenHelp : Bool = false
    
    @StateObject private var viewModel = FaceDistanceViewModel()
    
    @State private var completedDates: Set<DateComponents> = {
        if let data = UserDefaults.standard.data(forKey: "completedDates"),
           let savedDates = try? JSONDecoder().decode(Set<DateComponents>.self, from: data) {
            return savedDates
        } else {
            return []
        }
    }()
    
    private var today: Date {
        Calendar.current.startOfDay(for: Date())
    }
    
    private var todayComponents : DateComponents {
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        return components

    }
    
    private var isTodayDone : Bool {
        return completedDates.contains(todayComponents)
    }
    
    private func removeToday() {
        
        completedDates.remove(todayComponents)
        saveDatesToDisk()
    }
    
    private func addToday() {
       
        completedDates.insert(todayComponents)
        saveDatesToDisk()
        
    }
    
    private func saveDatesToDisk() {
        if let data = try? JSONEncoder().encode(completedDates) {
            UserDefaults.standard.set(data, forKey: "completedDates")
        }
    }

    
    
    // MARK: - View Components
    @ViewBuilder var faceTrackingSectionPortrait : some View {
        
        VStack {
            
            Toggle(isOn: $faceTrackingEnabled, label: {
                
                HStack {
                    Image(systemName: "sparkles")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.yellow)
                    
                    Text("Auto Counter")
                        .monospaced()
                        .bold()
                    
                    Text("- Camera")
                        .monospaced()
                        .foregroundColor(.secondary)
                        
                    
                }
                
                    
            })
            .padding(4)
            
            if faceTrackingEnabled {
                
                ZStack {

                    LineGraph(data: viewModel.faceDistances)
                        .frame(height: 70)
                        .cornerRadius(8)
                        .opacity(viewModel.phoneOnFloor ? 1.0 : 0.4)
                        .padding(2)
                    
                    
                    if viewModel.phoneOnFloor {
                        
                        VStack {
                            
                            Spacer()
                            
                            HStack {
                                Spacer().frame(width:8)
                                Text(String(format: "%.2f", viewModel.faceDistance ))
                                    .font(Font.system(size: 12, weight: .semibold, design: .monospaced))
                                    .foregroundColor( .blue )
                                    .padding(4)
                                
                                Text(viewModel.faceState.label)
                                    .font(Font.system(size: 12, weight: .semibold, design: .monospaced))
                                    .foregroundColor( .blue )
                                    .padding(4)
                                
                                Spacer()
                            }
                            
                        }.frame(height: 50)
                        
                    } else {
                        
                        VStack {
                            Spacer()
                            HStack(spacing: 0) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .resizable()
                                    .frame(width: 22, height: 18)
                                    .foregroundColor(.white)
                                    .padding(.leading, 14)
                                
                                
                                Text("Place Phone Flat on Floor")
                                    .bold()
                                    .foregroundColor( .white )
                                    .padding(.horizontal)
                            }
                            Spacer()
                        }
                        .frame(maxHeight: 44)
                        .background(Color.orange.opacity(0.88))
                        .cornerRadius(12)
                        
                        
                    }
                    
                    
                }
            }
            
        }
        
        
    }
    
    @ViewBuilder var actionsView : some View {
        
        HStack {
            
            Button(action: {
                counter = 0
            }, label: {
                Text("Reset Count")
                    .padding()
                    .foregroundColor(.red)
                    .bold()
                    
                    .background(Color(UIColor.tertiarySystemBackground))
                
                    .cornerRadius(18)
                    
                    
                
            })
            
            Spacer()
                //.frame(width: 20)
            
            
            if isTodayDone {
                
                Button(action: {
                    removeToday()
                }, label: {
                    
                    HStack {
                        //Image(systemName: "arrow.uturn.backward")
                        Image(systemName: "xmark")
                            .resizable().aspectRatio(contentMode: .fit)
                            .frame(height: 12)
                        
                        Text("Remove Today").bold()
                            .padding(.horizontal, 8)
                        //    Mark Today Done
                    }
                    .padding()
                    .background(Color(UIColor.tertiarySystemBackground))
                    .cornerRadius(18)
                    
                })
                
            } else {
                
                Button(action: {
                    addToday()
                }, label: {
                    
                    HStack {
                        Image(systemName: "checkmark")
                            .resizable().aspectRatio(contentMode: .fit)
                            .frame(height: 12)
                        
                        Text("Mark Today Done").bold()
                        
                    }
                    .padding()
                    .background(Color(UIColor.tertiarySystemBackground))
                    .cornerRadius(18)
                    
                })
                
            }
            
        }
        
    }
    
    @ViewBuilder var calendarView : some View {
        
        VStack(spacing: 3) {
            Text("\(completedDates.count) Days Completed")
                .font(.title2)
                .bold()
            
//            MultiDatePicker("Dates Available", selection: $completedDates)
//                .foregroundColor(.mint)
//                .fixedSize()
            
            CalendarView(selectedDates: $completedDates)
            
        }
    }
    
    @ViewBuilder var bgCameraViewPortrait : some View {
        
            
        ARKitView(viewModel: viewModel)
            
//            .overlay(
//                Rectangle()
//                    .foregroundColor(Color(UIColor.systemBackground).opacity(0.6))
//                    .blendMode(.overlay)
//            )
            
            .overlay(
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color(UIColor.secondarySystemBackground).opacity(1.0), Color(UIColor.secondarySystemBackground).opacity(0.5)]), startPoint: .top, endPoint: .bottom ))

            )
        
        .onReceive(viewModel.thresholdPassed) { _ in
            counter += 1
        }
    
        
    }
    
    @ViewBuilder var portraitView: some View {
        
        
        ScrollView {
            
            ZStack {
                
                if faceTrackingEnabled {
                    bgCameraViewPortrait
                }
                
                
                VStack(spacing: 22) {
                    
                    CounterView(counter: $counter, 
                                showingHelp: $showingHelp )
                    
                    faceTrackingSectionPortrait
                    
                    Divider()
                    
                    actionsView
                    
                    Divider() // .padding()
                        //.padding(.top, 10)
                    
                }
                .padding(.horizontal, 20)
                //.background( Color(UIColor.secondarySystemBackground) )
                
                
            }
            .background( Color(UIColor.secondarySystemBackground) )
            
            calendarView
                .padding(.top, 20)
                
            
        }
        
        
        
        
    }
    
    @ViewBuilder func landscapeView(size: CGSize) -> some View {
        
        
        
        HStack(spacing: 0) {
            
            
            // Left Column
            ZStack {
                
                if faceTrackingEnabled {
                    
                    ARKitView(viewModel: viewModel)
                        .overlay(
                            Rectangle()
                                .foregroundColor(Color(UIColor.systemBackground).opacity(0.5))
                                .blendMode(.overlay)
                        )
                        
                        .overlay(
                            Rectangle()
                                .fill(LinearGradient(gradient: Gradient(colors: [Color(UIColor.systemBackground).opacity(1), Color(UIColor.systemBackground).opacity(0.0)]), startPoint: .top, endPoint: .center ))

                        )
                    
                    .onReceive(viewModel.thresholdPassed) { _ in
                        counter += 1
                    }
                }
                
                VStack {
                    
                    VStack(spacing: 14) {
                        
                        HStack {
                            
                            Image(systemName: "sparkles")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.yellow)
                            
                            Text("Auto Counter")
                                .font(.system(size: 27, weight: .semibold, design: .monospaced))
                            
                        }
                        .padding(.top, 8)
                        .foregroundColor(.secondary)

                        
                        
                        Toggle(isOn: $faceTrackingEnabled, label: {
                            Text("Enable Auto Counter")
                        }).padding(.horizontal, 30)
                        
                        
                        
                        if !faceTrackingEnabled {
                            
                            Text("Use the front facing camera to auto count pushups")
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 4)
                            
                        } else {
                            
                            if !viewModel.phoneOnFloor {
                                
                                HStack {
                                    
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .resizable()
                                        .frame(width: 26, height: 22)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 6)
                                    
                                    Text("Place the phone on the floor\nwith the screen facing up")
                                        .bold()
                                        .lineLimit(2, reservesSpace: true)
                                        .foregroundColor(.white)
                                        //.padding(.horizontal, 20)
                                        .padding(4)
                                        //.frame(minHeight: 50)
                                }
                                .padding(10)
                                .background(Color.orange.opacity(0.9))
                                .cornerRadius(20)
                                .padding(.top, 44)
                            }
                        }
                        
                        
                    }
                    .padding(.horizontal, 17)
                    
                    Spacer()
                    
                    if faceTrackingEnabled {
                        
                        
                        
                        ZStack {
                            
                            LineGraph(data: viewModel.faceDistances)
                                .frame(maxHeight: 182)
                                .opacity(viewModel.phoneOnFloor ? 1.0 : 0.4)
                                                        
                            
                            VStack(spacing: 0) {
                                
                                Spacer()
                                
                                HStack {
                                    
                                    
                                    Spacer()
                                            
                                    Text(String(format: "Distance: %4.2f", viewModel.faceDistance ))
                                        .font(Font.system(size: 13, weight: .semibold, design: .monospaced))
                                        //.foregroundColor( .indigo)
                                        .padding(4)
                                    
                                    Text(viewModel.faceState.label)
                                        .font(Font.system(size: 13, weight: .semibold, design: .monospaced))
                                        .multilineTextAlignment(.leading)
                                        .padding(4)
                                        .frame(width: 66)
                                    
                                    Spacer()
                                    
                                }
                                .foregroundColor( .blue )
                                .padding()
                                
                            }
                            .frame(maxHeight: 182)
                            
                            
                        }
                        
                    }
                    
                } // end V
                
                
                
            } // end Z
            
            Divider()
                
            // Right Column
            
            ScrollView {
                
                VStack(spacing: 14) {
                    
                    CounterView(counter: $counter,
                                showingHelp: $showingHelp )

                    actionsView
                    
                }
                .padding(.horizontal, 30)
                
                Divider().padding(12)
                
                calendarView
                
            } // end scroll
            .frame(width: size.width * 0.61)
            .background( Color(UIColor.secondarySystemBackground) )
            
            
        }
        
            
            
        
        
    }
    
    
    // MARK: - Body
    
    var body: some View {
        
        Group {
            
            GeometryReader { reader in
                
                if reader.size.width > reader.size.height {
                    
                    // TODO: fix up the safe area BS
                    landscapeView(size: reader.size)
                        .edgesIgnoringSafeArea(.all)
                    
                } else {
                    
                    ZStack {
                        
                        // hack to add some fill above the safe area
                        // in portrait -- sure there's a better way
                        VStack {
                            Rectangle().fill(Color(UIColor.secondarySystemBackground))
                            .frame(maxHeight: 200)
                            Spacer()
                        }
                        .edgesIgnoringSafeArea(.top)
                        
                        portraitView
                        
                        
                    }
                    
                    
                }
                
            } // end GeometryReader
            
        } // end Group
        
        .onChange(of: faceTrackingEnabled) { newValue in
            
            UIApplication.shared.isIdleTimerDisabled = newValue
        }
        
        .fullScreenCover(isPresented: self.$showingHelp)
        {
            PushupAppHelpView(showingHelp: self.$showingHelp)
        }
        .onAppear {
            
            if !self.hasSeenHelp && self.completedDates.count == 0 {
            //if !self.hasSeenHelp {
            //if true {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.hasSeenHelp = true
                    self.showingHelp = true
                }
            }
            
        }
        
    }
    
    
}

#Preview {
    PushupCounterView()
        
}
