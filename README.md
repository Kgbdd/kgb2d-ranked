<h1 align="center" id="title">Kgb2d Ranked Server Open Source</h1>
<p align="center"><img src="https://raw.githubusercontent.com/Kgbdd/kgb2d-ranked/main/gfx/kgb2d/serverinfo/kgb2d.png"></p>

<p id="description">This is an open source development repository of Official Kgb2d Ranked server.</p>

<h2>🛠️ Installation Steps:</h2>

<p>1. Copy all the files to your CS2D root directory.</p>

<p>2. Check out serverinfo.txt and edit for your needs.</p>

```
sys/serverinfo.txt
```

<p>3. Check out servertransfer.lst and edit for your need.</p>

```
sys/servertransfer.lst
```

<p>4. Check out server.cfg and edit for your needs.</p>

```
sys/server.cfg
```

<h2>🛠️ Iptables Config:</h2>

```
sudo iptables -A INPUT -p udp -m length --length 0:30 -j DROP
sudo iptables -A INPUT -p udp --dport 36963 -m connlimit --connlimit-above 65 -j DROP
sudo iptables -A INPUT -p udp -m limit --limit 10/second -j ACCEPT
sudo iptables -A INPUT -p udp -m limit --limit-burst 50 -j DROP
sudo iptables -A INPUT -p udp -m multiport --dports 500,1194,4500 -j DROP
```

