param (
    [string]$Path
)

# 実際のカレントディレクトリに移動
Set-Location $Path

# 移動先の .venv のパス
$venvPath = Join-Path $Path ".venv"

# 現在のアクティブな venv パス（環境変数）
$currentVenv = $env:VIRTUAL_ENV

# .venv が存在するか？
if (Test-Path $venvPath) {

    # OSごとの activate スクリプトパス
    if ($IsWindows) {
        $activateScript = Join-Path $venvPath "Scripts\activate"
    } else {
        $activateScript = Join-Path $venvPath "bin/activate"
    }

    # 現在の venv が違う場合だけ再アクティベート
    if (-not $currentVenv -or (Compare-Path $currentVenv $venvPath) -ne $true) {
        Write-Host "仮想環境を切り替えます: $venvPath"
        & $activateScript
    } else {
        Write-Host "既にこのプロジェクトの仮想環境が有効です"
    }

} else {
    Write-Host "このフォルダには .venv はありません"
}

# パス比較用の関数（末尾のスラッシュや大文字小文字を無視）
function Compare-Path($path1, $path2) {
    return ( (Resolve-Path $path1).Path.TrimEnd('\','/') -ieq (Resolve-Path $path2).Path.TrimEnd('\','/') )
}
