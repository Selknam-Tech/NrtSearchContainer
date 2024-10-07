# Usamos una imagen base de Java
FROM openjdk:21-jdk-slim

# Variables de entorno
ENV NRTSEARCH_HOME /opt/nrtsearch

# Creamos el directorio de trabajo
WORKDIR $NRTSEARCH_HOME

# Instalamos git y las dependencias necesarias
RUN apt-get update && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/*

# Clonamos el repositorio de nrtSearch
RUN git clone https://github.com/Yelp/nrtsearch.git $NRTSEARCH_HOME

# Compilamos e instalamos nrtSearch y el gateway gRPC-REST
RUN ./gradlew clean installDist && \
    ./gradlew buildGrpcGateway

# Exponemos los puertos para el gRPC y la API REST
EXPOSE 8080 9090

# Comando para iniciar la API REST y el servidor gRPC
CMD ["./build/install/nrtsearch/bin/http_wrapper-linux-amd64", "9090", "8080"]
