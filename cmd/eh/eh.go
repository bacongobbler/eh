package main

import (
	"fmt"
	"os"
	"os/exec"
	"syscall"
)

var usage = `🇨🇦  🍁  Sorry. Try again, eh? 🍁  🇨🇦

	Usage: %s [args] eh
`

func sorry(err error) {
	fmt.Printf("Sorry... %v\n", err)
	os.Exit(1)
}

func main() {
	realPath := os.Getenv("PATH_EH")
	if realPath == "" {
		fmt.Println("🇨🇦  🍁  Sorry. Set $PATH_EH, eh? 🍁  🇨🇦")
		os.Exit(1)
	}

	if len(os.Args) == 1 {
		fmt.Printf(usage, os.Args[0])
		os.Exit(1)
	}

	if os.Args[len(os.Args)-1] != "eh" {
		fmt.Printf(usage, os.Args[0])
		os.Exit(1)
	}

	os.Setenv("PATH", realPath)

	// strip out 'eh' from the arg list and exec the real process
	entrypoint := os.Args[0]
	realArgs := os.Args[:len(os.Args)-1]

	cmd, err := exec.LookPath(entrypoint)
	if err != nil {
		sorry(err)
	}

	if err := syscall.Exec(cmd, realArgs, os.Environ()); err != nil {
		sorry(err)
	}
}
