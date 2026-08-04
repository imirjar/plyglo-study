FROM flutter:3.24.0
WORKDIR /app
COPY . .
RUN flutter build web --release 
VOLUME /app/build/web 

