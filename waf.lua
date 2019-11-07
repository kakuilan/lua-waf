-- 前端防火墙
-- require 'init'
ngx.ctx.startTime = kutil:getMilliseconds()
ngx.ctx.allowIp = true -- 默认允许通过
ngx.ctx.tipMst = '允许'
ngx.ctx.errors = {}

-- nginx未配置 memcache 服务
if ngx.var.memcache_server == nil then
    return
end

-- memcache 未能正常连接
local memConf = kutil:split(ngx.var.memcache_server, ':')
local memc, ok = kutil:openMemcache(memConf[1], memConf[2])
if not ok then
    return
end

local ip = kutil:getClientIp()

-- 先检查允许的IP,key中保存字符串,如 1.1.1.1,2.2.2.2,3.3.3.3,4.4.4.4
local res, _, err = memc:get("Authorized_IP")
if err then
    table.insert(ngx.ctx.errors, err)
    return
elseif (res ~= nil) then
    local pos, _ = string.find(tostring(res), ip, 1, true)
    -- 在允许的IP中
    if pos ~= nil then
        return
    end
end

-- 再检查拒绝的IP,key中保存字符串,如 1.1.1.1,2.2.2.2,3.3.3.3,4.4.4.4
local res, _, err = memc:get("Forbidden_IP")
if err then
  table.insert(ngx.ctx.errors, err)
elseif (err == nil and res ~= nil) then
    local pos, _ = string.find(tostring(res), ip, 1, true)
    -- 在拒绝的IP中
    if pos ~= nil then
        ngx.ctx.allowIp = false
        ngx.ctx.tipMst = '拒绝ip'
        kutil:sayDeny(ip)
        return
    end
end

-- 最后检查拒绝的区域,key中保存字符串,如 广东,海南,荷兰,瑞典
local res, _, err = memc:get("Forbidden_Area")
if err then
  table.insert(ngx.ctx.errors, err)
elseif (err == nil and res ~= nil) then
    res = tostring(res)

    -- 是否IPV6
    if kutil:isIpv4(ip) then
        local row = kutil:getIpRow(ip)
        if row ~= nil then
            -- 先看省份
            local provincePos, _ = string.find(res, tostring(row['province']), 1, true)
            if provincePos ~= nil then
                ngx.ctx.allowIp = false
                ngx.ctx.tipMst = '拒绝省份:' .. tostring(row['province'])
                kutil:sayDeny(ip)
                return
            end

            -- 再看国家
            local nationPos, _ = string.find(res, tostring(row['nation']), 1, true)
            if nationPos ~= nil then
                ngx.ctx.allowIp = false
                ngx.ctx.tipMst = '拒绝国家:' .. tostring(row['nation'])
                kutil:sayDeny(ip)
                return
            end
        end
    else
        --IPV6通过接口去检查
        local resV6 = kutil:checkIpv6(ip)
        if resV6 ~= nil then
            local areas = kutil:split(res, '"')
            for _, v in pairs(areas) do
                local chkPos,_ = string.find(resV6, v, 1, true)
                if chkPos~=nil and v~=nil then
                    ngx.ctx.allowIp = false
                    ngx.ctx.tipMst = string.format("拒绝ipv6: %s, %s", ip, v)
                    kutil:sayDeny(ip)
                    return
                end
            end
        end
    end

end

-- 测试局域网
local chk,_ = string.find(ip, '192.168.', 1, true)
if chk ~= nil then
    ngx.ctx.allowIp = false
    ngx.ctx.tipMst = '拒绝局域网'
    kutil:sayDeny(ip)
    return
end
