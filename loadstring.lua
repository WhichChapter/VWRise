shared.RiseMode = true
local env = getgenv()
local httpRequest = env.request or (type(http) == "table" and http.request) or request
assert(type(httpRequest) == "function", "Executor request() is unavailable")

-- Install the HTTP bridge before loading any VWRise code.
env.RiseHttpRequest = function(options)
    assert(type(options) == "table" and type(options.Url) == "string",
        "RiseHttpRequest expects an options table with a Url")
    local result = httpRequest(options)
    assert(type(result) == "table", "Executor request() returned no response")
    return result
end

env.RiseHttpGet = function(url)
    local result = env.RiseHttpRequest({Url = url, Method = "GET"})
    local status = tonumber(result.StatusCode or result.Status)
    assert((result.Success == true or status == 200) and type(result.Body) == "string",
        ("HTTP GET failed (%s): %s"):format(tostring(status or "no response"), url))
    return result.Body
end

local response = httpRequest({
    Url = "https://raw.githubusercontent.com/WhichChapter/VWRise/main/NewMainScript.lua",
    Method = "GET"
})
assert(type(response) == "table"
    and (response.Success == true or tonumber(response.StatusCode or response.Status) == 200)
    and type(response.Body) == "string",
    "Failed to download VWRise NewMainScript.lua")
loadstring(response.Body)()
