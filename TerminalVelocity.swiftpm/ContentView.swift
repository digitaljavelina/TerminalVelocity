import SwiftUI

struct ContentView: View {
    @State private var input = ""
    @State private var logs: [LogEntry] = []
    @State private var targetCommand = "sudo hack_mainframe"
    @State private var score = 0
    @State private var timeLeft = 30.0
    @State private var isGameOver = false
    @State private var gameStarted = false
    
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
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 10) {
                // Header
                HStack {
                    Text("TERMINAL_VELOCITY v1.0")
                        .foregroundColor(.green)
                        .font(.system(.headline, design: .monospaced))
                    Spacer()
                    Text("SCORE: \(score)")
                        .foregroundColor(.green)
                        .font(.system(.headline, design: .monospaced))
                }
                .padding(.top)
                
                Divider().background(Color.green)
                
                // Terminal Output
                ScrollView {
                    VStack(alignment: .leading, spacing: 5) {
                        ForEach(logs) { log in
                            Text(log.text)
                                .foregroundColor(log.color)
                                .font(.system(.caption, design: .monospaced))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .rotationEffect(Angle(degrees: 180))
                }
                .rotationEffect(Angle(degrees: 180))
                
                Divider().background(Color.green)
                
                if !gameStarted {
                    VStack(spacing: 20) {
                        Text("INITIATE_HACK_SEQUENCE?")
                            .foregroundColor(.green)
                            .font(.system(.title2, design: .monospaced))
                            .blinking()
                        
                        Button(action: startGame) {
                            Text("> EXECUTE")
                                .font(.system(.headline, design: .monospaced))
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(8)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 100)
                } else if isGameOver {
                    VStack(spacing: 10) {
                        Text("CONNECTION_TERMINATED")
                            .foregroundColor(.red)
                            .font(.system(.title, design: .monospaced))
                        
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
                } else {
                    // Active Game
                    VStack(alignment: .leading, spacing: 8) {
                        Text("TARGET_COMMAND:")
                            .foregroundColor(.gray)
                            .font(.system(.caption, design: .monospaced))
                        
                        Text(targetCommand)
                            .foregroundColor(.white)
                            .font(.system(.title3, design: .monospaced))
                            .padding(8)
                            .background(Color.green.opacity(0.1))
                            .border(Color.green, width: 1)
                        
                        // Progress Bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .frame(width: geometry.size.width, height: 4)
                                    .opacity(0.3)
                                    .foregroundColor(.green)
                                
                                Rectangle()
                                    .frame(width: min(CGFloat(self.timeLeft / 30.0) * geometry.size.width, geometry.size.width), height: 4)
                                    .foregroundColor(timeLeft < 5.0 ? .red : .green)
                                    .animation(.linear, value: timeLeft)
                            }
                        }
                        .frame(height: 4)
                        
                        // Input Area
                        HStack {
                            Text(">")
                                .foregroundColor(.green)
                            TextField("", text: $input)
                                .foregroundColor(.green)
                                .font(.system(.body, design: .monospaced))
                                .accentColor(.green)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                                .onChange(of: input) { _ in checkInput() }
                        }
                        .padding(10)
                        .background(Color.gray.opacity(0.2))
                    }
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
