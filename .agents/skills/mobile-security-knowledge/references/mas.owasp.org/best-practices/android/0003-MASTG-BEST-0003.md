---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0003/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0003
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0003: Comply with Privacy Regulations and Best Practices

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Comply with Privacy Regulations and Best Practices」（android）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: Recommendations from CWE-359.

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0003/>
* 関連 Knowledge: （未リンク）
* 索引: [`../0000-index.md`](../0000-index.md)

## Comply with Privacy Regulations and Best Practicesを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Comply with Privacy Regulations and Best Practicesを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Comply with Privacy Regulations and Best Practicesを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Recommendations from CWE-359.
* Identify and consult all relevant regulations for personal privacy. An organization may be required to comply with certain federal and state regulations, depending on its location, the type of business it conducts, and the nature of any private data it handles. Regulations may include Safe Harbor Privacy Framework [REF-340], Gramm-Leach Bliley Act (GLBA) [REF-341], Health Insurance Portability and Accountability Act (HIPAA) [REF-342], General Data Protection Regulation (GDPR) [REF-1047], California Consumer Privacy Act (CCPA) [REF-1048], and others.
* From a security perspective, all important operations should be recorded so that any anomalous activity can later be identified.
* However, when private data is involved, this practice can in fact create risk. Although there are many ways in which private data can be handled unsafely, a common risk stems from misplaced trust.
* [REF-340] U.S. Department of Commerce. "Safe Harbor Privacy Framework". <https://web.archive.org/web/20010223203241/http://www.export.gov/safeharbor/>. URL validated: 2023-04-07.
* [REF-341] Federal Trade Commission. "Financial Privacy: The Gramm-Leach Bliley Act (GLBA)". <https://www.ftc.gov/business-guidance/privacy-security/gramm-leach-bliley-act>. URL validated: 2023-04-07.
* [REF-342] U.S. Department of Human Services. "Health Insurance Portability and Accountability Act (HIPAA)". <https://www.hhs.gov/hipaa/index.html>. URL validated: 2023-04-07.
* [REF-1047] Wikipedia. "General Data Protection Regulation". <https://en.wikipedia.org/wiki/General_Data_Protection_Regulation>.
```

## ナレッジベース

### DO: Comply with Privacy Regulations and Best Practices を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Comply with Privacy Regulations and Best Practices を該当機能に適用する
- Recommendations from CWE-359.
- Identify and consult all relevant regulations for personal privacy. An organization may be required to comply with certain federal and state regulations, depending on its location, the type of business it conducts, and the nature of any private data it handles. Regulations may include Safe Harbor Privacy Framework [REF-340], Gramm-Leach Bliley Act (GLBA) [REF-341], Health Insurance Portability and Accountability Act (HIPAA) [REF-342], General Data Protection Regulation (GDPR) [REF-1047], California Consumer Privacy Act (CCPA) [REF-1048], and others.
- From a security perspective, all important operations should be recorded so that any anomalous activity can later be identified.
```

### DO NOT: MASTG-BEST-0003 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- 収集実態と申告・ポリシーを不一致のままにする

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0003 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0003/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
