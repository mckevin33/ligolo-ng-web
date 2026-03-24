# Ligolo-ng with Web UI

Build ligolo-ng proxy and agent binaries with the embedded web UI baked in. The Dockerfile clones the latest [ligolo-ng](https://github.com/nicocha30/ligolo-ng) and [ligolo-ng-web](https://github.com/nicocha30/ligolo-ng-web), builds the frontend, and compiles static binaries for multiple platforms.

## Requirements

- Docker

## Usage

```bash
make build
```

Binaries will be in `./build/`. Run `make clean` to remove them.

## Install as a Service

```bash
make install
```

This builds the binaries and installs ligolo-ng proxy as a systemd service. After installation, run the proxy once manually to generate the config file, then start the service:

```bash
┌──(kali㉿kali)-[~/Desktop/ligolo-ng-web]
└─$ cd /etc/ligolo-ng
                                                                                                                                                                                                                                      
┌──(kali㉿kali)-[/etc/ligolo-ng]
└─$ sudo ./ligolo-proxy -selfcert
INFO[0000] Loading configuration file ligolo-ng.yaml    
WARN[0000] daemon configuration file not found. Creating a new one... 
? Enable Ligolo-ng WebUI? Yes
? Allow CORS Access from https://webui.ligolo.ng? No
WARN[0003] WebUI enabled, default username and login are ligolo:password - make sure to update ligolo-ng.yaml to change credentials! 
WARN[0003] Using default selfcert domain 'ligolo', beware of CTI, SOC and IoC! 
ERRO[0003] Certificate cache error: acme/autocert: certificate cache miss, returning a new certificate 
INFO[0003] Listening on 0.0.0.0:11601                   
INFO[0003] Starting Ligolo-ng Web, API URL is set to: http://127.0.0.1:8080 
WARN[0003] Ligolo-ng API is experimental, and should be running behind a reverse-proxy if publicly exposed. 
    __    _             __                       
   / /   (_)___ _____  / /___        ____  ____ _                                                                                                                                                                                     
  / /   / / __ `/ __ \/ / __ \______/ __ \/ __ `/                                                                                                                                                                                     
 / /___/ / /_/ / /_/ / / /_/ /_____/ / / / /_/ /                                                                                                                                                                                      
/_____/_/\__, /\____/_/\____/     /_/ /_/\__, /                                                                                                                                                                                       
        /____/                          /____/                                                                                                                                                                                        
                                                                                                                                                                                                                                      
  Made in France ♥            by @Nicocha30!                                                                                                                                                                                          
  Version: dev                                                                                                                                                                                                                        
                                                                                                                                                                                                                                      
ligolo-ng » exit

┌──(kali㉿kali)-[/etc/ligolo-ng]
└─$ sudo systemctl enable ligolo-ng
Created symlink '/etc/systemd/system/multi-user.target.wants/ligolo-ng.service' → '/etc/systemd/system/ligolo-ng.service'.
                                                                                                                                                                                                                                      
┌──(kali㉿kali)-[/etc/ligolo-ng]
└─$ sudo systemctl start ligolo-ng

```

## Web UI

Open `http://localhost:8080` in your browser. Set the API URL to `http://localhost:8080`. Default credentials: `ligolo` / `password`.
