<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>共感工作室 - 音樂視覺化生成器</title>
    <!-- 引入 Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- 引入 Three.js (用於 3D 視覺化) -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
    <style>
        /* 使用 Inter 字體 */
        body { font-family: 'Inter', sans-serif; }
        /* 確保 Canvas 填滿容器 */
        #visualization-canvas {
            display: block;
            width: 100%;
            height: 100%;
        }
        .control-group input[type="range"] {
            -webkit-appearance: none;
            appearance: none;
            height: 8px;
            background: #4B5563; /* Gray-600 */
            border-radius: 4px;
        }
        .control-group input[type="range"]::-webkit-slider-thumb {
            -webkit-appearance: none;
            appearance: none;
            width: 16px;
            height: 16px;
            background: #6366F1; /* Indigo-500 */
            border-radius: 50%;
            cursor: pointer;
        }
    </style>
</head>
<body class="bg-gray-900 text-gray-100 min-h-screen antialiased">

    <div id="app" class="flex h-screen overflow-hidden">

        <!-- 左側控制面板 (Control Panel) -->
        <div class="w-full lg:w-1/3 xl:w-1/4 p-6 flex flex-col space-y-6 bg-gray-800 border-r border-gray-700 overflow-y-auto">
            
            <!-- 標題與標語 -->
            <header class="pb-4 border-b border-gray-700">
                <h1 class="text-3xl font-extrabold text-indigo-400">共感工作室</h1>
                <p class="text-sm text-gray-400 mt-1">
                    將音樂轉化為生成藝術
                </p>
            </header>

            <!-- 1. 音樂輸入區 (Music Input) -->
            <div class="space-y-4">
                <h2 class="text-xl font-semibold text-gray-200">🎵 輸入音樂</h2>
                <div class="flex flex-col space-y-3">
                    <!-- 檔案輸入會觸發 JavaScript 中的 handleFileSelect 函數 -->
                    <input type="file" id="music-input" accept="audio/*" class="hidden" onchange="handleFileSelect(this.files)">
                    <label for="music-input" class="cursor-pointer bg-indigo-600 hover:bg-indigo-700 transition duration-150 text-white font-bold py-2 px-4 rounded-lg shadow-md flex items-center justify-center">
                        <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12"></path></svg>
                        上傳或選擇歌曲 (.mp3 / .wav)
                    </label>
                    <p id="file-name" class="text-sm text-gray-400 italic">未選擇檔案</p>
                    <audio id="audio-player" class="hidden" controls></audio>
                </div>
            </div>

            <!-- 2. 預設風格 (Style Presets) -->
            <div class="space-y-4 pt-4 border-t border-gray-700">
                <h2 class="text-xl font-semibold text-gray-200">✨ 選擇預設風格</h2>
                <div class="grid grid-cols-2 gap-3">
                    <button class="preset-btn bg-gray-700 hover:bg-gray-600 p-3 rounded-lg text-sm font-medium transition duration-150 border-2 border-transparent focus:border-indigo-400" data-preset="neon">霓虹故障風 (Neon Glitch)</button>
                    <button class="preset-btn bg-gray-700 hover:bg-gray-600 p-3 rounded-lg text-sm font-medium transition duration-150 border-2 border-transparent focus:border-indigo-400" data-preset="liquid">流動液態 (Liquid Flow)</button>
                    <button class="preset-btn bg-gray-700 hover:bg-gray-600 p-3 rounded-lg text-sm font-medium transition duration-150 border-2 border-transparent focus:border-indigo-400" data-preset="geometric">幾何波紋 (Geometric Wave)</button>
                    <button class="preset-btn bg-gray-700 hover:bg-gray-600 p-3 rounded-lg text-sm font-medium transition duration-150 border-2 border-transparent focus:border-indigo-400" data-preset="particle">能量粒子 (Energy Particle)</button>
                </div>
            </div>

            <!-- 3. 參數對應設定 (Mapping Parameters) -->
            <div class="space-y-4 pt-4 border-t border-gray-700">
                <h2 class="text-xl font-semibold text-gray-200">⚙️ 參數對應設定 (即時調整)</h2>
                
                <!-- 節拍/韻律對應 -->
                <div class="control-group">
                    <label class="block text-sm font-medium text-gray-300">節拍/韻律 (Beat/Rhythm) → 形狀尺寸 (Size)</label>
                    <input type="range" min="1" max="100" value="75" id="range-beat" class="w-full h-2 bg-gray-700 rounded-lg appearance-none cursor-pointer range-lg transition duration-150">
                </div>

                <!-- 頻率/音高對應 -->
                <div class="control-group">
                    <label class="block text-sm font-medium text-gray-300">頻率/音高 (Frequency/Note) → 顏色變化 (Color Shift)</label>
                    <input type="range" min="1" max="100" value="45" id="range-frequency" class="w-full h-2 bg-gray-700 rounded-lg appearance-none cursor-pointer range-lg transition duration-150">
                </div>
                
                <!-- 強度/音量對應 -->
                <div class="control-group">
                    <label class="block text-sm font-medium text-gray-300">強度/音量 (Intensity/Volume) → 粒子密度 (Density)</label>
                    <input type="range" min="1" max="100" value="90" id="range-intensity" class="w-full h-2 bg-gray-700 rounded-lg appearance-none cursor-pointer range-lg transition duration-150">
                </div>
                
                <!-- 動畫速度 -->
                <div class="control-group">
                    <label class="block text-sm font-medium text-gray-300">動畫速度 (Animation Speed)</label>
                    <input type="range" min="1" max="100" value="60" id="range-speed" class="w-full h-2 bg-gray-700 rounded-lg appearance-none cursor-pointer range-lg transition duration-150">
                </div>

            </div>

            <!-- 動作按鈕 -->
            <div class="pt-6 border-t border-gray-700">
                <!-- 啟動按鈕現在會觸發播放/暫停邏輯 -->
                <button id="start-btn" onclick="togglePlayback()" class="w-full bg-green-600 hover:bg-green-700 text-white font-bold py-3 rounded-lg text-lg shadow-xl transition duration-150 ease-in-out transform hover:scale-[1.02] active:scale-[0.98]">
                    ▶️ 開始生成 (NFT / 演唱會模式)
                </button>
            </div>
            
        </div>

        <!-- 右側視覺輸出區 (Visualization Output) -->
        <div class="flex-1 relative bg-black">
            <h2 class="absolute top-4 left-4 z-10 text-xl font-bold text-white bg-black bg-opacity-50 px-3 py-1 rounded-lg">
                即時視覺輸出區
            </h2>
            <canvas id="visualization-canvas"></canvas>
            
            <!-- 播放控制模擬 (現已連接到真實的 audio-player 狀態) -->
            <div class="absolute bottom-0 w-full p-4 bg-gray-900 bg-opacity-70 flex justify-center items-center space-x-4">
                <button class="p-3 bg-gray-700 hover:bg-gray-600 rounded-full transition duration-150" onclick="document.getElementById('audio-player').currentTime -= 5">
                    <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path></svg>
                </button>
                <button id="play-pause-btn-bottom" class="p-4 bg-indigo-600 hover:bg-indigo-500 rounded-full transition duration-150" onclick="togglePlayback()">
                    <svg class="w-8 h-8 text-white" id="play-pause-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.752 11.168l-3.197-2.132A1 1 0 0010 9.87v4.263a1 1 0 001.555.832l3.197-2.132a1 1 0 000-1.664z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                </button>
                <button class="p-3 bg-gray-700 hover:bg-gray-600 rounded-full transition duration-150" onclick="document.getElementById('audio-player').currentTime += 5">
                    <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3"></path></svg>
                </button>
            </div>
        </div>

    </div>

    <script type="module">
        // --- 全域變數 ---
        const canvas = document.getElementById('visualization-canvas');
        const audioPlayer = document.getElementById('audio-player');
        const fileNameDisplay = document.getElementById('file-name');
        const startBtn = document.getElementById('start-btn');
        const playPauseIcon = document.getElementById('play-pause-icon');
        
        // Three.js 變數
        let scene, camera, renderer;
        let cubes = [];
        const numCubes = 25; 
        
        // Web Audio API 變數
        let audioContext;
        let analyser;
        let dataArray;
        let isPlaying = false;

        // --- 核心音訊處理邏輯 (Web Audio API) ---

        /**
         * 初始化 Audio Context 並連接 AnalyserNode
         */
        function setupAudioAnalysis() {
            if (!audioContext) {
                // 首次互動時創建 AudioContext (解決瀏覽器自動播放限制)
                audioContext = new (window.AudioContext || window.webkitAudioContext)();
                
                // 創建 AnalyserNode
                analyser = audioContext.createAnalyser();
                analyser.fftSize = 256; // 頻譜分析的尺寸
                const bufferLength = analyser.frequencyBinCount;
                dataArray = new Uint8Array(bufferLength);
                
                // 創建 MediaElementSource
                const source = audioContext.createMediaElementSource(audioPlayer);
                
                // 連接節點: 來源 -> 分析器 -> 輸出
                source.connect(analyser);
                analyser.connect(audioContext.destination);
            }
        }

        /**
         * 處理檔案選擇事件
         * @param {FileList} files - 選擇的檔案列表
         */
        window.handleFileSelect = function(files) {
            if (files.length > 0) {
                const file = files[0];
                
                // --- 偵錯日誌：確認檔案是否被正確選取 ---
                console.log("檔案已選取:", file.name, "大小:", file.size, "MIME類型:", file.type);
                // ----------------------------------------
                
                fileNameDisplay.textContent = file.name;

                // 設置 audio 元素的源為上傳的檔案
                audioPlayer.src = URL.createObjectURL(file);
                
                // 預先設定好 Analyser
                setupAudioAnalysis(); 
                
                // 重設播放狀態
                isPlaying = false;
                updateButtonState();
            } else {
                fileNameDisplay.textContent = '未選擇檔案';
                audioPlayer.src = '';
            }
        };

        /**
         * 播放/暫停音樂，並啟動/停止視覺化
         */
        window.togglePlayback = function() {
            if (!audioPlayer.src) {
                console.error("請先上傳音樂檔案。");
                // 這裡可以使用自定義 Modal 顯示錯誤訊息
                startBtn.textContent = "❌ 請先上傳檔案";
                setTimeout(() => updateButtonState(), 1500);
                return;
            }

            if (isPlaying) {
                audioPlayer.pause();
                isPlaying = false;
            } else {
                // 確保 AudioContext 狀態是 running
                if (audioContext && audioContext.state === 'suspended') {
                    audioContext.resume();
                }
                audioPlayer.play().catch(e => console.error("播放失敗:", e));
                isPlaying = true;
            }

            updateButtonState();
        };

        /**
         * 更新按鈕的文字和圖示狀態
         */
        function updateButtonState() {
            if (isPlaying) {
                startBtn.innerHTML = '⏸️ 暫停生成 (點擊停止)';
                startBtn.classList.remove('bg-green-600', 'hover:bg-green-700');
                startBtn.classList.add('bg-red-600', 'hover:bg-red-700');
                // 底部按鈕圖示切換為暫停
                playPauseIcon.innerHTML = `<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 9v6m4-6v6m7-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>`; 
            } else {
                startBtn.innerHTML = '▶️ 開始生成 (NFT / 演唱會模式)';
                startBtn.classList.remove('bg-red-600', 'hover:bg-red-700');
                startBtn.classList.add('bg-green-600', 'hover:bg-green-700');
                // 底部按鈕圖示切換為播放
                playPauseIcon.innerHTML = `<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.752 11.168l-3.197-2.132A1 1 0 0010 9.87v4.263a1 1 0 001.555.832l3.197-2.132a1 1 0 000-1.664z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>`;
            }
        }

        // --- Three.js 視覺化邏輯 ---

        /**
         * Initialize the Three.js scene, camera, and renderer.
         */
        function init() {
            scene = new THREE.Scene();
            // 背景色改為深藍灰
            scene.background = new THREE.Color(0x111827); 

            // Camera setup
            camera = new THREE.PerspectiveCamera(75, canvas.clientWidth / canvas.clientHeight, 0.1, 1000);
            // 拉近攝影機
            camera.position.z = 5; 

            // Renderer setup
            renderer = new THREE.WebGLRenderer({ canvas: canvas, antialias: true });
            resizeRenderer();

            // Add lighting - 增強光線確保物件可見
            const ambientLight = new THREE.AmbientLight(0xffffff, 1.5); 
            scene.add(ambientLight);
            const directionalLight = new THREE.DirectionalLight(0xffffff, 3);
            directionalLight.position.set(5, 5, 5).normalize();
            scene.add(directionalLight);

            // Add AxesHelper for debug confirmation - 加入座標軸輔助工具
            // 紅色 = X, 綠色 = Y, 藍色 = Z
            const axesHelper = new THREE.AxesHelper( 5 ); 
            scene.add( axesHelper );

            // Create cubes
            const cubeGeometry = new THREE.BoxGeometry(0.5, 0.5, 0.5);
            
            // 修正材質為 MeshStandardMaterial (更真實的著色)
            const baseMaterial = new THREE.MeshStandardMaterial({ 
                color: 0x6366F1, // Indigo 500
                emissive: 0x1E40AF, // Blue 800 - 給予輕微的自發光效果
                metalness: 0.2, 
                roughness: 0.5 
            }); 
            
            // 將方塊排列成 5x5 網格
            const cols = 5;
            const rows = 5;
            const spacing = 1.2;

            for (let i = 0; i < numCubes; i++) {
                const cube = new THREE.Mesh(cubeGeometry, baseMaterial.clone());
                
                const row = Math.floor(i / cols);
                const col = i % cols;

                // 計算網格中心位置
                cube.position.x = (col - (cols - 1) / 2) * spacing;
                cube.position.y = (row - (rows - 1) / 2) * spacing;
                cube.position.z = 0; // 放置在攝影機前方 

                cube.initialY = cube.position.y; // Store initial Y for beat pulsing
                cubes.push(cube);
                scene.add(cube);
            }
        }
        
        /**
         * 獲取真實的音訊分析數據
         */
        function getRealAudioAnalysis() {
            if (!analyser || !isPlaying) {
                // 如果沒有播放或分析器未設定，則返回零數據
                return { beat: 0, frequency: 0, intensity: 0, speed: 1.0 };
            }

            // 將頻率數據複製到 dataArray
            analyser.getByteFrequencyData(dataArray);

            let sumIntensity = 0;
            let lowFreqSum = 0; // 低頻 (約節拍/低音)
            let midFreqSum = 0; // 中頻 (約人聲/樂器)
            const lowFreqRange = Math.floor(dataArray.length * 0.15); // 15% for low
            const midFreqRange = Math.floor(dataArray.length * 0.4);  // 40% for mid

            for (let i = 0; i < dataArray.length; i++) {
                const value = dataArray[i] / 255; // Normalize to 0-1
                sumIntensity += value;

                if (i < lowFreqRange) {
                    lowFreqSum += value;
                } else if (i < midFreqRange) {
                    midFreqSum += value;
                }
            }

            // 總音量 (Intensity) - 平均強度
            const intensity = sumIntensity / dataArray.length;

            // 節拍 (Beat) - 低頻平均強度 (用於尺寸脈衝)
            const beat = lowFreqSum / lowFreqRange; 

            // 頻率/音高 (Frequency) - 中頻平均強度 (用於顏色變化)
            const frequency = midFreqSum / (midFreqRange - lowFreqRange);
            
            // 動畫速度 (Speed) - 取決於音量或自定義滑桿 (暫時使用固定值)
            const speed = 1.0 + (intensity * 0.5); 

            return { beat: beat, frequency: frequency, intensity: intensity, speed: speed };
        }

        /**
         * The main animation loop.
         */
        function animate() {
            requestAnimationFrame(animate);

            // 獲取真實的音訊數據 (如果正在播放)
            const audioData = getRealAudioAnalysis();
            const { beat, frequency, intensity, speed } = audioData;

            // 獲取使用者滑桿值 (從 1-100 轉換為 0.01-1.00 的影響係數)
            const beatControl = parseFloat(document.getElementById('range-beat').value) / 100;
            const freqControl = parseFloat(document.getElementById('range-frequency').value) / 100;
            const densityControl = parseFloat(document.getElementById('range-intensity').value) / 100;
            const speedControl = parseFloat(document.getElementById('range-speed').value) / 100;

            // 攝影機基礎旋轉速度 (加快，更容易看出動畫是否啟動)
            const baseCamSpeed = 0.005;
            camera.rotation.y += baseCamSpeed * (1 + speedControl * 2);

            // 將音訊數據應用到視覺效果
            cubes.forEach((cube, index) => {
                
                // 1. 節拍/韻律 (Beat) → 形狀尺寸 (Size)
                const scaleFactor = 1.0 + (beat * 1.0 * beatControl);
                cube.scale.setScalar(scaleFactor);

                // 2. 強度/音量 (Intensity) → 粒子密度 (Vertical movement/position)
                // 基礎波浪速度，即使沒有音樂也在動
                const baseWaveSpeed = 0.005; 
                const totalWaveSpeed = baseWaveSpeed + (0.003 * speed);

                // 使用 Math.sin 創建垂直波動，並受 Intensity/Density 影響
                cube.position.y = cube.initialY + (Math.sin(Date.now() * totalWaveSpeed + index * 0.5) * 0.5 * densityControl); 
                
                // 3. 頻率/音高 (Frequency) → 顏色變化 (Color Shift)
                // 使用 HSL 設置顏色，讓顏色變化更平滑
                const h = (frequency * 0.7 + freqControl * 0.3) % 1; 
                const s = 0.8;
                const l = 0.5 + intensity * 0.3; 
                
                cube.material.color.setHSL(h, s, l);
                
                // 4. 整體動畫速度 (Cube Rotation)
                const baseRotationSpeed = 0.01; // 加快方塊旋轉速度
                cube.rotation.x += baseRotationSpeed * (1 + speed * speedControl);
                cube.rotation.y += baseRotationSpeed * (1 + speed * speedControl);
            });

            renderer.render(scene, camera);
        }

        /**
         * Handles window resizing to keep the visualization responsive.
         */
        function resizeRenderer() {
            const container = canvas.parentElement;
            const width = container.clientWidth;
            const height = container.clientHeight;
            
            // Set canvas size
            canvas.width = width;
            canvas.height = height;

            // Update camera aspect ratio
            camera.aspect = width / height;
            camera.updateProjectionMatrix();

            // Update renderer size
            renderer.setSize(width, height);
        }

        // Initialize and start the loop
        window.addEventListener('resize', resizeRenderer);
        window.onload = function() {
            init();
            animate(); // Start the animation loop immediately
            updateButtonState(); // 初始化按鈕狀態
        };
    </script>
</body>
</html>
