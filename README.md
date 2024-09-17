# SetSoftVis

[中文](https://github.com/aktata/SetSoftVis/blob/main/README-zh.md) | [English](https://github.com/aktata/SetSoftVis/blob/main/README.md)

**SetSoftVis.ps1** is a PowerShell script to manage the visibility of installed software on a Windows system. It provides a user-friendly interface that allows users to toggle the visibility of software in the "Programs and Features" section of the Control Panel.

## Features

- **Display Installed Software**: Lists all installed software from different registry paths (including 32-bit and 64-bit) on the system.
- **Toggle Software Visibility**: Allows users to hide or show software in the Control Panel.
- **Logging**: Records all operations performed in a log file and generates a concise modification record.
- **Modern User Interface**: Provides a clear and modern UI using ASCII art and formatted tables.

## Installation

1. Download or clone this repository to your local machine:
   ```bash
   git clone https://github.com/aktata/SetSoftVis.git
   ```
2. Ensure that **PowerShell 5.0** or higher is installed on your system.

## Usage

### Running the Script

1. **Open PowerShell**: Right-click the Start menu and select **Windows PowerShell** (or **Windows PowerShell (Admin)** to run as an administrator).
2. **Navigate to the script directory**: Use the `cd` command to change the directory to where the script is saved:
   ```powershell
   cd C:\path\to\SetSoftVis
   ```
3. **Execute the script**:
   ```powershell
   .\SetSoftVis.ps1
   ```

### Solving PowerShell Execution Policy Issues

If you encounter issues running `.ps1` scripts, try the following methods:

- **Temporarily change execution policy**: Allow local scripts to run in the current session:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
   ```
- **Run the script with a batch file**: Create a `.bat` file with the following content:
   ```batch
   @echo off
   PowerShell -NoProfile -ExecutionPolicy Bypass -File "C:\path\to\SetSoftVis.ps1"
   pause
   ```
  Double-click the `.bat` file to run the PowerShell script.

## Logs and Records

- **Log.txt**: Contains a complete log of script operations.
- **ModRec.txt**: Contains a concise modification record for easy reference.

These files will be saved in the same directory as the script.

## Example

```plaintext
Enter software number to toggle visibility (Enter 'Q' to quit):
```

After entering the software number, the script will perform the corresponding operation and display:
```plaintext
✅ Software 'SoftwareName' is now hidden/visible.
```

### Exiting the Script

Enter `Q` to exit the script:
```plaintext
Enter software number to toggle visibility (Enter 'Q' to quit): Q
```

The script will clear the screen and display the locations of the log and record files.

## Contributing

Contributions are welcome! If you have any suggestions or find any bugs, please submit an [Issue](https://github.com/aktata/SetSoftVis/issues) or create a [Pull Request](https://github.com/aktata/SetSoftVis/pulls).

## License

This project is open-sourced under the [MIT License](https://raw.githubusercontent.com/aktata/SetSoftVis/main/LICENSE). See the LICENSE file for details.

## Contributors

- [Aktata](https://github.com/aktata) - Original author and maintainer
