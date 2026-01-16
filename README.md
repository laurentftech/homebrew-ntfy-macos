# Homebrew Tap for ntfy-macos

This is a [Homebrew](https://brew.sh) tap for [ntfy-macos](https://github.com/laurentftech/ntfy-macos), a native macOS CLI notifier and automation agent for [ntfy](https://ntfy.sh).

## Installation

```bash
brew tap laurentftech/ntfy-macos
brew install ntfy-macos
```

Or install directly:

```bash
brew install laurentftech/ntfy-macos/ntfy-macos
```

## Usage

After installation, initialize the configuration:

```bash
ntfy-macos init
```

Edit the configuration file at `~/.config/ntfy-macos/config.yml`, then start the service:

```bash
ntfy-macos serve
```

For more information, see the [ntfy-macos documentation](https://github.com/laurentftech/ntfy-macos).
