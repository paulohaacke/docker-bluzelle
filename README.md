# Description

Bluzelle related docker images.

# How to use this image

```shell
docker run -it -p1317:1317 --rm paulohaacke/algorand-private-network
```

# Environment Variables

## BLUZELLE_INITIAL_ACCOUNT_BALANCE

Variable holding the balance for the initial account. 

# Ports

* RESTful server: 1317
* RPC server: 26657
* P2P connection: 26656

