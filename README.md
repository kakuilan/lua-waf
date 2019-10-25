# lua-waf
lua-waf web应用防火墙

## 目录
- 将源码拷贝至/www/server/lua-waf 
- 修改目录权限
```shell
sudo chown -R www:www /www/server/lua-waf
sudo chmod -R g+xwr /www/server/lua-waf
```

## 安装依赖
```shell
#使用lua 5.1
sudo yum install -y lua luajit lua-devel lua-static lua-md5 lua-fun lua-json lua-socket

lua -v
Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio

luajit -v
LuaJIT 2.0.4 -- Copyright (C) 2005-2015 Mike Pall. http://luajit.org/

#其他扩展包
sudo yum install -y luarocks
sudo yum install -y sqlite sqlite-devel
sudo luarocks install luasql-sqlite3
```

## 配置
- 须使用nginx openresty
- 在nginx的http段最前面添加
```shell
        lua_shared_dict limit 50m;
        lua_code_cache on;
        lua_package_path "/usr/lib64/lua/5.1/?.lua;/usr/lib64/lua/5.1/?/init.lua;/www/server/nginx/lualib/resty/?.lua;/www/server/lua-waf/?.lua;;";
        init_by_lua_file /www/server/lua-waf/init.lua;
```

- 修改nginx的server段,添加
```shell
    set $memcache_server '127.0.0.1:11211';
    location ~ /memcheck {
        default_type "text/html";
        charset utf-8;
        content_by_lua_file /www/server/lua-waf/memcheck.lua;
    }

    location / {       
        access_by_lua_file /www/server/lua-waf/waf.lua;
        log_by_lua_file /www/server/lua-waf/log.lua;
        try_files $uri $uri/ /index.html;
    }    
```

