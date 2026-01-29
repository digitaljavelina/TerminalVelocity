import SwiftUI

struct ContentView: View {
    @State private var input = ""
    @State private var logs: [LogEntry] = []
    @State private var targetCommand = "sudo hack_mainframe"
    @State private var score = 0
    @State private var timeLeft = 30.0
    @State private var isGameOver = false
    @State private var gameStarted = false
    @State private var backgroundRotation = 0.0
    
    let commands = [
        "sudo apt-get install firewall-bypass",
        "rm -rf /trace/logs",
        "ping 192.168.1.1",
        "ssh root@mainframe",
        "chmod 777 exploit.sh",
        "grep -r 'password' /etc/shadow",
        "nmap -sV -p- 10.0.0.1",
        "git push origin master --force",
        "docker-compose up -d --build",
        "kubectl logs -f pod-123"
    ]
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    struct LogEntry: Identifiable {
        let id = UUID()
        let text: String
        let color: Color
    }
    
    var body: some View {
        ZStack {
            // Liquid Background
            GeometryReader { proxy in
                ZStack {
                    Color.black
                    
                    // Animated blobs
                    ForEach(0...2, id: \.self) { i in
                        Circle()
                            .fill(Color.green.opacity(0.4))
                            .frame(width: 300, height: 300)
                            .blur(radius: 60)
                            .offset(
                                x: CGFloat(i * 100) * cos(backgroundRotation + Double(i)),
                                y: CGFloat(i * 80) * sin(backgroundRotation * 0.8 + Double(i))
                            )
                    }
                    
                    // Deep liquid overlay
                    LinearGradient(
                        colors: [.black.opacity(0.8), .clear, .black.opacity(0.8)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
                .onAppear {
                    withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                        backgroundRotation = 360
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            // Glass Pane
            VStack(alignment: .leading, spacing: 10) {
                // Header
                HStack {
                    Text("TERMINAL_VELOCITY")
                        .foregroundColor(.green)
                        .font(.system(.headline, design: .monospaced))
                        .shadow(color: .green, radius: 5)
                    Spacer()
                    Text("SCORE: \(score)")
                        .foregroundColor(.green)
                        .font(.system(.headline, design: .monospaced))
                }
                .padding(.bottom, 5)
                
                // Terminal Output Area (Glass)
                ScrollView {
                    VStack(alignment: .leading, spacing: 5) {
                        ForEach(logs) { log in
                            Text(log.text)
                                .foregroundColor(log.color)
                                .font(.system(.caption, design: .monospaced))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .shadow(color: log.color.opacity(0.5), radius: 2)
                        }
                    }
                    .rotationEffect(Angle(degrees: 180))
                }
                .rotationEffect(Angle(degrees: 180))
                .padding()
                .background(.ultraThinMaterial) // Liquid Glass effect
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.green.opacity(0.3), lineWidth: 1)
                )
                
                // Active Game UI
                if !gameStarted {
                    startScreen
                } else if isGameOver {
                    gameOverScreen
                } else {
                    activeGameInterface
                }
            }
            .padding()
        }
        .onReceive(timer) { _ in
            if gameStarted && !isGameOver {
                if timeLeft > 0 {
                    timeLeft -= 0.1
                } else {
                    gameOver()
                }
            }
        }
    }
    
    var startScreen: some View {
        VStack(spacing: 20) {
            Text("INITIATE_HACK_SEQUENCE?")
                .foregroundColor(.green)
                .font(.system(.title2, design: .monospaced))
                .shadow(color: .green, radius: 8)
                .blinking()
            
            Button(action: startGame) {
                Text("> EXECUTE")
                    .font(.system(.headline, design: .monospaced))
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(8)
                    .shadow(color: .green.opacity(0.5), radius: 10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 100)
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(15)
    }
    
    var gameOverScreen: some View {
        VStack(spacing: 10) {
            Text("CONNECTION_TERMINATED")
                .foregroundColor(.red)
                .font(.system(.title, design: .monospaced))
                .shadow(color: .red, radius: 10)
            
            Text("SYSTEMS COMPROMISED: \(score)")
                .foregroundColor(.white)
                .font(.system(.headline, design: .monospaced))
            
            Button(action: startGame) {
                Text("> REBOOT_SYSTEM")
                    .font(.system(.headline, design: .monospaced))
                    .foregroundColor(.black)
                    .padding(10)
                    .background(Color.green)
                    .cornerRadius(5)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(15)
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.red, lineWidth: 1))
    }
    
    var activeGameInterface: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Access Level
            HStack {
                Text("ACCESS_LEVEL:")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.green.opacity(0.7))
                Text(accessLevel(score))
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.yellow)
                    .shadow(color: .yellow, radius: 3)
            }
            
            Text("TARGET_COMMAND:")
                .foregroundColor(.gray)
                .font(.system(.caption, design: .monospaced))
            
            Text(targetCommand)
                .foregroundColor(.white)
                .font(.system(.title3, design: .monospaced))
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.ultraThinMaterial)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.green.opacity(0.5), lineWidth: 1))
            
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: geometry.size.width, height: 6)
                        .opacity(0.2)
                        .foregroundColor(.green)
                    
                    Rectangle()
                        .frame(width: min(CGFloat(self.timeLeft / 30.0) * geometry.size.width, geometry.size.width), height: 6)
                        .foregroundColor(timeLeft < 5.0 ? .red : .green)
                        .shadow(color: timeLeft < 5.0 ? .red : .green, radius: 4)
                        .animation(.linear, value: timeLeft)
                }
            }
            .frame(height: 6)
            .cornerRadius(3)
            
            // Input Area
            HStack {
                Text(">")
                    .foregroundColor(.green)
                    .font(.system(.title3, design: .monospaced))
                TextField("", text: $input)
                    .foregroundColor(.green)
                    .font(.system(.body, design: .monospaced))
                    .accentColor(.green)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .onChange(of: input) { _ in checkInput() }
            }
            .padding(12)
            .background(.ultraThinMaterial)
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white.opacity(0.2), lineWidth: 1))
        }
    }
    
    func accessLevel(_ score: Int) -> String {
        switch score {
        case 0..<5: return "SCRIPT_KIDDIE"
        case 5..<10: return "GREY_HAT"
        case 10..<20: return "BLACK_HAT"
        case 20..<50: return "CYBER_WARLORD"
        default: return "ANONYMOUS_ENTITY"
        }
    }
    
    func startGame() {
        score = 0
        timeLeft = 30.0
        isGameOver = false
        gameStarted = true
        logs.removeAll()
        addLog("ESTABLISHING_SECURE_CONNECTION...", .yellow)
        nextCommand()
    }
    
    func nextCommand() {
        if let newCmd = commands.randomElement() {
            targetCommand = newCmd
            input = ""
        }
    }
    
    func checkInput() {
        if input == targetCommand {
            score += 1
            timeLeft += 2.0 // Bonus time
            addLog("ACCESS_GRANTED: \(targetCommand)", .green)
            
            // "Hack the Planet" Easter Egg
            if score % 10 == 0 {
                addLog(">>> GLOBAL_BROADCAST: HACK THE PLANET! <<<", .purple)
                timeLeft += 5.0
            }
            
            nextCommand()
            
            // Haptic feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }
    
    func gameOver() {
        isGameOver = true
        addLog("FIREWALL_DETECTED_INTRUSION", .red)
        addLog("CONNECTION_LOST", .red)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    func addLog(_ text: String, _ color: Color) {
        let entry = LogEntry(text: "[\(Date().formatted(date: .omitted, time: .standard))] \(text)", color: color)
        logs.insert(entry, at: 0)
        if logs.count > 20 { logs.removeLast() }
    }
}

// Blinking Effect Modifier
struct Blinking: ViewModifier {
    @State private var isOn = false
    func body(content: Content) -> some View {
        content
            .opacity(isOn ? 1 : 0)
            .animation(Animation.easeOut(duration: 0.5).repeatForever(), value: isOn)
            .onAppear { isOn = true }
    }
}

extension View {
    func blinking() -> some View {
        modifier(Blinking())
    }
}
