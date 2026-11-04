---
source: https://mas.owasp.org/MASTG/tests/
scopes:
  - test
  - android
  - ios
  - backend
  - mobile
  - security-review
  - implementation
  - mastg-tests
updated_at: 2026-08-16
upstream_revision: d7fd7d4
---

# OWASP MASTG Tests（索引）

## 概要

OWASP MASTG Tests を、テストナレッジ／DO NOT 監査向けに 1 テスト 1 ドキュメントへ蒸留した索引である。

* 生成元 upstream: OWASP/mastg@d7fd7d4 の `tests/` および `tests-beta/`
* 件数: 292（current / deprecated / placeholder を含む）
* 手順・合否の正本は公式 Test ページである
* 関連: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## ディレクトリ規則

```text
docs/security/mas.owasp.org/tests/
├── 0000-index.md
├── android/{MASVS-*}/NNNN-MASTG-TEST-NNNN.md
└── ios/{MASVS-*}/NNNN-MASTG-TEST-NNNN.md
```

## 利用原則

実装差分に対し、関連 MASVS カテゴリの Test を選び、Steps を実施して Evaluation で合否を付ける。

### 利用原則の補足

* 利点: Knowledge（何を知るか）と Test（どう検証するか）を分離できる
* 注意点: deprecated は covered_by の後継を優先する
* 適用範囲: 手動テスト、リリース前ゲート、外部委託 SoW
* 例外: なし

### 利用原則の実装例

```text
例: 外部ストレージ書き込みを追加した
1. android/MASVS-STORAGE の Test を索引から選ぶ
2. MASTG-TEST-0200 等を実施
3. 機微データ平文なら fail + MASWE を起票
```

## ナレッジベース

### DO: current Test をプロファイル（L1/L2/R/P）付きでテスト計画へ載せる

```text
# 推奨
profile: L1 (+ 必要なら L2/P/R)
tests: [MASTG-TEST-....]
evidence: build hash + 手順 + 合否
```

### DO NOT: deprecated のみを現行準拠の根拠にする

* 理由: MASTG v2 で後継 Test へ再編されている
* 理由: covered_by が示す現行手順と乖離する

```text
# DO NOT: MASTG-TEST-0001 だけで STORAGE 検証完了とする

# DO: covered_by の後継（例: 0200 系）を実施する
```

## 一覧

