# orne-babanya-docker
---
### ビルド
```
./build.sh
```
### 起動
- CPUだけを使用
```
xhost +local:
./run_cpu.sh
```
- GPUを使用
```
xhost +local:
./run_gpu.sh
```
### ログイン（2回目以降）
```
xhost +local:
./login.sh
```
### Docker Hub へのアップロード
```
# DockerHub ログイン
docker login

# タグ付け（既に正しいタグなら省略可）
docker tag ryuseibaba/orne-babanya ryuseibaba/orne-babanya:latest

# プッシュ
docker push ryuseibaba/orne-babanya:latest
```