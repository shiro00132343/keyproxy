# llm-proxy

**[日本語](#日本語) | [English](#english)**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Open Source](https://img.shields.io/badge/Open%20Source-%E2%9D%A4-brightgreen)](https://github.com/shiro00132343/llm-proxy-run)

> このプロジェクトはオープンソースです。誰でも無料で使用・改変・配布できます。
> This project is open source. Free to use, modify, and distribute by anyone.

---

<a name="日本語"></a>

# 日本語

> AIツールを使うとき、大切な「APIキー」を安全に守るためのツールです。

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

このような画面が出てきます。

```
llm-proxy セットアップ
APIキーをセキュアな場所 [~/.llm-proxy] に保存します。

プロキシのポート番号 [4000]:
```

▶ **ポート番号はそのままEnterでOKです。**

次に、登録済みのAPIキー一覧が表示されます（初回は「なし」）。

```
登録済みのAPIキー:
  (なし)

操作: サービス名を入力して追加・更新 / [d 番号] で削除 / [Enter] で完了
>
```

▶ **使いたいサービス名を入力してEnterを押します。**

```
> Anthropic
  APIキー:
```

▶ **ここに本物のAPIキーを入力します。**
入力した文字は画面に表示されません（見えないけど入力できています）。
Enterを押して進みます。

```
[OK] Anthropic を保存しました

登録済みのAPIキー:
  1. ANTHROPIC: sk-ant-a...

操作: サービス名を入力して追加・更新 / [d 番号] で削除 / [Enter] で完了
>
```

▶ **他にも登録したいサービスがあれば続けて入力できます。**
終わったら何も入力せずEnterを押してください。

```
[OK] 設定を保存しました
```

これで登録完了です。**本物のAPIキーはあなたのパソコンの安全な場所に保存されました。**

> **キーの追加・削除もいつでもできます：**
> - 追加・更新：`llm-proxy init` でサービス名を入力
> - 削除：`llm-proxy init` で `d 番号` を入力（例: `d 1`）

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
| 対応サービスの一覧を見る | `llm-proxy services` |
| 環境変数の設定方法を見る | `llm-proxy env` |
| ログを見る（困ったとき） | `llm-proxy logs` |

---

## 対応しているサービス

`llm-proxy init` でサービス名を自由に入力できるため、**任意のサービスのAPIキーを管理できます。**

以下のサービスはモデル名のルーティングが組み込まれており、特別な設定なしで使用できます。

| サービス | 説明 |
|---|---|
| Anthropic | Claude Code、Antigravityなどに対応 |
| OpenAI | GPT-4o、o1などに対応 |
| Google | Gemini 1.5 Pro/Flashなどに対応 |
| xAI | Grok-2などに対応 |
| Mistral | Mistral Large/Smallなどに対応 |
| Cohere | Command R+などに対応 |
| DeepSeek | DeepSeek Chat/R1などに対応 |
| Groq | Llama3、Mixtralなどに対応（高速推論） |
| Perplexity | ネット検索付きAIに対応 |
| Together | オープンソースモデルに対応 |

上記以外のサービスも `llm-proxy init` でサービス名とAPIキーを入力するだけで登録・保管できます。

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

### APIキーを変更・追加・削除したい

プロキシを止めてから `init` を実行し、また起動します。

```bash
llm-proxy stop
llm-proxy init
llm-proxy start
```

`llm-proxy init` の画面では：
- サービス名を入力 → 新しいキーを入力（追加・更新）
- `d 番号` を入力（削除）
- 空Enterで完了・保存

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

---

## ライセンス

MIT License — 誰でも自由に使用・改変・配布できます。

---
---

<a name="english"></a>

# English

> A tool to keep your API keys safe when using AI tools.

## What does this do?

When using AI tools like Claude Code or Antigravity, you need a secret "API key" to access the service.

If you write this key in a `.env` file, **the AI tool may read that file and expose your key**.

**llm-proxy** prevents this from happening.

### How it works

Think of it like a post office:

```
You ──→ Post Office (llm-proxy) ──→ AI Company (Anthropic, etc.)
         Holds your real address
         Only a fake address is visible outside
```

- **What tools see**: A dummy key (safe if leaked)
- **Your real key**: Stored securely on your machine, managed by llm-proxy

Your `.env` file only ever contains the dummy key. The real key never leaves its safe location.

---

## Installation (once only)

### Step 1: Open Terminal

On Mac:
- Press `Command (⌘) + Space`
- Type "Terminal" and press Enter

### Step 2: Copy, paste, and press Enter

```bash
curl -fsSL https://raw.githubusercontent.com/shiro00132343/llm-proxy-run/main/install.sh | bash
```

> Paste in Terminal with `Command (⌘) + V`.
> This downloads the installer from GitHub and runs it automatically.

When complete, you'll see:

```
[OK] llm-proxy installed
[OK] Installation complete!

Next steps:
  1. llm-proxy init    # Set your API keys
  2. llm-proxy start   # Start the proxy
  3. llm-proxy env     # Show environment variable instructions
```

---

## Setup (first time only)

### STEP 1: Register your API keys

```bash
llm-proxy init
```

You'll see:

```
llm-proxy setup
Saving API keys to a secure location [~/.llm-proxy].

Proxy port number [4000]:
```

▶ **Just press Enter to use the default port.**

Your registered keys are shown (empty on first run), then you enter an interactive prompt:

```
Registered API keys:
  (none)

Action: type a service name to add/update / [d N] to delete / [Enter] to finish
>
```

▶ **Type the name of the service you want to add, then press Enter.**

```
> Anthropic
  API key:
```

▶ **Enter your real API key here.**
Characters won't appear on screen as you type — that's normal. Press Enter when done.

```
[OK] Anthropic saved

Registered API keys:
  1. ANTHROPIC: sk-ant-a...

Action: type a service name to add/update / [d N] to delete / [Enter] to finish
>
```

▶ **Add more services if needed, or just press Enter to finish.**

```
[OK] Settings saved
```

Done. **Your real API key is now stored safely on your machine.**

> **You can add, update, or delete keys at any time:**
> - Add/update: run `llm-proxy init` and type a service name
> - Delete: run `llm-proxy init` and type `d N` (e.g. `d 1`)

---

### STEP 2: Start the proxy

```bash
llm-proxy start
```

After a moment, you'll see:

```
[OK] Proxy started!

Environment variable setup
Run the following in your terminal:

export ANTHROPIC_BASE_URL=http://localhost:4000
export ANTHROPIC_API_KEY=sk-dummy-safe-proxy-key-0000
```

---

### STEP 3: Set the dummy key

Copy and run the `export ...` lines shown in STEP 2:

```bash
export ANTHROPIC_BASE_URL=http://localhost:4000
export ANTHROPIC_API_KEY=sk-dummy-safe-proxy-key-0000
```

> `sk-dummy-safe-proxy-key-0000` is an **intentionally fake key**.
> It's safe if leaked. Your real key is managed by llm-proxy.

#### Set it automatically on every new Terminal (recommended)

```bash
echo 'export ANTHROPIC_BASE_URL=http://localhost:4000' >> ~/.zshrc
echo 'export ANTHROPIC_API_KEY=sk-dummy-safe-proxy-key-0000' >> ~/.zshrc
source ~/.zshrc
```

> `~/.zshrc` is your shell's startup file — anything written here runs automatically when you open a new terminal.

---

### STEP 4: Use your AI tools as normal

Use Claude Code, Antigravity, or any other tool as you normally would.
llm-proxy silently swaps in your real key behind the scenes.

---

## Daily usage

After restarting your computer or opening a new terminal, just run:

```bash
llm-proxy start
```

That's it. You only need to run `llm-proxy init` once.

---

## Commands

| What you want to do | Command |
|---|---|
| Set up API keys (first time) | `llm-proxy init` |
| Start the proxy | `llm-proxy start` |
| Stop the proxy | `llm-proxy stop` |
| Check if it's running | `llm-proxy status` |
| List supported services | `llm-proxy services` |
| Show environment variable setup | `llm-proxy env` |
| View logs (for troubleshooting) | `llm-proxy logs` |

---

## Supported services

Since `llm-proxy init` lets you type any service name, **you can store API keys for any service.**

The following services have built-in model routing and work out of the box:

| Service | Details |
|---|---|
| Anthropic | Claude Code, Antigravity, and more |
| OpenAI | GPT-4o, o1, o3-mini, and more |
| Google | Gemini 1.5 Pro/Flash, Gemini 2.0, and more |
| xAI | Grok-2 and more |
| Mistral | Mistral Large/Small, Codestral, and more |
| Cohere | Command R+ and more |
| DeepSeek | DeepSeek Chat, R1, and more |
| Groq | Llama3, Mixtral, and more (fast inference) |
| Perplexity | Web-connected AI models |
| Together | Open-source model hosting |

Any other service can also be registered — just enter the service name and API key in `llm-proxy init`.

---

## Troubleshooting

### `llm-proxy: command not found`

The tool is installed but your terminal can't find it. Run:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

Then try `llm-proxy start` again.

### Proxy won't start

```bash
llm-proxy logs
```

Common causes:
- **Python not installed** → Install from [python.org](https://www.python.org/downloads/)
- **Port already in use** → Run `llm-proxy init` and choose a different port (e.g. 4001)

### Want to add, update, or delete an API key?

Stop the proxy, run `init`, then start again:

```bash
llm-proxy stop
llm-proxy init
llm-proxy start
```

In the `llm-proxy init` screen:
- Type a service name → enter new key (add/update)
- Type `d N` → delete that entry
- Press Enter on empty → save and exit

---

## Security

| Location | What's stored | Safe if exposed? |
|---|---|---|
| `.env` file (in your project) | Dummy key | Yes — it's fake |
| `~/.llm-proxy/config` (home directory) | Real API key | Keep this private |

`~/.llm-proxy/` is protected with permission 600 (readable only by you).
It lives outside your project directory and will never be committed to Git.

---

## Requirements

- macOS or Linux
- Python 3.8+ (install from [python.org](https://www.python.org/downloads/) if needed)
- LiteLLM (installed automatically when you run `llm-proxy start`)

---

## License

MIT License — Free to use, modify, and distribute.

---

## Contributing

Pull requests and issues are welcome!
[https://github.com/shiro00132343/llm-proxy-run](https://github.com/shiro00132343/llm-proxy-run)
