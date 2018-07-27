[![pipeline status](https://gitlab.com/omae-app/omae/badges/master/pipeline.svg)](https://gitlab.com/omae-app/omae/commits/master)
[![coverage report](https://gitlab.com/omae-app/omae/badges/master/coverage.svg?job=rspec)](https://omae-app.gitlab.io/omae/)
# チケット運用

## Idea

* アイデア、改善要望、バグを思いつき/発見し次第追加する
* 順不同

## BackLog

* `Idea` リストの中から、実現すると決めたものを追加する
    * 何を実現するかはMTGで決める
* 常に上から優先度順に並べる

## ToDo, Doing, Done

* `BackLog` リストの一番上から着手する
* 個人的なタスクは最初から `ToDo` に追加する

## Rejected

* `Idea` リストの中から、実現しないと決めたものを追加する
* 「以前もやろうとしたけど結局やめた」という情報が残っているのは大事
* なぜやめたのかがわかるようにコメントを入れておく

# Git 運用

* `master` ブランチは常に本番環境にデプロイできる状態を保つ
* チケットに着手する際は `develop` ブランチから新規ブランチを作成する
* `master` へのマージまでに必ず実装した人と別の人がコードレビューをする

## コミットメッセージ

* コミットメッセージにはプレフィックスをつける
    * `feat:`：機能の追加
    * `fix:`：バグの修正
    * `refactor:`：リファクタリング
    * `test:`：テストの追加/変更など
    * `docs:`：ドキュメントのみの変更

> **参考：**
> [【今日からできる】コミットメッセージに 「プレフィックス」 をつけるだけで、開発効率が上がった話](https://qiita.com/numanomanu/items/45dd285b286a1f7280ed)

## マージリクエスト

* 基本的には、マージリクエストには最低限以下の項目を記載する
    * やりたかったこと
    * やったこと
    * 動作確認方法
* `Remove source branch when merge request is accepted.` にはチェックを入れて不要なブランチは残さないようにする
* コメントにはプレフィックスをつける
    * `MUST`：必ず直すべき
    * `IMO`：緩やかな指摘 (In my opinion, 自分なら直すけどどう?)
    * `NITS`：細かい指摘 (nitspick)

> **参考：**
> [プルリク時のコメント略語](https://qiita.com/dolaemoso/items/2ed8c48ff349e6add45b)

# 開発

* 基本的には１つの機能(チケット)は１人で担当する
    * ペアプログラミングや相談などは積極的におこなう
* 機能を追加するときはテストも追加する
