# Keylock

Keylock is another coffee-time project I undertook during a tranquil coffee break
at my favoured spot. It aims to fulfil a simple yet significant need—locking the
keyboard on a macOS system (tested on MacBook Pro M1 Pro devices) to ease the
cleaning process. Sometimes, a cleaning spree demands a pause on the keystrokes
to avoid any unintended inputs, and that's where keylock comes into play. Crafted
with Swift and harnessing the capabilities of macOS's native libraries, this
small utility seamlessly locks the keyboard until you decide it's time to bring
it back to action.

## Build and Execute

Building and executing keylock is straightforward. Given the Swift nature of the
project, you can utilise Swift's build system to manage the process. Here's how
you would do it:

```sh
$ swift build
$ swift run
```

A POSIX Makefile with an install target is also provided for convenience.
Without a target it would simply just run `swift build -c release`.

## Usage

On invocation, the keyboard will remain locked until the specified unlock
sequence is triggered. Not every key is locked, though; Brightness, Play/Pause,
Rewind, Fast Forward, Volume, and Caps Lock keys are not locked. Mouse movement
is also intact.

```sh
USAGE: command [--debug] [--timer <timer>]

OPTIONS:
  -d, --debug             Enable debug mode.
  -t, --timer <timer>     Exit after a specified number of seconds.
  -h, --help              Show help information.
```

**N.B.** The unlock sequence is **^U**.

## Design Notes

Keylock utilises the **Core Graphics** framework to tap into the keyboard
events. By creating an event tap, it intercepts keyDown and keyUp events,
effectively locking the keyboard. The heart of this functionality lies in
the [EventHandler.swift](Sources/EventHandler.swift) file, where the
**setupEventTap** and **handleKeyEvent** methods orchestrate the locking
and unlocking mechanism. The unlock sequence is triggered by a specific key
combination, hardcoded at the minute, **Control + U**, allowing a smooth
transition back to a functioning keyboard once your cleaning is done.

## Contributing

Discover an issue or see a pathway to enhancement? Or perhaps you have a query?
Feel free to open an issue or a pull request. Your engagement is always valued
and appreciated!

## License

Distributed under the MIT License. See [LICENSE](LICENSE) for more information.
