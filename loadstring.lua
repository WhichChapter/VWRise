shared.RiseMode = true
local env = getgenv()
local httpRequest = env.request or (type(http) == "table" and http.request) or request
assert(type(httpRequest) == "function", "Executor request() is unavailable")
local response = httpRequest({
    Url = "https://raw.githubusercontent.com/WhichChapter/VWRise/main/NewMainScript.lua",
    Method = "GET"
})
assert(type(response) == "table"
    and (response.Success == true or tonumber(response.StatusCode or response.Status) == 200)
    and type(response.Body) == "string",
    "Failed to download VWRise NewMainScript.lua")
loadstring(response.Body)()
