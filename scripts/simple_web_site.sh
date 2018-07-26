#!/bin/bash
LSB=`cat /etc/lsb-release`

cat > index.html <<EOF
<html>
    <head></head> 
    <body>
        <h2>Ric Test</h2>
        <b>Database address:</b> <a style='color:red;'>${db_address}</a><br />
        <b>Database port:</b> <a style='color:red;'>${db_port}</a><br />
        Web servers are using the port <b>${http_port}</b><br />
        Linux distribution: <br />
        $LSB <br /><br /><br />
        <footer style="font-size='small'">Version ${version}</footer>
    </body>
</html>
EOF

nohup busybox httpd -f -p "${http_port}" &