-- memchace 连接检查

local memConf = kutil:split(ngx.var.memcache_server, ':')
local _, ok = kutil:openMemcache(memConf[1], memConf[2])

if not ok then
  ngx.say('memcache server connect fail!')
else
  ngx.say('memcache server connect success!')
end
