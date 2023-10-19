import ArgumentParser

struct Command: ParsableCommand {
    @Flag(name: .shortAndLong, help: "Enable debug mode.")
    var debug = false
    
    @Option(name: .shortAndLong, help: "Exit after a specified number of seconds.")
    var timer: Int?
    
    func run() throws {
        let eventHandler = EventHandler(debug: debug)
        eventHandler.scheduleTimer(duration: timer)
        eventHandler.run()
    }
}
