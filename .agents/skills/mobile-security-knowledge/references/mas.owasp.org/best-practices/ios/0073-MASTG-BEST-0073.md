---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0073/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0073
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0073: Properly Validate Server Trust in URLSessionDelegate and WKNavigationDelegate

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Properly Validate Server Trust in URLSessionDelegate and WKNavigationDelegate」（ios）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: When an iOS app overrides the default certificate validation by implementing URLSessionDelegate.urlSession(_:didReceive:completionHandler:)) or WKNavigationDelegate.webView(_:didReceive:completionHandler:)), it takes full control of the server trust evaluation. An incorrect im...

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0073/>
* 関連 Knowledge: `MASTG-KNOW-0072`
* 索引: [`../0000-index.md`](../0000-index.md)

## Properly Validate Server Trust in URLSessionDelegate and WKNavigationDelegateを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Properly Validate Server Trust in URLSessionDelegate and WKNavigationDelegateを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Properly Validate Server Trust in URLSessionDelegate and WKNavigationDelegateを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* When an iOS app overrides the default certificate validation by implementing URLSessionDelegate.urlSession(_:didReceive:completionHandler:)) or WKNavigationDelegate.webView(_:didReceive:completionHandler:)), it takes full control of the server trust evaluation. An incorrect implementation that accepts credentials without calling SecTrustEvaluateWithError) bypasses certificate chain validation and hostname verification, leaving connections open to Machine-in-the-Middle (MITM) attacks.
* See "Performing manual server trust authentication" in the Apple Developer Documentation for more information.
* Confirm the challenge is of type NSURLAuthenticationMethodServerTrust.
* Obtain the serverTrust object from challenge.protectionSpace.serverTrust.
* Call SecTrustEvaluateWithError and verify it returns true.
* Call completionHandler(.useCredential, URLCredential(trust: serverTrust)) only when evaluation succeeds.
* Call completionHandler(.cancelAuthenticationChallenge, nil) on any other challenge type or when evaluation fails.
```

## ナレッジベース

### DO: Properly Validate Server Trust in URLSessionDelegate and WKNavigationDelegate を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Properly Validate Server Trust in URLSessionDelegate and WKNavigationDelegate を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0072）と合わせてレビューする
- When an iOS app overrides the default certificate validation by implementing URLSessionDelegate.urlSession(_:didReceive:completionHandler:)) or WKNavigationDelegate.webView(_:didReceive:completionHandler:)), it takes full control of the server trust evaluation. An incorrect implementation that accepts credentials without calling SecTrustEvaluateWithError) bypasses certificate chain validation and hostname verification, leaving connections open to Machine-in-the-Middle (MITM) attacks.
- See "Performing manual server trust authentication" in the Apple Developer Documentation for more information.
- Confirm the challenge is of type NSURLAuthenticationMethodServerTrust.
```

### DO NOT: MASTG-BEST-0073 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- URLSession / WKNavigation のサーバ信頼検証を常時成功にする

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0073 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0073/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
