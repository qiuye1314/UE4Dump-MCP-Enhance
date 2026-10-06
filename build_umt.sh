#!/usr/bin/env bash
# =============================================================================
# UnrealMemoryTools (tearue4mcp) 一键编译脚本
# =============================================================================
# ⚠️ 必须在 PRoot Linux 沙箱里用 bash 运行（宿主 shell 无 cmake/ninja）：
#      bash build_umt.sh
# =============================================================================
set -euo pipefail

# 兼容 sh 调用：若 BASH_SOURCE 不可用则用 PWD 兜底（仅当脚本以绝对路径从源码目录运行）
if [ -n "${BASH_SOURCE:-}" ] && [ -n "${BASH_SOURCE[0]:-}" ]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
elif [ -n "${0:-}" ]; then
  SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
else
  SCRIPT_DIR="$(pwd)"
fi
SRC_DIR="${SRC_DIR:-$SCRIPT_DIR}"
NDK_PATH="/opt/wanxiang/toolchains/android/ndk/artifacts/02e10e4ddfe8deaeb0bd0cf29d04c981ed5bc8a5d6b560ebb9e7661f472d684b/ndk"
BUILD_DIR="$SRC_DIR/build_arm64"
OUT_DIR="$SRC_DIR/outputs/arm64-v8a"
DEPLOY_PATH="/data/shhiwo/UnrealMemoryTools"

# ---- 二、命令行参数 ------------------------------------------------------
CLEAN=0
GHIDRA=ON
DEPLOY=0
for arg in "$@"; do
  case "$arg" in
    --clean)   CLEAN=1 ;;
    --no-ghidra) GHIDRA=OFF ;;
    --deploy)  DEPLOY=1 ;;
    *) echo "未知参数: $arg"; exit 1 ;;
  esac
done

# ---- 三、前置检查 --------------------------------------------------------
echo "==== 1/5 前置检查 ===="
if [ ! -d "$SRC_DIR" ]; then
  echo "❌ 源码目录不存在: $SRC_DIR"
  exit 1
fi
if ! command -v cmake >/dev/null 2>&1; then
  echo "❌ 当前 shell 里找不到 cmake。"
  echo "   本脚本必须在 PRoot Linux 沙箱里运行（cmake/ninja/NDK 都在沙箱内）。"
  echo "   请进入沙箱后执行：bash build_umt.sh"
  exit 1
fi
for t in cmake ninja; do
  command -v "$t" >/dev/null || { echo "❌ 缺少工具: $t"; exit 1; }
done
[ -f "$NDK_PATH/build/cmake/android.toolchain.cmake" ] || {
  echo "❌ NDK 工具链不存在: $NDK_PATH"; exit 1; }
echo "✅ 源码目录: $SRC_DIR"
echo "✅ NDK: $NDK_PATH"
echo "✅ cmake: $(cmake --version | head -1 | awk '{print $3}'), ninja: $(ninja --version)"

# ---- 四、配置构建 --------------------------------------------------------
echo "==== 2/5 清理构建缓存 ===="
if [ "$CLEAN" = "1" ] && [ -d "$BUILD_DIR" ]; then
  rm -rf "$BUILD_DIR"
  echo "  已清理 $BUILD_DIR"
else
  echo "  (增量构建)"
fi

echo "==== 3/5 CMake 配置 ===="
cmake -S "$SRC_DIR" -B "$BUILD_DIR" \
  -DNDK_PATH="$NDK_PATH" \
  -DUMT_GHIDRA="$GHIDRA" \
  -DCMAKE_MAKE_PROGRAM="$(command -v ninja)" \
  -DCMAKE_BUILD_TYPE=Release \
  -G Ninja
echo "✅ CMake 配置完成"

# ---- 五、编译 ------------------------------------------------------------
echo "==== 4/5 编译 ===="
CPU_CORES=$(nproc 2>/dev/null || echo 2)
cmake --build "$BUILD_DIR" -j"$CPU_CORES"

# ---- 六、校验产物 --------------------------------------------------------
echo "==== 5/5 校验产物 ===="
if [ ! -f "$OUT_DIR/UnrealMemoryTools" ]; then
  echo "❌ 产物未生成: $OUT_DIR/UnrealMemoryTools"
  exit 1
fi
FILESIZE=$(stat -c%s "$OUT_DIR/UnrealMemoryTools")
echo "✅ 产物: $OUT_DIR/UnrealMemoryTools ($FILESIZE bytes)"

# 架构校验（若有 llvm-readelf）
RE="$NDK_PATH/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-readelf"
if [ -f "$RE" ]; then
  ARCH=$("$RE" -h "$OUT_DIR/UnrealMemoryTools" 2>/dev/null | grep -i machine | awk '{print $2}')
  CLASS=$("$RE" -h "$OUT_DIR/UnrealMemoryTools" 2>/dev/null | grep -i class | awk '{print $2}')
  echo " 架构: $CLASS / $ARCH"
fi

# 校验关键修复标记(多对象验证)：产物含 "GUObject @ ... follow=" 日志字符串
if strings "$OUT_DIR/UnrealMemoryTools" 2>/dev/null | grep -q "follow=" && \
   strings "$OUT_DIR/UnrealMemoryTools" 2>/dev/null | grep -q "Adjusting UObject.NamePrivate"; then
  echo "✅ 确认包含「多对象连续验证」修复"
else
  echo "⚠️  警告：产物未检出多对象验证标记，请检查源码"
fi

# ---- 七、可选部署 --------------------------------------------------------
if [ "$DEPLOY" = "1" ]; then
  echo "==== 部署到设备端 ===="
  cp -f "$OUT_DIR/UnrealMemoryTools" "$DEPLOY_PATH"
  chmod 755 "$DEPLOY_PATH"
  echo "✅ 已部署: $DEPLOY_PATH"
  echo "   (重启设备端后生效: kill <pid>，然后重新运行)"
fi

echo ""
echo "🎉 编译完成！产物: $OUT_DIR/UnrealMemoryTools"