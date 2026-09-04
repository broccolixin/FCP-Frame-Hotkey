# FCP Frame Hotkey

在 Final Cut Pro 中按数字键 `1`，快速打开 **共享 → 存储当前帧**，并停在 macOS 保存窗口。

> Press `1` in Final Cut Pro to open **Share → Save Current Frame** and stop at the macOS Save dialog.

## 快速安装 Skill

在终端运行：

```bash
npx skills add https://github.com/broccolixin/FCP-Frame-Hotkey
```

安装完成后重新启动或刷新 Codex，然后输入：

```text
请使用 fcp-frame-hotkey Skill，在我的 Mac 上配置 Final Cut Pro 按 1 导出当前帧，并停在保存窗口。
```

> `npx` 安装方式需要电脑已安装 Node.js。没有 ChatGPT 或 Codex 的用户，可直接使用下方的 Hammerspoon 手动安装方法。

## 功能

- 仅在 **Final Cut Pro 位于前台**时生效
- 支持主键盘 `1` 和数字小键盘 `1`
- 自动匹配中文与英文菜单
- 自动进入保存窗口，但**不会自动确认保存**
- 其他应用中的数字键 `1` 保持正常
- 不修改 Final Cut Pro 原生快捷键
- 不使用屏幕坐标
- 支持登录后自动启动

本项目调用的是真正的导出功能：

```text
文件 → 共享 → 存储当前帧
File → Share → Save Current Frame
```

不是 Comparison Viewer 中的 **Store Frame / 储存帧**。

## 使用条件

- macOS
- Final Cut Pro
- 免费的 [Hammerspoon](https://www.hammerspoon.org/)
- FCP 已配置 **Save Current Frame / 存储当前帧**共享目的位置
- Hammerspoon 已获得**辅助功能**权限
- 部分 macOS 版本还需要开启**输入监控**权限

自动化运行时不需要 ChatGPT、Codex 或网络连接。

## 安装方法一：作为 Codex Skill 安装

首选使用：

```bash
npx skills add https://github.com/broccolixin/FCP-Frame-Hotkey
```

也可以将本仓库克隆或下载到：

```text
~/.codex/skills/fcp-frame-hotkey/
```

目录结构应为：

```text
fcp-frame-hotkey/
├── SKILL.md
├── agents/
│   └── openai.yaml
└── assets/
    └── init.lua
```

重新启动 Codex，然后输入：

```text
请使用 fcp-frame-hotkey Skill，在我的 Mac 上配置 Final Cut Pro 按 1 导出当前帧，并停在保存窗口。
```

Codex 会检查已有配置、所需权限和 FCP 菜单，再安装自动化。

## 安装方法二：不使用 ChatGPT 或 Codex

### 1. 安装 Hammerspoon

从 [Hammerspoon 官网](https://www.hammerspoon.org/) 下载并安装，然后启动。

### 2. 配置 Final Cut Pro

1. 打开 Final Cut Pro。
2. 进入 **Final Cut Pro → 设置 → 目的位置**。
3. 添加 **存储当前帧 / Save Current Frame**。
4. 如需无损静帧，将格式设为 **PNG**。
5. 保持项目原始分辨率和色彩空间，不额外缩放。

### 3. 安装脚本

将仓库中的：

```text
assets/init.lua
```

复制到：

```text
~/.hammerspoon/init.lua
```

如果 `~/.hammerspoon/init.lua` 已包含其他自动化，请先备份并合并代码，**不要直接覆盖**。

在 Finder 中看不到 `.hammerspoon` 时，按 `Command + Shift + G`，输入：

```text
~/.hammerspoon
```

### 4. 开启权限

打开：

```text
系统设置 → 隐私与安全性 → 辅助功能
```

开启 **Hammerspoon**。

如果快捷键仍无响应，再打开：

```text
系统设置 → 隐私与安全性 → 输入监控
```

开启 **Hammerspoon**，然后彻底退出并重新打开 Hammerspoon。

### 5. 加载配置

点击菜单栏中的 Hammerspoon 图标，选择：

```text
Reload Config
```

没有出现红色错误即表示配置已加载。

## 使用方法

1. 在 Final Cut Pro 时间线上移动播放头。
2. 确保 Final Cut Pro 位于前台。
3. 按数字键 `1`。
4. 等待 macOS 保存窗口出现。
5. 确认文件名与保存位置。
6. 点击**存储**。

脚本默认不会输入文件名、选择文件夹或点击最终的“存储”按钮。

## 验证

1. 在 FCP 中按 `1`，应打开当前帧保存窗口。
2. 保存 PNG 后检查画面，应与播放头位置一致。
3. 切换到备忘录或浏览器，按 `1`，应正常输入数字。
4. 移动 FCP 播放头后再次按 `1`，应能导出另一帧。

## 启动与停止

- **启动：** 打开 Hammerspoon
- **停止：** 退出 Hammerspoon
- **重新加载：** 菜单栏 Hammerspoon → Reload Config
- **开机启动：** 脚本中的 `hs.autoLaunch(true)` 默认启用登录启动

## 修改快捷键

`assets/init.lua` 默认使用以下 macOS 键码：

- 主键盘 `1`：`18`
- 数字小键盘 `1`：`83`

修改下面的判断即可更换按键：

```lua
if code ~= 18 and code ~= 83 then return false end
```

修改后保存，并在 Hammerspoon 中选择 **Reload Config**。

## 常见问题

### 提示找不到“存储当前帧”

确认 FCP 的“设置 → 目的位置”中已经添加 **存储当前帧 / Save Current Frame**。

### 按 `1` 没有反应

检查 Hammerspoon 的**辅助功能**和**输入监控**权限，然后重启 Hammerspoon。

### 没有导出 PNG

在 FCP 的“目的位置”设置中，将“存储当前帧”的格式改为 **PNG**。

### 保存窗口没有出现

FCP 响应较慢时，可适当调大 `assets/init.lua` 中的等待时间。

## 文件结构

```text
.
├── SKILL.md            # Codex Skill 指令
├── agents/
│   └── openai.yaml     # Skill 显示信息
├── assets/
│   └── init.lua        # Hammerspoon 自动化脚本
├── README.md
└── LICENSE
```

## License

[MIT License](LICENSE)

如果这个项目对你有帮助，欢迎 Star、Fork 或提交兼容性反馈。
