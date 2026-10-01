# stzb-ios — iOS 原生库

## 这是什么

率土之滨 iOS 端的**原生渲染层**。

背景：安卓和 PC 端都靠「自带 ImGui + 自己钩图形 API」工作（PC 钩 D3D11 Present、
安卓钩 eglSwapBuffers）。iOS 没有对应的库，所以在这里编。

**托管侧（四个页签、主题、缩放、卡片逻辑）全部复用，不在这里。**

## 为什么用 GitHub Actions

iOS 原生库必须在 macOS 工具链下编译（苹果的硬性限制）。
GitHub 给公开仓库提供**免费**的 macOS 运行器，自带 Xcode —— 不用买 Mac、不用装 Xcode。

## 当前进度：第 1 步（工具链探针）

只编一个最小的 dylib，验证：
- macOS runner 能不能用
- iOS SDK + CMake 交叉编译通不通
- 产物是不是 **Mach-O arm64**（`file` / `lipo -info` 都会检查）

## 怎么用

1. 双击 `push.bat`（git 会让你登一次 GitHub，在浏览器里点授权）
2. 打开 https://github.com/ttkx0725/stzb-ios/actions
3. 等绿色的 ✓，点进去在 **Artifacts** 里下载 `ios-native-probe`

## 后面几步（工具链通了再做）

| 步骤 | 内容 |
|---|---|
| 2 | 加上 imgui 核心 + `imgui_impl_metal.mm`，编出真的 `libcimgui.dylib` |
| 3 | 加上 cimgui 的 C 导出层 |
| 4 | 移植 `ao_overlay`：Mach-O GOT 钩 Metal present |
| 5 | 巨魔 / TrollFools 注入 + 托管侧换 P/Invoke 库名 |

## 备注

`imgui_impl_metal.mm` 已经在本地 `native/cimgui/imgui/backends/` 里，不需要额外去找。
imgui 版本 **1.91.6**，与托管侧 `ImGui.NET 1.91.6.1` 对齐。
