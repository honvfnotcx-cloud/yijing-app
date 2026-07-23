from dulwich import porcelain 
import os 
 
root = '.' 
files = [] 
for dirpath, dirnames, filenames in os.walk(root): 
    for fn in filenames: 
        fp = os.path.join(dirpath, fn) 
        if '.git' not in fp: 
            files.append(fp.replace('\\', '/')) 
 
porcelain.add(root, files) 
porcelain.commit(root, message='Initial commit: I Ching Daily Reflection App', author='User <user@example.com>')
