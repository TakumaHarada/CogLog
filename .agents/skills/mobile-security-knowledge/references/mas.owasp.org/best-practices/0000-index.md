---
source: https://mas.owasp.org/MASTG/best-practices/
scopes:
  - test
  - android
  - ios
  - backend
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
upstream_revision: d7fd7d4
---

# OWASP MASTG Best Practices（索引）

## 概要

OWASP MASTG Best Practices を、実装予防策／DO NOT 監査向けに 1 件 1 ドキュメントへ蒸留した索引である。

* 生成元 upstream: OWASP/mastg@d7fd7d4 の `best-practices/`
* 件数: 74（current 66 / placeholder 8）
* Best Practices は Tests 失敗を防ぐ具体策である。手順の正本は公式ページである
* 関連: [`../knowledge/0000-index.md`](../knowledge/0000-index.md)、[`../tests/0000-index.md`](../tests/0000-index.md)

## ディレクトリ規則

```text
docs/security/mas.owasp.org/best-practices/
├── 0000-index.md
├── android/NNNN-MASTG-BEST-NNNN.md
├── ios/NNNN-MASTG-BEST-NNNN.md
└── generic/NNNN-MASTG-BEST-NNNN.md
```

## 利用原則

実装差分に対し、関連プラットフォームの Best Practice を選び、適用有無をレビューする。検証は Tests で行う。

### 利用原則の補足

* 利点: Knowledge（解説）と Best（予防）と Test（検証）を役割分担できる
* 注意点: placeholder は意図のメモであり、完了根拠にしない
* 適用範囲: モバイル実装、設計レビュー、リリース前ゲート
* 例外: なし

### 利用原則の実装例

```text
例: 機微画面を追加した
1. android/ または ios/ から screenshot / overlay / biometric 系 BEST を選ぶ
2. 実装に FLAG_SECURE 等を適用
3. 対応 Test で合否を取る
```

## ナレッジベース

### DO: current の Best Practice を実装チェックリストへ載せる

```text
# 推奨
platform: android|ios
best: [MASTG-BEST-....]
verify_with: related MASTG-TEST / Knowledge
```

### DO NOT: Best Practice 要約 alone で「MASTG 準拠」と宣言する

* 理由: Best は予防策、Test は検証手順である
* 理由: 要約は蒸留であり公式本文の全条件を含まない

```text
# DO NOT: BEST 索引を読んだだけで準拠完了とする

# DO: 該当 BEST を実装し、Tests で証拠を残す
```

## 一覧

