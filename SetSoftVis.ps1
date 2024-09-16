# 作者信息
# Author: Aktata
# Description: This script manages the visibility of installed software on a Windows system.

# 日志和修改记录文件路径
$logFilePath = "$PSScriptRoot\Log.txt"
$modificationFilePath = "$PSScriptRoot\ModRec.txt"

# 初始化日志文件和修改记录文件
"Log Start - $(Get-Date)" | Out-File -FilePath $logFilePath -Append
"Modification Record Start - $(Get-Date)" | Out-File -FilePath $modificationFilePath -Append

# 声明全局变量用于存储软件列表
$global:softwareList = @()

# 显示现代化软件列表函数
function Show-SoftwareList {
    Clear-Host  # 清理屏幕，保持界面整洁

    # 使用现代化的 ASCII 艺术字显示脚本标题
    Write-Host @"
  ______   ______   ______  ______     __   __ __   ______       __    __   ______   __   __   ______   ______   ______   ______    
 /\  ___\ /\  __ \ /\  ___\/\__  _\   /\ \ / //\ \ /\  ___\     /\ "-./  \ /\  __ \ /\ "-.\ \ /\  __ \ /\  ___\ /\  ___\ /\  == \   
 \ \___  \\ \ \/\ \\ \  __\\/_/\ \/   \ \ \'/ \ \ \\ \___  \    \ \ \-./\ \\ \  __ \\ \ \-.  \\ \  __ \\ \ \__ \\ \  __\ \ \  __<   
  \/\_____\\ \_____\\ \_\     \ \_\    \ \__|  \ \_\\/\_____\    \ \_\ \ \_\\ \_\ \_\\ \_\\"\_\\ \_\ \_\\ \_____\\ \_____\\ \_\ \_\ 
   \/_____/ \/_____/ \/_/      \/_/     \/_/    \/_/ \/_____/     \/_/  \/_/ \/_/\/_/ \/_/ \/_/ \/_/\/_/ \/_____/ \/_____/ \/_/ /_/   Script by Aktata
"@ -ForegroundColor Cyan

    $global:softwareList = @()  # 清空全局软件列表
    $index = 1  # 初始化索引

    # 定义需要遍历的注册表路径（分别对应64位、32位和用户特定软件）
    $registryPaths = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
    )

    # 遍历每个注册表路径以查找已安装的软件
    foreach ($path in $registryPaths) {
        try {
            # 记录访问的注册表路径
            "Accessing registry path: $path" | Out-File -FilePath $logFilePath -Append
            $items = Get-ItemProperty -Path $path\* 2> $null  # 获取注册表项属性

            if ($items) {  # 如果在该路径中找到了软件项
                foreach ($item in $items) {
                    $displayName = $item.DisplayName  # 软件名称
                    $displayVersion = $item.DisplayVersion  # 软件版本
                    $systemComponent = $item.SystemComponent  # 系统组件标识

                    # 检查软件是否有名称（DisplayName属性）
                    if ($displayName) {
                        # 确定软件是否被隐藏
                        $isHidden = if ($systemComponent -eq 1) { "Yes" } else { "No" }

                        # 将软件信息添加到全局列表
                        $global:softwareList += [PSCustomObject]@{
                            Idx = $index
                            Hid = $isHidden
                            Name = $displayName
                            Ver = $displayVersion
                            RegistryPath = $item.PSPath
                        }

                        $index++  # 增加索引以用于下一个软件项
                    }
                }
            }
        } catch {
            # 捕获错误并记录到日志文件
            "Cannot access registry path: $path - $_" | Out-File -FilePath $logFilePath -Append
        }
    }

    # 检查是否找到了任何软件
    if ($global:softwareList.Count -eq 0) {
        # 如果未找到任何软件，记录并输出信息
        "No software found." | Out-File -FilePath $logFilePath -Append
        Write-Host "⚠️  No software available." -ForegroundColor Red
    } else {
        # 按软件名称排序列表
        $global:softwareList = $global:softwareList | Sort-Object Name

        # 重新生成软件索引
        $index = 1
        $global:softwareList | ForEach-Object { $_.Idx = $index; $index++ }

        # 正确格式化输出表格
        Write-Host "───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
        $global:softwareList | Select-Object Idx, Hid, Name, Ver | Format-Table -AutoSize 
        Write-Host "───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    }
}

