# Microblink Java

This is the optimal Java runtime built from OpenJDK and based on Alpine Linux.  

## Description

With the OpenJDK it is available the whole Java Development Kit, but to reduce the runtime size, this runtime is built with `jlink` which keeps only required parts of the OpenJDK for running Java applications (just for running not for compiling), for the development you should still use whole JDK. 

## Compare Sizes

The whole [OpenJDK](https://jdk.java.net) has around `317MB` but reduced custom build runtime with `jlink` has only `91MB`. This reduced runtime is based on [Alpine Linux](https://hub.docker.com/_/alpine) and this is the most optimal by size generic Java runtime. 

## Primary Usage

This image is `BASE` docker image for the [Microblink API](https://hub.docker.com/r/microblink/api) docker image. More details about Microblink API and other Microblink's products please find at https://microblink.com