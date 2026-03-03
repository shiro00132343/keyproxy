# llm-proxy

> AIツールを使うとき、大切な「APIキー」を安全に守るためのツールです。

---

## これは何をするツール？

Claude CodeやAntigravityなどのAIツールを使うとき、「APIキー」という秘密の合言葉が必要です。

でも、この合言葉を `.env` というファイルに書いておくと、**AIツールがそのファイルを読んで、合言葉がバレてしまう**ことがあります。

**llm-proxy** は、それを防ぐツールです。

### 仕組みをかんたんに説明すると

郵便局に例えてみましょう。

```
あなた ──→ 郵便局（llm-proxy） ──→ AI会社（Anthropicなど）
          ここで本物の住所を管理
          外に見えるのは仮の住所だけ
```

- **外に見せるもの**：偽の合言葉（バレても大丈夫）
- **本物の合言葉**：あなたのパソコンの中の安全な場所にこっそり保管

`.env` ファイルにはニセの合言葉だけ書いておきます。本物は llm-proxy が管理します。

---

## インストール（最初に1回だけ）

### ステップ1：ターミナルを開く

Macの場合：
- キーボードで `Command（⌘）+ スペース` を押す
- 「ターミナル」と入力してEnterを押す

### ステップ2：以下をコピーして貼り付けて、Enterを押す

```bash
curl -fsSL https://raw.githubusercontent.com/shiro00132343/llm-proxy-run/main/install.sh | bash
```

> ターミナルに文字を貼り付けるときは `Command（⌘）+ V` です。
> このコマンドはGitHubからインストーラーをダウンロードして、そのまま実行します。

インストールが完了すると、このような画面になります。

```
[OK] llm-proxy をインストールしました
[OK] インストール完了！

次のステップ:
  1. llm-proxy init    # APIキーを設定する
  2. llm-proxy start   # プロキシを起動する
  3. llm-proxy env     # 環境変数の設定方法を確認する
```

---

## 使い方（初回セットアップ）

### STEP 1：APIキーを登録する

ターミナルで以下を入力してEnterを押します。

```bash
llm-proxy init
```

このような質問が出てきます。

```
llm-proxy セットアップ
APIキーをセキュアな場所に保存します。

プロキシのポート番号 [4000]:
```

▶ **ポート番号はそのままEnterでOKです。**

```
Anthropic (Claude)
  APIキー（例: sk-ant-...）:
```

▶ **ここに本物のAPIキーを入力します。**
入力した文字は画面に表示されません（見えないけど入力できています）。
Enterを押して進みます。

```
OpenAI (GPT)
  APIキー [スキップする場合はEnter]:
```

▶ **OpenAIのAPIキーを持っていない場合はそのままEnterを押してください。**

```
設定を保存しました！
```

これで登録完了です。**本物のAPIキーはあなたのパソコンの安全な場所に保存されました。**

---

### STEP 2：プロキシを起動する

```bash
llm-proxy start
```

しばらく待つと、このような画面が出てきます。

```
[OK] プロキシが起動しました！

環境変数の設定方法
以下をターミナルで実行してください：

export ANTHROPIC_BASE_URL=http://localhost:4000
export ANTHROPIC_API_KEY=sk-dummy-safe-proxy-key-0000
```

---

### STEP 3：偽の合言葉を設定する

STEP 2で表示された `export ...` の行を、ターミナルにコピーして貼り付けて実行します。

```bash
export ANTHROPIC_BASE_URL=http://localhost:4000
export ANTHROPIC_API_KEY=sk-dummy-safe-proxy-key-0000
```

> `sk-dummy-safe-proxy-key-0000` は**わざと使う偽の合言葉**です。
> バレても問題ありません。本物のキーは llm-proxy が管理しています。

#### ターミナルを開くたびに自動で設定されるようにする（推奨）

毎回入力するのは面倒なので、設定ファイルに書いておきましょう。

ターミナルで以下を実行します（コピペOK）：

```bash
echo 'export ANTHROPIC_BASE_URL=http://localhost:4000' >> ~/.zshrc
echo 'export ANTHROPIC_API_KEY=sk-dummy-safe-proxy-key-0000' >> ~/.zshrc
source ~/.zshrc
```

> `~/.zshrc` というのは「ターミナルを開いたときに自動で読み込む設定ファイル」です。
> ここに書いておけば、次から自動で設定されます。

---

### STEP 4：あとは普通に使うだけ！

Claude CodeやAntigravityをいつも通り使ってください。
裏側でllm-proxyが本物のキーに差し替えて送ってくれます。

---

## 毎日の使い方

パソコンを再起動したあとや、新しいターミナルを開いたあとは、プロキシを起動し直す必要があります。

```bash
llm-proxy start
```

これだけです。APIキーの設定（init）は最初に1回やれば、次からは不要です。

---

## よく使うコマンド

| やりたいこと | コマンド |
|---|---|
| 初回設定（APIキーを登録） | `llm-proxy init` |
| プロキシを起動する | `llm-proxy start` |
| プロキシを止める | `llm-proxy stop` |
| 起動しているか確認する | `llm-proxy status` |
| 環境変数の設定方法を見る | `llm-proxy env` |
| ログを見る（困ったとき） | `llm-proxy logs` |

---

## 困ったときは

### 「llm-proxy: command not found」と表示された

インストールはできていますが、パソコンが場所を見つけられていません。
以下をターミナルに貼り付けて実行してください。

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

その後、もう一度 `llm-proxy start` を試してください。

### プロキシが起動しない

```bash
llm-proxy logs
```

でエラーの内容を確認できます。

よくある原因：
- **Pythonが入っていない** → [python.org](https://www.python.org/downloads/) からインストール
- **ポートが使用中** → `llm-proxy init` を実行して別の番号（例: 4001）に変える

### APIキーを変更したい

```bash
llm-proxy stop
llm-proxy init
llm-proxy start
```

この3つを順番に実行してください。

---

## セキュリティについて（安全性の説明）

| 場所 | 何が保存される？ | 見られたら困る？ |
|---|---|---|
| `.env` ファイル（プロジェクト） | 偽の合言葉 | 困らない（偽物なので） |
| `~/.llm-proxy/config`（パソコンの奥） | 本物のAPIキー | ここだけ大切に保管 |

`~/.llm-proxy/` フォルダはあなた本人しか読めないように設定されています（パーミッション600）。
Gitには絶対にアップロードされません（ホームフォルダにあるため）。

---

## 前提条件

- macOS または Linux
- Python 3.8以上（ない場合は [python.org](https://www.python.org/downloads/) からインストール）
- LiteLLM（`llm-proxy start` のときに自動でインストールされます）
