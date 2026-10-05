# UE4Dump MCP（tearue4mcp）增强版发布说明

> **Unreal Engine 内存 Dump + MCP 工具链 · 全自动跨版本适配**
> *基于开源的 tearue4mcp 项目二次增强，修复多个游戏自动定位难题，实现"零偏移、跨版本、重启不失效"的自动 Dump。*

---

## 🌟 一句话介绍

对 **tearue4mcp**（泪心团队开源的 UE4/UE5 内存 Dump + MCP 工具链）做深度增强：修复了**和平精英（PUBGMHD）probe 失败**、**卡拉彼丘（klbqm）dump 失败**、**设备端 UTF-8 崩溃**三大问题，并让 **GNames / GUObjectArray 自动定位做到跨版本自适应**——不依赖任何手动偏移、不依赖外部 dump 字典。

---

## 🔥 本版核心成果

### ✅ 1. 原创「多对象连续验证」——彻底解决假对象数组误判
- **问题**：原版用「单个 `/Script/CoreUObject` 锚点」验证 GUObjectArray，经常会**命中假对象数组**（只有孤立锚点），导致名字解码全失败
- **修复**：候选对象数组命中后，再验证**后续 4~6 个对象名都是合法包路径（`/Script/...`）或核心类名**才认可
- **效果**：假对象数组被剔除，真对象数组被锁定 → **和平精英、卡拉彼丘都能自动定位**

### ✅ 2. 修正 PUBGMHD 的 `+0x110` 误用
- 原版把 `pubgmhd`（和平精英国服）错误地并入 PUBG-style 的 `+0x110` 三级解引用链，导致 GNames/GUObject 定位错乱
- 修正后和平精英走**通用暴搜路径**（与卡拉彼丘一致），probe 自动成功

### ✅ 3. UTF-8 崩溃根治（设备端不再闪退）
- `README_STRING` / `GET_LOGS` / Dumper 名字解码三处，对日志/字符串做 **SanitizeUtf8 净化**
- 修复 `nlohmann::json type_error.316 invalid UTF-8` 崩溃——之前 probe 到一半就 SIGABRT

### ✅ 4. 重启不失效
- 所有修复**写入源码**（`UEGameProfile.cpp` / `executable.cpp` / `Dumper.cpp` / `MemoryHelpers.cpp`），编译进二进制
- 冷启动全新进程，**不注入 override、不依赖运行时状态**，`select_process → attach → probe → dump` 全自动成功

### ✅ 5. 一键编译脚本 `build_umt.sh`
- 自动前置检查 → CMake 配置（arm64/NDK/Ghidra）→ 多核编译 → 校验产物（ELF64/AArch64 + 修复标记）→ 可选部署

---

## 📝 Changelog（v1.0.1 增强版）

- **v1.0.1** （本版）
  - 🆕 新增「多对象连续验证」原创算法，GUObjectArray 自动定位跨版本自适应
  - 🐛 修复和平精英（pubgmhd）probe 失败：移除 `+0x110` 误用，走通用暴搜
  - 🐛 修复设备端 UTF-8 崩溃（READ_STRING / GET_LOGS / GetNameByID）
  - 🐛 修复卡拉彼丘（klbqm）dump 失败
  - 🛠 新增 `build_umt.sh` 一键编译脚本
  - 🎨 悬浮窗录屏显示开关修正
  - 📝 署名新增改写者 e7(Trade-offs)，保留原作者与版本信息
- **v1.0.0**（tearue4mcp 原版）
  - 47 项 MCP 功能：MEMORY_READ / WRITE_MEMORY / START_PROBE / SCAN_GNAMES / SCAN_OBJECTS / DISASSEMBLE / CALL_FUNCTION …

---

## ✅ 真机验证结果

| 游戏 | 包名 | probe | dump | 9文件 |
|------|------|-------|------|-------|
| **和平精英** | `com.tencent.tmgp.pubgmhd` | ✅ 自动 | ✅ 自动 | ✅ |
| **卡拉彼丘** | `com.idreamsky.klbqm` | ✅ 自动 | ✅ 自动 | ✅ |

均**零偏移、零 override、重启后依然成功**。

---

## 📚 引用与致谢

本项目基于以下开源项目二次增强：

| 项目 | 作者 | 说明 |
|------|------|------|
| **tearue4mcp** (`UE4Dump_imGui_AnalyseToolsForMCP`) | [tearhacker](https://github.com/tearhacker)（泪心）| 本增强版的基础（含 MCP 服务）|
| **UE4Dumper** (`kp7742/UE4Dumper`) | [kp7742](https://github.com/kp7742)（残梦）| GNames/GUObject deRef 与偏移参考 |
| **Andriod_UnrealMemoryTools** | [DreamFekk](https://github.com/DreamFekk)（曦曦）| 通用暴搜/AutoFix 架构参考 |
| **AndUEProber / AndUEDumper** | MJx0 等 | UI / probe 思路参考 |

> 感谢以上所有开源作者的无私分享。—— 本项目遵守 **GPL-3.0 / 各自许可证**，如引用方有要求，同步开源回馈。

---

## ⚠️ 已知限制

- **GNames / GUObjectArray 自动定位依赖"多对象名合法"判据**，对少数魔改到不保留核心类名的引擎仍可能需手动 override（`APPLY_PROBE_OVERRIDES` 可用）
- 高帧率/分辨率录制受设备屏幕刷新率与编码器能力限制
- MCP 服务默认监听 `127.0.0.1:35515`，请在可信网络使用

---

## 🔐 安全与合规

- 本工具仅建议用于**分析自己拥有或已授权**的目标（自录游戏、自建测试环境）
- 请勿用于绕过受保护应用的安全边界（如防录屏 DRM、付费内容）

---

## 📄 License

**GPL-3.0** — 修改须开源回馈 © 2026

**原作者**：曦曦(DreamFekk) / 泪心(tearhacker)
**改写者**：e7(Trade-offs)
**版本**：v1.0.1

---

*不求赞赏，记录踩坑经验，愿为 UE 引擎分析与逆向同行者点一盏灯。*