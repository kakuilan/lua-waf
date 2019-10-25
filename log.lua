-- 日志

if not ngx.ctx.allowIp or kutil:random(1, 100)==1 then
  kutil:log()
end