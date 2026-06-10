import os
import shutil
import re

# --- SETTINGS ---
log = False
target_dir = os.path.dirname(os.path.abspath(__file__))

deep_dive = False  
max_depth = False  # How many sub-dirs to go, or off for all.

file_map = {
    "ai": [],  
    "docs": [
        ".pdf", ".docx", ".doc", ".txt", ".rtf", ".odt", ".pages", ".wpd",
        ".xlsx", ".xls", ".csv", ".ods", ".numbers", ".tsv",
        ".pptx", ".ppt", ".pps", ".key", ".odp"
    ],
    "imgs": [
        ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".tiff", ".tif", ".svg", 
        ".webp", ".heic", ".raw", ".cr2", ".nef", ".ico", ".psd", ".ai", ".eps"
    ],
    "audio": [
        ".mp3", ".wav", ".aac", ".flac", ".m4a", ".wma", ".ogg", ".vlc", 
        ".mid", ".midi", ".amr", ".aif", ".aiff"
    ],
    "vids": [
        ".mp4", ".mov", ".avi", ".mkv", ".wmv", ".flv", ".webm", ".m4v", 
        ".mpeg", ".mpg", ".3gp", ".3g2"
    ],
    "zips": [
        ".zip", ".rar", ".7z", ".tar", ".gz", ".bz2", ".xz", ".iso", 
        ".img", ".vcd", ".dmg"
    ],
    "apps": [
        ".exe", ".msi", ".dmg", ".pkg", ".apk", ".deb", ".rpm", ".app", ".bat", ".cmd"
    ],
    "code": [
        ".py", ".js", ".html", ".css", ".cpp", ".c", ".java", ".php", ".json", 
        ".pyw", ".cs", ".rb", ".swift", ".go", ".rs", ".ts", ".xml", ".yaml", 
        ".yml", ".sql", ".sh", ".bash", ".pl", ".h", ".m", ".kt", ".dart"
    ],
    "3d": [
        ".blend", ".obj", ".fbx", ".stl", ".3ds", ".max", ".dwg", ".dxf", ".skp"
    ],
    "fonts": [
        ".ttf", ".otf", ".woff", ".woff2", ".eot"
    ],
    "other": []  
}

def is_ai_related(name):
    name_lower = name.lower()
    ai_keywords = ["gpt", "chat", "claude", "gemini", "llm", "midjourney", "stable-diffusion", "copilot", "ollama"]
    if any(keyword in name_lower for keyword in ai_keywords):
        return True
        
    # Matches 'ai' as a standalone word (prevents false flags on words like 'mail' or 'paint')
    if re.search(r'\bai\b', name_lower):
        return True
        
    return False

def organize_files():
    script_name = os.path.basename(__file__)
    unsorted_name = "unsorted"
    log_folder_name = "logs"
    protected_names = [n for n in file_map.keys()] + [unsorted_name, log_folder_name]

    def write_log(message):
        print(message)
        if log:
            log_dir = os.path.join(target_dir, log_folder_name)
            os.makedirs(log_dir, exist_ok=True)
            log_file = os.path.join(log_dir, "organizer_log.txt")
            with open(log_file, "a", encoding="utf-8") as f:
                f.write(message + "\n")

    write_log("\n--- SESSION START ---")

    tasks = []
    base_depth = target_dir.rstrip(os.path.sep).count(os.path.sep)

    for root, dirs, files in os.walk(target_dir):
        # Prevent the walk from traveling into master destination categories
        dirs[:] = [d for d in dirs if d.lower() not in protected_names]
        
        current_depth = root.rstrip(os.path.sep).count(os.path.sep) - base_depth + 1
        
        if not deep_dive and current_depth > 1:
            dirs[:] = []
            continue
            
        if deep_dive and max_depth not in (False, None, 0, "off", "Off", "OFF"):
            if current_depth > int(max_depth):
                dirs[:] = []  
                continue
            
        for file in files:
            if file == script_name or file.lower() == "desktop.ini":
                continue
                
            file_path = os.path.join(root, file)
            tasks.append((file_path, file))

    for filepath, filename in tasks:
        filename_lower = filename.lower()
        
        if is_ai_related(filename):
            try:
                dest_dir = os.path.join(target_dir, "ai")
                os.makedirs(dest_dir, exist_ok=True)
                shutil.move(filepath, os.path.join(dest_dir, filename))
                write_log(f"[AI]       {filename} -> ai")
                continue  
            except Exception as e:
                write_log(f"[ERR-AI]  {filename}: {e}")
                continue

        _, extension = os.path.splitext(filename)
        extension = extension.lower().strip()
        
        if not extension:
            try:
                dest_dir = os.path.join(target_dir, unsorted_name)
                os.makedirs(dest_dir, exist_ok=True)
                shutil.move(filepath, os.path.join(dest_dir, filename))
                write_log(f"[NO EXT]    {filename} -> {unsorted_name}")
            except Exception as e:
                write_log(f"[ERR-NON] {filename}: {e}")
            continue

        if extension == ".lnk":
            try:
                dest_dir = os.path.join(target_dir, unsorted_name)
                os.makedirs(dest_dir, exist_ok=True)
                shutil.move(filepath, os.path.join(dest_dir, filename))
                write_log(f"[SHORTCUT] {filename} -> {unsorted_name}")
            except Exception as e:
                write_log(f"[ERR-LNK] {filename}: {e}")
            continue

        moved = False
        for folder_name, extensions in file_map.items():
            if extension in extensions:
                try:
                    dest_dir = os.path.join(target_dir, folder_name)
                    os.makedirs(dest_dir, exist_ok=True)
                    shutil.move(filepath, os.path.join(dest_dir, filename))
                    write_log(f"[SUCCESS]  {filename} -> {folder_name}")
                    moved = True
                except Exception as e:
                    write_log(f"[ERR-FIL] {filename}: {e}")
                break
        
        if not moved:
            try:
                dest_dir = os.path.join(target_dir, "other")
                os.makedirs(dest_dir, exist_ok=True)
                shutil.move(filepath, os.path.join(dest_dir, filename))
                write_log(f"[OTHER]    {filename} -> other")
            except Exception as e:
                write_log(f"[ERR-OTH] {filename}: {e}")

    # Topdown=False is mandatory here to drop deep subfolders before clearing out parent levels
    if deep_dive:
        for root, dirs, _ in os.walk(target_dir, topdown=False):
            current_depth = root.rstrip(os.path.sep).count(os.path.sep) - base_depth + 1
            
            if max_depth not in (False, None, 0, "off", "Off", "OFF") and current_depth > int(max_depth):
                continue
                
            for d in dirs:
                dir_to_check = os.path.join(root, d)
                if d.lower() not in protected_names and os.path.exists(dir_to_check) and not os.listdir(dir_to_check):
                    try:
                        os.rmdir(dir_to_check)
                        write_log(f"[CLEANUP]  Removed empty folder: {d}")
                    except Exception:
                        pass

    write_log("--- SESSION END ---")

if __name__ == "__main__":
    organize_files()
    input("\nDone! Press Enter to exit...")