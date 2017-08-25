# eh

Bring some Canadian charm into your terminal, eh?

```
$ ls
🇨🇦  🍁  Sorry. Try again, eh? 🍁  🇨🇦

	Usage: ls [args] eh
$ ls eh
Azure        bacongobbler deis         kubernetes
```

## Installing

Releases are available for most platforms.

Windows amd64:
MacOS amd64:
Linux amd64:
Linux i386:
Linux ARM:

You can also build this project from source with `go get`.

```
$ go get github.com/bacongobbler/cmd/eh
```

## Usage

eh works by "pretending" to be a binary, then executing the real binary by stripping out "eh" from the argument list. It replaces PATH with PATH_EH so it can find commands in your path without finding itself.

Once you have the binary from the release, go ahead and move it into a temporary directory, replacing the name of a common command with the eh binary:

```
$ mkdir -p /tmp/eh/bin
$ mv eh /tmp/eh/bin/sleep
$ export PATH_EH=$PATH
$ export PATH=/tmp/eh/bin:$PATH_EH
$ sleep 1 eh
```
