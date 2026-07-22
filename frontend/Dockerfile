# --- STAGE 1: Build the React Application ---
FROM node:20-slim AS builder

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .

# Pass the backend URL during the build phase so Vite can bake it into the static files
ARG VITE_API_URL
ENV VITE_API_URL=$VITE_API_URL

RUN npm run build

# --- STAGE 2: Serve with Nginx ---
FROM nginx:alpine

# Copy the production build assets from Stage 1 to Nginx's public folder
COPY --from=builder /usr/src/app/dist /usr/share/nginx/html

# Expose Nginx web server port
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]