# 设置软件显示状态的函数
function Set-SoftwareVisibility {
    param (
        [Parameter(Mandatory = $true)]
        [int]$index  # 传入的软件编号
    )

    # 从全局列表中获取指定的软件项
    $software = $global:softwareList | Where-Object { $_.Idx -eq $index }

    if ($software) {
        $registryPath = $software.RegistryPath  # 获取软件的注册表路径
        $timestamp = Get-Date  # 获取当前时间戳

        # 根据当前状态设置可见性
        if ($software.Hid -eq "Yes") {
            # 当前状态为隐藏，执行取消隐藏操作
            Remove-ItemProperty -Path $registryPath -Name "SystemComponent" -ErrorAction SilentlyContinue
            $logEntry = "Unhidden: $($software.Name) ($($software.Ver)) at $registryPath on $timestamp"
            Write-Host "    ✅  Software '$($software.Name)' is now visible." -ForegroundColor Green
        }
        elseif ($software.Hid -eq "No") {
            # 当前状态为显示，执行隐藏操作
            Set-ItemProperty -Path $registryPath -Name "SystemComponent" -Value 1 -Force
            $logEntry = "Hidden: $($software.Name) ($($software.Ver)) at $registryPath on $timestamp"
            Write-Host "    ✅  Software '$($software.Name)' is now hidden." -ForegroundColor Yellow
        }

        # 如果状态发生变化，记录日志和修改记录
        if ($logEntry) {
            $logEntry | Out-File -FilePath $logFilePath -Append
            $logEntry | Out-File -FilePath $modificationFilePath -Append
        }
    } else {
        # 输入的索引无效
        Write-Host "    ❌ Invalid software number: $index" -ForegroundColor Red
        "Invalid software number: $index" | Out-File -FilePath $logFilePath -Append
    }

    # 操作完成后重新显示软件列表
    Show-SoftwareList
}

# 执行主程序
Show-SoftwareList

# 如果软件列表为空，则退出脚本
if ($global:softwareList.Count -eq 0) {
    exit
}

# 用户输入循环，允许用户选择要操作的软件
while ($true) {
    $choice = Read-Host "Enter software number to toggle visibility (Enter 'Q' to quit)"
    if ($choice -eq "Q") { 
        # 清屏并显示日志文件和作者信息
        Clear-Host
        Write-Host "───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────" -ForegroundColor Cyan
        Write-Host "    Operation Completed. Log and modification record files are located at:" -ForegroundColor Green
        Write-Host "    Log file: $logFilePath" -ForegroundColor Yellow
        Write-Host "    Modification record: $modificationFilePath" -ForegroundColor Yellow
        Write-Host "───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────" -ForegroundColor Cyan
        # 显示作者信息
        Write-Host "    Script by Aktata" -ForegroundColor Magenta
        break 
    }

    # 如果用户输入的是一个有效的数字
    if ($choice -match '^\d+$') {
        $index = [int]$choice

        # 验证用户输入的索引是否在范围内
        if ($index -ge 1 -and $index -le $global:softwareList.Count) {
            Set-SoftwareVisibility -index $index  # 设置软件的显示状态
            Write-Host "    ✅  Operation completed. Check the log file and modification record for details." -ForegroundColor Green
        } else {
            # 如果索引超出范围，显示提示信息
            Write-Host "    ❌ Invalid software number. Please enter a number between 1 and $($global:softwareList.Count)." -ForegroundColor Red
        }
    } else {
        # 如果输入不是有效的数字，显示错误信息
        Write-Host "    ❌ Invalid input. Please enter a valid software number." -ForegroundColor Red
    }
}
