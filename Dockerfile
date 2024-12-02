# 使用最新兼容的 Node.js 版本
FROM node:16-alpine

# 构建参数
ARG CHANGE_APK_SOURCE=false
ARG CHANGE_NPM_SOURCE=false

# 设置环境变量
ENV NODE_ENV=production
WORKDIR /blog

# 切换源、安装 Hexo CLI 和依赖
RUN set -xe \
    && if [ "${CHANGE_APK_SOURCE}" = "true" ]; then \
        sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories ; \
    fi \
    && apk update && apk add --no-cache git libc6-compat \
    && if [ "${CHANGE_NPM_SOURCE}" = "true" ]; then \
        npm config set registry http://mirrors.cloud.tencent.com/npm/ ; \
    fi \
    && npm install hexo-cli@latest

# 将本地内容复制到镜像中
COPY . .

# 安装项目依赖
RUN npm install

# 暴露端口
EXPOSE 4000

# 默认启动命令
CMD ["npx", "hexo", "server", "-i", "0.0.0.0"]