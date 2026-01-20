# Open WebUI File-to-Markdown Conversion Tool

## Overview
This tool converts files you upload to Open WebUI into Markdown format. It works with PDFs, Word documents, HTML files, and many other formats.

## Installation Steps

### 1. Go to Tools Section
1. Open http://localhost:3002
2. Navigate to **Workspace → Tools** (not Functions!)

### 2. Create New Tool
1. Click **"+ New Tool"**
2. Set:
   - **Name**: `MarkItDown File Converter`
   - **Description**: `Convert uploaded files to Markdown`

### 3. Add the Code
Copy and paste this code:

```python
"""
MarkItDown Tool for Open WebUI - Works with uploaded files
"""

import os
import glob

class Tools:
    def __init__(self):
        self.upload_dir = "/app/backend/data/uploads"
        
    def convert_to_markdown(self, filename: str = None) -> str:
        """
        Convert uploaded file to Markdown. 
        If no filename provided, converts the most recent upload.
        """
        try:
            from markitdown import MarkItDown
            
            # If no filename specified, find the most recent upload
            if not filename:
                # Get all files in upload directory
                files = glob.glob(f"{self.upload_dir}/*")
                if not files:
                    return "No uploaded files found. Please upload a file first."
                
                # Get most recent file
                latest_file = max(files, key=os.path.getctime)
                file_path = latest_file
                filename = os.path.basename(latest_file).split('_', 1)[-1] if '_' in os.path.basename(latest_file) else os.path.basename(latest_file)
            else:
                # Search for file containing the filename
                matching_files = glob.glob(f"{self.upload_dir}/*{filename}*")
                if not matching_files:
                    # Try without extension
                    name_without_ext = os.path.splitext(filename)[0]
                    matching_files = glob.glob(f"{self.upload_dir}/*{name_without_ext}*")
                
                if not matching_files:
                    return f"File '{filename}' not found in uploads. Available files: " + ", ".join([os.path.basename(f).split('_', 1)[-1] for f in glob.glob(f"{self.upload_dir}/*")])
                
                # Use the first match
                file_path = matching_files[0]
            
            # Convert the file
            md = MarkItDown()
            result = md.convert(file_path)
            
            if result and result.text_content:
                return f"# Converted: {filename}\n\n{result.text_content}"
            else:
                return f"Could not extract content from {filename}. The file might be corrupted or in an unsupported format."
                
        except Exception as e:
            return f"Error converting file: {str(e)}"
    
    def list_uploads(self) -> str:
        """
        List all uploaded files available for conversion.
        """
        try:
            files = glob.glob(f"{self.upload_dir}/*")
            if not files:
                return "No files uploaded yet."
            
            file_list = []
            for f in sorted(files, key=os.path.getctime, reverse=True):
                basename = os.path.basename(f)
                # Remove UUID prefix if present
                display_name = basename.split('_', 1)[-1] if '_' in basename else basename
                size = os.path.getsize(f)
                size_kb = size / 1024
                file_list.append(f"- {display_name} ({size_kb:.1f} KB)")
            
            return "Uploaded files:\n" + "\n".join(file_list)
            
        except Exception as e:
            return f"Error listing files: {str(e)}"
    
    def convert_latest_upload(self) -> str:
        """
        Convert the most recently uploaded file to Markdown.
        """
        return self.convert_to_markdown()
```

### 4. Save and Enable
1. Click **Save**
2. Ensure the tool is **Enabled**

## Usage

### Basic Usage (after uploading a file):
1. Upload a file using the paperclip icon in the chat
2. Type: `convert to markdown`
3. The tool will automatically convert your most recent upload

### Specific File:
If you have multiple uploads:
```
convert architecture-diagram.html to markdown
```

### List Available Files:
```
list uploads
```

### Examples:
- Upload a PDF, then say: "convert to markdown"
- Upload an HTML file, then say: "convert to markdown"
- Upload a Word doc, then say: "please convert this document to markdown"

## Supported File Types
- PDF documents
- Microsoft Word (.docx)
- HTML files
- Text files
- PowerPoint presentations
- Excel spreadsheets
- And many more formats supported by MarkItDown

## Troubleshooting

### "No uploaded files found"
- Make sure you uploaded a file using the paperclip icon
- The file should appear in the chat with a preview

### File not converting properly
- Some complex PDFs might not convert perfectly
- Try uploading a different format if possible

### Tool not responding
- Refresh the page
- Make sure the tool is enabled in the Tools section
- Check that markitdown is installed (it should be from our earlier setup)

## How It Works
1. When you upload a file, Open WebUI stores it in `/app/backend/data/uploads/`
2. The tool finds your uploaded file (or the most recent one)
3. MarkItDown converts it to Markdown format
4. The converted text is returned in the chat

This approach works seamlessly with Open WebUI's file upload system!