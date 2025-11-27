🚀 中國飛彈打台灣 (China Missile Strike Taiwan)

這是一個基於瀏覽器的橫向捲軸閃避遊戲（Flappy Bird 風格），玩家將控制一枚高速飛行的飛彈，穿越險峻的中央山脈防線。

🎮 遊戲介紹

本專案是一個使用純 HTML5、CSS3 (Tailwind CSS) 和 JavaScript 開發的單一檔案網頁遊戲。遊戲將經典的 Flappy Bird 玩法進行了改編，將主角替換為飛彈，並將障礙物替換為連綿起伏的山脈地形，配有動態的粒子尾焰與音效系統。

✨ 特色

物理模擬：飛彈具有重力與慣性，飛行時會根據上升或下降改變角度。

動態地形：障礙物不再是單調的管子，而是隨機生成的岩石山脈（包含倒懸的岩壁）。

視覺特效：

飛彈噴射時的火焰粒子系統。

撞擊時的畫面閃爍與爆炸效果。

視差捲動的背景雲層。

音效合成：使用 Web Audio API 即時生成音效（噴射、得分、撞擊），無需載入外部音訊檔案。

響應式設計：支援桌機（鍵盤/滑鼠）與行動裝置（觸控）遊玩。

🕹️ 操作說明

遊戲目標是盡可能飛得更遠，避開上下方的山脈障礙。

電腦版：

點擊 滑鼠左鍵 或 按下 空白鍵 (Space) 來啟動推進器向上飛。

手機/平板：

點擊 螢幕任意位置 即可向上飛。

🛠️ 技術架構

核心：HTML5 Canvas (2D Context) 用於遊戲渲染。

樣式：Tailwind CSS (經由 CDN 載入) 用於 UI 介面美化。

腳本：原生 JavaScript (ES6+)。

requestAnimationFrame 實現流暢的遊戲迴圈。

AudioContext 實現無素材音效合成。

localStorage 用於儲存本機最佳分數。

🚀 如何執行

由於本遊戲為單一 HTML 檔案架構，您無需安裝任何伺服器或依賴套件。

下載 flappy_missile.html 檔案。

直接使用現代瀏覽器（Chrome, Edge, Firefox, Safari）開啟該檔案。

點擊畫面上的「發射飛彈」即可開始遊玩。

📝 檔案結構

flappy_missile.html  # 包含所有 HTML 結構、CSS 樣式與 JavaScript 遊戲邏輯
README.md            # 專案說明文件


僅供娛樂與程式教學用途。
