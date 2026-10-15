# Testing the Windows fix on the laptop (Zebra)

1. Copy `windows-build.ps1` to the laptop (or download it from this folder).
2. Open PowerShell and run:

       Set-ExecutionPolicy -Scope Process Bypass
       .\windows-build.ps1

   The first run installs Git, Rust and the Visual Studio Build Tools (C++ workload) through
   winget and asks for admin approval, then clones the `test/windows-build` branch of
   https://github.com/MaxFairwinds/pdfcraft and builds it. That branch is the two pdfcraft patches
   plus one commit that points at the patched craft-print on https://github.com/MaxFairwinds/craft-libs
   (test only; upstream will get the merged pin instead). Budget 30 to 60 minutes the first time.
3. When the app opens (title and Help > About say `printerpapers`): File > Print, choose the
   Zebra, open Paper. After the standard sizes and a separator, the driver's own sizes should be
   listed with their dimensions, including any size added in the Zebra's Printing Preferences.
4. Choose the label size that is loaded, Size > Actual size (or Fit), Print. Before the fix the
   same job was refused with "... has no X × Y inch paper".
5. Optional, worth attaching to the PR: in the clone, `cargo test -p pdfcraft-print` and, in a
   clone of craft-libs on branch `feat/printer-papers`, `cargo test -p craft-print`. The craft-print
   test `printer_papers_come_from_the_drivers_capabilities` uses "Microsoft Print to PDF".

If the build fails, send me the last 40 lines of the output.
