import Foundation
import CoreGraphics

enum KeyCode: CGKeyCode {
    case u = 0x20
}

class EventHandler {
    var debug: Bool
    var isLocked = true
    
    init(debug: Bool) {
        self.debug = debug
    }
    
    func debugLog(_ message: String) {
        if debug {
            print(message)
        }
    }
    
    func scheduleTimer(duration: Int?) {
        guard let duration = duration else { return }
        let timer = Timer(timeInterval: TimeInterval(duration),
                          repeats: false) { _ in
            let message = "Timer expired ⏱️\n"
            if let data = message.data(using: .utf8) {
                FileHandle.standardError.write(data)
            }
            
            CFRunLoopStop(CFRunLoopGetCurrent())
        }
        RunLoop.current.add(timer, forMode: .common)
    }


    func run() {
        setupEventTap() // Setup event tap to capture key events
        CFRunLoopRun()  // Start the run loop to handle events
    }
    
    private func setupEventTap() {
        let keyboardEvents = (1 << CGEventType.keyDown.rawValue) |
                             (1 << CGEventType.keyUp.rawValue)

        let mouseClickEvents = (1 << CGEventType.leftMouseDown.rawValue)  |
                               (1 << CGEventType.leftMouseUp.rawValue)    |
                               (1 << CGEventType.rightMouseDown.rawValue) |
                               (1 << CGEventType.rightMouseUp.rawValue)

        let mouseMotionEvents = (1 << CGEventType.mouseMoved.rawValue) |
                                (1 << CGEventType.scrollWheel.rawValue)

        let eventMask = CGEventMask(keyboardEvents | mouseClickEvents | mouseMotionEvents)

        guard let eventTap = CGEvent.tapCreate(
            tap: .cghidEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: eventMask,
            callback: globalKeyEventHandler,
            userInfo: UnsafeMutableRawPointer(Unmanaged
                .passUnretained(self)
                .toOpaque())
        ) else {
            fatalError("Failed to create event tap")
        }
        
        let runLoopSource = CFMachPortCreateRunLoopSource(
            kCFAllocatorDefault,
            eventTap,
            0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
    }
    
    func handleKeyEvent(
        proxy: CGEventTapProxy,
        type: CGEventType,
        event: CGEvent) -> Unmanaged<CGEvent>? {

        if type == .keyDown || type == .keyUp {
            let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
            let controlFlag = event.flags.contains(.maskControl)
            let eventType = type == .keyDown ? "pressed" : "released"

            debugLog("Key Code: \(keyCode),\t" +
                     "Control Flag: \(controlFlag),\t" +
                     "Event Type: (\(type.rawValue)) \(eventType)")

            if controlFlag && keyCode == KeyCode.u.rawValue && type == .keyDown {
                debugLog("Input devices unlocked")
                CFRunLoopStop(CFRunLoopGetCurrent())
            }
        } else {
            let eventType = switch type {
                case .leftMouseDown: "left pressed"
                case .leftMouseUp: "left released"
                case .rightMouseDown: "right pressed"
                case .rightMouseUp: "right released"
                case .mouseMoved: "moved"
                case .scrollWheel: "scrolled"
                default: "other"
            }
            debugLog("Mouse Event: (\(type.rawValue)) \(eventType)")
        }

        return isLocked ? nil : Unmanaged.passRetained(event)
    }
}

func globalKeyEventHandler(
    proxy: CGEventTapProxy,
    type: CGEventType,
    event: CGEvent,
    refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    guard let refcon = refcon else { return Unmanaged.passRetained(event) }
    let mySelf = Unmanaged<EventHandler>.fromOpaque(refcon).takeUnretainedValue()
    return mySelf.handleKeyEvent(proxy: proxy, type: type, event: event)
}
