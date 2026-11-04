---
source: https://mas.owasp.org/MASTG/knowledge/
scopes:
  - test
  - android
  - ios
  - backend
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
updated_at: 2026-08-16
upstream_revision: d7fd7d4
---

# OWASP MASTG Knowledge Base（索引）

## 概要

OWASP MASTG Knowledge Base の各記事を、DO / DO NOT 監査向けに 1 記事 1 ドキュメントへ蒸留した索引である。

* 生成元 upstream: OWASP/mastg@d7fd7d4 の `knowledge/`
* 件数: 140（deprecated / placeholder を含む）
* 詳細 API 説明の正本は公式サイトである。本ツリーは実装レビュー用の要約である

## ディレクトリ規則

```text
docs/security/mas.owasp.org/knowledge/
├── 0000-index.md
├── android/{MASVS-*}/NNNN-MASTG-KNOW-NNNN.md
├── ios/{MASVS-*}/NNNN-MASTG-KNOW-NNNN.md
└── generic/{MASVS-*}/NNNN-MASTG-KNOW-NNNN.md
```

## 利用原則

監査・実装レビューでは Knowledge ID を参照し、制御群（MASVS）と弱点（MASWE）へ紐づける。

### 利用原則の補足

* 利点: プラットフォーム固有の実装知識を検索可能にできる
* 注意点: deprecated / placeholder は新規採用根拠にしない
* 適用範囲: モバイル実装、テスト設計、DO NOT 監査
* 例外: なし

### 利用原則の実装例

```text
PR レビューコメント例
* 参照: MASTG-KNOW-0014 (Network Security Configuration)
* 確認: release で cleartextTrafficPermitted=false
```

## ナレッジベース

### DO: current の Knowledge を制御群ごとに参照して実装可否を判断する

* まず category ディレクトリを開き、変更差分に関連する KNOW を選ぶ

```text
# 推奨
network 変更 → android/MASVS-NETWORK または ios/MASVS-NETWORK
保存変更 → MASVS-STORAGE
```

### DO NOT: Knowledge 要約だけで公式テストを省略する

* 理由: Knowledge は解説、Tests は検証手順である
* 理由: 要約は蒸留であり API の全条件を含まない

```text
# DO NOT: 要約の DO だけで「MASTG 準拠」と宣言する

# DO: `docs/security/mas.owasp.org/tests/0000-index.md` から該当 Test を実施する
```

## 一覧

