import os
import re
import urllib.parse

def clean_name(name):
    # Remove extension
    name = os.path.splitext(name)[0]
    # Replace underscores and hyphens with spaces
    name = name.replace('_', ' ').replace('-', ' ')
    # If the name is already somewhat formatted (has uppercase), keep it
    if any(c.isupper() for c in name):
        # But if it's all uppercase and long, maybe it's just a shouty filename
        if name.isupper() and len(name) > 5:
            return name.capitalize()
        return name
    # Otherwise capitalize it
    return name.capitalize()

def generate_pdf_list(root_dir):
    pdf_files = []
    for root, dirs, files in os.walk(root_dir):
        # Ignore hidden directories
        dirs[:] = [d for d in dirs if not d.startswith('.')]
        for file in files:
            if file.lower().endswith('.pdf'):
                full_path = os.path.join(root, file)
                rel_path = os.path.relpath(full_path, root_dir)
                pdf_files.append(rel_path)
    
    pdf_files.sort()
    
    lines = []
    current_dir = ""
    for pdf in pdf_files:
        dirname = os.path.dirname(pdf)
        filename = os.path.basename(pdf)
        
        if dirname != current_dir:
            if dirname:
                lines.append(f"\n### {dirname}\n")
            current_dir = dirname
        
        display_name = clean_name(filename)
        # URL encode the path for the link
        encoded_pdf = urllib.parse.quote(pdf)
        lines.append(f"- [{display_name}]({encoded_pdf})")
    
    return "\n".join(lines)

def update_readme(readme_path, pdf_list_content):
    with open(readme_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    start_marker = "<!-- PDF-LIST-START -->"
    end_marker = "<!-- PDF-LIST-END -->"
    
    pattern = re.compile(f"{re.escape(start_marker)}.*?{re.escape(end_marker)}", re.DOTALL)
    new_content = pattern.sub(f"{start_marker}\n{pdf_list_content}\n{end_marker}", content)
    
    with open(readme_path, 'w', encoding='utf-8') as f:
        f.write(new_content)

if __name__ == "__main__":
    repo_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
    readme_path = os.path.join(repo_root, 'README.md')
    
    print(f"Searching for PDFs in {repo_root}...")
    pdf_list = generate_pdf_list(repo_root)
    
    print(f"Updating {readme_path}...")
    update_readme(readme_path, pdf_list)
    print("Done!")
