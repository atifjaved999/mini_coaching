FROM node:18-bullseye

WORKDIR /app

COPY package.json yarn.lock ./

# Prevent rollup native module install
ENV ROLLUP_NO_BINARY=true

RUN yarn install --frozen-lockfile

# Optional cleanup
RUN rm -rf node_modules/rollup/dist/native

COPY . .

CMD ["yarn", "dev"]