| ID | Platform | Category | Title | Status | Path |
| --- | --- | --- | --- | --- | --- |
| MASTG-KNOW-0001 | android | MASVS-AUTH | Biometric Authentication | current | [`knowledge/android/MASVS-AUTH/0001-MASTG-KNOW-0001.md`](./android/MASVS-AUTH/0001-MASTG-KNOW-0001.md) |
| MASTG-KNOW-0002 | android | MASVS-AUTH | FingerprintManager | deprecated | [`knowledge/android/MASVS-AUTH/0002-MASTG-KNOW-0002.md`](./android/MASVS-AUTH/0002-MASTG-KNOW-0002.md) |
| MASTG-KNOW-0003 | android | MASVS-RESILIENCE | App Signing | current | [`knowledge/android/MASVS-RESILIENCE/0003-MASTG-KNOW-0003.md`](./android/MASVS-RESILIENCE/0003-MASTG-KNOW-0003.md) |
| MASTG-KNOW-0004 | android | MASVS-CODE | Third-Party Libraries | current | [`knowledge/android/MASVS-CODE/0004-MASTG-KNOW-0004.md`](./android/MASVS-CODE/0004-MASTG-KNOW-0004.md) |
| MASTG-KNOW-0005 | android | MASVS-CODE | Memory Corruption Bugs | current | [`knowledge/android/MASVS-CODE/0005-MASTG-KNOW-0005.md`](./android/MASVS-CODE/0005-MASTG-KNOW-0005.md) |
| MASTG-KNOW-0006 | android | MASVS-CODE | Binary Protection Mechanisms | current | [`knowledge/android/MASVS-CODE/0006-MASTG-KNOW-0006.md`](./android/MASVS-CODE/0006-MASTG-KNOW-0006.md) |
| MASTG-KNOW-0007 | android | MASVS-CODE | Debuggable Apps | current | [`knowledge/android/MASVS-CODE/0007-MASTG-KNOW-0007.md`](./android/MASVS-CODE/0007-MASTG-KNOW-0007.md) |
| MASTG-KNOW-0008 | android | MASVS-CODE | Debugging Information and Debug Symbols | current | [`knowledge/android/MASVS-CODE/0008-MASTG-KNOW-0008.md`](./android/MASVS-CODE/0008-MASTG-KNOW-0008.md) |
| MASTG-KNOW-0009 | android | MASVS-CODE | StrictMode | current | [`knowledge/android/MASVS-CODE/0009-MASTG-KNOW-0009.md`](./android/MASVS-CODE/0009-MASTG-KNOW-0009.md) |
| MASTG-KNOW-0010 | android | MASVS-CODE | Exception Handling | current | [`knowledge/android/MASVS-CODE/0010-MASTG-KNOW-0010.md`](./android/MASVS-CODE/0010-MASTG-KNOW-0010.md) |
| MASTG-KNOW-0011 | android | MASVS-CRYPTO | Security Provider | current | [`knowledge/android/MASVS-CRYPTO/0011-MASTG-KNOW-0011.md`](./android/MASVS-CRYPTO/0011-MASTG-KNOW-0011.md) |
| MASTG-KNOW-0012 | android | MASVS-CRYPTO | Key Generation | current | [`knowledge/android/MASVS-CRYPTO/0012-MASTG-KNOW-0012.md`](./android/MASVS-CRYPTO/0012-MASTG-KNOW-0012.md) |
| MASTG-KNOW-0013 | android | MASVS-CRYPTO | Random Number Generation | current | [`knowledge/android/MASVS-CRYPTO/0013-MASTG-KNOW-0013.md`](./android/MASVS-CRYPTO/0013-MASTG-KNOW-0013.md) |
| MASTG-KNOW-0014 | android | MASVS-NETWORK | Android Network Security Configuration | current | [`knowledge/android/MASVS-NETWORK/0014-MASTG-KNOW-0014.md`](./android/MASVS-NETWORK/0014-MASTG-KNOW-0014.md) |
| MASTG-KNOW-0015 | android | MASVS-NETWORK | Certificate Pinning | current | [`knowledge/android/MASVS-NETWORK/0015-MASTG-KNOW-0015.md`](./android/MASVS-NETWORK/0015-MASTG-KNOW-0015.md) |
| MASTG-KNOW-0016 | android | MASVS-NETWORK | TBD | placeholder | [`knowledge/android/MASVS-NETWORK/0016-MASTG-KNOW-0016.md`](./android/MASVS-NETWORK/0016-MASTG-KNOW-0016.md) |
| MASTG-KNOW-0017 | android | MASVS-PLATFORM | App Permissions | current | [`knowledge/android/MASVS-PLATFORM/0017-MASTG-KNOW-0017.md`](./android/MASVS-PLATFORM/0017-MASTG-KNOW-0017.md) |
| MASTG-KNOW-0018 | android | MASVS-PLATFORM | WebViews | current | [`knowledge/android/MASVS-PLATFORM/0018-MASTG-KNOW-0018.md`](./android/MASVS-PLATFORM/0018-MASTG-KNOW-0018.md) |
| MASTG-KNOW-0019 | android | MASVS-PLATFORM | Deep Links | current | [`knowledge/android/MASVS-PLATFORM/0019-MASTG-KNOW-0019.md`](./android/MASVS-PLATFORM/0019-MASTG-KNOW-0019.md) |
| MASTG-KNOW-0020 | android | MASVS-PLATFORM | Inter-Process Communication (IPC) Mechanisms | current | [`knowledge/android/MASVS-PLATFORM/0020-MASTG-KNOW-0020.md`](./android/MASVS-PLATFORM/0020-MASTG-KNOW-0020.md) |
| MASTG-KNOW-0021 | android | MASVS-PLATFORM | Object Serialization | current | [`knowledge/android/MASVS-PLATFORM/0021-MASTG-KNOW-0021.md`](./android/MASVS-PLATFORM/0021-MASTG-KNOW-0021.md) |
| MASTG-KNOW-0022 | android | MASVS-PLATFORM | Overlay Attacks | current | [`knowledge/android/MASVS-PLATFORM/0022-MASTG-KNOW-0022.md`](./android/MASVS-PLATFORM/0022-MASTG-KNOW-0022.md) |
| MASTG-KNOW-0023 | android | MASVS-PLATFORM | Enforced Updating | current | [`knowledge/android/MASVS-PLATFORM/0023-MASTG-KNOW-0023.md`](./android/MASVS-PLATFORM/0023-MASTG-KNOW-0023.md) |
| MASTG-KNOW-0024 | android | MASVS-PLATFORM | Pending Intents | current | [`knowledge/android/MASVS-PLATFORM/0024-MASTG-KNOW-0024.md`](./android/MASVS-PLATFORM/0024-MASTG-KNOW-0024.md) |
| MASTG-KNOW-0025 | android | MASVS-PLATFORM | Explicit vs Implicit Intents | current | [`knowledge/android/MASVS-PLATFORM/0025-MASTG-KNOW-0025.md`](./android/MASVS-PLATFORM/0025-MASTG-KNOW-0025.md) |
| MASTG-KNOW-0026 | android | MASVS-STORAGE | Third-party Services Embedded in the App | current | [`knowledge/android/MASVS-STORAGE/0026-MASTG-KNOW-0026.md`](./android/MASVS-STORAGE/0026-MASTG-KNOW-0026.md) |
| MASTG-KNOW-0027 | android | MASVS-RESILIENCE | Root Detection | current | [`knowledge/android/MASVS-RESILIENCE/0027-MASTG-KNOW-0027.md`](./android/MASVS-RESILIENCE/0027-MASTG-KNOW-0027.md) |
| MASTG-KNOW-0028 | android | MASVS-RESILIENCE | Anti-Debugging | current | [`knowledge/android/MASVS-RESILIENCE/0028-MASTG-KNOW-0028.md`](./android/MASVS-RESILIENCE/0028-MASTG-KNOW-0028.md) |
| MASTG-KNOW-0029 | android | MASVS-RESILIENCE | File Integrity Checks | current | [`knowledge/android/MASVS-RESILIENCE/0029-MASTG-KNOW-0029.md`](./android/MASVS-RESILIENCE/0029-MASTG-KNOW-0029.md) |
| MASTG-KNOW-0030 | android | MASVS-RESILIENCE | Reverse Engineering Tool Detection | current | [`knowledge/android/MASVS-RESILIENCE/0030-MASTG-KNOW-0030.md`](./android/MASVS-RESILIENCE/0030-MASTG-KNOW-0030.md) |
| MASTG-KNOW-0031 | android | MASVS-RESILIENCE | Emulator Detection | current | [`knowledge/android/MASVS-RESILIENCE/0031-MASTG-KNOW-0031.md`](./android/MASVS-RESILIENCE/0031-MASTG-KNOW-0031.md) |
| MASTG-KNOW-0032 | android | MASVS-RESILIENCE | Runtime Integrity Verification | current | [`knowledge/android/MASVS-RESILIENCE/0032-MASTG-KNOW-0032.md`](./android/MASVS-RESILIENCE/0032-MASTG-KNOW-0032.md) |
| MASTG-KNOW-0033 | android | MASVS-RESILIENCE | Obfuscation | current | [`knowledge/android/MASVS-RESILIENCE/0033-MASTG-KNOW-0033.md`](./android/MASVS-RESILIENCE/0033-MASTG-KNOW-0033.md) |
| MASTG-KNOW-0034 | android | MASVS-RESILIENCE | Device Binding | current | [`knowledge/android/MASVS-RESILIENCE/0034-MASTG-KNOW-0034.md`](./android/MASVS-RESILIENCE/0034-MASTG-KNOW-0034.md) |
| MASTG-KNOW-0035 | android | MASVS-RESILIENCE | Google Play Integrity API | current | [`knowledge/android/MASVS-RESILIENCE/0035-MASTG-KNOW-0035.md`](./android/MASVS-RESILIENCE/0035-MASTG-KNOW-0035.md) |
| MASTG-KNOW-0036 | android | MASVS-STORAGE | Shared Preferences | current | [`knowledge/android/MASVS-STORAGE/0036-MASTG-KNOW-0036.md`](./android/MASVS-STORAGE/0036-MASTG-KNOW-0036.md) |
| MASTG-KNOW-0037 | android | MASVS-STORAGE | SQLite Database | current | [`knowledge/android/MASVS-STORAGE/0037-MASTG-KNOW-0037.md`](./android/MASVS-STORAGE/0037-MASTG-KNOW-0037.md) |
| MASTG-KNOW-0038 | android | MASVS-STORAGE | SQLCipher Database | current | [`knowledge/android/MASVS-STORAGE/0038-MASTG-KNOW-0038.md`](./android/MASVS-STORAGE/0038-MASTG-KNOW-0038.md) |
| MASTG-KNOW-0039 | android | MASVS-STORAGE | Firebase Real-time Databases | current | [`knowledge/android/MASVS-STORAGE/0039-MASTG-KNOW-0039.md`](./android/MASVS-STORAGE/0039-MASTG-KNOW-0039.md) |
| MASTG-KNOW-0040 | android | MASVS-STORAGE | Realm Databases | current | [`knowledge/android/MASVS-STORAGE/0040-MASTG-KNOW-0040.md`](./android/MASVS-STORAGE/0040-MASTG-KNOW-0040.md) |
| MASTG-KNOW-0041 | android | MASVS-STORAGE | Internal Storage | current | [`knowledge/android/MASVS-STORAGE/0041-MASTG-KNOW-0041.md`](./android/MASVS-STORAGE/0041-MASTG-KNOW-0041.md) |
| MASTG-KNOW-0042 | android | MASVS-STORAGE | External Storage | current | [`knowledge/android/MASVS-STORAGE/0042-MASTG-KNOW-0042.md`](./android/MASVS-STORAGE/0042-MASTG-KNOW-0042.md) |
| MASTG-KNOW-0043 | android | MASVS-STORAGE | Android KeyStore | current | [`knowledge/android/MASVS-STORAGE/0043-MASTG-KNOW-0043.md`](./android/MASVS-STORAGE/0043-MASTG-KNOW-0043.md) |
| MASTG-KNOW-0044 | android | MASVS-STORAGE | Key Attestation | current | [`knowledge/android/MASVS-STORAGE/0044-MASTG-KNOW-0044.md`](./android/MASVS-STORAGE/0044-MASTG-KNOW-0044.md) |
| MASTG-KNOW-0045 | android | MASVS-STORAGE | Secure Key Import into Keystore | current | [`knowledge/android/MASVS-STORAGE/0045-MASTG-KNOW-0045.md`](./android/MASVS-STORAGE/0045-MASTG-KNOW-0045.md) |
| MASTG-KNOW-0046 | android | MASVS-STORAGE | BouncyCastle KeyStore | deprecated | [`knowledge/android/MASVS-STORAGE/0046-MASTG-KNOW-0046.md`](./android/MASVS-STORAGE/0046-MASTG-KNOW-0046.md) |
| MASTG-KNOW-0047 | android | MASVS-STORAGE | Cryptographic Key Storage | current | [`knowledge/android/MASVS-STORAGE/0047-MASTG-KNOW-0047.md`](./android/MASVS-STORAGE/0047-MASTG-KNOW-0047.md) |
| MASTG-KNOW-0048 | android | MASVS-STORAGE | KeyChain | current | [`knowledge/android/MASVS-STORAGE/0048-MASTG-KNOW-0048.md`](./android/MASVS-STORAGE/0048-MASTG-KNOW-0048.md) |
| MASTG-KNOW-0049 | android | MASVS-STORAGE | Logs | current | [`knowledge/android/MASVS-STORAGE/0049-MASTG-KNOW-0049.md`](./android/MASVS-STORAGE/0049-MASTG-KNOW-0049.md) |
| MASTG-KNOW-0050 | android | MASVS-STORAGE | Backups | current | [`knowledge/android/MASVS-STORAGE/0050-MASTG-KNOW-0050.md`](./android/MASVS-STORAGE/0050-MASTG-KNOW-0050.md) |
| MASTG-KNOW-0051 | android | MASVS-STORAGE | Process Memory | current | [`knowledge/android/MASVS-STORAGE/0051-MASTG-KNOW-0051.md`](./android/MASVS-STORAGE/0051-MASTG-KNOW-0051.md) |
| MASTG-KNOW-0052 | android | MASVS-STORAGE | User Interface Components | current | [`knowledge/android/MASVS-STORAGE/0052-MASTG-KNOW-0052.md`](./android/MASVS-STORAGE/0052-MASTG-KNOW-0052.md) |
| MASTG-KNOW-0053 | android | MASVS-STORAGE | Screenshots | current | [`knowledge/android/MASVS-STORAGE/0053-MASTG-KNOW-0053.md`](./android/MASVS-STORAGE/0053-MASTG-KNOW-0053.md) |
| MASTG-KNOW-0054 | android | MASVS-STORAGE | App Notifications | current | [`knowledge/android/MASVS-STORAGE/0054-MASTG-KNOW-0054.md`](./android/MASVS-STORAGE/0054-MASTG-KNOW-0054.md) |
| MASTG-KNOW-0055 | android | MASVS-STORAGE | Keyboard Cache | current | [`knowledge/android/MASVS-STORAGE/0055-MASTG-KNOW-0055.md`](./android/MASVS-STORAGE/0055-MASTG-KNOW-0055.md) |
| MASTG-KNOW-0056 | ios | MASVS-AUTH | Local Authentication Framework | current | [`knowledge/ios/MASVS-AUTH/0056-MASTG-KNOW-0056.md`](./ios/MASVS-AUTH/0056-MASTG-KNOW-0056.md) |
| MASTG-KNOW-0057 | ios | MASVS-AUTH | Keychain Services | current | [`knowledge/ios/MASVS-AUTH/0057-MASTG-KNOW-0057.md`](./ios/MASVS-AUTH/0057-MASTG-KNOW-0057.md) |
| MASTG-KNOW-0058 | ios | MASVS-CODE | App Signing | current | [`knowledge/ios/MASVS-CODE/0058-MASTG-KNOW-0058.md`](./ios/MASVS-CODE/0058-MASTG-KNOW-0058.md) |
| MASTG-KNOW-0059 | ios | MASVS-CODE | Third-Party Libraries | current | [`knowledge/ios/MASVS-CODE/0059-MASTG-KNOW-0059.md`](./ios/MASVS-CODE/0059-MASTG-KNOW-0059.md) |
| MASTG-KNOW-0060 | ios | MASVS-CODE | Memory Corruption Bugs | current | [`knowledge/ios/MASVS-CODE/0060-MASTG-KNOW-0060.md`](./ios/MASVS-CODE/0060-MASTG-KNOW-0060.md) |
| MASTG-KNOW-0061 | ios | MASVS-CODE | Binary Protection Mechanisms | current | [`knowledge/ios/MASVS-CODE/0061-MASTG-KNOW-0061.md`](./ios/MASVS-CODE/0061-MASTG-KNOW-0061.md) |
| MASTG-KNOW-0062 | ios | MASVS-CODE | Debuggable Apps | current | [`knowledge/ios/MASVS-CODE/0062-MASTG-KNOW-0062.md`](./ios/MASVS-CODE/0062-MASTG-KNOW-0062.md) |
| MASTG-KNOW-0063 | ios | MASVS-CODE | Debugging Information and Debug Symbols | current | [`knowledge/ios/MASVS-CODE/0063-MASTG-KNOW-0063.md`](./ios/MASVS-CODE/0063-MASTG-KNOW-0063.md) |
| MASTG-KNOW-0064 | ios | MASVS-CODE | Non-Production Resources | current | [`knowledge/ios/MASVS-CODE/0064-MASTG-KNOW-0064.md`](./ios/MASVS-CODE/0064-MASTG-KNOW-0064.md) |
| MASTG-KNOW-0065 | ios | MASVS-CODE | Exception Handling | current | [`knowledge/ios/MASVS-CODE/0065-MASTG-KNOW-0065.md`](./ios/MASVS-CODE/0065-MASTG-KNOW-0065.md) |
| MASTG-KNOW-0066 | ios | MASVS-CRYPTO | CryptoKit | current | [`knowledge/ios/MASVS-CRYPTO/0066-MASTG-KNOW-0066.md`](./ios/MASVS-CRYPTO/0066-MASTG-KNOW-0066.md) |
| MASTG-KNOW-0067 | ios | MASVS-CRYPTO | CommonCrypto, SecKey and Wrapper libraries | current | [`knowledge/ios/MASVS-CRYPTO/0067-MASTG-KNOW-0067.md`](./ios/MASVS-CRYPTO/0067-MASTG-KNOW-0067.md) |
| MASTG-KNOW-0068 | ios | MASVS-CRYPTO | Cryptographic Third-Party libraries | current | [`knowledge/ios/MASVS-CRYPTO/0068-MASTG-KNOW-0068.md`](./ios/MASVS-CRYPTO/0068-MASTG-KNOW-0068.md) |
| MASTG-KNOW-0069 | ios | MASVS-CRYPTO | Key Management | current | [`knowledge/ios/MASVS-CRYPTO/0069-MASTG-KNOW-0069.md`](./ios/MASVS-CRYPTO/0069-MASTG-KNOW-0069.md) |
| MASTG-KNOW-0070 | ios | MASVS-CRYPTO | Random Number Generator | current | [`knowledge/ios/MASVS-CRYPTO/0070-MASTG-KNOW-0070.md`](./ios/MASVS-CRYPTO/0070-MASTG-KNOW-0070.md) |
| MASTG-KNOW-0071 | ios | MASVS-NETWORK | iOS App Transport Security | current | [`knowledge/ios/MASVS-NETWORK/0071-MASTG-KNOW-0071.md`](./ios/MASVS-NETWORK/0071-MASTG-KNOW-0071.md) |
| MASTG-KNOW-0072 | ios | MASVS-NETWORK | Server Trust Evaluation | current | [`knowledge/ios/MASVS-NETWORK/0072-MASTG-KNOW-0072.md`](./ios/MASVS-NETWORK/0072-MASTG-KNOW-0072.md) |
| MASTG-KNOW-0073 | ios | MASVS-NETWORK | iOS Network APIs | current | [`knowledge/ios/MASVS-NETWORK/0073-MASTG-KNOW-0073.md`](./ios/MASVS-NETWORK/0073-MASTG-KNOW-0073.md) |
| MASTG-KNOW-0074 | ios | MASVS-PLATFORM | Enforced Updating | current | [`knowledge/ios/MASVS-PLATFORM/0074-MASTG-KNOW-0074.md`](./ios/MASVS-PLATFORM/0074-MASTG-KNOW-0074.md) |
| MASTG-KNOW-0075 | ios | MASVS-PLATFORM | Object Serialization | current | [`knowledge/ios/MASVS-PLATFORM/0075-MASTG-KNOW-0075.md`](./ios/MASVS-PLATFORM/0075-MASTG-KNOW-0075.md) |
| MASTG-KNOW-0076 | ios | MASVS-PLATFORM | WebViews | current | [`knowledge/ios/MASVS-PLATFORM/0076-MASTG-KNOW-0076.md`](./ios/MASVS-PLATFORM/0076-MASTG-KNOW-0076.md) |
| MASTG-KNOW-0077 | ios | MASVS-PLATFORM | App Permissions | current | [`knowledge/ios/MASVS-PLATFORM/0077-MASTG-KNOW-0077.md`](./ios/MASVS-PLATFORM/0077-MASTG-KNOW-0077.md) |
| MASTG-KNOW-0078 | ios | MASVS-PLATFORM | Inter-Process Communication (IPC) | current | [`knowledge/ios/MASVS-PLATFORM/0078-MASTG-KNOW-0078.md`](./ios/MASVS-PLATFORM/0078-MASTG-KNOW-0078.md) |
| MASTG-KNOW-0079 | ios | MASVS-PLATFORM | Custom URL Schemes | current | [`knowledge/ios/MASVS-PLATFORM/0079-MASTG-KNOW-0079.md`](./ios/MASVS-PLATFORM/0079-MASTG-KNOW-0079.md) |
| MASTG-KNOW-0080 | ios | MASVS-PLATFORM | Universal Links | current | [`knowledge/ios/MASVS-PLATFORM/0080-MASTG-KNOW-0080.md`](./ios/MASVS-PLATFORM/0080-MASTG-KNOW-0080.md) |
| MASTG-KNOW-0081 | ios | MASVS-PLATFORM | UIActivity Sharing | current | [`knowledge/ios/MASVS-PLATFORM/0081-MASTG-KNOW-0081.md`](./ios/MASVS-PLATFORM/0081-MASTG-KNOW-0081.md) |
| MASTG-KNOW-0082 | ios | MASVS-PLATFORM | App Extensions | current | [`knowledge/ios/MASVS-PLATFORM/0082-MASTG-KNOW-0082.md`](./ios/MASVS-PLATFORM/0082-MASTG-KNOW-0082.md) |
| MASTG-KNOW-0083 | ios | MASVS-PLATFORM | Pasteboard | current | [`knowledge/ios/MASVS-PLATFORM/0083-MASTG-KNOW-0083.md`](./ios/MASVS-PLATFORM/0083-MASTG-KNOW-0083.md) |
| MASTG-KNOW-0084 | ios | MASVS-RESILIENCE | Jailbreak Detection | current | [`knowledge/ios/MASVS-RESILIENCE/0084-MASTG-KNOW-0084.md`](./ios/MASVS-RESILIENCE/0084-MASTG-KNOW-0084.md) |
| MASTG-KNOW-0085 | ios | MASVS-RESILIENCE | Anti-Debugging Detection | current | [`knowledge/ios/MASVS-RESILIENCE/0085-MASTG-KNOW-0085.md`](./ios/MASVS-RESILIENCE/0085-MASTG-KNOW-0085.md) |
| MASTG-KNOW-0086 | ios | MASVS-RESILIENCE | Storage Integrity Checks | current | [`knowledge/ios/MASVS-RESILIENCE/0086-MASTG-KNOW-0086.md`](./ios/MASVS-RESILIENCE/0086-MASTG-KNOW-0086.md) |
| MASTG-KNOW-0087 | ios | MASVS-RESILIENCE | Reverse Engineering Tools Detection | current | [`knowledge/ios/MASVS-RESILIENCE/0087-MASTG-KNOW-0087.md`](./ios/MASVS-RESILIENCE/0087-MASTG-KNOW-0087.md) |
| MASTG-KNOW-0088 | ios | MASVS-RESILIENCE | iOS Simulator Detection | current | [`knowledge/ios/MASVS-RESILIENCE/0088-MASTG-KNOW-0088.md`](./ios/MASVS-RESILIENCE/0088-MASTG-KNOW-0088.md) |
| MASTG-KNOW-0089 | ios | MASVS-RESILIENCE | Obfuscation | current | [`knowledge/ios/MASVS-RESILIENCE/0089-MASTG-KNOW-0089.md`](./ios/MASVS-RESILIENCE/0089-MASTG-KNOW-0089.md) |
| MASTG-KNOW-0090 | ios | MASVS-RESILIENCE | Device Binding | current | [`knowledge/ios/MASVS-RESILIENCE/0090-MASTG-KNOW-0090.md`](./ios/MASVS-RESILIENCE/0090-MASTG-KNOW-0090.md) |
| MASTG-KNOW-0091 | ios | MASVS-STORAGE | File System APIs | current | [`knowledge/ios/MASVS-STORAGE/0091-MASTG-KNOW-0091.md`](./ios/MASVS-STORAGE/0091-MASTG-KNOW-0091.md) |
| MASTG-KNOW-0092 | ios | MASVS-STORAGE | Binary Data Storage | current | [`knowledge/ios/MASVS-STORAGE/0092-MASTG-KNOW-0092.md`](./ios/MASVS-STORAGE/0092-MASTG-KNOW-0092.md) |
| MASTG-KNOW-0093 | ios | MASVS-STORAGE | UserDefaults | current | [`knowledge/ios/MASVS-STORAGE/0093-MASTG-KNOW-0093.md`](./ios/MASVS-STORAGE/0093-MASTG-KNOW-0093.md) |
| MASTG-KNOW-0094 | ios | MASVS-STORAGE | CoreData | current | [`knowledge/ios/MASVS-STORAGE/0094-MASTG-KNOW-0094.md`](./ios/MASVS-STORAGE/0094-MASTG-KNOW-0094.md) |
| MASTG-KNOW-0095 | ios | MASVS-STORAGE | Firebase Real-time Databases | current | [`knowledge/ios/MASVS-STORAGE/0095-MASTG-KNOW-0095.md`](./ios/MASVS-STORAGE/0095-MASTG-KNOW-0095.md) |
| MASTG-KNOW-0096 | ios | MASVS-STORAGE | Realm Databases | current | [`knowledge/ios/MASVS-STORAGE/0096-MASTG-KNOW-0096.md`](./ios/MASVS-STORAGE/0096-MASTG-KNOW-0096.md) |
| MASTG-KNOW-0097 | ios | MASVS-STORAGE | Other Third-Party Databases | current | [`knowledge/ios/MASVS-STORAGE/0097-MASTG-KNOW-0097.md`](./ios/MASVS-STORAGE/0097-MASTG-KNOW-0097.md) |
| MASTG-KNOW-0098 | ios | MASVS-STORAGE | User Interface Components | current | [`knowledge/ios/MASVS-STORAGE/0098-MASTG-KNOW-0098.md`](./ios/MASVS-STORAGE/0098-MASTG-KNOW-0098.md) |
| MASTG-KNOW-0099 | ios | MASVS-STORAGE | Screenshots | current | [`knowledge/ios/MASVS-STORAGE/0099-MASTG-KNOW-0099.md`](./ios/MASVS-STORAGE/0099-MASTG-KNOW-0099.md) |
| MASTG-KNOW-0100 | ios | MASVS-STORAGE | Keyboard Cache | current | [`knowledge/ios/MASVS-STORAGE/0100-MASTG-KNOW-0100.md`](./ios/MASVS-STORAGE/0100-MASTG-KNOW-0100.md) |
| MASTG-KNOW-0101 | ios | MASVS-STORAGE | Logs | current | [`knowledge/ios/MASVS-STORAGE/0101-MASTG-KNOW-0101.md`](./ios/MASVS-STORAGE/0101-MASTG-KNOW-0101.md) |
| MASTG-KNOW-0102 | ios | MASVS-STORAGE | Backups | current | [`knowledge/ios/MASVS-STORAGE/0102-MASTG-KNOW-0102.md`](./ios/MASVS-STORAGE/0102-MASTG-KNOW-0102.md) |
| MASTG-KNOW-0103 | ios | MASVS-STORAGE | Process Memory | current | [`knowledge/ios/MASVS-STORAGE/0103-MASTG-KNOW-0103.md`](./ios/MASVS-STORAGE/0103-MASTG-KNOW-0103.md) |
| MASTG-KNOW-0104 | ios | MASVS-PLATFORM | Low-Level System IPC Mechanisms | current | [`knowledge/ios/MASVS-PLATFORM/0104-MASTG-KNOW-0104.md`](./ios/MASVS-PLATFORM/0104-MASTG-KNOW-0104.md) |
| MASTG-KNOW-0105 | android | MASVS-PLATFORM | User-Initiated Screenshots and Screen Recording | placeholder | [`knowledge/android/MASVS-PLATFORM/0105-MASTG-KNOW-0105.md`](./android/MASVS-PLATFORM/0105-MASTG-KNOW-0105.md) |
| MASTG-KNOW-0106 | android | MASVS-PLATFORM | App-Initiated Screenshots and Screen Recording | placeholder | [`knowledge/android/MASVS-PLATFORM/0106-MASTG-KNOW-0106.md`](./android/MASVS-PLATFORM/0106-MASTG-KNOW-0106.md) |
| MASTG-KNOW-0107 | android | MASVS-PLATFORM | Screenshots and Screen Recording Detection | placeholder | [`knowledge/android/MASVS-PLATFORM/0107-MASTG-KNOW-0107.md`](./android/MASVS-PLATFORM/0107-MASTG-KNOW-0107.md) |
| MASTG-KNOW-0108 | ios | MASVS-STORAGE | App Sandbox Directories | current | [`knowledge/ios/MASVS-STORAGE/0108-MASTG-KNOW-0108.md`](./ios/MASVS-STORAGE/0108-MASTG-KNOW-0108.md) |
| MASTG-KNOW-0109 | generic | MASVS-RESILIENCE | Binary Patching | current | [`knowledge/generic/MASVS-RESILIENCE/0109-MASTG-KNOW-0109.md`](./generic/MASVS-RESILIENCE/0109-MASTG-KNOW-0109.md) |
| MASTG-KNOW-0110 | generic | MASVS-RESILIENCE | Code Injection | current | [`knowledge/generic/MASVS-RESILIENCE/0110-MASTG-KNOW-0110.md`](./generic/MASVS-RESILIENCE/0110-MASTG-KNOW-0110.md) |
| MASTG-KNOW-0111 | generic | MASVS-RESILIENCE | Obfuscation | current | [`knowledge/generic/MASVS-RESILIENCE/0111-MASTG-KNOW-0111.md`](./generic/MASVS-RESILIENCE/0111-MASTG-KNOW-0111.md) |
| MASTG-KNOW-0112 | generic | MASVS-RESILIENCE | Emulation-based Dynamic Analysis | current | [`knowledge/generic/MASVS-RESILIENCE/0112-MASTG-KNOW-0112.md`](./generic/MASVS-RESILIENCE/0112-MASTG-KNOW-0112.md) |
| MASTG-KNOW-0113 | generic | MASVS-RESILIENCE | Using Disassemblers and Decompilers | current | [`knowledge/generic/MASVS-RESILIENCE/0113-MASTG-KNOW-0113.md`](./generic/MASVS-RESILIENCE/0113-MASTG-KNOW-0113.md) |
| MASTG-KNOW-0114 | generic | MASVS-RESILIENCE | Debugging and Tracing | current | [`knowledge/generic/MASVS-RESILIENCE/0114-MASTG-KNOW-0114.md`](./generic/MASVS-RESILIENCE/0114-MASTG-KNOW-0114.md) |
| MASTG-KNOW-0115 | generic | MASVS-RESILIENCE | Dynamic Binary Instrumentation | current | [`knowledge/generic/MASVS-RESILIENCE/0115-MASTG-KNOW-0115.md`](./generic/MASVS-RESILIENCE/0115-MASTG-KNOW-0115.md) |
| MASTG-KNOW-0116 | generic | MASVS-RESILIENCE | Symbolic Execution | current | [`knowledge/generic/MASVS-RESILIENCE/0116-MASTG-KNOW-0116.md`](./generic/MASVS-RESILIENCE/0116-MASTG-KNOW-0116.md) |
| MASTG-KNOW-0117 | android | MASVS-CODE | Android ContentProvider | current | [`knowledge/android/MASVS-CODE/0117-MASTG-KNOW-0117.md`](./android/MASVS-CODE/0117-MASTG-KNOW-0117.md) |
| MASTG-KNOW-0118 | android | MASVS-RESILIENCE | Runtime Application Self-Protection (RASP) | current | [`knowledge/android/MASVS-RESILIENCE/0118-MASTG-KNOW-0118.md`](./android/MASVS-RESILIENCE/0118-MASTG-KNOW-0118.md) |
| MASTG-KNOW-0119 | android | MASVS-RESILIENCE | Key Attestation | placeholder | [`knowledge/android/MASVS-RESILIENCE/0119-MASTG-KNOW-0119.md`](./android/MASVS-RESILIENCE/0119-MASTG-KNOW-0119.md) |
| MASTG-KNOW-0120 | android | MASVS-RESILIENCE | Device Attestation | placeholder | [`knowledge/android/MASVS-RESILIENCE/0120-MASTG-KNOW-0120.md`](./android/MASVS-RESILIENCE/0120-MASTG-KNOW-0120.md) |
| MASTG-KNOW-0121 | ios | MASVS-PLATFORM | Text Input Field Masking in iOS | current | [`knowledge/ios/MASVS-PLATFORM/0121-MASTG-KNOW-0121.md`](./ios/MASVS-PLATFORM/0121-MASTG-KNOW-0121.md) |
| MASTG-KNOW-0122 | ios | MASVS-PLATFORM | Document Picker, Document Interaction, and Open in Place | current | [`knowledge/ios/MASVS-PLATFORM/0122-MASTG-KNOW-0122.md`](./ios/MASVS-PLATFORM/0122-MASTG-KNOW-0122.md) |
| MASTG-KNOW-0123 | ios | MASVS-PLATFORM | Handoff | current | [`knowledge/ios/MASVS-PLATFORM/0123-MASTG-KNOW-0123.md`](./ios/MASVS-PLATFORM/0123-MASTG-KNOW-0123.md) |
| MASTG-KNOW-0124 | ios | MASVS-PLATFORM | SiriKit and Siri Shortcuts | current | [`knowledge/ios/MASVS-PLATFORM/0124-MASTG-KNOW-0124.md`](./ios/MASVS-PLATFORM/0124-MASTG-KNOW-0124.md) |
| MASTG-KNOW-0125 | ios | MASVS-PLATFORM | App Groups | current | [`knowledge/ios/MASVS-PLATFORM/0125-MASTG-KNOW-0125.md`](./ios/MASVS-PLATFORM/0125-MASTG-KNOW-0125.md) |
| MASTG-KNOW-0126 | ios | MASVS-PLATFORM | Keychain Access Groups | current | [`knowledge/ios/MASVS-PLATFORM/0126-MASTG-KNOW-0126.md`](./ios/MASVS-PLATFORM/0126-MASTG-KNOW-0126.md) |
| MASTG-KNOW-0127 | ios | MASVS-PLATFORM | File Coordination APIs | current | [`knowledge/ios/MASVS-PLATFORM/0127-MASTG-KNOW-0127.md`](./ios/MASVS-PLATFORM/0127-MASTG-KNOW-0127.md) |
| MASTG-KNOW-0128 | ios | MASVS-PLATFORM | Bonjour | current | [`knowledge/ios/MASVS-PLATFORM/0128-MASTG-KNOW-0128.md`](./ios/MASVS-PLATFORM/0128-MASTG-KNOW-0128.md) |
| MASTG-KNOW-0129 | ios | MASVS-PLATFORM | App Intents and AI Agent Exposure | current | [`knowledge/ios/MASVS-PLATFORM/0129-MASTG-KNOW-0129.md`](./ios/MASVS-PLATFORM/0129-MASTG-KNOW-0129.md) |
| MASTG-KNOW-0130 | ios | MASVS-PLATFORM | Core Bluetooth | current | [`knowledge/ios/MASVS-PLATFORM/0130-MASTG-KNOW-0130.md`](./ios/MASVS-PLATFORM/0130-MASTG-KNOW-0130.md) |
| MASTG-KNOW-0131 | ios | MASVS-PLATFORM | Core NFC | current | [`knowledge/ios/MASVS-PLATFORM/0131-MASTG-KNOW-0131.md`](./ios/MASVS-PLATFORM/0131-MASTG-KNOW-0131.md) |
| MASTG-KNOW-0132 | android | MASVS-PLATFORM | Android Activities | current | [`knowledge/android/MASVS-PLATFORM/0132-MASTG-KNOW-0132.md`](./android/MASVS-PLATFORM/0132-MASTG-KNOW-0132.md) |
| MASTG-KNOW-0133 | android | MASVS-PLATFORM | Android Services | current | [`knowledge/android/MASVS-PLATFORM/0133-MASTG-KNOW-0133.md`](./android/MASVS-PLATFORM/0133-MASTG-KNOW-0133.md) |
| MASTG-KNOW-0134 | android | MASVS-PLATFORM | Android Broadcast Receivers | current | [`knowledge/android/MASVS-PLATFORM/0134-MASTG-KNOW-0134.md`](./android/MASVS-PLATFORM/0134-MASTG-KNOW-0134.md) |
| MASTG-KNOW-0135 | ios | MASVS-RESILIENCE | Virtual Devices Detection | current | [`knowledge/ios/MASVS-RESILIENCE/0135-MASTG-KNOW-0135.md`](./ios/MASVS-RESILIENCE/0135-MASTG-KNOW-0135.md) |
| MASTG-KNOW-0136 | ios | MASVS-RESILIENCE | iOS Apps Running on macOS Detection | current | [`knowledge/ios/MASVS-RESILIENCE/0136-MASTG-KNOW-0136.md`](./ios/MASVS-RESILIENCE/0136-MASTG-KNOW-0136.md) |
| MASTG-KNOW-0138 | android | MASVS-CODE | URI Schemes in Android Intent Results | current | [`knowledge/android/MASVS-CODE/0138-MASTG-KNOW-0138.md`](./android/MASVS-CODE/0138-MASTG-KNOW-0138.md) |
| MASTG-KNOW-0139 | ios | MASVS-PLATFORM | WKContentWorld | current | [`knowledge/ios/MASVS-PLATFORM/0139-MASTG-KNOW-0139.md`](./ios/MASVS-PLATFORM/0139-MASTG-KNOW-0139.md) |
| MASTG-KNOW-0140 | ios | MASVS-RESILIENCE | Source Code Integrity Checks | current | [`knowledge/ios/MASVS-RESILIENCE/0140-MASTG-KNOW-0140.md`](./ios/MASVS-RESILIENCE/0140-MASTG-KNOW-0140.md) |
| MASTG-KNOW-0141 | ios | MASVS-PLATFORM | Custom Keyboards | current | [`knowledge/ios/MASVS-PLATFORM/0141-MASTG-KNOW-0141.md`](./ios/MASVS-PLATFORM/0141-MASTG-KNOW-0141.md) |

## 参考リンク

* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* OWASP/mastg knowledge/: <https://github.com/OWASP/mastg/tree/master/knowledge>
