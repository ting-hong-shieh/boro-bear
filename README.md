# Boro Bear · 波洛熊：縫線房

一款以 Godot 4.7 製作的 2D 短篇敘事解謎平台遊戲。主角小眠在一棟逐漸崩解的記憶之屋中遇見失去四肢的泰迪熊「波洛」，必須走過四個房間、解開四種機關，把四肢逐一帶回，最後在倒數中一起逃離。

## 完整遊戲流程

1. **沉水地下室**：跨越積水、依壓力紀錄開啟三個水壓閥，取回左手。
2. **月光溫室**：理解鏡根連動規則，讓三面鏡同時匯聚月光，取回右手。
3. **沉默樂室**：依台座上的序號重奏四個音盒，取回左腳。
4. **逆行鐘塔**：依金色目標刻度調整三枚配重，取回右腳。
5. **房子醒了**：波洛修復完成後，於 48 秒內沿崩塌樓梯抵達右上方出口。

每個章節藏有一條「記憶線」。四條全部找到會開啟完整結局；缺少記憶線仍可完成普通結局。遊戲在重要進度後自動存檔。

四肢是每個房間的解謎獎勵：進入房間時不會顯示，只有完成機關後才會透過縫線揭露演出出現。

## 操作

- 移動：`A` / `D` 或方向鍵
- 跳躍：`Space`、`W` 或上方向鍵
- 互動／推進對話：`E`
- 暫停：`Esc`
- 靜音：`M`
- 暫停畫面回標題：`R`
- 標題畫面：`Enter` 繼續、`N` 開始新遊戲

### 手機網頁版

- 建議橫向遊玩；加入主畫面後可以 PWA 全螢幕開啟。
- 左下角：左右移動（支援滑動換向與多點觸控）。
- 右下角：互動、跳躍；右上角：暫停。
- 觸控按鈕僅在觸摸螢幕或 coarse pointer 裝置顯示，桌面瀏覽器仍使用鍵盤。

## 執行

使用 Godot 4.7.x 匯入此資料夾，開啟 `project.godot` 後按 `F6` 或 `F5`。

```sh
godot --path . --editor
```

Web 版本地匯出（需先安裝 Godot 4.7.1 export templates）：

```sh
mkdir -p build/web
godot --headless --path . --export-release Web build/web/index.html
```

`main` 分支每次 push 都會由 GitHub Actions 重新匯出並發佈到 GitHub Pages。

開發者測試：

```sh
godot --path . -- --debug-basement
godot --path . -- --debug-greenhouse
godot --path . -- --debug-music_room
godot --path . -- --debug-clocktower
godot --path . -- --debug-escape
godot --headless --path . -- --debug-full-flow
godot --headless --path . -- --debug-physics-test
```

物理測試會以模擬按鍵實際走動與跳躍，驗證：平台下方通行不卡住、單向平台可從下方穿越、跳躍高度足以登上平台、左右邊界牆有效。成功時輸出 `BORO_PHYSICS_TEST_OK`。

完整流程測試成功時會輸出：

```text
BORO_COMPLETE_FLOW_OK: four puzzles -> four repairs -> escape -> true ending
```

## 專案結構

- `scenes/`：主場景與玩家場景
- `scripts/game.gd`：關卡、謎題、敘事、UI、逃生與結局流程
- `scripts/game_state.gd`：跨關卡狀態與 JSON 存檔
- `scripts/player.gd`：移動、跳躍、動畫與腳步聲
- `art/`：概念場景、角色動畫、模組化泰迪熊與遊戲預覽
- `audio/`：實際使用的 CC0 音樂與音效
- `third_party/`：第三方原始素材與隨附授權

遊戲以 1280×720 為設計基準，使用 GL Compatibility renderer。第三方素材來源與授權見 `THIRD_PARTY_NOTICES.md`。
