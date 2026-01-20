# Adding MarkItDown as a Tool in Open WebUI - Step by Step

## Step 1: Access Open WebUI Functions

1. Open your browser and go to: **http://localhost:3002**
2. Log in with your credentials
3. In the left sidebar, click on **"Workspace"**
4. From the dropdown menu, select **"Functions"**

## Step 2: Create a New Function

1. Click the **"+ New Function"** button (usually in the top right)
2. You'll see a code editor interface

## Step 3: Add the Function Code

1. **Function Name**: Enter `MarkItDown Converter` in the name field
2. **Description**: Enter `Convert documents and web pages to Markdown format`
3. **Code**: Copy and paste this entire code block:

```python
"""
MarkItDown Document Converter for Open WebUI
Converts URLs, PDFs, and documents to Markdown format
"""

import requests
import json

class Tools:
    def __init__(self):
        self.mcp_url = "http://localhost:3001"
        
    def convert_to_markdown(self, uri: str) -> str:
        """
        Convert any document or webpage to Markdown format.
        Supports: webpages, PDFs, Word docs, PowerPoints, and more.
        
        :param uri: URL of the document (e.g., https://example.com or https://example.com/doc.pdf)
        :return: Markdown formatted content
        """
        
        if not uri:
            return "Please provide a URL to convert"
            
        # Add https:// if missing
        if not uri.startswith(('http://', 'https://', 'file://')):
            uri = f"https://{uri}"
        
        try:
            # First try the simple endpoint
            response = requests.post(
                f"{self.mcp_url}/convert",
                json={"uri": uri},
                timeout=60
            )
            
            if response.status_code == 200:
                data = response.json()
                markdown = data.get('markdown', data.get('content', data.get('result')))
                if markdown:
                    return markdown
            
            # If that doesn't work, try MCP protocol format
            response = requests.post(
                self.mcp_url,
                json={
                    "jsonrpc": "2.0",
                    "method": "convert_to_markdown",
                    "params": {"uri": uri},
                    "id": 1
                },
                timeout=60
            )
            
            if response.status_code == 200:
                data = response.json()
                if 'result' in data:
                    return data['result']
                elif 'error' in data:
                    return f"Error: {data['error'].get('message', 'Unknown error')}"
                    
            return f"Error: Unable to convert. Server returned status {response.status_code}"
                
        except requests.ConnectionError:
            return "Error: Cannot connect to MarkItDown server. Make sure it's running on port 3001"
        except requests.Timeout:
            return "Error: Request timed out. The document might be too large or the server is busy."
        except Exception as e:
            return f"Error: {str(e)}"
    
    def convert_webpage(self, url: str) -> str:
        """
        Convert a webpage to Markdown (alias function).
        
        :param url: The webpage URL
        :return: Webpage content as Markdown
        """
        return self.convert_to_markdown(url)
    
    def convert_pdf(self, pdf_url: str) -> str:
        """
        Convert a PDF document to Markdown.
        
        :param pdf_url: URL of the PDF document
        :return: PDF content as Markdown
        """
        return self.convert_to_markdown(pdf_url)
```

## Step 4: Save and Enable

1. Click **"Save"** button
2. Make sure the toggle switch is **ON** (enabled)
3. You should see your function listed in the Functions page

## Step 5: Test the Function

1. Go back to the main chat interface (click "New Chat")
2. Try these test commands:

### Basic webpage conversion:
```
Convert https://github.com to markdown
```

### PDF conversion:
```
Convert this PDF to markdown: https://www.w3.org/WAI/WCAG21/working-examples/pdf-table/table.pdf
```

### Simple domain (will add https://):
```
Convert example.com to markdown
```

## How It Works in Chat

When you type a message that includes phrases like:
- "Convert [URL] to markdown"
- "Convert this webpage to markdown: [URL]"
- "Convert this PDF: [URL]"

The AI will recognize your intent and automatically call the `convert_to_markdown` function.

## Troubleshooting

### "Cannot connect to MarkItDown server"
- Check if the MCP server is running: `docker ps | grep markitdown-mcp`
- Start it if needed: `./start-markitdown-mcp.sh`

### No response or function not called
- Make sure the function is enabled (toggle switch ON)
- Try being more explicit: "Please use the convert_to_markdown function on https://example.com"

### Function not appearing
- Refresh the Open WebUI page
- Check if you're in the correct workspace
- Make sure you saved the function

## Advanced Usage

### Converting local files
If you place files in the `shared-documents` directory:
```
Convert file:///workdir/mydocument.pdf to markdown
```

### Customization
You can modify the timeout value in the code (currently 60 seconds) for larger documents.

## Tips

1. The function works best with public URLs
2. Large documents may take 10-30 seconds to convert
3. The conversion preserves formatting, links, and structure
4. Images are converted to markdown image syntax with alt text

That's it! You now have MarkItDown integrated as a tool in your Open WebUI.