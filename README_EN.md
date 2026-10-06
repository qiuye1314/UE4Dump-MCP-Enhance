# UE4 Dump MCP — Enhanced (fixes tearue4mcp probe failures)

> **Android UE4/UE5 memory dump tool · MCP server · cross-version adaptive**
>
> Enhanced from [tearue4mcp](https://github.com/tearhacker/UE4Dump_imGui_AnalyseToolsForMCP), fixing its core **probe failure** issue so GNames/GUObjectArray auto-locate **adaptively across versions and survive restarts**.
>
> License: **GPL-3.0**

---

## 🎯 Core Enhancements

| Original problem | This enhanced version |
|------------------|----------------------|
| Peace Elite / Sichuan (卡拉彼丘) probe often fails | ✅ Fixed, one-click `attach → probe → dump` fully auto |
| Single-anchor validation hits **fake object arrays** | ✅ Original "multi-object continuous validation" rejects fake, locks real |
| Illegal UTF-8 in logs crashes JSON serialization | ✅ SanitizeUtf8 fixes it |
| Needs manual GNames/GUObjectArray offsets | ✅ Auto-locate, zero-offset, cross-version adaptive |

---

## 📌 Overview

```
AI (Claude / Cursor / WanXiang App)
   │ MCP stdio / HTTP
   ▼
This tool (Android ELF, C++)
   │ memory read · UE probe · AutoFix · SDK dump · Ghidra
   ▼
Attach UE game → probe → dump full SDK
```

### MCP Tools (46+)
- Process: `list_processes` / `select_process` / `attach`
- Locate: `start_probe` / `detect_ue_version` / `scan_gnames` / `scan_objects`
- Memory: `memory_read` / `memory_read_value` / `read_string` / `write_memory` / `scan_pattern`
- SDK: `start_dump` / `dump_unreal_library` / `search_classes` / `analyze_class`
- Reverse: `disassemble` / `decompile`(Ghidra) / `call_remote_function`
- Util: `apply_probe_overrides` / `get_logs` / `get_capabilities`

---

## ✅ Tested On Device

| Game | Package | probe | dump (9 files) |
|------|---------|-------|----------------|
| PUBG Mobile CN | `com.tencent.tmgp.pubgmhd` | ✅ auto | ✅ |
| Karakuri (卡拉彼丘) | `com.idreamsky.klbqm` | ✅ auto | ✅ |

> All **zero-offset, zero-override, still works after restart**.

---

## 🛠 Build

```bash
bash build_umt.sh              # incremental build (with result check)
bash build_umt.sh --clean      # clean build
bash build_umt.sh --deploy     # build & deploy to device
```

Output: `outputs/arm64-v8a/UnrealMemoryTools` (ELF64 / AArch64)

---

## 📄 License

**GPL-3.0** — modifications must be open-sourced back

- Original: 曦曦(DreamFekk) · 泪心(tearhacker)
- Remaker: e7

---

## 🙏 Credits

Enhanced from these open-source projects:
- [tearue4mcp](https://github.com/tearhacker/UE4Dump_imGui_AnalyseToolsForMCP) (tearhacker) — base + MCP
- [UE4Dumper](https://github.com/kp7742/UE4Dumper) (kp7742) — GNames/GUObject reference
- [Andriod_UnrealMemoryTools](https://github.com/DreamFekk/) (曦曦) — generic brute-force/AutoFix reference
- [AndUEProber](https://github.com/MJx0/AndUEDumper) — probe idea

> For analysis of targets you own or are authorized to access. Respect all licenses.