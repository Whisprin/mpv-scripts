local utils = require "mp.utils"

trash_list = {}

function contains_item(l, i)
   for k, v in pairs(l) do
      if v == i then
         mp.osd_message("file won't be trashed")
         l[k] = nil
         return true
      end
   end
   mp.osd_message("trashing file upon exit")
   return false
end

function mark_trash_skip()
   local work_dir = mp.get_property_native("working-directory")
   local file_path = mp.get_property_native("path")
   local s = file_path:find(work_dir, 0, true)
   local final_path
   if s and s == 0 then
      final_path = file_path
   else
      final_path = utils.join_path(work_dir, file_path)
   end
   if not contains_item(trash_list, final_path) then
      table.insert(trash_list, final_path)
      mp.command("playlist-next")
   end
end

function trash(e)
   if e.reason == "quit" then
      for i, v in pairs(trash_list) do
         print("trashing: "..v)
         os.execute("gio trash '"..v.."'")
      end
   end
end

mp.add_key_binding("alt+DEL", "trash_file_skip", mark_trash_skip)
mp.register_event("end-file", trash)
