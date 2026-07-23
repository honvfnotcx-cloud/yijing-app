var fs = new ActiveXObject('Scripting.FileSystemObject'); 
var base = '.'; 
function w(path, content) { var f = base + '\\' + path; var d = f.substring(0, f.lastIndexOf('\\')); if (!fs.FolderExists(d)) { var parts = d.split('\\'); var p = ''; for (var i = 0; i < parts.length; i++) { p += (p ? '\\' : '') + parts[i]; if (!fs.FolderExists(p)) fs.CreateFolder(p); } } var s = fs.CreateTextFile(f, true, true); s.Write(content); s.Close(); } 
w('apps/api/src/profiles/profiles.module.ts', 'import { Module } from \\'@nestjs/common\\';\\n\\n@Module({})\\nexport class ProfilesModule {}'); 
WScript.Echo('gen done');
