# shiny-docker

create golem app
```
golem::create_golem(path = "app")
```

```
golem::add_dockerfile_with_renv()
```

docker build -f Dockerfile_base --progress=plain -t app_base .
docker build -f Dockerfile --progress=plain -t app:latest .
docker run -p 80:80 app:latest
# then go to 127.0.0.1:80
