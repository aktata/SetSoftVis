# SetSoftVis

**SetSoftVis.ps1** 是一个 PowerShell 脚本，用于管理 Windows 系统中已安装软件的可见性。它提供了一个用户友好的界面，使用户可以在“控制面板”的“程序和功能”部分中切换软件的可见性。

## 功能

- **显示已安装的软件**：列出从系统注册表中的不同路径（包括 32 位和 64 位）读取的所有已安装软件。
- **切换软件可见性**：允许用户在控制面板中隐藏或显示软件。
- **日志记录**：将所有操作记录到日志文件中，并生成一份简洁的修改记录。
- **现代化用户界面**：使用 ASCII 艺术字和格式化表格，提供清晰和现代化的 UI。

## 安装

1. 下载或克隆此存储库到您的本地计算机。
   ```bash
   git clone https://github.com/aktata/SetSoftVis.git
   ```
2. 确保您的系统上安装了 **PowerShell 5.0** 或更高版本。

## 使用

### 运行脚本

1. **打开 PowerShell**：右键单击“开始”菜单，选择 **Windows PowerShell**（或 **Windows PowerShell (Admin)**，以管理员身份运行）。
2. **导航到脚本目录**：使用 `cd` 命令将目录更改为脚本保存的位置。
   ```powershell
   cd C:\path\to\SetSoftVis
   ```
3. **执行脚本**：
   ```powershell
   .\SetSoftVis.ps1
   ```

### 解决 PowerShell 执行权限问题

如果您遇到无法执行 `.ps1` 脚本的问题，请参考以下方法解决：

- **临时更改执行策略**：在当前会话中允许执行本地脚本：
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
   ```
- **使用批处理文件运行脚本**：创建一个 `.bat` 文件，内容如下：
   ```batch
   @echo off
   PowerShell -NoProfile -ExecutionPolicy Bypass -File "C:\path\to\SetSoftVis.ps1"
   pause
   ```
  双击该 `.bat` 文件即可运行脚本。

## 日志和记录

- **Log.txt**：包含脚本操作的完整日志。
- **ModRec.txt**：包含简洁的修改记录。

这些文件将保存在与脚本相同的目录中。

## 示例

```plaintext
Enter software number to toggle visibility (Enter 'Q' to quit):
```

输入软件编号后，脚本将执行相应操作，并显示：
```plaintext
✅ Software 'SoftwareName' is now hidden/visible.
```

### 退出脚本

输入 `Q` 后，脚本将退出并显示日志和记录文件的位置。

## 贡献

欢迎任何形式的贡献！如果您有改进建议或发现了 bug，请提交 [Issue](https://github.com/aktata/SetSoftVis/issues) 或创建 [Pull Request](https://github.com/aktata/SetSoftVis/pulls)。

## 许可证

此项目基于 [MIT 许可证](https://raw.githubusercontent.com/aktata/SetSoftVis/main/LICENSE) 开源。详情请参见 LICENSE 文件。

## 贡献者

- [Aktata](https://github.com/aktata) - 原始作者和维护者
