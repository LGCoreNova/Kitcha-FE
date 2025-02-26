# Stage 1: Build
FROM node:22-alpine AS builder
WORKDIR /app

ARG VITE_API_BASE_URL
COPY package*.json ./
RUN echo "VITE_API_BASE_URL=${VITE_API_BASE_URL}" > .env
RUN npm install

COPY . .
RUN npm run build

# Stage 2: Run - nginx serving
FROM nginx:stable-alpine

COPY --from=builder /app/dist /usr/share/nginx/html

# 사용자 정의 Nginx 설정 파일 복사 (nginx.conf를 프로젝트 루트에 두세요)
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]