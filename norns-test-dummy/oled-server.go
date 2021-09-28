// Simple http server to serve X Window screenshots.
package main

import (
  "bytes"
  "context"
  "flag"
  "fmt"
  "io"
  "net/http"
  "os/exec"
)

func main() {
  var windowName string
  var windowID string
	var port uint
  flag.StringVar(&windowName, "window-name", "", "X Window Name to display selected by name.")
  flag.StringVar(&windowID, "window-id", "", "X Window ID to display selected by name.")
  flag.UintVar(&port, "port", 8889, "Port to serve on.")
  flag.Parse()

  http.HandleFunc("/", screen(windowName, windowID))
  http.ListenAndServe(fmt.Sprintf(":%d", port), nil)
}

func screen(windowName, windowID string) http.HandlerFunc {
  return func(w http.ResponseWriter, req *http.Request) {
    err := displayToPNG(context.Background(), windowName, windowID, w)
    if  err != nil {
      http.Error(w, err.Error(), 500)
    }
  }
}

// displayToPNG uses xwd and convert to display a screenshot of the matron display.
func displayToPNG(ctx context.Context, windowName, windowID string, w io.Writer) error {
	// xwd needs -id or -name to run non-interactively.
  var capture *exec.Cmd
  if windowID != "" {
    capture = exec.CommandContext(ctx, "xwd", "-id", windowID, "-display", ":0")
  } else if windowName != "" {
    capture = exec.CommandContext(ctx, "xwd", "-name", windowName, "-display", ":0")
  } else {
    return fmt.Errorf("No windowName or windowID provided to server.")
  }
	// convert uses '-' to read from STDIN and write to STDOUT.
  convert := exec.CommandContext(ctx, "convert", "xwd:-", "png:-")

  pRead, pWrite := io.Pipe()
  var captureErr bytes.Buffer
  var convertErr bytes.Buffer

  capture.Stdout = pWrite
  capture.Stderr = &captureErr
  convert.Stdin = pRead
  convert.Stdout = w
  convert.Stderr = &convertErr

  // Start the commands
  if err := capture.Start(); err != nil {
    return err
  }
  if err := convert.Start(); err != nil {
    return err
  }
  if err := capture.Wait(); err != nil {
    if captureErr.Len() > 0 {
      return fmt.Errorf(captureErr.String())
    }
    return err
  }
  pWrite.Close()
  if captureErr.Len() > 0 {
    return fmt.Errorf(captureErr.String())
  }
  if err := convert.Wait(); err != nil {
    if convertErr.Len() > 0 {
      return fmt.Errorf(captureErr.String())
    }
    return err
  }
  if captureErr.Len() > 0 {
    return fmt.Errorf(captureErr.String())
  }

  return nil
}
