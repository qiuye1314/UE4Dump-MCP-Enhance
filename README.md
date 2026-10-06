# UE4 Dump MCP — 增强版（修复 tearue4mcp 探针失败）

> **Android UE4/UE5 内存 Dump 工具 · MCP 服务 · 跨版本自适应**
>
> 基于 [tearue4mcp](https://github.com/tearhacker/UE4Dump_imGui_AnalyseToolsForMCP)（泪心）二次增强，**修复了原版探针失败**的核心问题，让 GNames / GUObjectArray 自动定位做到**跨版本自适应、重启不失效**。
>
> 协议：**GPL-3.0**

---

## 🎯 本次增强核心

| 原版痛点 | 本增强版 |
|---------|---------|
| 和平精英、卡拉彼丘探针（probe）经常失败 | ✅ 修复，一键 `attach → probe → dump` 全自动 |
| 用单个锚点验证对象数组，易命中**假对象数组** | ✅ 原创「多对象连续验证」，假数组剔除、真数组锁定 |
| 日志含非法 UTF-8，设备端 JSON 序列化崩溃 | ✅ SanitizeUtf8 根治 |
| 需要手动喂 GNames / GUObjectArray 偏移 | ✅ 自动定位，零偏移、跨版本自适应 |

---

## 📌 功能总览

```
AI (Claude / Cursor / 万象App)
   │ MCP HTTP/stdio
   ▼
本工具 (Android ELF, C++)
   │ 内存读取 · UE探针 · AutoFix · SDK Dump · Ghidra反编译
   ▼
Attach 目标 UE 游戏 → probe → dump 完整 SDK
```

### MCP 工具（46+）
- 进程：`list_processes` / `select_process` / `attach`
- 定位：`start_probe` / `detect_ue_version` / `scan_gnames` / `scan_objects`
- 内存：`memory_read` / `memory_read_value` / `read_string` / `write_memory` / `scan_pattern`
- SDK：`start_dump` / `dump_unreal_library` / `search_classes` / `analyze_class`
- 逆向：`disassemble` / `decompile`(Ghidra) / `call_remote_function`
- 工具：`apply_probe_overrides` / `get_logs` / `get_capabilities`

---

## ✅ 真机验证（实测）

| 游戏 | 包名 | probe | dump(9文件) |
|------|------|-------|-------------|
| 和平精英 | `com.tencent.tmgp.pubgmhd` | ✅ 自动成功 | ✅ |
| 卡拉彼丘 | `com.idreamsky.klbqm` | ✅ 自动成功 | ✅ |

> 全部**零偏移、零 override、重启后依然成功**。

---

## 🛠 构建

```bash
bash build_umt.sh              # 增量编译（含结果校验）
bash build_umt.sh --clean      # 清理后全新编译
bash build_umt.sh --deploy     # 编译后自动部署到设备端
```

产物：`outputs/arm64-v8a/UnrealMemoryTools`（ELF64 / AArch64）

---

## 📄 License

**GPL-3.0** — 修改必须开源回馈

- 原作者：曦曦(DreamFekk) · 泪心(tearhacker)
- 改写者：e7

---

## 🙏 致谢

本增强版基于以下开源项目：
- [tearue4mcp](https://github.com/tearhacker/UE4Dump_imGui_AnalyseToolsForMCP)（泪心）— 基础框架 + MCP
- [UE4Dumper](https://github.com/kp7742/UE4Dumper)（残梦）— GNames/GUObject 参考
- [Andriod_UnrealMemoryTools](https://github.com/DreamFekk/)（曦曦）— 通用暴搜/AutoFix 参考
- [AndUEProber](https://github.com/MJx0/AndUEDumper) — probe 思路

> 仅建议用于分析自己拥有/已授权 的目标。请遵守各开源项目许可。