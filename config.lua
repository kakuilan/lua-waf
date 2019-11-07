-- 配置
-- 模块名必须是全局,否则ngx找不到
local config = {}

-- 日志目录
config.logdir = "/www/wwwlogs/lua-waf"
-- 是否开启日志
config.openlog = true
-- IPV6检查的地址URL,其中%s为占位符,将会使用具体IP去替换
config.ipv6Url = "http://11.22.33.44:5566/ipaddr?ips=%s"

-- 拒绝页html
config.denyHtml = [[
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>403</title>
    <style>
        * {
            color: black !important;
        }

        body {
            font-family: "Arial", "Microsoft YaHei";
        }

        .noService {
            width: 1200px;
            height: 500px;
            position: absolute;
            top: 0;
            bottom: 0;
            right: 0;
            left: 0;
            margin: auto;
        }

        .noService .item {
            display: inline-block;
            vertical-align: middle;
        }

        .noService .icon {
            width: 500px;
        }

        .noService .txt {
            width: 615px;
            text-align: center;
            font-size: 20px;
        }

        .noService .txt p,
        span {
            color: #f0eff0;
        }

        .noService .txt h1 {
            color: #ffae00;
            font-size: 70px;
        }

        .noService .txt a {
            text-decoration: none;
            color: #fcdf00;
            font-size: 22px;
        }

        .title1 {
            font-size: 50px;
            text-align: center;
            font-weight: bold;
            margin: 12px;
        }

        .title2 {
            font-size: 30px;
            text-align: center;
            font-weight: bold;
            margin: 12px;
        }

        #iperror {
            display: block;
            font-size: 20px;
            text-align: center;
        }
    </style>
</head>

<body>
    <p class="title1">403 Forbidden</p>
    <p class="title2">You don't have permission to access / on this server！</p>
    <a id="iperror">
        Your IP details : denyIp
    </a>
</body>
</html>
]]

return config