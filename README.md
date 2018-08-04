[![pipeline status](https://gitlab.com/omae-app/omae/badges/master/pipeline.svg)](https://gitlab.com/omae-app/omae/commits/master)
[![coverage report](https://gitlab.com/omae-app/omae/badges/master/coverage.svg?job=rspec)](https://omae-app.gitlab.io/omae/)

# OMAE

## 環境

* ruby 2.5.1
* PostgreSQL
* yarn

## ローカルで動かすには

1. ローカルにクローン

    ```bash
    $ git clone https://gitlab.com/omae-app/omae.git
    $ cd omae
    ```
2. JSパッケージインストール

    ```bash
    $ yarn install
    ```
    
    > **Note:** 事前に `yarn` の[インストールが必要](https://yarnpkg.com/lang/ja/docs/install/#mac-stable)
    
3. DBの生成・初期化

    ```bash
    $ rails db:create
    $ rails db:migration
    ```
    
    > **Note:** 事前に `PostgreSQL` のインストールと起動が必要
    
4. OMAE 起動

    ```bash
    $ rails s
    ```