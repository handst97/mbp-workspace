# Setting Up MarkItDown as a Tool in Open WebUI

## Important: This is a TOOL, not a Function!

In Open WebUI, there are two types of extensions:
- **Functions**: For chat enhancements and filters
- **Tools**: For specific actions the AI can call (this is what we need)

## Step-by-Step Instructions

### 1. Navigate to Tools (not Functions!)

1. Go to http://localhost:3002
2. Log in with your credentials
3. Click on **"Workspace"** in the left sidebar
4. Select **"Tools"** (NOT Functions)

### 2. Create a New Tool

1. Click **"+ New Tool"** button
2. Fill in the details:
   - **Name**: `MarkItDown Converter`
   - **Description**: `Convert documents and webpages to Markdown`
   - **ID**: Leave auto-generated or use `markitdown-converter`

### 3. Add the Tool Code

Copy and paste this EXACT code:

```python
"""
MarkItDown Direct Tool for Open WebUI
Uses the markitdown library directly
"""

import subprocess
import sys

class Tools:
    def __init__(self):
        # Install markitdown if not already installed
        try:
            import markitdown
        except ImportError:
            subprocess.check_call([sys.executable, "-m", "pip", "install", "markitdown"])
            
    def convert_to_markdown(self, url: str) -> str:
        """
        Convert any document URL to Markdown format using MarkItDown.
        
        :param url: URL of the document (webpage, PDF, etc.)
        :return: Markdown formatted content
        """
        try:
            from markitdown import MarkItDown
            
            if not url:
                return "Please provide a URL to convert"
            
            # Add https:// if missing
            if not url.startswith(('http://', 'https://', 'file://')):
                if '.' in url and '/' not in url:
                    url = f"https://{url}"
                else:
                    return f"Invalid URL: {url}"
            
            # Create MarkItDown instance
            md = MarkItDown()
            
            # Convert the document
            result = md.convert(url)
            
            if result and result.text_content:
                # Add source attribution
                markdown_output = f"# Content from: {url}\n\n{result.text_content}"
                return markdown_output
            else:
                return f"Could not extract content from {url}"
                
        except Exception as e:
            return f"Error converting {url}: {str(e)}"
```

### 4. Save and Enable

1. Click **"Save"** button
2. Make sure the tool is **Enabled** (there should be a toggle switch)
3. You'll see your tool listed in the Tools page

### 5. Select a Model with Tool Support

1. Go back to the chat interface
2. In the model selector, choose a model that supports tools (most do)
3. You might see a tools icon appear when the tool is available

### 6. Test the Tool

Try these commands in a new chat:

```
Convert https://github.com to markdown
```

```
Please convert example.com to markdown format
```

```
Extract the content from this page as markdown: https://docs.python.org/3/
```

## Troubleshooting

### "No Tools class found"
- Make sure you're in the **Tools** section, not Functions
- The class must be named `Tools` (with capital T)
- Check for any syntax errors in the code

### Tool not being called
- Be explicit in your request: "Use the convert_to_markdown tool on [URL]"
- Make sure the tool is enabled
- Check that your selected model supports tool calling

### "markitdown not found"
- The tool will auto-install the library on first use
- If it fails, the Open WebUI container might need the package installed

## Alternative: If Direct Tool Doesn't Work

If the direct tool approach doesn't work, you can use the MCP server approach:

1. Stop the markitdown-mcp container
2. Install markitdown in the Open WebUI container:
   ```bash
   docker exec -it open-webui pip install markitdown
   ```
3. Then use the direct tool code above

## How It Works

When you ask the AI to convert a URL to markdown, it will:
1. Recognize the intent
2. Call the `convert_to_markdown` tool
3. Pass the URL to the tool
4. Return the converted markdown content

The tool uses the official Microsoft MarkItDown library to handle the conversion, supporting many formats including HTML, PDF, DOCX, PPTX, and more.