| ID | Platform | Category | Title | Status | Profiles | Path |
| --- | --- | --- | --- | --- | --- | --- |
| MASTG-TEST-0001 | android | MASVS-STORAGE | Testing Local Storage for Sensitive Data | deprecated | L1,L2 | [`android/MASVS-STORAGE/0001-MASTG-TEST-0001.md`](./android/MASVS-STORAGE/0001-MASTG-TEST-0001.md) |
| MASTG-TEST-0002 | android | MASVS-CODE | Testing Local Storage for Input Validation | deprecated | L1,L2 | [`android/MASVS-CODE/0002-MASTG-TEST-0002.md`](./android/MASVS-CODE/0002-MASTG-TEST-0002.md) |
| MASTG-TEST-0003 | android | MASVS-STORAGE | Testing Logs for Sensitive Data | deprecated | L1,L2 | [`android/MASVS-STORAGE/0003-MASTG-TEST-0003.md`](./android/MASVS-STORAGE/0003-MASTG-TEST-0003.md) |
| MASTG-TEST-0004 | android | MASVS-STORAGE | Determining Whether Sensitive Data Is Shared with Third Parties via Embedded Services | deprecated | L1,L2 | [`android/MASVS-STORAGE/0004-MASTG-TEST-0004.md`](./android/MASVS-STORAGE/0004-MASTG-TEST-0004.md) |
| MASTG-TEST-0005 | android | MASVS-STORAGE | Determining Whether Sensitive Data Is Shared with Third Parties via Notifications | deprecated | L1,L2 | [`android/MASVS-STORAGE/0005-MASTG-TEST-0005.md`](./android/MASVS-STORAGE/0005-MASTG-TEST-0005.md) |
| MASTG-TEST-0006 | android | MASVS-STORAGE | Determining Whether the Keyboard Cache Is Disabled for Text Input Fields | deprecated | L1,L2 | [`android/MASVS-STORAGE/0006-MASTG-TEST-0006.md`](./android/MASVS-STORAGE/0006-MASTG-TEST-0006.md) |
| MASTG-TEST-0007 | android | MASVS-PLATFORM | Determining Whether Sensitive Stored Data Has Been Exposed via IPC Mechanisms | deprecated | L1,L2 | [`android/MASVS-PLATFORM/0007-MASTG-TEST-0007.md`](./android/MASVS-PLATFORM/0007-MASTG-TEST-0007.md) |
| MASTG-TEST-0008 | android | MASVS-PLATFORM | Checking for Sensitive Data Disclosure Through the User Interface | deprecated | L2 | [`android/MASVS-PLATFORM/0008-MASTG-TEST-0008.md`](./android/MASVS-PLATFORM/0008-MASTG-TEST-0008.md) |
| MASTG-TEST-0009 | android | MASVS-STORAGE | Testing Backups for Sensitive Data | deprecated | L1,L2 | [`android/MASVS-STORAGE/0009-MASTG-TEST-0009.md`](./android/MASVS-STORAGE/0009-MASTG-TEST-0009.md) |
| MASTG-TEST-0010 | android | MASVS-PLATFORM | Finding Sensitive Information in Auto-Generated Screenshots | deprecated | L2 | [`android/MASVS-PLATFORM/0010-MASTG-TEST-0010.md`](./android/MASVS-PLATFORM/0010-MASTG-TEST-0010.md) |
| MASTG-TEST-0011 | android | MASVS-STORAGE | Testing Memory for Sensitive Data | deprecated | L2 | [`android/MASVS-STORAGE/0011-MASTG-TEST-0011.md`](./android/MASVS-STORAGE/0011-MASTG-TEST-0011.md) |
| MASTG-TEST-0012 | android | MASVS-STORAGE | Testing the Device-Access-Security Policy | deprecated | L2 | [`android/MASVS-STORAGE/0012-MASTG-TEST-0012.md`](./android/MASVS-STORAGE/0012-MASTG-TEST-0012.md) |
| MASTG-TEST-0013 | android | MASVS-CRYPTO | Testing Symmetric Cryptography | deprecated | L1,L2 | [`android/MASVS-CRYPTO/0013-MASTG-TEST-0013.md`](./android/MASVS-CRYPTO/0013-MASTG-TEST-0013.md) |
| MASTG-TEST-0014 | android | MASVS-CRYPTO | Testing the Configuration of Cryptographic Standard Algorithms | deprecated | L1,L2 | [`android/MASVS-CRYPTO/0014-MASTG-TEST-0014.md`](./android/MASVS-CRYPTO/0014-MASTG-TEST-0014.md) |
| MASTG-TEST-0015 | android | MASVS-CRYPTO | Testing the Purposes of Keys | deprecated | L2 | [`android/MASVS-CRYPTO/0015-MASTG-TEST-0015.md`](./android/MASVS-CRYPTO/0015-MASTG-TEST-0015.md) |
| MASTG-TEST-0016 | android | MASVS-CRYPTO | Testing Random Number Generation | deprecated | L1,L2 | [`android/MASVS-CRYPTO/0016-MASTG-TEST-0016.md`](./android/MASVS-CRYPTO/0016-MASTG-TEST-0016.md) |
| MASTG-TEST-0017 | android | MASVS-AUTH | Testing Confirm Credentials | deprecated | L2 | [`android/MASVS-AUTH/0017-MASTG-TEST-0017.md`](./android/MASVS-AUTH/0017-MASTG-TEST-0017.md) |
| MASTG-TEST-0018 | android | MASVS-AUTH | Testing Biometric Authentication | deprecated | L2 | [`android/MASVS-AUTH/0018-MASTG-TEST-0018.md`](./android/MASVS-AUTH/0018-MASTG-TEST-0018.md) |
| MASTG-TEST-0019 | android | MASVS-NETWORK | Testing Data Encryption on the Network | deprecated | L1,L2 | [`android/MASVS-NETWORK/0019-MASTG-TEST-0019.md`](./android/MASVS-NETWORK/0019-MASTG-TEST-0019.md) |
| MASTG-TEST-0020 | android | MASVS-NETWORK | Testing the TLS Settings | deprecated | L1,L2 | [`android/MASVS-NETWORK/0020-MASTG-TEST-0020.md`](./android/MASVS-NETWORK/0020-MASTG-TEST-0020.md) |
| MASTG-TEST-0021 | android | MASVS-NETWORK | Testing Endpoint Identify Verification | deprecated | L1,L2 | [`android/MASVS-NETWORK/0021-MASTG-TEST-0021.md`](./android/MASVS-NETWORK/0021-MASTG-TEST-0021.md) |
| MASTG-TEST-0022 | android | MASVS-NETWORK | Testing Custom Certificate Stores and Certificate Pinning | deprecated | L2 | [`android/MASVS-NETWORK/0022-MASTG-TEST-0022.md`](./android/MASVS-NETWORK/0022-MASTG-TEST-0022.md) |
| MASTG-TEST-0023 | android | MASVS-NETWORK | Testing the Security Provider | deprecated | L2 | [`android/MASVS-NETWORK/0023-MASTG-TEST-0023.md`](./android/MASVS-NETWORK/0023-MASTG-TEST-0023.md) |
| MASTG-TEST-0024 | android | MASVS-PLATFORM | Testing for App Permissions | deprecated | L1,L2 | [`android/MASVS-PLATFORM/0024-MASTG-TEST-0024.md`](./android/MASVS-PLATFORM/0024-MASTG-TEST-0024.md) |
| MASTG-TEST-0025 | android | MASVS-CODE | Testing for Injection Flaws | deprecated | L1,L2 | [`android/MASVS-CODE/0025-MASTG-TEST-0025.md`](./android/MASVS-CODE/0025-MASTG-TEST-0025.md) |
| MASTG-TEST-0026 | android | MASVS-CODE | Testing Implicit Intents | deprecated | L1,L2 | [`android/MASVS-CODE/0026-MASTG-TEST-0026.md`](./android/MASVS-CODE/0026-MASTG-TEST-0026.md) |
| MASTG-TEST-0027 | android | MASVS-CODE | Testing for URL Loading in WebViews | deprecated | L1,L2 | [`android/MASVS-CODE/0027-MASTG-TEST-0027.md`](./android/MASVS-CODE/0027-MASTG-TEST-0027.md) |
| MASTG-TEST-0028 | android | MASVS-PLATFORM | Testing Deep Links | deprecated | L1,L2 | [`android/MASVS-PLATFORM/0028-MASTG-TEST-0028.md`](./android/MASVS-PLATFORM/0028-MASTG-TEST-0028.md) |
| MASTG-TEST-0029 | android | MASVS-PLATFORM | Testing for Sensitive Functionality Exposure Through IPC | deprecated | L1,L2 | [`android/MASVS-PLATFORM/0029-MASTG-TEST-0029.md`](./android/MASVS-PLATFORM/0029-MASTG-TEST-0029.md) |
| MASTG-TEST-0030 | android | MASVS-PLATFORM | Testing for Vulnerable Implementation of PendingIntent | deprecated | L1,L2 | [`android/MASVS-PLATFORM/0030-MASTG-TEST-0030.md`](./android/MASVS-PLATFORM/0030-MASTG-TEST-0030.md) |
| MASTG-TEST-0031 | android | MASVS-PLATFORM | Testing JavaScript Execution in WebViews | deprecated | L1,L2 | [`android/MASVS-PLATFORM/0031-MASTG-TEST-0031.md`](./android/MASVS-PLATFORM/0031-MASTG-TEST-0031.md) |
| MASTG-TEST-0032 | android | MASVS-PLATFORM | Testing WebView Protocol Handlers | deprecated | L1,L2 | [`android/MASVS-PLATFORM/0032-MASTG-TEST-0032.md`](./android/MASVS-PLATFORM/0032-MASTG-TEST-0032.md) |
| MASTG-TEST-0033 | android | MASVS-PLATFORM | Testing for Java Objects Exposed Through WebViews | deprecated | L1,L2 | [`android/MASVS-PLATFORM/0033-MASTG-TEST-0033.md`](./android/MASVS-PLATFORM/0033-MASTG-TEST-0033.md) |
| MASTG-TEST-0034 | android | MASVS-CODE | Testing Object Persistence | deprecated | L1,L2 | [`android/MASVS-CODE/0034-MASTG-TEST-0034.md`](./android/MASVS-CODE/0034-MASTG-TEST-0034.md) |
| MASTG-TEST-0035 | android | MASVS-PLATFORM | Testing for Overlay Attacks | deprecated | L2 | [`android/MASVS-PLATFORM/0035-MASTG-TEST-0035.md`](./android/MASVS-PLATFORM/0035-MASTG-TEST-0035.md) |
| MASTG-TEST-0036 | android | MASVS-CODE | Testing Enforced Updating | deprecated | L2 | [`android/MASVS-CODE/0036-MASTG-TEST-0036.md`](./android/MASVS-CODE/0036-MASTG-TEST-0036.md) |
| MASTG-TEST-0037 | android | MASVS-PLATFORM | Testing WebViews Cleanup | deprecated | L2 | [`android/MASVS-PLATFORM/0037-MASTG-TEST-0037.md`](./android/MASVS-PLATFORM/0037-MASTG-TEST-0037.md) |
| MASTG-TEST-0038 | android | MASVS-RESILIENCE | Making Sure that the App is Properly Signed | deprecated | R | [`android/MASVS-RESILIENCE/0038-MASTG-TEST-0038.md`](./android/MASVS-RESILIENCE/0038-MASTG-TEST-0038.md) |
| MASTG-TEST-0039 | android | MASVS-RESILIENCE | Testing whether the App is Debuggable | deprecated | R | [`android/MASVS-RESILIENCE/0039-MASTG-TEST-0039.md`](./android/MASVS-RESILIENCE/0039-MASTG-TEST-0039.md) |
| MASTG-TEST-0040 | android | MASVS-RESILIENCE | Testing for Debugging Symbols | deprecated | R | [`android/MASVS-RESILIENCE/0040-MASTG-TEST-0040.md`](./android/MASVS-RESILIENCE/0040-MASTG-TEST-0040.md) |
| MASTG-TEST-0041 | android | MASVS-RESILIENCE | Testing for Debugging Code and Verbose Error Logging | deprecated | R | [`android/MASVS-RESILIENCE/0041-MASTG-TEST-0041.md`](./android/MASVS-RESILIENCE/0041-MASTG-TEST-0041.md) |
| MASTG-TEST-0042 | android | MASVS-CODE | Checking for Weaknesses in Third Party Libraries | deprecated | L1,L2 | [`android/MASVS-CODE/0042-MASTG-TEST-0042.md`](./android/MASVS-CODE/0042-MASTG-TEST-0042.md) |
| MASTG-TEST-0043 | android | MASVS-CODE | Memory Corruption Bugs | deprecated | L1,L2 | [`android/MASVS-CODE/0043-MASTG-TEST-0043.md`](./android/MASVS-CODE/0043-MASTG-TEST-0043.md) |
| MASTG-TEST-0044 | android | MASVS-CODE | Make Sure That Free Security Features Are Activated | deprecated | L1,L2 | [`android/MASVS-CODE/0044-MASTG-TEST-0044.md`](./android/MASVS-CODE/0044-MASTG-TEST-0044.md) |
| MASTG-TEST-0045 | android | MASVS-RESILIENCE | Testing Root Detection | deprecated | R | [`android/MASVS-RESILIENCE/0045-MASTG-TEST-0045.md`](./android/MASVS-RESILIENCE/0045-MASTG-TEST-0045.md) |
| MASTG-TEST-0046 | android | MASVS-RESILIENCE | Testing Anti-Debugging Detection | deprecated | R | [`android/MASVS-RESILIENCE/0046-MASTG-TEST-0046.md`](./android/MASVS-RESILIENCE/0046-MASTG-TEST-0046.md) |
| MASTG-TEST-0047 | android | MASVS-RESILIENCE | Testing File Integrity Checks | deprecated | R | [`android/MASVS-RESILIENCE/0047-MASTG-TEST-0047.md`](./android/MASVS-RESILIENCE/0047-MASTG-TEST-0047.md) |
| MASTG-TEST-0048 | android | MASVS-RESILIENCE | Testing Reverse Engineering Tools Detection | deprecated | R | [`android/MASVS-RESILIENCE/0048-MASTG-TEST-0048.md`](./android/MASVS-RESILIENCE/0048-MASTG-TEST-0048.md) |
| MASTG-TEST-0049 | android | MASVS-RESILIENCE | Testing Emulator Detection | deprecated | R | [`android/MASVS-RESILIENCE/0049-MASTG-TEST-0049.md`](./android/MASVS-RESILIENCE/0049-MASTG-TEST-0049.md) |
| MASTG-TEST-0050 | android | MASVS-RESILIENCE | Testing Runtime Integrity Checks | deprecated | R | [`android/MASVS-RESILIENCE/0050-MASTG-TEST-0050.md`](./android/MASVS-RESILIENCE/0050-MASTG-TEST-0050.md) |
| MASTG-TEST-0051 | android | MASVS-RESILIENCE | Testing Obfuscation | deprecated | R | [`android/MASVS-RESILIENCE/0051-MASTG-TEST-0051.md`](./android/MASVS-RESILIENCE/0051-MASTG-TEST-0051.md) |
| MASTG-TEST-0052 | ios | MASVS-STORAGE | Testing Local Data Storage | deprecated | L1,L2 | [`ios/MASVS-STORAGE/0052-MASTG-TEST-0052.md`](./ios/MASVS-STORAGE/0052-MASTG-TEST-0052.md) |
| MASTG-TEST-0053 | ios | MASVS-STORAGE | Checking Logs for Sensitive Data | deprecated | L1,L2 | [`ios/MASVS-STORAGE/0053-MASTG-TEST-0053.md`](./ios/MASVS-STORAGE/0053-MASTG-TEST-0053.md) |
| MASTG-TEST-0054 | ios | MASVS-STORAGE | Determining Whether Sensitive Data Is Shared with Third Parties | deprecated | L1,L2 | [`ios/MASVS-STORAGE/0054-MASTG-TEST-0054.md`](./ios/MASVS-STORAGE/0054-MASTG-TEST-0054.md) |
| MASTG-TEST-0055 | ios | MASVS-STORAGE | Finding Sensitive Data in the Keyboard Cache | deprecated | L1,L2 | [`ios/MASVS-STORAGE/0055-MASTG-TEST-0055.md`](./ios/MASVS-STORAGE/0055-MASTG-TEST-0055.md) |
| MASTG-TEST-0056 | ios | MASVS-PLATFORM | Determining Whether Sensitive Data Is Exposed via IPC Mechanisms | deprecated | L1,L2 | [`ios/MASVS-PLATFORM/0056-MASTG-TEST-0056.md`](./ios/MASVS-PLATFORM/0056-MASTG-TEST-0056.md) |
| MASTG-TEST-0057 | ios | MASVS-PLATFORM | Checking for Sensitive Data Disclosed Through the User Interface | deprecated | L2 | [`ios/MASVS-PLATFORM/0057-MASTG-TEST-0057.md`](./ios/MASVS-PLATFORM/0057-MASTG-TEST-0057.md) |
| MASTG-TEST-0058 | ios | MASVS-STORAGE | Testing Backups for Sensitive Data | deprecated | L1,L2 | [`ios/MASVS-STORAGE/0058-MASTG-TEST-0058.md`](./ios/MASVS-STORAGE/0058-MASTG-TEST-0058.md) |
| MASTG-TEST-0059 | ios | MASVS-PLATFORM | Testing Auto-Generated Screenshots for Sensitive Information | deprecated | L2 | [`ios/MASVS-PLATFORM/0059-MASTG-TEST-0059.md`](./ios/MASVS-PLATFORM/0059-MASTG-TEST-0059.md) |
| MASTG-TEST-0060 | ios | MASVS-STORAGE | Testing Memory for Sensitive Data | deprecated | L2 | [`ios/MASVS-STORAGE/0060-MASTG-TEST-0060.md`](./ios/MASVS-STORAGE/0060-MASTG-TEST-0060.md) |
| MASTG-TEST-0061 | ios | MASVS-CRYPTO | Verifying the Configuration of Cryptographic Standard Algorithms | deprecated | L1,L2 | [`ios/MASVS-CRYPTO/0061-MASTG-TEST-0061.md`](./ios/MASVS-CRYPTO/0061-MASTG-TEST-0061.md) |
| MASTG-TEST-0062 | ios | MASVS-CRYPTO | Testing Key Management | deprecated | L2 | [`ios/MASVS-CRYPTO/0062-MASTG-TEST-0062.md`](./ios/MASVS-CRYPTO/0062-MASTG-TEST-0062.md) |
| MASTG-TEST-0063 | ios | MASVS-CRYPTO | Testing Random Number Generation | deprecated | L1,L2 | [`ios/MASVS-CRYPTO/0063-MASTG-TEST-0063.md`](./ios/MASVS-CRYPTO/0063-MASTG-TEST-0063.md) |
| MASTG-TEST-0064 | ios | MASVS-AUTH | Testing Biometric Authentication | deprecated | L2 | [`ios/MASVS-AUTH/0064-MASTG-TEST-0064.md`](./ios/MASVS-AUTH/0064-MASTG-TEST-0064.md) |
| MASTG-TEST-0065 | ios | MASVS-NETWORK | Testing Data Encryption on the Network | deprecated | L1,L2 | [`ios/MASVS-NETWORK/0065-MASTG-TEST-0065.md`](./ios/MASVS-NETWORK/0065-MASTG-TEST-0065.md) |
| MASTG-TEST-0066 | ios | MASVS-NETWORK | Testing the TLS Settings | deprecated | L1,L2 | [`ios/MASVS-NETWORK/0066-MASTG-TEST-0066.md`](./ios/MASVS-NETWORK/0066-MASTG-TEST-0066.md) |
| MASTG-TEST-0067 | ios | MASVS-NETWORK | Testing Endpoint Identity Verification | deprecated | L1,L2 | [`ios/MASVS-NETWORK/0067-MASTG-TEST-0067.md`](./ios/MASVS-NETWORK/0067-MASTG-TEST-0067.md) |
| MASTG-TEST-0068 | ios | MASVS-NETWORK | Testing Custom Certificate Stores and Certificate Pinning | deprecated | L2 | [`ios/MASVS-NETWORK/0068-MASTG-TEST-0068.md`](./ios/MASVS-NETWORK/0068-MASTG-TEST-0068.md) |
| MASTG-TEST-0069 | ios | MASVS-PLATFORM | Testing App Permissions | deprecated | L1,L2 | [`ios/MASVS-PLATFORM/0069-MASTG-TEST-0069.md`](./ios/MASVS-PLATFORM/0069-MASTG-TEST-0069.md) |
| MASTG-TEST-0070 | ios | MASVS-PLATFORM | Testing Universal Links | deprecated | L1,L2 | [`ios/MASVS-PLATFORM/0070-MASTG-TEST-0070.md`](./ios/MASVS-PLATFORM/0070-MASTG-TEST-0070.md) |
| MASTG-TEST-0071 | ios | MASVS-PLATFORM | Testing UIActivity Sharing | deprecated | L1,L2 | [`ios/MASVS-PLATFORM/0071-MASTG-TEST-0071.md`](./ios/MASVS-PLATFORM/0071-MASTG-TEST-0071.md) |
| MASTG-TEST-0072 | ios | MASVS-PLATFORM | Testing App Extensions | deprecated | L1,L2 | [`ios/MASVS-PLATFORM/0072-MASTG-TEST-0072.md`](./ios/MASVS-PLATFORM/0072-MASTG-TEST-0072.md) |
| MASTG-TEST-0073 | ios | MASVS-PLATFORM | Testing UIPasteboard | deprecated | L1,L2 | [`ios/MASVS-PLATFORM/0073-MASTG-TEST-0073.md`](./ios/MASVS-PLATFORM/0073-MASTG-TEST-0073.md) |
| MASTG-TEST-0075 | ios | MASVS-PLATFORM | Testing Custom URL Schemes | deprecated | L1,L2 | [`ios/MASVS-PLATFORM/0075-MASTG-TEST-0075.md`](./ios/MASVS-PLATFORM/0075-MASTG-TEST-0075.md) |
| MASTG-TEST-0076 | ios | MASVS-PLATFORM | Testing iOS WebViews | deprecated | L1,L2 | [`ios/MASVS-PLATFORM/0076-MASTG-TEST-0076.md`](./ios/MASVS-PLATFORM/0076-MASTG-TEST-0076.md) |
| MASTG-TEST-0077 | ios | MASVS-PLATFORM | Testing WebView Protocol Handlers | deprecated | L1,L2 | [`ios/MASVS-PLATFORM/0077-MASTG-TEST-0077.md`](./ios/MASVS-PLATFORM/0077-MASTG-TEST-0077.md) |
| MASTG-TEST-0078 | ios | MASVS-PLATFORM | Determining Whether Native Methods Are Exposed Through WebViews | deprecated | L1,L2 | [`ios/MASVS-PLATFORM/0078-MASTG-TEST-0078.md`](./ios/MASVS-PLATFORM/0078-MASTG-TEST-0078.md) |
| MASTG-TEST-0079 | ios | MASVS-CODE | Testing Object Persistence | deprecated | L1,L2 | [`ios/MASVS-CODE/0079-MASTG-TEST-0079.md`](./ios/MASVS-CODE/0079-MASTG-TEST-0079.md) |
| MASTG-TEST-0080 | ios | MASVS-CODE | Testing Enforced Updating | deprecated | L2 | [`ios/MASVS-CODE/0080-MASTG-TEST-0080.md`](./ios/MASVS-CODE/0080-MASTG-TEST-0080.md) |
| MASTG-TEST-0081 | ios | MASVS-RESILIENCE | Making Sure that the App Is Properly Signed | deprecated | R | [`ios/MASVS-RESILIENCE/0081-MASTG-TEST-0081.md`](./ios/MASVS-RESILIENCE/0081-MASTG-TEST-0081.md) |
| MASTG-TEST-0082 | ios | MASVS-RESILIENCE | Testing whether the App is Debuggable | deprecated | R | [`ios/MASVS-RESILIENCE/0082-MASTG-TEST-0082.md`](./ios/MASVS-RESILIENCE/0082-MASTG-TEST-0082.md) |
| MASTG-TEST-0083 | ios | MASVS-RESILIENCE | Testing for Debugging Symbols | deprecated | R | [`ios/MASVS-RESILIENCE/0083-MASTG-TEST-0083.md`](./ios/MASVS-RESILIENCE/0083-MASTG-TEST-0083.md) |
| MASTG-TEST-0084 | ios | MASVS-RESILIENCE | Testing for Debugging Code and Verbose Error Logging | deprecated | R | [`ios/MASVS-RESILIENCE/0084-MASTG-TEST-0084.md`](./ios/MASVS-RESILIENCE/0084-MASTG-TEST-0084.md) |
| MASTG-TEST-0085 | ios | MASVS-CODE | Checking for Weaknesses in Third Party Libraries | deprecated | L1,L2 | [`ios/MASVS-CODE/0085-MASTG-TEST-0085.md`](./ios/MASVS-CODE/0085-MASTG-TEST-0085.md) |
| MASTG-TEST-0086 | ios | MASVS-CODE | Memory Corruption Bugs | deprecated | L1,L2 | [`ios/MASVS-CODE/0086-MASTG-TEST-0086.md`](./ios/MASVS-CODE/0086-MASTG-TEST-0086.md) |
| MASTG-TEST-0087 | ios | MASVS-CODE | Make Sure That Free Security Features Are Activated | deprecated | L1,L2 | [`ios/MASVS-CODE/0087-MASTG-TEST-0087.md`](./ios/MASVS-CODE/0087-MASTG-TEST-0087.md) |
| MASTG-TEST-0088 | ios | MASVS-RESILIENCE | Testing Jailbreak Detection | deprecated | R | [`ios/MASVS-RESILIENCE/0088-MASTG-TEST-0088.md`](./ios/MASVS-RESILIENCE/0088-MASTG-TEST-0088.md) |
| MASTG-TEST-0089 | ios | MASVS-RESILIENCE | Testing Anti-Debugging Detection | deprecated | R | [`ios/MASVS-RESILIENCE/0089-MASTG-TEST-0089.md`](./ios/MASVS-RESILIENCE/0089-MASTG-TEST-0089.md) |
| MASTG-TEST-0090 | ios | MASVS-RESILIENCE | Testing File Integrity Checks | deprecated | R | [`ios/MASVS-RESILIENCE/0090-MASTG-TEST-0090.md`](./ios/MASVS-RESILIENCE/0090-MASTG-TEST-0090.md) |
| MASTG-TEST-0091 | ios | MASVS-RESILIENCE | Testing Reverse Engineering Tools Detection | deprecated | R | [`ios/MASVS-RESILIENCE/0091-MASTG-TEST-0091.md`](./ios/MASVS-RESILIENCE/0091-MASTG-TEST-0091.md) |
| MASTG-TEST-0092 | ios | MASVS-RESILIENCE | Testing Emulator Detection | deprecated | R | [`ios/MASVS-RESILIENCE/0092-MASTG-TEST-0092.md`](./ios/MASVS-RESILIENCE/0092-MASTG-TEST-0092.md) |
| MASTG-TEST-0093 | ios | MASVS-RESILIENCE | Testing Obfuscation | deprecated | R | [`ios/MASVS-RESILIENCE/0093-MASTG-TEST-0093.md`](./ios/MASVS-RESILIENCE/0093-MASTG-TEST-0093.md) |
| MASTG-TEST-0200 | android | MASVS-STORAGE | Files Written to External Storage | current | L1,L2 | [`android/MASVS-STORAGE/0200-MASTG-TEST-0200.md`](./android/MASVS-STORAGE/0200-MASTG-TEST-0200.md) |
| MASTG-TEST-0201 | android | MASVS-STORAGE | Runtime Use of APIs to Access External Storage | current | L1,L2 | [`android/MASVS-STORAGE/0201-MASTG-TEST-0201.md`](./android/MASVS-STORAGE/0201-MASTG-TEST-0201.md) |
| MASTG-TEST-0202 | android | MASVS-STORAGE | References to APIs and Permissions for Accessing External Storage | current | L1,L2 | [`android/MASVS-STORAGE/0202-MASTG-TEST-0202.md`](./android/MASVS-STORAGE/0202-MASTG-TEST-0202.md) |
| MASTG-TEST-0203 | android | MASVS-STORAGE | Runtime Use of Logging APIs | current | L1,L2,P | [`android/MASVS-STORAGE/0203-MASTG-TEST-0203.md`](./android/MASVS-STORAGE/0203-MASTG-TEST-0203.md) |
| MASTG-TEST-0204 | android | MASVS-CRYPTO | Insecure Random API Usage | current | L1,L2 | [`android/MASVS-CRYPTO/0204-MASTG-TEST-0204.md`](./android/MASVS-CRYPTO/0204-MASTG-TEST-0204.md) |
| MASTG-TEST-0205 | android | MASVS-CRYPTO | Non-random Sources Usage | current | L1,L2 | [`android/MASVS-CRYPTO/0205-MASTG-TEST-0205.md`](./android/MASVS-CRYPTO/0205-MASTG-TEST-0205.md) |
| MASTG-TEST-0206 | android | MASVS-PRIVACY | Undeclared PII in Network Traffic Capture | current | P | [`android/MASVS-PRIVACY/0206-MASTG-TEST-0206.md`](./android/MASVS-PRIVACY/0206-MASTG-TEST-0206.md) |
| MASTG-TEST-0207 | android | MASVS-STORAGE | Runtime Storage of Unencrypted Data in the App Sandbox | current | L2 | [`android/MASVS-STORAGE/0207-MASTG-TEST-0207.md`](./android/MASVS-STORAGE/0207-MASTG-TEST-0207.md) |
| MASTG-TEST-0208 | android | MASVS-CRYPTO | Insufficient Key Sizes | current | L1,L2 | [`android/MASVS-CRYPTO/0208-MASTG-TEST-0208.md`](./android/MASVS-CRYPTO/0208-MASTG-TEST-0208.md) |
| MASTG-TEST-0209 | ios | MASVS-CRYPTO | Insufficient Key Sizes | current | L1,L2 | [`ios/MASVS-CRYPTO/0209-MASTG-TEST-0209.md`](./ios/MASVS-CRYPTO/0209-MASTG-TEST-0209.md) |
| MASTG-TEST-0210 | ios | MASVS-CRYPTO | Broken Symmetric Encryption Algorithms | current | L1,L2 | [`ios/MASVS-CRYPTO/0210-MASTG-TEST-0210.md`](./ios/MASVS-CRYPTO/0210-MASTG-TEST-0210.md) |
| MASTG-TEST-0211 | ios | MASVS-CRYPTO | Broken Hashing Algorithms | current | L1,L2 | [`ios/MASVS-CRYPTO/0211-MASTG-TEST-0211.md`](./ios/MASVS-CRYPTO/0211-MASTG-TEST-0211.md) |
| MASTG-TEST-0212 | android | MASVS-CRYPTO | Use of Hardcoded Cryptographic Keys in Code | current | L1,L2 | [`android/MASVS-CRYPTO/0212-MASTG-TEST-0212.md`](./android/MASVS-CRYPTO/0212-MASTG-TEST-0212.md) |
| MASTG-TEST-0213 | ios | MASVS-CRYPTO | Use of Hardcoded Cryptographic Keys in Code | current | L1,L2 | [`ios/MASVS-CRYPTO/0213-MASTG-TEST-0213.md`](./ios/MASVS-CRYPTO/0213-MASTG-TEST-0213.md) |
| MASTG-TEST-0214 | ios | MASVS-CRYPTO | Hardcoded Cryptographic Keys in Files | current | L1,L2 | [`ios/MASVS-CRYPTO/0214-MASTG-TEST-0214.md`](./ios/MASVS-CRYPTO/0214-MASTG-TEST-0214.md) |
| MASTG-TEST-0215 | ios | MASVS-STORAGE | Sensitive Data Not Marked For Backup Exclusion | current | L1,L2,P | [`ios/MASVS-STORAGE/0215-MASTG-TEST-0215.md`](./ios/MASVS-STORAGE/0215-MASTG-TEST-0215.md) |
| MASTG-TEST-0216 | android | MASVS-STORAGE | Sensitive Data Not Excluded From Backup | current | L1,L2,P | [`android/MASVS-STORAGE/0216-MASTG-TEST-0216.md`](./android/MASVS-STORAGE/0216-MASTG-TEST-0216.md) |
| MASTG-TEST-0217 | android | MASVS-NETWORK | Insecure TLS Protocols Explicitly Allowed in Code | current | L1,L2 | [`android/MASVS-NETWORK/0217-MASTG-TEST-0217.md`](./android/MASVS-NETWORK/0217-MASTG-TEST-0217.md) |
| MASTG-TEST-0218 | android | MASVS-NETWORK | Insecure TLS Protocols in Network Traffic | current | L1,L2 | [`android/MASVS-NETWORK/0218-MASTG-TEST-0218.md`](./android/MASVS-NETWORK/0218-MASTG-TEST-0218.md) |
| MASTG-TEST-0219 | ios | MASVS-RESILIENCE | Testing for Debugging Symbols | current | R | [`ios/MASVS-RESILIENCE/0219-MASTG-TEST-0219.md`](./ios/MASVS-RESILIENCE/0219-MASTG-TEST-0219.md) |
| MASTG-TEST-0220 | ios | MASVS-RESILIENCE | Usage of Outdated Code Signature Format | current | R | [`ios/MASVS-RESILIENCE/0220-MASTG-TEST-0220.md`](./ios/MASVS-RESILIENCE/0220-MASTG-TEST-0220.md) |
| MASTG-TEST-0221 | android | MASVS-CRYPTO | Broken Symmetric Encryption Algorithms | current | L1,L2 | [`android/MASVS-CRYPTO/0221-MASTG-TEST-0221.md`](./android/MASVS-CRYPTO/0221-MASTG-TEST-0221.md) |
| MASTG-TEST-0222 | android | MASVS-CODE | Position Independent Code (PIC) Not Enabled | current | L2 | [`android/MASVS-CODE/0222-MASTG-TEST-0222.md`](./android/MASVS-CODE/0222-MASTG-TEST-0222.md) |
| MASTG-TEST-0223 | android | MASVS-CODE | Stack Canaries Not Enabled | current | L2 | [`android/MASVS-CODE/0223-MASTG-TEST-0223.md`](./android/MASVS-CODE/0223-MASTG-TEST-0223.md) |
| MASTG-TEST-0224 | android | MASVS-RESILIENCE | Usage of Insecure APK Signature Version | current | R | [`android/MASVS-RESILIENCE/0224-MASTG-TEST-0224.md`](./android/MASVS-RESILIENCE/0224-MASTG-TEST-0224.md) |
| MASTG-TEST-0225 | android | MASVS-RESILIENCE | Usage of Insecure APK Signature Key Size | current | R | [`android/MASVS-RESILIENCE/0225-MASTG-TEST-0225.md`](./android/MASVS-RESILIENCE/0225-MASTG-TEST-0225.md) |
| MASTG-TEST-0226 | android | MASVS-RESILIENCE | Debuggable Flag Enabled in the AndroidManifest | current | R | [`android/MASVS-RESILIENCE/0226-MASTG-TEST-0226.md`](./android/MASVS-RESILIENCE/0226-MASTG-TEST-0226.md) |
| MASTG-TEST-0227 | android | MASVS-RESILIENCE | Debugging Enabled for WebViews | current | R | [`android/MASVS-RESILIENCE/0227-MASTG-TEST-0227.md`](./android/MASVS-RESILIENCE/0227-MASTG-TEST-0227.md) |
| MASTG-TEST-0228 | ios | MASVS-CODE | Position Independent Code (PIC) not Enabled | current | L2 | [`ios/MASVS-CODE/0228-MASTG-TEST-0228.md`](./ios/MASVS-CODE/0228-MASTG-TEST-0228.md) |
| MASTG-TEST-0229 | ios | MASVS-CODE | Stack Canaries Not enabled | current | L2 | [`ios/MASVS-CODE/0229-MASTG-TEST-0229.md`](./ios/MASVS-CODE/0229-MASTG-TEST-0229.md) |
| MASTG-TEST-0230 | ios | MASVS-CODE | Automatic Reference Counting (ARC) not enabled | current | L2 | [`ios/MASVS-CODE/0230-MASTG-TEST-0230.md`](./ios/MASVS-CODE/0230-MASTG-TEST-0230.md) |
| MASTG-TEST-0231 | android | MASVS-STORAGE | References to Logging APIs | current | L1,L2,P | [`android/MASVS-STORAGE/0231-MASTG-TEST-0231.md`](./android/MASVS-STORAGE/0231-MASTG-TEST-0231.md) |
| MASTG-TEST-0232 | android | MASVS-CRYPTO | Broken Symmetric Encryption Modes | current | L1,L2 | [`android/MASVS-CRYPTO/0232-MASTG-TEST-0232.md`](./android/MASVS-CRYPTO/0232-MASTG-TEST-0232.md) |
| MASTG-TEST-0233 | android | MASVS-NETWORK | Hardcoded HTTP URLs | current | L1,L2 | [`android/MASVS-NETWORK/0233-MASTG-TEST-0233.md`](./android/MASVS-NETWORK/0233-MASTG-TEST-0233.md) |
| MASTG-TEST-0234 | android | MASVS-NETWORK | Missing Implementation of Server Hostname Verification with SSLSockets | current | L1,L2 | [`android/MASVS-NETWORK/0234-MASTG-TEST-0234.md`](./android/MASVS-NETWORK/0234-MASTG-TEST-0234.md) |
| MASTG-TEST-0235 | android | MASVS-NETWORK | Android App Configurations Allowing Cleartext Traffic | current | L1,L2 | [`android/MASVS-NETWORK/0235-MASTG-TEST-0235.md`](./android/MASVS-NETWORK/0235-MASTG-TEST-0235.md) |
| MASTG-TEST-0236 | android | MASVS-NETWORK | Cleartext Traffic Observed on the Network | current | L1,L2 | [`network/MASVS-NETWORK/0236-MASTG-TEST-0236.md`](./android/MASVS-NETWORK/0236-MASTG-TEST-0236.md) |
| MASTG-TEST-0237 | android | MASVS-NETWORK | Cross-Platform Framework Configurations Allowing Cleartext Traffic | placeholder | L1,L2 | [`android/MASVS-NETWORK/0237-MASTG-TEST-0237.md`](./android/MASVS-NETWORK/0237-MASTG-TEST-0237.md) |
| MASTG-TEST-0238 | android | MASVS-NETWORK | Runtime Use of Network APIs Transmitting Cleartext Traffic | placeholder | L1,L2 | [`android/MASVS-NETWORK/0238-MASTG-TEST-0238.md`](./android/MASVS-NETWORK/0238-MASTG-TEST-0238.md) |
| MASTG-TEST-0239 | android | MASVS-NETWORK | Using low-level APIs (e.g. Socket) to set up a custom HTTP connection | placeholder | L1,L2 | [`android/MASVS-NETWORK/0239-MASTG-TEST-0239.md`](./android/MASVS-NETWORK/0239-MASTG-TEST-0239.md) |
| MASTG-TEST-0240 | ios | MASVS-RESILIENCE | Jailbreak Detection in Code | current | R | [`ios/MASVS-RESILIENCE/0240-MASTG-TEST-0240.md`](./ios/MASVS-RESILIENCE/0240-MASTG-TEST-0240.md) |
| MASTG-TEST-0241 | ios | MASVS-RESILIENCE | Runtime Use of Jailbreak Detection Techniques | current | R | [`ios/MASVS-RESILIENCE/0241-MASTG-TEST-0241.md`](./ios/MASVS-RESILIENCE/0241-MASTG-TEST-0241.md) |
| MASTG-TEST-0242 | android | MASVS-NETWORK | Missing Certificate Pinning in Network Security Configuration | current | L2 | [`android/MASVS-NETWORK/0242-MASTG-TEST-0242.md`](./android/MASVS-NETWORK/0242-MASTG-TEST-0242.md) |
| MASTG-TEST-0243 | android | MASVS-NETWORK | Expired Certificate Pins in the Network Security Configuration | current | L2 | [`android/MASVS-NETWORK/0243-MASTG-TEST-0243.md`](./android/MASVS-NETWORK/0243-MASTG-TEST-0243.md) |
| MASTG-TEST-0244 | android | MASVS-NETWORK | Missing Certificate Pinning in Network Traffic | current | L2 | [`network/MASVS-NETWORK/0244-MASTG-TEST-0244.md`](./android/MASVS-NETWORK/0244-MASTG-TEST-0244.md) |
| MASTG-TEST-0245 | android | MASVS-CODE | References to Platform Version APIs | current | L2 | [`android/MASVS-CODE/0245-MASTG-TEST-0245.md`](./android/MASVS-CODE/0245-MASTG-TEST-0245.md) |
| MASTG-TEST-0246 | ios | MASVS-RESILIENCE | Runtime Use of Secure Screen Lock Detection APIs | current | L2 | [`ios/MASVS-RESILIENCE/0246-MASTG-TEST-0246.md`](./ios/MASVS-RESILIENCE/0246-MASTG-TEST-0246.md) |
| MASTG-TEST-0247 | android | MASVS-RESILIENCE | References to APIs for Detecting Secure Screen Lock | current | L2 | [`android/MASVS-RESILIENCE/0247-MASTG-TEST-0247.md`](./android/MASVS-RESILIENCE/0247-MASTG-TEST-0247.md) |
| MASTG-TEST-0248 | ios | MASVS-RESILIENCE | References to APIs for Detecting Secure Screen Lock | current | L2 | [`ios/MASVS-RESILIENCE/0248-MASTG-TEST-0248.md`](./ios/MASVS-RESILIENCE/0248-MASTG-TEST-0248.md) |
| MASTG-TEST-0249 | android | MASVS-RESILIENCE | Runtime Use of Secure Screen Lock Detection APIs | current | L2 | [`android/MASVS-RESILIENCE/0249-MASTG-TEST-0249.md`](./android/MASVS-RESILIENCE/0249-MASTG-TEST-0249.md) |
| MASTG-TEST-0250 | android | MASVS-PLATFORM | References to Content Provider Access in WebViews | current | L1,L2 | [`android/MASVS-PLATFORM/0250-MASTG-TEST-0250.md`](./android/MASVS-PLATFORM/0250-MASTG-TEST-0250.md) |
| MASTG-TEST-0251 | android | MASVS-PLATFORM | Runtime Use of Content Provider Access APIs in WebViews | current | L1,L2 | [`android/MASVS-PLATFORM/0251-MASTG-TEST-0251.md`](./android/MASVS-PLATFORM/0251-MASTG-TEST-0251.md) |
| MASTG-TEST-0252 | android | MASVS-PLATFORM | References to Local File Access in WebViews | current | L1,L2 | [`android/MASVS-PLATFORM/0252-MASTG-TEST-0252.md`](./android/MASVS-PLATFORM/0252-MASTG-TEST-0252.md) |
| MASTG-TEST-0253 | android | MASVS-PLATFORM | Runtime Use of Local File Access APIs in WebViews | current | L1,L2 | [`android/MASVS-PLATFORM/0253-MASTG-TEST-0253.md`](./android/MASVS-PLATFORM/0253-MASTG-TEST-0253.md) |
| MASTG-TEST-0254 | android | MASVS-PRIVACY | Dangerous App Permissions | current | P | [`android/MASVS-PRIVACY/0254-MASTG-TEST-0254.md`](./android/MASVS-PRIVACY/0254-MASTG-TEST-0254.md) |
| MASTG-TEST-0255 | android | MASVS-PRIVACY | Permission Requests Not Minimized | placeholder | P | [`android/MASVS-PRIVACY/0255-MASTG-TEST-0255.md`](./android/MASVS-PRIVACY/0255-MASTG-TEST-0255.md) |
| MASTG-TEST-0256 | android | MASVS-PRIVACY | Missing Permission Rationale | placeholder | P | [`android/MASVS-PRIVACY/0256-MASTG-TEST-0256.md`](./android/MASVS-PRIVACY/0256-MASTG-TEST-0256.md) |
| MASTG-TEST-0257 | android | MASVS-PRIVACY | Not Resetting Unused Permissions | placeholder | P | [`android/MASVS-PRIVACY/0257-MASTG-TEST-0257.md`](./android/MASVS-PRIVACY/0257-MASTG-TEST-0257.md) |
| MASTG-TEST-0258 | android | MASVS-PLATFORM | References to Keyboard Caching Attributes in UI Elements | current | L2 | [`android/MASVS-PLATFORM/0258-MASTG-TEST-0258.md`](./android/MASVS-PLATFORM/0258-MASTG-TEST-0258.md) |
| MASTG-TEST-0261 | ios | MASVS-RESILIENCE | Debuggable Entitlement Enabled in the entitlements.plist | current | R | [`ios/MASVS-RESILIENCE/0261-MASTG-TEST-0261.md`](./ios/MASVS-RESILIENCE/0261-MASTG-TEST-0261.md) |
| MASTG-TEST-0262 | android | MASVS-STORAGE | References to Backup Configurations Not Excluding Sensitive Data | current | L1,L2,P | [`android/MASVS-STORAGE/0262-MASTG-TEST-0262.md`](./android/MASVS-STORAGE/0262-MASTG-TEST-0262.md) |
| MASTG-TEST-0263 | android | MASVS-RESILIENCE | Logging of StrictMode Violations | current | R | [`android/MASVS-RESILIENCE/0263-MASTG-TEST-0263.md`](./android/MASVS-RESILIENCE/0263-MASTG-TEST-0263.md) |
| MASTG-TEST-0264 | android | MASVS-RESILIENCE | Runtime Use of StrictMode APIs | current | R | [`android/MASVS-RESILIENCE/0264-MASTG-TEST-0264.md`](./android/MASVS-RESILIENCE/0264-MASTG-TEST-0264.md) |
| MASTG-TEST-0265 | android | MASVS-RESILIENCE | References to StrictMode APIs | current | R | [`android/MASVS-RESILIENCE/0265-MASTG-TEST-0265.md`](./android/MASVS-RESILIENCE/0265-MASTG-TEST-0265.md) |
| MASTG-TEST-0266 | ios | MASVS-AUTH | References to APIs for Event-Bound Biometric Authentication | current | L2 | [`ios/MASVS-AUTH/0266-MASTG-TEST-0266.md`](./ios/MASVS-AUTH/0266-MASTG-TEST-0266.md) |
| MASTG-TEST-0267 | ios | MASVS-AUTH | Runtime Use Of Event-Bound Biometric Authentication | current | L2 | [`ios/MASVS-AUTH/0267-MASTG-TEST-0267.md`](./ios/MASVS-AUTH/0267-MASTG-TEST-0267.md) |
| MASTG-TEST-0268 | ios | MASVS-AUTH | References to APIs Allowing Fallback to Non-Biometric Authentication | current | L2 | [`ios/MASVS-AUTH/0268-MASTG-TEST-0268.md`](./ios/MASVS-AUTH/0268-MASTG-TEST-0268.md) |
| MASTG-TEST-0269 | ios | MASVS-AUTH | Runtime Use Of APIs Allowing Fallback to Non-Biometric Authentication | current | L2 | [`ios/MASVS-AUTH/0269-MASTG-TEST-0269.md`](./ios/MASVS-AUTH/0269-MASTG-TEST-0269.md) |
| MASTG-TEST-0270 | ios | MASVS-AUTH | References to APIs Detecting Biometric Enrollment Changes | current | L2 | [`ios/MASVS-AUTH/0270-MASTG-TEST-0270.md`](./ios/MASVS-AUTH/0270-MASTG-TEST-0270.md) |
| MASTG-TEST-0271 | ios | MASVS-AUTH | Runtime Use Of APIs Detecting Biometric Enrollment Changes | current | L2 | [`ios/MASVS-AUTH/0271-MASTG-TEST-0271.md`](./ios/MASVS-AUTH/0271-MASTG-TEST-0271.md) |
| MASTG-TEST-0272 | android | MASVS-CODE | Identify Dependencies with Known Vulnerabilities in the Android Project | current | L1,L2 | [`android/MASVS-CODE/0272-MASTG-TEST-0272.md`](./android/MASVS-CODE/0272-MASTG-TEST-0272.md) |
| MASTG-TEST-0273 | ios | MASVS-CODE | Identify Dependencies with Known Vulnerabilities by Scanning Dependency Managers Artifacts | current | L1,L2 | [`ios/MASVS-CODE/0273-MASTG-TEST-0273.md`](./ios/MASVS-CODE/0273-MASTG-TEST-0273.md) |
| MASTG-TEST-0274 | android | MASVS-CODE | Dependencies with Known Vulnerabilities in the App's SBOM | current | L1,L2 | [`android/MASVS-CODE/0274-MASTG-TEST-0274.md`](./android/MASVS-CODE/0274-MASTG-TEST-0274.md) |
| MASTG-TEST-0275 | ios | MASVS-CODE | Dependencies with Known Vulnerabilities in the App's SBOM | current | L1,L2 | [`ios/MASVS-CODE/0275-MASTG-TEST-0275.md`](./ios/MASVS-CODE/0275-MASTG-TEST-0275.md) |
| MASTG-TEST-0276 | ios | MASVS-PLATFORM | Use of the iOS General Pasteboard | current | L2 | [`ios/MASVS-PLATFORM/0276-MASTG-TEST-0276.md`](./ios/MASVS-PLATFORM/0276-MASTG-TEST-0276.md) |
| MASTG-TEST-0277 | ios | MASVS-PLATFORM | Sensitive Data in the iOS General Pasteboard at Runtime | current | L2 | [`ios/MASVS-PLATFORM/0277-MASTG-TEST-0277.md`](./ios/MASVS-PLATFORM/0277-MASTG-TEST-0277.md) |
| MASTG-TEST-0278 | ios | MASVS-PLATFORM | Pasteboard Contents Not Cleared After Use | current | L2 | [`ios/MASVS-PLATFORM/0278-MASTG-TEST-0278.md`](./ios/MASVS-PLATFORM/0278-MASTG-TEST-0278.md) |
| MASTG-TEST-0279 | ios | MASVS-PLATFORM | Pasteboard Contents Not Expiring | current | L2 | [`ios/MASVS-PLATFORM/0279-MASTG-TEST-0279.md`](./ios/MASVS-PLATFORM/0279-MASTG-TEST-0279.md) |
| MASTG-TEST-0280 | ios | MASVS-PLATFORM | Pasteboard Contents Not Restricted to Local Device | current | L2 | [`ios/MASVS-PLATFORM/0280-MASTG-TEST-0280.md`](./ios/MASVS-PLATFORM/0280-MASTG-TEST-0280.md) |
| MASTG-TEST-0281 | ios | MASVS-PRIVACY | Undeclared Known Tracking Domains | current | P | [`ios/MASVS-PRIVACY/0281-MASTG-TEST-0281.md`](./ios/MASVS-PRIVACY/0281-MASTG-TEST-0281.md) |
| MASTG-TEST-0282 | android | MASVS-NETWORK | Unsafe Custom Trust Evaluation | current | L1,L2 | [`android/MASVS-NETWORK/0282-MASTG-TEST-0282.md`](./android/MASVS-NETWORK/0282-MASTG-TEST-0282.md) |
| MASTG-TEST-0283 | android | MASVS-NETWORK | Incorrect Implementation of Server Hostname Verification | current | L1,L2 | [`android/MASVS-NETWORK/0283-MASTG-TEST-0283.md`](./android/MASVS-NETWORK/0283-MASTG-TEST-0283.md) |
| MASTG-TEST-0284 | android | MASVS-NETWORK | Incorrect SSL Error Handling in WebViews | current | L1,L2 | [`android/MASVS-NETWORK/0284-MASTG-TEST-0284.md`](./android/MASVS-NETWORK/0284-MASTG-TEST-0284.md) |
| MASTG-TEST-0285 | android | MASVS-NETWORK | Outdated Android Version Allowing Trust in User-Provided CAs | current | L1,L2 | [`android/MASVS-NETWORK/0285-MASTG-TEST-0285.md`](./android/MASVS-NETWORK/0285-MASTG-TEST-0285.md) |
| MASTG-TEST-0286 | android | MASVS-NETWORK | Network Security Configuration Allowing Trust in User-Provided CAs | current | L1,L2 | [`android/MASVS-NETWORK/0286-MASTG-TEST-0286.md`](./android/MASVS-NETWORK/0286-MASTG-TEST-0286.md) |
| MASTG-TEST-0287 | android | MASVS-STORAGE | Runtime Storage of Unencrypted Data via the SharedPreferences API | current | L1,L2 | [`android/MASVS-STORAGE/0287-MASTG-TEST-0287.md`](./android/MASVS-STORAGE/0287-MASTG-TEST-0287.md) |
| MASTG-TEST-0288 | android | MASVS-RESILIENCE | Debugging Symbols in Native Binaries | current | R | [`android/MASVS-RESILIENCE/0288-MASTG-TEST-0288.md`](./android/MASVS-RESILIENCE/0288-MASTG-TEST-0288.md) |
| MASTG-TEST-0289 | android | MASVS-PLATFORM | Runtime Verification of Sensitive Content Exposure in Screenshots During App Backgrounding | current | L2 | [`android/MASVS-PLATFORM/0289-MASTG-TEST-0289.md`](./android/MASVS-PLATFORM/0289-MASTG-TEST-0289.md) |
| MASTG-TEST-0290 | ios | MASVS-PLATFORM | Runtime Verification of Sensitive Content Exposure in Screenshots During App Backgrounding | current | L2 | [`ios/MASVS-PLATFORM/0290-MASTG-TEST-0290.md`](./ios/MASVS-PLATFORM/0290-MASTG-TEST-0290.md) |
| MASTG-TEST-0291 | android | MASVS-PLATFORM | References to Screen Capturing Prevention APIs | current | L2 | [`android/MASVS-PLATFORM/0291-MASTG-TEST-0291.md`](./android/MASVS-PLATFORM/0291-MASTG-TEST-0291.md) |
| MASTG-TEST-0292 | android | MASVS-PLATFORM | `setRecentsScreenshotEnabled` Not Used to Prevent Screenshots When Backgrounded | placeholder | L2 | [`android/MASVS-PLATFORM/0292-MASTG-TEST-0292.md`](./android/MASVS-PLATFORM/0292-MASTG-TEST-0292.md) |
| MASTG-TEST-0293 | android | MASVS-PLATFORM | `setSecure` Not Used to Prevent Screenshots in SurfaceViews | placeholder | L2 | [`android/MASVS-PLATFORM/0293-MASTG-TEST-0293.md`](./android/MASVS-PLATFORM/0293-MASTG-TEST-0293.md) |
| MASTG-TEST-0294 | android | MASVS-PLATFORM | `SecureOn` Not Used to Prevent Screenshots in Compose Dialogs | placeholder | L2 | [`android/MASVS-PLATFORM/0294-MASTG-TEST-0294.md`](./android/MASVS-PLATFORM/0294-MASTG-TEST-0294.md) |
| MASTG-TEST-0295 | android | MASVS-NETWORK | GMS Security Provider Not Updated | current | L2 | [`android/MASVS-NETWORK/0295-MASTG-TEST-0295.md`](./android/MASVS-NETWORK/0295-MASTG-TEST-0295.md) |
| MASTG-TEST-0296 | ios | MASVS-STORAGE | Sensitive Data Exposure in Logs | current | L1,L2 | [`ios/MASVS-STORAGE/0296-MASTG-TEST-0296.md`](./ios/MASVS-STORAGE/0296-MASTG-TEST-0296.md) |
| MASTG-TEST-0297 | ios | MASVS-STORAGE | Sensitive Data Exposure Through Logging APIs | current | L1,L2 | [`ios/MASVS-STORAGE/0297-MASTG-TEST-0297.md`](./ios/MASVS-STORAGE/0297-MASTG-TEST-0297.md) |
| MASTG-TEST-0298 | ios | MASVS-STORAGE | Runtime Monitoring of Files Eligible for Backup | current | L1,L2,P | [`ios/MASVS-STORAGE/0298-MASTG-TEST-0298.md`](./ios/MASVS-STORAGE/0298-MASTG-TEST-0298.md) |
| MASTG-TEST-0299 | ios | MASVS-STORAGE | Data Protection Classes for Files in Private Storage | current | L1 | [`ios/MASVS-STORAGE/0299-MASTG-TEST-0299.md`](./ios/MASVS-STORAGE/0299-MASTG-TEST-0299.md) |
| MASTG-TEST-0300 | ios | MASVS-STORAGE | References to APIs for Storing Unencrypted Data in Private Storage | current | L2 | [`ios/MASVS-STORAGE/0300-MASTG-TEST-0300.md`](./ios/MASVS-STORAGE/0300-MASTG-TEST-0300.md) |
| MASTG-TEST-0301 | ios | MASVS-STORAGE | Runtime Use of APIs for Storing Unencrypted Data in Private Storage | current | L2 | [`ios/MASVS-STORAGE/0301-MASTG-TEST-0301.md`](./ios/MASVS-STORAGE/0301-MASTG-TEST-0301.md) |
| MASTG-TEST-0302 | ios | MASVS-STORAGE | Sensitive Data Unencrypted in Private Storage Files | current | L2 | [`ios/MASVS-STORAGE/0302-MASTG-TEST-0302.md`](./ios/MASVS-STORAGE/0302-MASTG-TEST-0302.md) |
| MASTG-TEST-0303 | ios | MASVS-STORAGE | References to APIs for Storing Unencrypted Data in Shared Storage | current | L1,L2 | [`ios/MASVS-STORAGE/0303-MASTG-TEST-0303.md`](./ios/MASVS-STORAGE/0303-MASTG-TEST-0303.md) |
| MASTG-TEST-0304 | android | MASVS-STORAGE | References to Sensitive Data Unencrypted via Android Room Database | placeholder | L1,L2 | [`android/MASVS-STORAGE/0304-MASTG-TEST-0304.md`](./android/MASVS-STORAGE/0304-MASTG-TEST-0304.md) |
| MASTG-TEST-0305 | android | MASVS-STORAGE | Sensitive Data Stored Unencrypted via DataStore | placeholder | L1,L2 | [`android/MASVS-STORAGE/0305-MASTG-TEST-0305.md`](./android/MASVS-STORAGE/0305-MASTG-TEST-0305.md) |
| MASTG-TEST-0306 | android | MASVS-STORAGE | References to Sensitive Data Stored Unencrypted via Android Room DB | placeholder | L1,L2 | [`android/MASVS-STORAGE/0306-MASTG-TEST-0306.md`](./android/MASVS-STORAGE/0306-MASTG-TEST-0306.md) |
| MASTG-TEST-0307 | android | MASVS-CRYPTO | References to Asymmetric Key Pairs Used For Multiple Purposes | current | L2 | [`android/MASVS-CRYPTO/0307-MASTG-TEST-0307.md`](./android/MASVS-CRYPTO/0307-MASTG-TEST-0307.md) |
| MASTG-TEST-0308 | android | MASVS-CRYPTO | Runtime Use of Asymmetric Key Pairs Used For Multiple Purposes | current | L2 | [`android/MASVS-CRYPTO/0308-MASTG-TEST-0308.md`](./android/MASVS-CRYPTO/0308-MASTG-TEST-0308.md) |
| MASTG-TEST-0309 | android | MASVS-CRYPTO | References to Reused Initialization Vectors in Symmetric Encryption | placeholder | L2 | [`android/MASVS-CRYPTO/0309-MASTG-TEST-0309.md`](./android/MASVS-CRYPTO/0309-MASTG-TEST-0309.md) |
| MASTG-TEST-0310 | android | MASVS-CRYPTO | Runtime Use of Reused Initialization Vectors in Symmetric Encryption | placeholder | L2 | [`android/MASVS-CRYPTO/0310-MASTG-TEST-0310.md`](./android/MASVS-CRYPTO/0310-MASTG-TEST-0310.md) |
| MASTG-TEST-0311 | ios | MASVS-CRYPTO | Insecure Random API Usage | current | L1,L2 | [`ios/MASVS-CRYPTO/0311-MASTG-TEST-0311.md`](./ios/MASVS-CRYPTO/0311-MASTG-TEST-0311.md) |
| MASTG-TEST-0312 | android | MASVS-CRYPTO | References to Explicit Security Provider in Cryptographic APIs | current | L1,L2 | [`android/MASVS-CRYPTO/0312-MASTG-TEST-0312.md`](./android/MASVS-CRYPTO/0312-MASTG-TEST-0312.md) |
| MASTG-TEST-0313 | ios | MASVS-STORAGE | References to APIs for Preventing Keyboard Caching of Text Fields | current | L2 | [`ios/MASVS-STORAGE/0313-MASTG-TEST-0313.md`](./ios/MASVS-STORAGE/0313-MASTG-TEST-0313.md) |
| MASTG-TEST-0314 | ios | MASVS-STORAGE | Runtime Monitoring of Text Fields Eligible for Keyboard Caching | current | L2 | [`ios/MASVS-STORAGE/0314-MASTG-TEST-0314.md`](./ios/MASVS-STORAGE/0314-MASTG-TEST-0314.md) |
| MASTG-TEST-0315 | android | MASVS-PLATFORM | Sensitive Data Exposed via Notifications | current | L2 | [`android/MASVS-PLATFORM/0315-MASTG-TEST-0315.md`](./android/MASVS-PLATFORM/0315-MASTG-TEST-0315.md) |
| MASTG-TEST-0316 | android | MASVS-PLATFORM | App Exposing User Authentication Data in Text Input Fields | current | L2 | [`android/MASVS-PLATFORM/0316-MASTG-TEST-0316.md`](./android/MASVS-PLATFORM/0316-MASTG-TEST-0316.md) |
| MASTG-TEST-0317 | ios | MASVS-CRYPTO | Broken Symmetric Encryption Modes | current | L1,L2 | [`ios/MASVS-CRYPTO/0317-MASTG-TEST-0317.md`](./ios/MASVS-CRYPTO/0317-MASTG-TEST-0317.md) |
| MASTG-TEST-0318 | android | MASVS-PRIVACY | References to SDK APIs Known to Handle Sensitive User Data | current | P | [`android/MASVS-PRIVACY/0318-MASTG-TEST-0318.md`](./android/MASVS-PRIVACY/0318-MASTG-TEST-0318.md) |
| MASTG-TEST-0319 | android | MASVS-PRIVACY | Runtime Use of SDK APIs Known to Handle Sensitive User Data | current | P | [`android/MASVS-PRIVACY/0319-MASTG-TEST-0319.md`](./android/MASVS-PRIVACY/0319-MASTG-TEST-0319.md) |
| MASTG-TEST-0320 | android | MASVS-PLATFORM | WebViews Not Cleaning Up Sensitive Data | current | L1,L2 | [`android/MASVS-PLATFORM/0320-MASTG-TEST-0320.md`](./android/MASVS-PLATFORM/0320-MASTG-TEST-0320.md) |
| MASTG-TEST-0321 | ios | MASVS-NETWORK | Hardcoded HTTP URLs | current | L1,L2 | [`ios/MASVS-NETWORK/0321-MASTG-TEST-0321.md`](./ios/MASVS-NETWORK/0321-MASTG-TEST-0321.md) |
| MASTG-TEST-0322 | ios | MASVS-NETWORK | App Transport Security Configurations Allowing Cleartext Traffic | current | L1,L2 | [`ios/MASVS-NETWORK/0322-MASTG-TEST-0322.md`](./ios/MASVS-NETWORK/0322-MASTG-TEST-0322.md) |
| MASTG-TEST-0323 | ios | MASVS-NETWORK | Uses of Low-Level Networking APIs for Cleartext Traffic | current | L1,L2 | [`ios/MASVS-NETWORK/0323-MASTG-TEST-0323.md`](./ios/MASVS-NETWORK/0323-MASTG-TEST-0323.md) |
| MASTG-TEST-0324 | android | MASVS-RESILIENCE | References to Root Detection Mechanisms | current | R | [`android/MASVS-RESILIENCE/0324-MASTG-TEST-0324.md`](./android/MASVS-RESILIENCE/0324-MASTG-TEST-0324.md) |
| MASTG-TEST-0325 | android | MASVS-RESILIENCE | Runtime Use of Root Detection Techniques | current | R | [`android/MASVS-RESILIENCE/0325-MASTG-TEST-0325.md`](./android/MASVS-RESILIENCE/0325-MASTG-TEST-0325.md) |
| MASTG-TEST-0326 | android | MASVS-AUTH | References to APIs Allowing Fallback to Non-Biometric Authentication | current | L2 | [`android/MASVS-AUTH/0326-MASTG-TEST-0326.md`](./android/MASVS-AUTH/0326-MASTG-TEST-0326.md) |
| MASTG-TEST-0327 | android | MASVS-AUTH | References to APIs for Event-Bound Biometric Authentication | current | L2 | [`android/MASVS-AUTH/0327-MASTG-TEST-0327.md`](./android/MASVS-AUTH/0327-MASTG-TEST-0327.md) |
| MASTG-TEST-0328 | android | MASVS-AUTH | References to APIs Detecting Biometric Enrollment Changes | current | L2 | [`android/MASVS-AUTH/0328-MASTG-TEST-0328.md`](./android/MASVS-AUTH/0328-MASTG-TEST-0328.md) |
| MASTG-TEST-0329 | android | MASVS-AUTH | References to APIs Enforcing Authentication without Explicit User Action | current | L2 | [`android/MASVS-AUTH/0329-MASTG-TEST-0329.md`](./android/MASVS-AUTH/0329-MASTG-TEST-0329.md) |
| MASTG-TEST-0330 | android | MASVS-AUTH | References to APIs for Keys used in Biometric Authentication with Extended Validity Duration | current | L2 | [`android/MASVS-AUTH/0330-MASTG-TEST-0330.md`](./android/MASVS-AUTH/0330-MASTG-TEST-0330.md) |
| MASTG-TEST-0331 | ios | MASVS-PLATFORM | Use of Deprecated WebView APIs | current | L1,L2 | [`ios/MASVS-PLATFORM/0331-MASTG-TEST-0331.md`](./ios/MASVS-PLATFORM/0331-MASTG-TEST-0331.md) |
| MASTG-TEST-0332 | ios | MASVS-PLATFORM | Attacker-Controlled URI in WebViews | current | L1,L2,P | [`ios/MASVS-PLATFORM/0332-MASTG-TEST-0332.md`](./ios/MASVS-PLATFORM/0332-MASTG-TEST-0332.md) |
| MASTG-TEST-0333 | ios | MASVS-PLATFORM | Overly Broad File Read Access in WebViews | current | L1,L2 | [`ios/MASVS-PLATFORM/0333-MASTG-TEST-0333.md`](./ios/MASVS-PLATFORM/0333-MASTG-TEST-0333.md) |
| MASTG-TEST-0334 | android | MASVS-PLATFORM | Native Code Exposed Through WebViews | current | L1,L2 | [`android/MASVS-PLATFORM/0334-MASTG-TEST-0334.md`](./android/MASVS-PLATFORM/0334-MASTG-TEST-0334.md) |
| MASTG-TEST-0335 | ios | MASVS-PLATFORM | WebView File Origin Access Relaxed by Configuration | current | L1,L2 | [`ios/MASVS-PLATFORM/0335-MASTG-TEST-0335.md`](./ios/MASVS-PLATFORM/0335-MASTG-TEST-0335.md) |
| MASTG-TEST-0336 | ios | MASVS-PLATFORM | Runtime Setting of Relaxed WebView File Origin Policies | current | L1,L2 | [`ios/MASVS-PLATFORM/0336-MASTG-TEST-0336.md`](./ios/MASVS-PLATFORM/0336-MASTG-TEST-0336.md) |
| MASTG-TEST-0337 | android | MASVS-CODE | References to Object Deserialization of Untrusted Data | current | L1,L2 | [`android/MASVS-CODE/0337-MASTG-TEST-0337.md`](./android/MASVS-CODE/0337-MASTG-TEST-0337.md) |
| MASTG-TEST-0338 | android | MASVS-RESILIENCE | References to Storage Integrity Check APIs | current | R | [`android/MASVS-RESILIENCE/0338-MASTG-TEST-0338.md`](./android/MASVS-RESILIENCE/0338-MASTG-TEST-0338.md) |
| MASTG-TEST-0339 | android | MASVS-CODE | SQL Injection in Content Providers | current | L1,L2 | [`android/MASVS-CODE/0339-MASTG-TEST-0339.md`](./android/MASVS-CODE/0339-MASTG-TEST-0339.md) |
| MASTG-TEST-0340 | android | MASVS-PLATFORM | References to Overlay Attack Protections | current | L2 | [`android/MASVS-PLATFORM/0340-MASTG-TEST-0340.md`](./android/MASVS-PLATFORM/0340-MASTG-TEST-0340.md) |
| MASTG-TEST-0341 | android | MASVS-RESILIENCE | Runtime Use of Hook Detection Techniques | current | R | [`android/MASVS-RESILIENCE/0341-MASTG-TEST-0341.md`](./android/MASVS-RESILIENCE/0341-MASTG-TEST-0341.md) |
| MASTG-TEST-0342 | ios | MASVS-NETWORK | References to Weak ATS TLS Policy Exceptions in Info.plist | current | L1,L2 | [`ios/MASVS-NETWORK/0342-MASTG-TEST-0342.md`](./ios/MASVS-NETWORK/0342-MASTG-TEST-0342.md) |
| MASTG-TEST-0343 | ios | MASVS-NETWORK | URLSession TLS Protocol Configuration | current | L1,L2 | [`ios/MASVS-NETWORK/0343-MASTG-TEST-0343.md`](./ios/MASVS-NETWORK/0343-MASTG-TEST-0343.md) |
| MASTG-TEST-0344 | ios | MASVS-NETWORK | Network.framework TLS Protocol Configuration | current | L1,L2 | [`ios/MASVS-NETWORK/0344-MASTG-TEST-0344.md`](./ios/MASVS-NETWORK/0344-MASTG-TEST-0344.md) |
| MASTG-TEST-0345 | ios | MASVS-NETWORK | Embedded or Third-party TLS Stack Configuration | current | L1,L2 | [`ios/MASVS-NETWORK/0345-MASTG-TEST-0345.md`](./ios/MASVS-NETWORK/0345-MASTG-TEST-0345.md) |
| MASTG-TEST-0346 | ios | MASVS-PLATFORM | References to APIs Hiding Sensitive Data in Text Input Fields | current | L2 | [`ios/MASVS-PLATFORM/0346-MASTG-TEST-0346.md`](./ios/MASVS-PLATFORM/0346-MASTG-TEST-0346.md) |
| MASTG-TEST-0347 | ios | MASVS-PLATFORM | Runtime Use of APIs Hiding Sensitive Data in Text Input Fields | current | L2 | [`ios/MASVS-PLATFORM/0347-MASTG-TEST-0347.md`](./ios/MASVS-PLATFORM/0347-MASTG-TEST-0347.md) |
| MASTG-TEST-0348 | ios | MASVS-NETWORK | Insecure TLS Protocols in Network Traffic | current | L1,L2 | [`ios/MASVS-NETWORK/0348-MASTG-TEST-0348.md`](./ios/MASVS-NETWORK/0348-MASTG-TEST-0348.md) |
| MASTG-TEST-0349 | ios | MASVS-CRYPTO | Runtime Use of Insecure Random APIs | current | L1,L2 | [`ios/MASVS-CRYPTO/0349-MASTG-TEST-0349.md`](./ios/MASVS-CRYPTO/0349-MASTG-TEST-0349.md) |
| MASTG-TEST-0350 | android | MASVS-CRYPTO | Runtime Use of Broken Symmetric Encryption Modes | current | L1,L2 | [`android/MASVS-CRYPTO/0350-MASTG-TEST-0350.md`](./android/MASVS-CRYPTO/0350-MASTG-TEST-0350.md) |
| MASTG-TEST-0351 | android | MASVS-RESILIENCE | Runtime Use of Emulator Detection Techniques | current | R | [`android/MASVS-RESILIENCE/0351-MASTG-TEST-0351.md`](./android/MASVS-RESILIENCE/0351-MASTG-TEST-0351.md) |
| MASTG-TEST-0352 | android | MASVS-RESILIENCE | References to Debugging Detection APIs | current | R | [`android/MASVS-RESILIENCE/0352-MASTG-TEST-0352.md`](./android/MASVS-RESILIENCE/0352-MASTG-TEST-0352.md) |
| MASTG-TEST-0353 | android | MASVS-RESILIENCE | Runtime Use of Debugging Detection APIs | current | R | [`android/MASVS-RESILIENCE/0353-MASTG-TEST-0353.md`](./android/MASVS-RESILIENCE/0353-MASTG-TEST-0353.md) |
| MASTG-TEST-0354 | ios | MASVS-RESILIENCE | Runtime Use of Hook Detection Techniques | current | R | [`ios/MASVS-RESILIENCE/0354-MASTG-TEST-0354.md`](./ios/MASVS-RESILIENCE/0354-MASTG-TEST-0354.md) |
| MASTG-TEST-0355 | android | MASVS-PLATFORM | References to Unauthorized Database Access through Content Providers | current | L1,L2 | [`android/MASVS-PLATFORM/0355-MASTG-TEST-0355.md`](./android/MASVS-PLATFORM/0355-MASTG-TEST-0355.md) |
| MASTG-TEST-0356 | android | MASVS-PLATFORM | Runtime Verification of Unauthorized Database Access through Content Providers | current | L1,L2 | [`android/MASVS-PLATFORM/0356-MASTG-TEST-0356.md`](./android/MASVS-PLATFORM/0356-MASTG-TEST-0356.md) |
| MASTG-TEST-0357 | android | MASVS-PLATFORM | References to Oversharing of File-Based Content Providers | current | L1,L2 | [`android/MASVS-PLATFORM/0357-MASTG-TEST-0357.md`](./android/MASVS-PLATFORM/0357-MASTG-TEST-0357.md) |
| MASTG-TEST-0358 | ios | MASVS-RESILIENCE | Implementation Details Exposure Through Logging APIs | current | R | [`ios/MASVS-RESILIENCE/0358-MASTG-TEST-0358.md`](./ios/MASVS-RESILIENCE/0358-MASTG-TEST-0358.md) |
| MASTG-TEST-0359 | ios | MASVS-RESILIENCE | Implementation Details Exposure in Logs | current | R | [`ios/MASVS-RESILIENCE/0359-MASTG-TEST-0359.md`](./ios/MASVS-RESILIENCE/0359-MASTG-TEST-0359.md) |
| MASTG-TEST-0360 | ios | MASVS-PRIVACY | Purpose String Accuracy for Reachable Protected Resource Access | current | P | [`ios/MASVS-PRIVACY/0360-MASTG-TEST-0360.md`](./ios/MASVS-PRIVACY/0360-MASTG-TEST-0360.md) |
| MASTG-TEST-0361 | ios | MASVS-PRIVACY | Runtime Use of Protected Resource APIs Without Accurate Purpose Strings | current | P | [`ios/MASVS-PRIVACY/0361-MASTG-TEST-0361.md`](./ios/MASVS-PRIVACY/0361-MASTG-TEST-0361.md) |
| MASTG-TEST-0362 | ios | MASVS-PRIVACY | Entitlements for Unjustified Capability Exposure | current | P | [`ios/MASVS-PRIVACY/0362-MASTG-TEST-0362.md`](./ios/MASVS-PRIVACY/0362-MASTG-TEST-0362.md) |
| MASTG-TEST-0363 | ios | MASVS-PRIVACY | Runtime Use of Entitlement-Backed APIs for Unjustified Capability Exposure | current | P | [`ios/MASVS-PRIVACY/0363-MASTG-TEST-0363.md`](./ios/MASVS-PRIVACY/0363-MASTG-TEST-0363.md) |
| MASTG-TEST-0364 | android | MASVS-PLATFORM | Exported And Unprotected Activities That Expose Sensitive Functionality | current | L1,L2 | [`android/MASVS-PLATFORM/0364-MASTG-TEST-0364.md`](./android/MASVS-PLATFORM/0364-MASTG-TEST-0364.md) |
| MASTG-TEST-0365 | android | MASVS-PLATFORM | Exported And Unprotected Services That Expose Sensitive Functionality | current | L1,L2 | [`android/MASVS-PLATFORM/0365-MASTG-TEST-0365.md`](./android/MASVS-PLATFORM/0365-MASTG-TEST-0365.md) |
| MASTG-TEST-0366 | android | MASVS-PLATFORM | Exported And Unprotected Broadcast Receivers That Expose Sensitive Functionality | current | L1,L2 | [`android/MASVS-PLATFORM/0366-MASTG-TEST-0366.md`](./android/MASVS-PLATFORM/0366-MASTG-TEST-0366.md) |
| MASTG-TEST-0367 | ios | MASVS-RESILIENCE | Runtime Use of Virtual Device Detection Techniques | current | R | [`ios/MASVS-RESILIENCE/0367-MASTG-TEST-0367.md`](./ios/MASVS-RESILIENCE/0367-MASTG-TEST-0367.md) |
| MASTG-TEST-0368 | android | MASVS-RESILIENCE | Insufficient Obfuscation of Security-Relevant Java/Kotlin Code | current | R | [`android/MASVS-RESILIENCE/0368-MASTG-TEST-0368.md`](./android/MASVS-RESILIENCE/0368-MASTG-TEST-0368.md) |
| MASTG-TEST-0369 | android | MASVS-RESILIENCE | Insufficient Obfuscation of Security-Relevant Native Code | current | R | [`android/MASVS-RESILIENCE/0369-MASTG-TEST-0369.md`](./android/MASVS-RESILIENCE/0369-MASTG-TEST-0369.md) |
| MASTG-TEST-0370 | ios | MASVS-PLATFORM | Missing Input Validation in Custom URL Scheme Handlers | current | L1,L2 | [`ios/MASVS-PLATFORM/0370-MASTG-TEST-0370.md`](./ios/MASVS-PLATFORM/0370-MASTG-TEST-0370.md) |
| MASTG-TEST-0371 | ios | MASVS-PLATFORM | Missing Source Validation in Custom URL Scheme Handlers | current | L1,L2 | [`ios/MASVS-PLATFORM/0371-MASTG-TEST-0371.md`](./ios/MASVS-PLATFORM/0371-MASTG-TEST-0371.md) |
| MASTG-TEST-0372 | android | MASVS-CODE | Implicit Intents Used for Internal App Communication | current | L1,L2 | [`android/MASVS-CODE/0372-MASTG-TEST-0372.md`](./android/MASVS-CODE/0372-MASTG-TEST-0372.md) |
| MASTG-TEST-0374 | android | MASVS-CODE | References to Implicit Intents Carrying Sensitive Extras | current | L1,L2 | [`android/MASVS-CODE/0374-MASTG-TEST-0374.md`](./android/MASVS-CODE/0374-MASTG-TEST-0374.md) |
| MASTG-TEST-0375 | android | MASVS-CODE | Missing Validation of Data Returned from Implicit Intents | current | L1,L2 | [`android/MASVS-CODE/0375-MASTG-TEST-0375.md`](./android/MASVS-CODE/0375-MASTG-TEST-0375.md) |
| MASTG-TEST-0376 | ios | MASVS-PLATFORM | References to Native Bridge APIs in WebViews | current | L1,L2 | [`ios/MASVS-PLATFORM/0376-MASTG-TEST-0376.md`](./ios/MASVS-PLATFORM/0376-MASTG-TEST-0376.md) |
| MASTG-TEST-0377 | ios | MASVS-PLATFORM | References to `evaluateJavaScript` Used as Bridge Reply in `WKScriptMessageHandler` | current | L1,L2 | [`ios/MASVS-PLATFORM/0377-MASTG-TEST-0377.md`](./ios/MASVS-PLATFORM/0377-MASTG-TEST-0377.md) |
| MASTG-TEST-0378 | ios | MASVS-PLATFORM | References to Password Fields in WebView-Loaded HTML | current | L1,L2 | [`ios/MASVS-PLATFORM/0378-MASTG-TEST-0378.md`](./ios/MASVS-PLATFORM/0378-MASTG-TEST-0378.md) |
| MASTG-TEST-0379 | ios | MASVS-PLATFORM | References to `evaluateJavaScript` Without Content World Isolation | current | L1,L2 | [`ios/MASVS-PLATFORM/0379-MASTG-TEST-0379.md`](./ios/MASVS-PLATFORM/0379-MASTG-TEST-0379.md) |
| MASTG-TEST-0380 | ios | MASVS-PLATFORM | References to `evaluateJavaScript` Writing Sensitive Data into WebView DOM | current | L1,L2 | [`ios/MASVS-PLATFORM/0380-MASTG-TEST-0380.md`](./ios/MASVS-PLATFORM/0380-MASTG-TEST-0380.md) |
| MASTG-TEST-0381 | android | MASVS-PLATFORM | References to Insecure PendingIntent Creation | current | L1,L2 | [`android/MASVS-PLATFORM/0381-MASTG-TEST-0381.md`](./android/MASVS-PLATFORM/0381-MASTG-TEST-0381.md) |
| MASTG-TEST-0382 | android | MASVS-CODE | Runtime Use of Enforced Updating APIs | current | L2 | [`android/MASVS-CODE/0382-MASTG-TEST-0382.md`](./android/MASVS-CODE/0382-MASTG-TEST-0382.md) |
| MASTG-TEST-0383 | ios | MASVS-CODE | References to Enforced Updating APIs | current | L2 | [`ios/MASVS-CODE/0383-MASTG-TEST-0383.md`](./ios/MASVS-CODE/0383-MASTG-TEST-0383.md) |
| MASTG-TEST-0384 | ios | MASVS-CODE | Runtime Use of Enforced Updating APIs | current | L2 | [`ios/MASVS-CODE/0384-MASTG-TEST-0384.md`](./ios/MASVS-CODE/0384-MASTG-TEST-0384.md) |
| MASTG-TEST-0385 | ios | MASVS-NETWORK | Missing Certificate Pinning in ATS | current | L2 | [`ios/MASVS-NETWORK/0385-MASTG-TEST-0385.md`](./ios/MASVS-NETWORK/0385-MASTG-TEST-0385.md) |
| MASTG-TEST-0386 | ios | MASVS-CODE | References to Object Deserialization of Untrusted Data | current | L1,L2 | [`ios/MASVS-CODE/0386-MASTG-TEST-0386.md`](./ios/MASVS-CODE/0386-MASTG-TEST-0386.md) |
| MASTG-TEST-0387 | ios | MASVS-RESILIENCE | References to Storage Integrity Check APIs | current | R | [`ios/MASVS-RESILIENCE/0387-MASTG-TEST-0387.md`](./ios/MASVS-RESILIENCE/0387-MASTG-TEST-0387.md) |
| MASTG-TEST-0388 | ios | MASVS-STORAGE | References to Sensitive Data Stored Unprotected in Shared App Group Containers | current | L1,L2 | [`ios/MASVS-STORAGE/0388-MASTG-TEST-0388.md`](./ios/MASVS-STORAGE/0388-MASTG-TEST-0388.md) |
| MASTG-TEST-0389 | ios | MASVS-PLATFORM | References to the App-Wide Restriction of Custom Keyboards | current | L2 | [`ios/MASVS-PLATFORM/0389-MASTG-TEST-0389.md`](./ios/MASVS-PLATFORM/0389-MASTG-TEST-0389.md) |
| MASTG-TEST-0390 | ios | MASVS-PLATFORM | Full Access Requested by a Custom Keyboard Extension | current | L2 | [`ios/MASVS-PLATFORM/0390-MASTG-TEST-0390.md`](./ios/MASVS-PLATFORM/0390-MASTG-TEST-0390.md) |
| MASTG-TEST-0391 | ios | MASVS-RESILIENCE | Insufficient Obfuscation of Security-Relevant Native Code | current | R | [`ios/MASVS-RESILIENCE/0391-MASTG-TEST-0391.md`](./ios/MASVS-RESILIENCE/0391-MASTG-TEST-0391.md) |
| MASTG-TEST-0392 | android | MASVS-CODE | References to Enforced Updating APIs | current | L2 | [`android/MASVS-CODE/0392-MASTG-TEST-0392.md`](./android/MASVS-CODE/0392-MASTG-TEST-0392.md) |
| MASTG-TEST-0393 | android | MASVS-PLATFORM | Use of Unverified App Links | current | L1,L2 | [`android/MASVS-PLATFORM/0393-MASTG-TEST-0393.md`](./android/MASVS-PLATFORM/0393-MASTG-TEST-0393.md) |
| MASTG-TEST-0394 | android | MASVS-PLATFORM | Missing Input Validation in Custom URL Scheme Handlers | current | L1,L2 | [`android/MASVS-PLATFORM/0394-MASTG-TEST-0394.md`](./android/MASVS-PLATFORM/0394-MASTG-TEST-0394.md) |
| MASTG-TEST-0395 | ios | MASVS-PLATFORM | Missing Input Validation in Universal Link Handlers | current | L1,L2 | [`ios/MASVS-PLATFORM/0395-MASTG-TEST-0395.md`](./ios/MASVS-PLATFORM/0395-MASTG-TEST-0395.md) |
| MASTG-TEST-0396 | ios | MASVS-NETWORK | References to URLSessionDelegate Bypassing Certificate Validation | current | L1,L2 | [`ios/MASVS-NETWORK/0396-MASTG-TEST-0396.md`](./ios/MASVS-NETWORK/0396-MASTG-TEST-0396.md) |
| MASTG-TEST-0397 | ios | MASVS-NETWORK | References to WKNavigationDelegate Bypassing Certificate Validation | current | L1,L2 | [`ios/MASVS-NETWORK/0397-MASTG-TEST-0397.md`](./ios/MASVS-NETWORK/0397-MASTG-TEST-0397.md) |
| MASTG-TEST-0398 | android | MASVS-CODE | References to WebViewClient URL Loading Handlers | current | L1,L2 | [`android/MASVS-CODE/0398-MASTG-TEST-0398.md`](./android/MASVS-CODE/0398-MASTG-TEST-0398.md) |
| MASTG-TEST-0399 | android | MASVS-CODE | SafeBrowsing Disabled | current | L1,L2 | [`android/MASVS-CODE/0399-MASTG-TEST-0399.md`](./android/MASVS-CODE/0399-MASTG-TEST-0399.md) |
| MASTG-TEST-0400 | android | MASVS-CODE | Runtime Use of WebViewClient URL Loading Handlers | current | L1,L2 | [`android/MASVS-CODE/0400-MASTG-TEST-0400.md`](./android/MASVS-CODE/0400-MASTG-TEST-0400.md) |
| MASTG-TEST-0401 | ios | MASVS-RESILIENCE | References to Debugging Detection APIs | current | R | [`ios/MASVS-RESILIENCE/0401-MASTG-TEST-0401.md`](./ios/MASVS-RESILIENCE/0401-MASTG-TEST-0401.md) |
| MASTG-TEST-0402 | ios | MASVS-RESILIENCE | Runtime Use of Debugging Detection APIs | current | R | [`ios/MASVS-RESILIENCE/0402-MASTG-TEST-0402.md`](./ios/MASVS-RESILIENCE/0402-MASTG-TEST-0402.md) |

## 件数サマリ

* current: 186
* deprecated: 92
* placeholder: 14

## 参考リンク

* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
* OWASP/mastg tests: <https://github.com/OWASP/mastg/tree/master/tests>
* OWASP/mastg tests-beta: <https://github.com/OWASP/mastg/tree/master/tests-beta>
