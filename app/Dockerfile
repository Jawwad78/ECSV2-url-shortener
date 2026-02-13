#Build stage
FROM python:3.11-slim AS build
WORKDIR /app
COPY requirements.txt .
#--prefix/downloads means which folder we want, that's inside requirements.txt to go to , so in this case it's called downloads (it can be called anything)
RUN pip install --prefix=/downloads -r requirements.txt
COPY src/ ./src


#Runtime stage ..


#distroless image means ONLY the necessary things we need in runtime and that's what we copied from build stage , *there wont be any shell inside 
FROM gcr.io/distroless/python3-debian12
#pythonpath means we r telling python to also look in this path aswell when it will run and tablename is the dynamodb table name that we'll configure
ENV PYTHONPATH=/usr/local/lib/python3.11/site-packages \
WORKDIR /app
COPY --from=build /downloads /usr/local
COPY --from=build /app/src .
#non root user for for a distroless image, you can't create your own as distroless doesn't have a shell
USER 65532:65532
EXPOSE 8080
CMD ["-m", "uvicorn", "main:app", "--host=0.0.0.0", "--port=8080"]