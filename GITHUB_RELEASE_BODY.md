# UE4 Dump MCP 增强版 v1.0.1

> **修复 tearue4mcp 探针失败 · 跨版本自适应 · 一键出完整 SDK**
> *基于开源的 tearue4mcp 二次增强，让和平精英、卡拉彼丘探针从"失败"变成"全自动成功"。*

---

## 🔥 本版核心

**修复了原版 tearue4mcp 的探针（probe）失败问题。**

原版对和平精英、卡拉彼丘经常 `探针失败`（GNames / GUObjectArray 定位不来）。
本版加入**原创「多对象连续验证」算法**：候选对象数组命中后，验证后续多个对象名是否合法，必须通过才认可 → **假对象数组被剔除，真对象数组被锁定**。

---

## ✨ 亮点

- 🎯 **探针修复**：和平精英 / 卡拉彼丘 一键 `attach → probe → dump`
- 🧠 **零偏移自适应**：自动定位 GNames / GUObjectArray，不依赖手动偏移
- ♻️ **重启不失效**：修复写入源码，冷启动照样自动成功
- 🛡 **稳定性**：根治设备端 UTF-8 崩溃（JSON 序列化闪退）
- 🛠 **工程化**：`build_umt.sh` 一键编译（含结果校验）
- 📄 **完整文档**：README（中/英）+ Release Notes

---

## ✅ 实测

| 游戏 | 包名 | probe | dump |
|------|------|-------|------|
| 和平精英 | `com.tencent.tmgp.pubgmhd` | ✅ 自动 | ✅ 9文件 |
| 卡拉彼丘 | `com.idreamsky.klbqm` | ✅ 自动 | ✅ 9文件 |

---

## 📦 包含

- 完整源码（C++ / NDK）
- `build_umt.sh` 一键编译脚本
- `README.md` / `README_EN.md` / `RELEASE_NOTES.md`

---

## 🙏 致谢

- [tearue4mcp](https://github.com/tearhacker/UE4Dump_imGui_AnalyseToolsForMCP)（泪心）— 基础框架
- [UE4Dumper](https://github.com/kp7742/UE4Dumper)（残梦）— 参考
- [Andriod_UnrealMemoryTools](https://github.com/DreamFekk/)（曦曦）— 参考

> **License: GPL-3.0**
> 仅建议用于分析自己拥有/已授权 的目标。

---

**原作者**：曦曦(DreamFekk) · 泪心(tearhacker)
**改写者**：e7