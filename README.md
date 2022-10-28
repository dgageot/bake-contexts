When multiple images share the same context, it's way faster to create a base image that contains a copy of the whole context
and have the downstream builds copy from this base image instead of from the "." context.

Slow build (takes minutes):
```bash
BASE="." docker buildx bake -f slow.hcl --load
```

Faster build (19s):
```bash
BASE="target:base" docker buildx bake -f slow.hcl --load
```

The faster solution requires changing all of our Dockerfiles.
`COPY x y` becomes `COPY --from=base x y`
It would be much simpler if we could redefine the "." context and set it to "target:base".

Another issue is visible with this example:

Even though the build takes 18.5s, almost all the build steps show 0.0s and the total sum of those steps is 4.7s.
Where are he other 14s spent?
When I look at the build, I have the feeling that the time taken to write the image is more than 0.7s.
By the way, each time I run this build, the result is the same but it seems that the image still gets loaded over and over again.

```
[+] Building 18.5s (173/173) FINISHED
 => [base internal] load build definition from Dockerfile                                                            0.0s
 => => transferring dockerfile: 59B                                                                                  0.0s
 => [base internal] load .dockerignore                                                                               0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg26 internal] load build context                                                                              0.0s
 => => transferring context: 7.50kB                                                                                  0.0s
 => CACHED [pkg26 1/1] COPY . .                                                                                      0.1s
 => [pkg26] exporting to image                                                                                       0.7s
 => => exporting layers                                                                                              0.0s
 => => writing image sha256:b028daff45f597ec1bf4a6a090391c5dce0fff854def9057b4ee005ee79ff8ea                         0.0s
 => => writing image sha256:82f0fd8aa9e650107ba5a6909752e26afe17d183af92d54ec28396ad44af70e5                         0.0s
 => [pkg04 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 360B                                                                                 0.0s
 => [pkg12 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg32 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg30 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg25 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg05 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg18 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg14 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg15 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg02 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg10 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg38 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg36 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg19 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg23 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg39 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg03 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg28 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg08 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg37 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg21 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg35 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg20 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg06 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg00 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg13 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg33 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg27 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg29 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg24 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg09 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg22 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg16 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg01 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg07 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg11 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg31 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg34 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg17 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg26 internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 32B                                                                                  0.0s
 => [pkg04 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg12 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg32 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg30 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg25 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg05 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg18 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg14 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg15 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg02 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg10 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg38 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg36 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg19 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg23 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg39 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg03 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg28 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg08 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg37 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg21 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg35 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg20 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg06 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg00 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg13 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg33 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg27 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg29 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg24 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg09 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg22 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg16 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg01 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg07 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg11 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg31 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg34 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg17 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg26 internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                      0.0s
 => [pkg26] resolve image config for docker.io/docker/dockerfile@sha256:9ba7531bd80fb0a858632727cf7a112fbfd19b17e94  0.0s
 => CACHED [pkg26] docker-image://docker.io/docker/dockerfile@sha256:9ba7531bd80fb0a858632727cf7a112fbfd19b17e94c4e  0.0s
 => [pkg04 internal] load .dockerignore                                                                              0.0s
 => [pkg04 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg26 internal] load metadata for docker.io/library/golang:1.19.2-alpine3.16@sha256:e4dcdac3ed37d8c2b3b8bcef29  0.0s
 => [pkg26 build 1/4] FROM docker.io/library/golang:1.19.2-alpine3.16@sha256:e4dcdac3ed37d8c2b3b8bcef2909573b2ad9c2  0.0s
 => CACHED [pkg26 build 2/4] WORKDIR /src                                                                            0.0s
 => CACHED [pkg26 build 3/4] COPY --from=base . ./                                                                   0.9s
 => CACHED [pkg26 build 4/4] RUN go build -o main ./pkg1/                                                            3.0s
 => [pkg12 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg12 internal] load .dockerignore                                                                              0.0s
 => [pkg32 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg32 internal] load .dockerignore                                                                              0.0s
 => [pkg30 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg30 internal] load .dockerignore                                                                              0.0s
 => [pkg25 internal] load .dockerignore                                                                              0.0s
 => [pkg25 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg05 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg05 internal] load .dockerignore                                                                              0.0s
 => [pkg18 internal] load .dockerignore                                                                              0.0s
 => [pkg18 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg14 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg14 internal] load .dockerignore                                                                              0.0s
 => [pkg15 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg15 internal] load .dockerignore                                                                              0.0s
 => [pkg02 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg02 internal] load .dockerignore                                                                              0.0s
 => [pkg10 internal] load .dockerignore                                                                              0.0s
 => [pkg10 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg38 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg38 internal] load .dockerignore                                                                              0.0s
 => [pkg36 internal] load .dockerignore                                                                              0.0s
 => [pkg36 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg19 internal] load .dockerignore                                                                              0.0s
 => [pkg19 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg23 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg23 internal] load .dockerignore                                                                              0.0s
 => [pkg39 internal] load .dockerignore                                                                              0.0s
 => [pkg39 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg03 internal] load .dockerignore                                                                              0.0s
 => [pkg03 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg28 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg28 internal] load .dockerignore                                                                              0.0s
 => [pkg08 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg08 internal] load .dockerignore                                                                              0.0s
 => [pkg37 internal] load .dockerignore                                                                              0.0s
 => [pkg37 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg21 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg21 internal] load .dockerignore                                                                              0.0s
 => [pkg35 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg35 internal] load .dockerignore                                                                              0.0s
 => [pkg20 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg20 internal] load .dockerignore                                                                              0.0s
 => [pkg06 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg06 internal] load .dockerignore                                                                              0.0s
 => [pkg00 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg00 internal] load .dockerignore                                                                              0.0s
 => [pkg13 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg13 internal] load .dockerignore                                                                              0.0s
 => CACHED [pkg26 stage-1 1/1] COPY --from=build /src/main /main                                                     0.0s
 => [pkg33 internal] load .dockerignore                                                                              0.0s
 => [pkg33 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg29 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg29 internal] load .dockerignore                                                                              0.0s
 => [pkg27 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg27 internal] load .dockerignore                                                                              0.0s
 => [pkg24 internal] load .dockerignore                                                                              0.0s
 => [pkg24 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg09 internal] load .dockerignore                                                                              0.0s
 => [pkg09 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg22 internal] load .dockerignore                                                                              0.0s
 => [pkg22 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg16 internal] load .dockerignore                                                                              0.0s
 => [pkg16 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg01 internal] load .dockerignore                                                                              0.0s
 => [pkg01 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg07 internal] load .dockerignore                                                                              0.0s
 => [pkg07 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg11 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg11 internal] load .dockerignore                                                                              0.0s
 => [pkg31 internal] load .dockerignore                                                                              0.0s
 => [pkg31 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg34 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg34 internal] load .dockerignore                                                                              0.0s
 => [pkg17 internal] load build definition from Dockerfile                                                           0.0s
 => [pkg17 internal] load .dockerignore                                                                              0.0s
 => [pkg26 internal] load .dockerignore                                                                              0.0s
 => [pkg26 internal] load build definition from Dockerfile                                                           0.0s
```