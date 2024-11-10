-- docgen.lua 

-- Define constants
const VERSION = "0.5" 
CSS = '<link rel="stylesheet" href="./s.css"/>' 
NL = "\n" 

-- Define functions 
local function is_empty(tbl) 
  if #tbl == 0 then return true 
  else return false end 
end 

--> Parse Lua code 
local function parse_lua(filename) 
    local ast = {} 
    local f_lines={} 

    for ln in io.lines(filename) do 
      table.insert(f_lines,ln) 
    end 
    for key,ln in ipairs(f_lines) do 
      if ln:match("function%s*([%w_]+)([%g]*)") then 
            func_name,args_capture = ln:match("function%s*([%w_]+)([%g]*)") 
            local func = {} 
            func.name=func_name 
            func.args={} 
            for a in args_capture:gmatch("[%w_]+") do 
               table.insert(func.args,a) 
            end 
            func.description = f_lines[key-1]:match("-->%s?([%g%s]+)") or "No description" 
         func.args_dfn={} 
            for i=1,#func.args,1 do 
              a=func.args[i] 
          -- see if theres any markup a few lines below our definition 
          func.args_dfn[a] = f_lines[key+i]:match("--%s?%[[%w_]+%]%:%s?([%g%s]+)") 
        end --XXX above is not good; argument order is messed up.... 
            table.insert(ast, func) 
      end 
     end 
    return ast 
end 

-- Generate HTML documentation 
local function generate_html(ast, file) 
  local html = "<html><head>".. CSS .."</head><body>" 
  html = html .. '<h1 id="fn">' .. file .. "</h1><hr>" 
  html = html .. "<h2>Functions:</h2>" 
  for _, node in ipairs(ast) do 
      html=html..'<div class="func_div">' 
      if is_empty(node.args) then html = html .. "<h3>"..node.name..'</h3>' 
      else html=html .. "<h3><code>"..node.name.."<sup>(" 
      for k,a in ipairs(node.args) do 
           html=html .. a 
            if k < #node.args then html=html.."," end 
        end 
         html=html..')</sup></code></h3>' 
      end 
      html = html.."<b>"..node.description.."</b><br>" 
      html=html.."<h4>Arguments</h4><ol>" 
    for a,d in pairs(node.args_dfn) do 
      html = html .. "<li><var>" .. a .. " </var> --> <strong> "..d.."</strong></li>" 
    end 
      html = html .. "</ol></div>" 
      html = html .. "<hr>" 
   end 
   --TODO parse objects / tbls 

   html = html .. "<small>Lua GenDoc v"..VERSION.."</small>" 
  html = html .. "</body></html>" 
  return html 
end 

-- Main function 
local function autodoc(file) 
local ast = parse_lua(file) 
local output 

-- Generate documentation in specified format 
    output = generate_html(ast, file) 
    local outf = io.open(file .. ".html", "w") 
    outf:write(output) 
    outf:close() 
    print("HTML documentation generated: " .. file .. ".html") 
end 

-- Command-line interface 
local args = {...} 
if #args < 1 then 
   print("Usage: lua docgen.lua <file>") 
else 
   local file = args[1] 
   if args[2] then user_css_fn = args[2] end 
   autodoc(file) 

end 
    
