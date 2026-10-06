# Release Notes

## v1.0.1 — 增强版（修复 tearue4mcp 探针失败）

> 基于 tearue4mcp（泪心）二次增强，核心是**修复原版探针（probe）失败**。

### 🆕 新增
- **原创「多对象连续验证」算法**：候选 GUObjectArray 命中后，验证后续 4~6 个对象名是否为合法包路径（`/Script/...`）或核心类名（`Object` / `Engine` / `ActorComponent` 等），必须通过才认可。
  - 效果：剔除「仅有孤立锚点」的**假对象数组**，锁定真对象数组 → 探针成功率大幅提升。
- **一键编译脚本** `build_umt.sh`（前置检查 → CMake 配置 → 多核编译 → 产物校验 → 可选部署）。

### 🐛 修复
- **和平精英（`com.tencent.tmgp.pubgmhd`）探针失败**：原版误用 PUBG-style `+0x110` 三级解引用链，导致 GNames/GUObjectArray 定位错乱。修正后走通用暴搜，probe 自动成功。
- **卡拉彼丘（`com.idreamsky.klbqm`）探针/dump 失败**：假对象数组问题，由「多对象连续验证」修复。
- **设备端 UTF-8 崩溃**（`nlohmann::json type_error.316 invalid UTF-8`）：
  - `READ_STRING` 返回的原始字节净化
  - `GET_LOGS` 日志统一净化
  - `GetNameByID` 名字解码净化
  - 之前 probe 到一半就 SIGABRT，现已根治。

### 🎨 调整
- 悬浮窗录屏显示/隐藏开关（`permeate_record`）修正。
- 署名：保留原作者（曦曦 / 泪心），新增改写者 `e7`；导出文件头显示版本信息。

### ✅ 验证
- 和平精英、卡拉彼丘：`attach → probe → dump` 全自动成功，导出完整 9 文件 SDK。
- 冷启动全新设备端进程，**零 override、零偏移**，依然成功。

---

## v1.0.0 — 基础版（上游 tearue4mcp）

- 47 项 MCP 功能：`MEMORY_READ` / `WRITE_MEMORY` / `START_PROBE` / `SCAN_GNAMES` / `SCAN_OBJECTS` / `DISASSEMBLE` / `DECOMPILE` / `CALL_REMOTE_FUNCTION` 等。
- Vulkan + ImGui 悬浮窗 UI，Probe / Dump 两步式流水线。
- 集成 Ghidra 反编译器（ARM64）。

> 上游项目：https://github.com/tearhacker/UE4Dump_imGui_AnalyseToolsForMCP