| ID | Platform | Title | Status | Knowledge | Path |
| --- | --- | --- | --- | --- | --- |
| MASTG-BEST-0001 | android | Use Secure Random Number Generator APIs | current | MASTG-KNOW-0013 | [`android/0001-MASTG-BEST-0001.md`](./android/0001-MASTG-BEST-0001.md) |
| MASTG-BEST-0002 | android | Remove Logging Code | current | MASTG-KNOW-0049 | [`android/0002-MASTG-BEST-0002.md`](./android/0002-MASTG-BEST-0002.md) |
| MASTG-BEST-0003 | android | Comply with Privacy Regulations and Best Practices | current | — | [`android/0003-MASTG-BEST-0003.md`](./android/0003-MASTG-BEST-0003.md) |
| MASTG-BEST-0004 | android | Exclude Sensitive Data from Backups | current | MASTG-KNOW-0050 | [`android/0004-MASTG-BEST-0004.md`](./android/0004-MASTG-BEST-0004.md) |
| MASTG-BEST-0005 | android | Use Secure Encryption Modes | current | — | [`android/0005-MASTG-BEST-0005.md`](./android/0005-MASTG-BEST-0005.md) |
| MASTG-BEST-0006 | android | Use Up-to-Date APK Signing Schemes | current | MASTG-KNOW-0003 | [`android/0006-MASTG-BEST-0006.md`](./android/0006-MASTG-BEST-0006.md) |
| MASTG-BEST-0007 | android | Debuggable Flag Disabled in the AndroidManifest | current | MASTG-KNOW-0007 | [`android/0007-MASTG-BEST-0007.md`](./android/0007-MASTG-BEST-0007.md) |
| MASTG-BEST-0008 | android | Debugging Disabled for WebViews | current | MASTG-KNOW-0018 | [`android/0008-MASTG-BEST-0008.md`](./android/0008-MASTG-BEST-0008.md) |
| MASTG-BEST-0009 | android | Use Secure Encryption Algorithms | current | — | [`android/0009-MASTG-BEST-0009.md`](./android/0009-MASTG-BEST-0009.md) |
| MASTG-BEST-0010 | android | Use Up-to-Date minSdkVersion | current | — | [`android/0010-MASTG-BEST-0010.md`](./android/0010-MASTG-BEST-0010.md) |
| MASTG-BEST-0011 | android | Securely Load File Content in a WebView | current | MASTG-KNOW-0018 | [`android/0011-MASTG-BEST-0011.md`](./android/0011-MASTG-BEST-0011.md) |
| MASTG-BEST-0012 | android | Disable JavaScript in WebViews | current | MASTG-KNOW-0018 | [`android/0012-MASTG-BEST-0012.md`](./android/0012-MASTG-BEST-0012.md) |
| MASTG-BEST-0013 | android | Disable Content Provider Access in WebViews | current | MASTG-KNOW-0018 | [`android/0013-MASTG-BEST-0013.md`](./android/0013-MASTG-BEST-0013.md) |
| MASTG-BEST-0014 | android | Preventing Screenshots and Screen Recording | current | — | [`android/0014-MASTG-BEST-0014.md`](./android/0014-MASTG-BEST-0014.md) |
| MASTG-BEST-0015 | android | Use `setRecentsScreenshotEnabled` to Prevent Screenshots When Backgrounded | placeholder | — | [`android/0015-MASTG-BEST-0015.md`](./android/0015-MASTG-BEST-0015.md) |
| MASTG-BEST-0016 | android | Use `SECURE_FLAG` to Prevent Screenshots and Screen Recording | placeholder | — | [`android/0016-MASTG-BEST-0016.md`](./android/0016-MASTG-BEST-0016.md) |
| MASTG-BEST-0017 | android | Use `setSecure` to Prevent Screenshots in SurfaceViews | placeholder | — | [`android/0017-MASTG-BEST-0017.md`](./android/0017-MASTG-BEST-0017.md) |
| MASTG-BEST-0018 | android | Use `SecureFlagPolicy.SecureOn` to Prevent Screenshots in Compose Components | placeholder | — | [`android/0018-MASTG-BEST-0018.md`](./android/0018-MASTG-BEST-0018.md) |
| MASTG-BEST-0019 | android | Use Non-Caching Input Types for Sensitive Fields | placeholder | MASTG-KNOW-0055 | [`android/0019-MASTG-BEST-0019.md`](./android/0019-MASTG-BEST-0019.md) |
| MASTG-BEST-0020 | android | Update the GMS Security Provider | current | MASTG-KNOW-0011 | [`android/0020-MASTG-BEST-0020.md`](./android/0020-MASTG-BEST-0020.md) |
| MASTG-BEST-0021 | android | Ensure Proper Error and Exception Handling | current | MASTG-KNOW-0010 | [`android/0021-MASTG-BEST-0021.md`](./android/0021-MASTG-BEST-0021.md) |
| MASTG-BEST-0022 | ios | Disable Verbose and Debug Logging in Production Builds | current | MASTG-KNOW-0101 | [`ios/0022-MASTG-BEST-0022.md`](./ios/0022-MASTG-BEST-0022.md) |
| MASTG-BEST-0023 | ios | Exclude Sensitive Information from Backups | current | MASTG-KNOW-0102 | [`ios/0023-MASTG-BEST-0023.md`](./ios/0023-MASTG-BEST-0023.md) |
| MASTG-BEST-0024 | ios | Store Data Encrypted in App Sandbox Directory | current | MASTG-KNOW-0108 | [`ios/0024-MASTG-BEST-0024.md`](./ios/0024-MASTG-BEST-0024.md) |
| MASTG-BEST-0025 | ios | Use Secure Random Number Generator APIs | current | MASTG-KNOW-0070 | [`ios/0025-MASTG-BEST-0025.md`](./ios/0025-MASTG-BEST-0025.md) |
| MASTG-BEST-0026 | ios | Preventing Keyboard Caching for Sensitive Text Inputs | placeholder | MASTG-KNOW-0100 | [`ios/0026-MASTG-BEST-0026.md`](./ios/0026-MASTG-BEST-0026.md) |
| MASTG-BEST-0027 | android | Preventing Sensitive Data Exposure in Notifications | placeholder | MASTG-KNOW-0054 | [`android/0027-MASTG-BEST-0027.md`](./android/0027-MASTG-BEST-0027.md) |
| MASTG-BEST-0028 | android | WebViews Cache Cleanup | current | — | [`android/0028-MASTG-BEST-0028.md`](./android/0028-MASTG-BEST-0028.md) |
| MASTG-BEST-0029 | generic | Implementing Resilience and RASP Signals | placeholder | MASTG-KNOW-0027, MASTG-KNOW-0028, MASTG-KNOW-0029, MASTG-KNOW-0030, MASTG-KNOW-0031, MASTG-KNOW-0032, MASTG-KNOW-0033, MASTG-KNOW-0034, MASTG-KNOW-0035, MASTG-KNOW-0089 | [`generic/0029-MASTG-BEST-0029.md`](./generic/0029-MASTG-BEST-0029.md) |
| MASTG-BEST-0030 | generic | Implementing Root Detection | current | MASTG-KNOW-0027 | [`generic/0030-MASTG-BEST-0030.md`](./generic/0030-MASTG-BEST-0030.md) |
| MASTG-BEST-0031 | android | Enforce Strong Biometrics for Sensitive Operations | current | MASTG-KNOW-0001 | [`android/0031-MASTG-BEST-0031.md`](./android/0031-MASTG-BEST-0031.md) |
| MASTG-BEST-0032 | ios | Migrate from UIWebView to WKWebView | current | MASTG-KNOW-0076 | [`ios/0032-MASTG-BEST-0032.md`](./ios/0032-MASTG-BEST-0032.md) |
| MASTG-BEST-0033 | ios | Securely Load File Content in a WebView | current | MASTG-KNOW-0076 | [`ios/0033-MASTG-BEST-0033.md`](./ios/0033-MASTG-BEST-0033.md) |
| MASTG-BEST-0034 | ios | Validate WebView Input | current | MASTG-KNOW-0076 | [`ios/0034-MASTG-BEST-0034.md`](./ios/0034-MASTG-BEST-0034.md) |
| MASTG-BEST-0035 | android | Prefer Origin Scoped Messaging Over Legacy JavaScript Bridges | current | MASTG-KNOW-0018 | [`android/0035-MASTG-BEST-0035.md`](./android/0035-MASTG-BEST-0035.md) |
| MASTG-BEST-0036 | android | Use Cryptographic Binding for Biometric Authentication | current | MASTG-KNOW-0001 | [`android/0036-MASTG-BEST-0036.md`](./android/0036-MASTG-BEST-0036.md) |
| MASTG-BEST-0037 | android | Invalidate Biometric Keys on Enrollment Changes | current | MASTG-KNOW-0001 | [`android/0037-MASTG-BEST-0037.md`](./android/0037-MASTG-BEST-0037.md) |
| MASTG-BEST-0038 | android | Require Explicit User Confirmation for Biometric Authentication | current | MASTG-KNOW-0001 | [`android/0038-MASTG-BEST-0038.md`](./android/0038-MASTG-BEST-0038.md) |
| MASTG-BEST-0039 | android | Prevent SQL Injection in ContentProviders | current | MASTG-KNOW-0117 | [`android/0039-MASTG-BEST-0039.md`](./android/0039-MASTG-BEST-0039.md) |
| MASTG-BEST-0040 | android | Preventing Overlay Attacks | current | MASTG-KNOW-0022 | [`android/0040-MASTG-BEST-0040.md`](./android/0040-MASTG-BEST-0040.md) |
| MASTG-BEST-0041 | android | Hardening Against Runtime Hooking | current | MASTG-KNOW-0027, MASTG-KNOW-0030, MASTG-KNOW-0032, MASTG-KNOW-0118, MASTG-KNOW-0033, MASTG-KNOW-0119, MASTG-KNOW-0120 | [`android/0041-MASTG-BEST-0041.md`](./android/0041-MASTG-BEST-0041.md) |
| MASTG-BEST-0042 | ios | Use Strong TLS Settings in ATS Configuration | current | MASTG-KNOW-0071 | [`ios/0042-MASTG-BEST-0042.md`](./ios/0042-MASTG-BEST-0042.md) |
| MASTG-BEST-0043 | ios | Enforce Strong TLS Settings When ATS Doesn't Apply | current | MASTG-KNOW-0073 | [`ios/0043-MASTG-BEST-0043.md`](./ios/0043-MASTG-BEST-0043.md) |
| MASTG-BEST-0044 | ios | Mask Sensitive Data in Text Input Fields | current | MASTG-KNOW-0098 | [`ios/0044-MASTG-BEST-0044.md`](./ios/0044-MASTG-BEST-0044.md) |
| MASTG-BEST-0045 | ios | Limit Sensitive Data Exposure Through iOS IPC Channels | current | MASTG-KNOW-0083, MASTG-KNOW-0079, MASTG-KNOW-0080, MASTG-KNOW-0081, MASTG-KNOW-0082, MASTG-KNOW-0122, MASTG-KNOW-0123, MASTG-KNOW-0124, MASTG-KNOW-0125, MASTG-KNOW-0126, MASTG-KNOW-0127, MASTG-KNOW-0128, MASTG-KNOW-0129, MASTG-KNOW-0130, MASTG-KNOW-0131, MASTG-KNOW-0104 | [`ios/0045-MASTG-BEST-0045.md`](./ios/0045-MASTG-BEST-0045.md) |
| MASTG-BEST-0046 | android | Hardening Against Emulation | current | MASTG-KNOW-0031, MASTG-KNOW-0035, MASTG-KNOW-0033, MASTG-KNOW-0030 | [`android/0046-MASTG-BEST-0046.md`](./android/0046-MASTG-BEST-0046.md) |
| MASTG-BEST-0047 | android | Continuous Anti-Debugging Checks | current | MASTG-KNOW-0028 | [`android/0047-MASTG-BEST-0047.md`](./android/0047-MASTG-BEST-0047.md) |
| MASTG-BEST-0048 | ios | Hardening Against Reverse Engineering Tools | current | MASTG-KNOW-0087 | [`ios/0048-MASTG-BEST-0048.md`](./ios/0048-MASTG-BEST-0048.md) |
| MASTG-BEST-0049 | android | Restrict and Validate Access to Exported Content Providers | current | — | [`android/0049-MASTG-BEST-0049.md`](./android/0049-MASTG-BEST-0049.md) |
| MASTG-BEST-0050 | android | Store Data Encrypted in App Sandbox Directory | current | MASTG-KNOW-0036 | [`android/0050-MASTG-BEST-0050.md`](./android/0050-MASTG-BEST-0050.md) |
| MASTG-BEST-0051 | ios | Minimize iOS Permissions and Entitlements | current | MASTG-KNOW-0077 | [`ios/0051-MASTG-BEST-0051.md`](./ios/0051-MASTG-BEST-0051.md) |
| MASTG-BEST-0052 | android | Restrict Access to Android App Components | current | MASTG-KNOW-0017, MASTG-KNOW-0132, MASTG-KNOW-0133, MASTG-KNOW-0134, MASTG-KNOW-0020 | [`android/0052-MASTG-BEST-0052.md`](./android/0052-MASTG-BEST-0052.md) |
| MASTG-BEST-0053 | ios | Hardening Against Virtual Devices | current | MASTG-KNOW-0135, MASTG-KNOW-0088, MASTG-KNOW-0136, MASTG-KNOW-0087, MASTG-KNOW-0089 | [`ios/0053-MASTG-BEST-0053.md`](./ios/0053-MASTG-BEST-0053.md) |
| MASTG-BEST-0054 | ios | Validate Input Parameters in Custom URL Scheme Handlers | current | MASTG-KNOW-0079 | [`ios/0054-MASTG-BEST-0054.md`](./ios/0054-MASTG-BEST-0054.md) |
| MASTG-BEST-0055 | ios | Validate Source Application in Custom URL Scheme Handlers | current | MASTG-KNOW-0079 | [`ios/0055-MASTG-BEST-0055.md`](./ios/0055-MASTG-BEST-0055.md) |
| MASTG-BEST-0056 | android | Use Explicit Intents for Internal IPC | current | MASTG-KNOW-0025 | [`android/0056-MASTG-BEST-0056.md`](./android/0056-MASTG-BEST-0056.md) |
| MASTG-BEST-0057 | android | Sanitize Data Coming from External Components | current | MASTG-KNOW-0025, MASTG-KNOW-0138 | [`android/0057-MASTG-BEST-0057.md`](./android/0057-MASTG-BEST-0057.md) |
| MASTG-BEST-0058 | ios | Restrict Native Functionality Exposed Through WebView Bridges | current | MASTG-KNOW-0076 | [`ios/0058-MASTG-BEST-0058.md`](./ios/0058-MASTG-BEST-0058.md) |
| MASTG-BEST-0059 | ios | Render Sensitive UI as Native Views Over the WebView | current | MASTG-KNOW-0076, MASTG-KNOW-0139 | [`ios/0059-MASTG-BEST-0059.md`](./ios/0059-MASTG-BEST-0059.md) |
| MASTG-BEST-0060 | ios | Use Native Views for Sensitive Text Entry Over a WebView | current | MASTG-KNOW-0076, MASTG-KNOW-0139 | [`ios/0060-MASTG-BEST-0060.md`](./ios/0060-MASTG-BEST-0060.md) |
| MASTG-BEST-0061 | ios | Use WKContentWorld Isolation for DOM Inspection Scripts | current | MASTG-KNOW-0076, MASTG-KNOW-0139 | [`ios/0061-MASTG-BEST-0061.md`](./ios/0061-MASTG-BEST-0061.md) |
| MASTG-BEST-0062 | ios | Use WKScriptMessageHandlerWithReply to Return Data to JavaScript | current | MASTG-KNOW-0076, MASTG-KNOW-0139 | [`ios/0062-MASTG-BEST-0062.md`](./ios/0062-MASTG-BEST-0062.md) |
| MASTG-BEST-0063 | android | Use Immutable PendingIntents with Explicit Intents | current | — | [`android/0063-MASTG-BEST-0063.md`](./android/0063-MASTG-BEST-0063.md) |
| MASTG-BEST-0064 | ios | Use Safe APIs for Object Deserialization | current | MASTG-KNOW-0075 | [`ios/0064-MASTG-BEST-0064.md`](./ios/0064-MASTG-BEST-0064.md) |
| MASTG-BEST-0065 | ios | Implementing Storage Integrity Checks on iOS | current | MASTG-KNOW-0086 | [`ios/0065-MASTG-BEST-0065.md`](./ios/0065-MASTG-BEST-0065.md) |
| MASTG-BEST-0066 | android | Implementing Storage Integrity Checks on Android | current | MASTG-KNOW-0036 | [`android/0066-MASTG-BEST-0066.md`](./android/0066-MASTG-BEST-0066.md) |
| MASTG-BEST-0067 | ios | Implementing Source Code Integrity Checks on iOS | current | MASTG-KNOW-0140 | [`ios/0067-MASTG-BEST-0067.md`](./ios/0067-MASTG-BEST-0067.md) |
| MASTG-BEST-0068 | ios | Secure Data Sharing Between App Extensions and Containing Apps | current | MASTG-KNOW-0082 | [`ios/0068-MASTG-BEST-0068.md`](./ios/0068-MASTG-BEST-0068.md) |
| MASTG-BEST-0069 | ios | Keep Sensitive Input on the System Keyboard | current | MASTG-KNOW-0082, MASTG-KNOW-0141 | [`ios/0069-MASTG-BEST-0069.md`](./ios/0069-MASTG-BEST-0069.md) |
| MASTG-BEST-0070 | android | Verify Android App Links with autoVerify and Digital Asset Links | current | MASTG-KNOW-0019 | [`android/0070-MASTG-BEST-0070.md`](./android/0070-MASTG-BEST-0070.md) |
| MASTG-BEST-0071 | android | Validate Input Parameters in Deep Link and Custom URL Scheme Handlers | current | MASTG-KNOW-0019 | [`android/0071-MASTG-BEST-0071.md`](./android/0071-MASTG-BEST-0071.md) |
| MASTG-BEST-0072 | ios | Validate Input Parameters in Universal Link Handlers | current | MASTG-KNOW-0080 | [`ios/0072-MASTG-BEST-0072.md`](./ios/0072-MASTG-BEST-0072.md) |
| MASTG-BEST-0073 | ios | Properly Validate Server Trust in URLSessionDelegate and WKNavigationDelegate | current | MASTG-KNOW-0072 | [`ios/0073-MASTG-BEST-0073.md`](./ios/0073-MASTG-BEST-0073.md) |
| MASTG-BEST-0074 | ios | Implementing Anti-Debugging Checks on iOS | current | MASTG-KNOW-0085 | [`ios/0074-MASTG-BEST-0074.md`](./ios/0074-MASTG-BEST-0074.md) |

## 参考リンク

* Best Practices: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG: <https://mas.owasp.org/MASTG/>
* upstream: <https://github.com/OWASP/mastg/tree/master/best-practices>
