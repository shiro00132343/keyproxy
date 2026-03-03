#!/usr/bin/env bash
# llm-proxy インストールスクリプト
# 使い方: curl -fsSL https://raw.githubusercontent.com/.../install.sh | bash

set -euo pipefail

INSTALL_DIR="$HOME/.local/bin"
SCRIPT_URL="https://raw.githubusercontent.com/shiro00132343/llm-proxy-run/main/llm-proxy"
SCRIPT_NAME="llm-proxy"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'

info()    { echo -e "${BLUE}[INFO]${RESET} $*"; }
success() { echo -e "${GREEN}[OK]${RESET} $*"; }
warn()    { echo -e "${YELLOW}[WARN]${RESET} $*"; }
error()   { echo -e "${RED}[ERROR]${RESET} $*" >&2; }

echo ""
echo -e "${BOLD}llm-proxy インストーラー${RESET}"
echo "========================================"
echo ""

# インストール先ディレクトリを作成
mkdir -p "$INSTALL_DIR"

# ローカルインストール（このスクリプトがリポジトリ内で実行される場合）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/llm-proxy" ]; then
  info "ローカルファイルからインストールします..."
  cp "$SCRIPT_DIR/llm-proxy" "$INSTALL_DIR/$SCRIPT_NAME"
else
  # リモートからダウンロード
  info "llm-proxyをダウンロード中..."
  if command -v curl &>/dev/null; then
    curl -fsSL "$SCRIPT_URL" -o "$INSTALL_DIR/$SCRIPT_NAME"
  elif command -v wget &>/dev/null; then
    wget -q "$SCRIPT_URL" -O "$INSTALL_DIR/$SCRIPT_NAME"
  else
    error "curl または wget が必要です。"
    exit 1
  fi
fi

chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
success "llm-proxy をインストールしました: $INSTALL_DIR/$SCRIPT_NAME"

# PATHの確認
if echo "$PATH" | tr ':' '\n' | grep -q "^$INSTALL_DIR$"; then
  success "$INSTALL_DIR は PATH に含まれています"
else
  warn "$INSTALL_DIR が PATH に含まれていません"
  echo ""
  echo "以下をシェルの設定ファイルに追加してください："
  echo ""

  # シェルの種類を判定
  SHELL_NAME=$(basename "${SHELL:-bash}")
  case "$SHELL_NAME" in
    zsh)
      SHELL_CONFIG="$HOME/.zshrc"
      ;;
    bash)
      if [ -f "$HOME/.bash_profile" ]; then
        SHELL_CONFIG="$HOME/.bash_profile"
      else
        SHELL_CONFIG="$HOME/.bashrc"
      fi
      ;;
    fish)
      SHELL_CONFIG="$HOME/.config/fish/config.fish"
      ;;
    *)
      SHELL_CONFIG="$HOME/.profile"
      ;;
  esac

  echo -e "  ${YELLOW}export PATH=\"\$HOME/.local/bin:\$PATH\"${RESET}"
  echo ""

  # 自動追加するか確認
  read -r -p "自動的に $SHELL_CONFIG に追加しますか？ [y/N]: " answer
  if [[ "$answer" =~ ^[Yy]$ ]]; then
    echo '' >> "$SHELL_CONFIG"
    echo '# llm-proxy' >> "$SHELL_CONFIG"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_CONFIG"
    success "$SHELL_CONFIG に追加しました"
    echo ""
    info "設定を反映するには以下を実行してください："
    echo "  source $SHELL_CONFIG"
  fi
fi

# Pythonの確認
echo ""
info "Pythonの確認中..."
if command -v python3 &>/dev/null; then
  PYTHON_VERSION=$(python3 --version 2>&1)
  success "Python: $PYTHON_VERSION"
else
  warn "Python3が見つかりません。"
  echo "  LiteLLMはPythonが必要です。以下からインストールしてください："
  echo "  → https://www.python.org/downloads/"
fi

# LiteLLMの確認
if command -v litellm &>/dev/null; then
  LITELLM_VERSION=$(litellm --version 2>&1 | head -1)
  success "LiteLLM: $LITELLM_VERSION（インストール済み）"
else
  warn "LiteLLMが見つかりません（'llm-proxy start' 時に自動インストールします）"
fi

echo ""
echo "========================================"
success "インストール完了！"
echo ""
echo -e "${BOLD}次のステップ:${RESET}"
echo "  1. llm-proxy init    # APIキーを設定する"
echo "  2. llm-proxy start   # プロキシを起動する"
echo "  3. llm-proxy env     # 環境変数の設定方法を確認する"
echo ""
