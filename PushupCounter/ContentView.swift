//
//  ContentView.swift
//  PushupCounter
//
//  Created by CC Laan on 10/14/23.
//

import SwiftUI
import Combine
//import SwiftData
import ARKit
import SceneKit


/*
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
*/


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

class FaceDistanceViewModel: ObservableObject {
    
    @Published var phoneOnFloor = false
    
    //@Published var faceVisible = false
    
    @Published var faceDistances: [Float] = []
    
    @Published var faceDistance : Float = 0
    
    @Published var faceState : FaceState = .noFace
    
    let thresholdPassed = PassthroughSubject<Void, Never>()
    
    private var lastDistance: Float = 0.0
    
    //private let threshold: Float = -0.25
    private let threshold: Float = 0.25

    //private var timer: Timer?
    
    init() {
        
//        timer = Timer.scheduledTimer(withTimeInterval: 1/30.0, repeats: true) { [weak self] _ in
//            self?.updateDistance()
//        }
        
    }
    
    
    
//    // Old version
//    var lastThresholdTime = Date.distantPast
//    let debounceTimeSeconds : Double = 0.5
//    func addNewDistance( _ newDistance : Float ) {
//        
//        if faceDistances.count >= 150 {
//            faceDistances.removeFirst()
//        }
//        
//        faceDistances.append(newDistance)
//        
//        self.faceDistance = newDistance
//                
//        if (lastDistance >= threshold && newDistance < threshold) &&
//            ( abs(lastThresholdTime.timeIntervalSinceNow) > debounceTimeSeconds ) {
//            thresholdPassed.send()
//            lastThresholdTime = Date()
//        }
//        
//        lastDistance = newDistance
//        
//    }
    
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
        
        faceDistances.append(newDistance)
        // -------------------------------   //
        
        
        self.faceDistance = newDistance
        
        if self.hasDonePushup() {
            // clear history
            self.stateHistory.removeAll()
            thresholdPassed.send()
        }
        
//        if (lastDistance >= threshold && newDistance < threshold) &&
//            ( abs(lastThresholdTime.timeIntervalSinceNow) > debounceTimeSeconds ) {
//            thresholdPassed.send()
//            lastThresholdTime = Date()
//        }
//        
//        lastDistance = newDistance
        
    }
    
}

struct LineGraph: View {
    
    var data: [Float]
    
    private let strokeColor: Color = .blue
    private let lineWidth: CGFloat = 1
    
    //private var frameIndex = 0
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                
                for (index, value) in data.enumerated() {
                    
                    let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index)
                    
                    // -0.1 -> -0.6 max
                    // values are 0 -> -1.0 ish
                    let minDist : Float = 0.17
                    let maxDist : Float = 0.65
                    
                    var val : Float = abs(value) // face dist is negative
                    val = (val - minDist) / (maxDist - minDist)
                    val = min(max(val,0.0), 1.0)
                    
                    //val = lerp(val, 0.1, 0.7) *
                    val -= 0.5 // -0.5:0.5
                    val *= Float(geometry.size.height * 0.9)
                    
                    //let yPosition = geometry.size.height / 2 + CGFloat(value * 100)
                    let yPosition = geometry.size.height / 2 + CGFloat( val )

                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    } else {
                        path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                    }
                }
            }
            .stroke(strokeColor, lineWidth: lineWidth)
        }
        .background(Color.gray.opacity(0.13))
    }
}


class ARKitViewController: UIViewController,
                            ARSCNViewDelegate,
                            ARSessionDelegate
{
    var sceneView: ARSCNView!
    //var onDistanceUpdate: ((Float) -> Void)?
    var faceDistanceViewModel: FaceDistanceViewModel?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize ARSCNView
        sceneView = ARSCNView(frame: view.bounds)
        view.addSubview(sceneView)
        
        sceneView.frame = .init(x: 0, y: 0, width: 1, height: 0)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Set the session's delegate
        
        sceneView.session.delegate = self
        sceneView.preferredFramesPerSecond = 5
        
        // Create a new ARFaceTrackingConfiguration
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = false
        configuration.isWorldTrackingEnabled = false
        configuration.maximumNumberOfTrackedFaces = 0
        //configuration.frameSemantics = .sceneDepth
        
        // Run the session with the configuration
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
    
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
        
//        if let d = frame.sceneDepth {
//            print("  ________-- depth?? ")
//        }
        
        
        
        
        let worldUp : simd_float3 = .init(x: 0, y: -1, z: 0)
        
        let gravity_diff = simd_length(averageVector - worldUp)
        
        //print(" grav diff: ", gravity_diff )
        
        
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
            
            hasDepth = validPixels > 7_000
            
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
        
        
//        DispatchQueue.main.async {
//            print("face: ", faceDistance )
//            self.onDistanceUpdate?(faceDistance)
//        }
        
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
    
    //@Binding var faceDistance: Float
    @ObservedObject var viewModel: FaceDistanceViewModel

    func makeUIViewController(context: Context) -> ARKitViewController {
        let viewController = ARKitViewController()
//        viewController.onDistanceUpdate = { distance in
//            self.faceDistance = distance
//        }
        viewController.faceDistanceViewModel = viewModel
        return viewController
    }

    func updateUIViewController(_ uiViewController: ARKitViewController, context: Context) {
        // Update the view controller if needed.
    }
}



