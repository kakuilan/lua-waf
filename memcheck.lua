-- memchace 连接检查

local memConf = kutil:split(ngx.var.memcache_server, ':')
local memc, ok = kutil:openMemcache(memConf[1], memConf[2])

if not ok then
  ngx.say('memcache server connect fail!')
else
  local authIps, _, err = memc:get("Authorized_IP")
  local forbIps, _, err = memc:get("Forbidden_IP")
  local forbArea, _, err = memc:get("Forbidden_Area")
  ngx.say('memcache server connect success!')
  ngx.say('Authorized_IP:' .. tostring(authIps))
  ngx.say('Forbidden_IP:' .. tostring(forbIps))
  ngx.say('Forbidden_Area:' .. tostring(forbArea))
end
