import os
import winshell
from pathlib import Path
from difflib import SequenceMatcher
from datetime import datetime

MOVE_TO_FOLDER = True
THRESHOLD = 0.4
CREATE_LOG = True

SKIP_FILES = ["subnautica32", "unitycrashhandler", "crashpad_handler", "crashreportclient"] 

def similarity(a, b):
    return SequenceMatcher(None, a.lower(), b.lower()).ratio()

def get_version_from_path(root_path):
    path_parts = Path(root_path).parts
    for part in path_parts:
        if part.strip().lower().startswith("version"):
            v_part = part.lower().replace("version", "").strip()
            return f"v{v_part}"
    return None

def create_shortcuts_final():
    script_file = Path(__file__).resolve()
    base_dir = script_file.parent.resolve()
    
    if MOVE_TO_FOLDER:
        dest_dir = base_dir / "!shortcuts"
        os.makedirs(dest_dir, exist_ok=True)
    else:
        dest_dir = base_dir

    print(f"Starting safe scan in: {base_dir}")

    log_file = base_dir / "shortcut_log.txt"
    log = open(log_file, "w", encoding="utf-8") if CREATE_LOG else None

    if log:
        log.write(f"Shortcut Generation Log - {datetime.now()}\n")
        log.write(f"Scanning: {base_dir}\n\n")

    for entry in os.scandir(base_dir):
        if entry.is_dir() and entry.name == "!shortcuts":
            continue
            
        if entry.is_dir():
            folder_path = Path(entry.path).resolve()
            folder_name = folder_path.name
            
            if log: log.write(f"Checking Folder: {folder_name}\n")
            
            for root, dirs, files in os.walk(folder_path):
                for filename in files:
                    filename_lower = filename.lower()
                    
                    if any(skip_item.lower() in filename_lower for skip_item in SKIP_FILES) or filename_lower == "shortcut_log.txt":
                        if log: log.write(f"  [EXCLUDED] {filename}\n")
                        continue

                    if filename_lower.endswith(".exe"):
                        if "subnautica2-win64-shipping" in filename_lower:
                            if log: log.write(f"  [EXCLUDED SHIPPING BINARY] {filename}\n")
                            continue

                        exe_path = Path(root).resolve() / filename
                        
                        if exe_path == script_file:
                            continue

                        exe_name = exe_path.stem
                        display_name = exe_name
                        
                        if exe_name.lower() == "minecraft2":
                            display_name = "Story Mode s2"
                        
                        if "subnautica 2" in folder_name.lower():
                            version_name = get_version_from_path(root)
                            if version_name:
                                display_name = version_name
                            
                            final_dest_dir = dest_dir / "Subnautica"
                            os.makedirs(final_dest_dir, exist_ok=True)
                        else:
                            final_dest_dir = dest_dir

                        score = similarity(folder_name, exe_name)
                        
                        if score >= THRESHOLD or "subnautica 2" in folder_name.lower():
                            shortcut_name = f"{display_name}.lnk"
                            shortcut_path = final_dest_dir / shortcut_name
                            
                            try:
                                with winshell.shortcut(str(shortcut_path)) as link:
                                    link.path = str(exe_path)
                                    link.working_directory = str(Path(root).resolve())
                                
                                msg = f"[SUCCESS] Created: {str(shortcut_path)} (Match: {score:.2f})"
                                print(msg)
                                if log: log.write(f"  {msg}\n")
                            except Exception as e:
                                if log: log.write(f"  [ERROR] {exe_name}: {e}\n")
                        else:
                            if log: log.write(f"  [SKIPPED] {filename} (Score {score:.2f})\n")
            if log: log.write("\n")

    if log:
        log.close()
        print(f"\nFinished! Log saved to '{log_file.name}'.")
    else:
        print("\nFinished!")

if __name__ == "__main__":
    create_shortcuts_final()