struct PushupCounterView: View {
    
    @AppStorage("counter") var counter: Int = 0
    
    var counterSets : Int {
        return Int( counter / 10 )
    }
    
    //@State private var dates: Set<DateComponents> = []
    //@AppStorage("dates2") var dates2 : [Date] = []
    
    @State var faceTrackingEnabled : Bool = false
    
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
    
    private func addDay() {
       
        completedDates.insert(todayComponents)
        
        if let data = try? JSONEncoder().encode(completedDates) {
            UserDefaults.standard.set(data, forKey: "completedDates")
        }
    }

    
    //@State private var counter: Int = 0
    //@State private var faceDistance: Float = 0.0

    var body: some View {
        ScrollView {
            
            VStack(spacing: 14) {
                
                
                VStack {
                    
                    Text("PUSHUPS")
                        .font(.system(size: 38))
                        .padding(6)
                        .foregroundColor(.secondary)
                    
                    
                    Text("\(counter)")
                        .font(.system(size: 110))
                        .padding(6)
                    
                }
                
                VStack(spacing: 14) {
                    
                    HStack {
                        ForEach(0..<10) { step in
                            Circle().fill( step < counterSets ? Color.blue : Color.secondary.opacity(0.5) )
                                .frame(width: 12, height: 12)
                        }
                    }
                    
                    HStack {
                        ForEach(0..<10) { step in
                            Circle().fill( step < (counterSets-10) ? Color.blue : Color.secondary.opacity(0.5) )
                                .frame(width: 12, height: 12)
                        }
                    }
                }
                
                
                HStack(spacing: 100) {
                    Button(action: {
                        if counter > 0 {
                            counter -= 10
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                    }
                    
                    Button(action: {
                        counter += 10
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                    }
                }
                .font(.system(size: 100))
                .padding()
                
                // Face Tracking
                //Divider()
                
                VStack {
                    
                    Toggle(isOn: $faceTrackingEnabled, label: {
                        Text("Face Tracking")
                    })
                    .padding(4)
                    
                    if faceTrackingEnabled {
                        
                        ZStack {
                            
                            
                            
                            //Text("Distance: \(String(format: "%.2f", viewModel.faceDistance))")
                            //Text("Distance: \(viewModel.faceDistance)")
                            
                            if viewModel.phoneOnFloor {
                                
                                VStack {
                                    Spacer()
                                    HStack {
                                        
                                        Text(String(format: "%.2f", viewModel.faceDistance ))
                                            .font(Font.system(size: 12, weight: .semibold, design: .monospaced))
                                            .foregroundColor( .green )
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
                                    Text("Place Phone Flat on Floor")
                                        //.font(.footnote)
                                        .foregroundColor( .orange )
                                    Spacer()
                                }
                                .frame(height: 50)
                                
                                
                            }
                            
                            ARKitView(viewModel: viewModel)
                                .frame(width: 0, height: 0)
                            
                                .onReceive(viewModel.thresholdPassed) { _ in
                                    counter += 1
                                }
                            
                            LineGraph(data: viewModel.faceDistances)
                                            .frame(height: 60)
                                            .opacity(viewModel.phoneOnFloor ? 1.0 : 0.4)
                                            .padding(2)
                                                        
                            
                            
                        }
                    }
                    
                }
                //.padding(4)
                
                
                Divider()
                
                HStack {
                    
                    Button(action: {
                        counter = 0
                    }, label: {
                        Text("Reset Count")
                            .padding()
                            .foregroundColor(.red)
                            .background(Color.secondary.opacity(0.2))
                            .cornerRadius(18)
                        
                    })
                
                    Spacer()
                    
                    Button(action: {
                        addDay()
                    }, label: {
                        Text("Mark Today Done")
                            .padding()
                            .bold()
                            //.foregroundColor(.primary)
                            .background(Color.secondary.opacity(0.2))
                            .cornerRadius(18)
                        
                    })
                    
                }
                
            }
            .padding(.horizontal, 50)
            
            
            
            Divider().padding()
            
            Text("\(completedDates.count) Days Completed")
                .font(.title2)
                .bold()
                
                
            
            MultiDatePicker("Dates Available", selection: $completedDates)
                .foregroundColor(.mint)
                        .fixedSize()
                        
                        //.allowsHitTesting(/*@START_MENU_TOKEN@*/false/*@END_MENU_TOKEN@*/)
            
        } // end scroll
    }
}

#Preview {
    PushupCounterView()
        
}
