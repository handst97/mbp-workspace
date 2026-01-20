"""
MarkItDown Tool for Open WebUI - Fixed Version
Handles cases where URL is not provided
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
            
    def convert_to_markdown(self, url: str = "") -> str:
        """
        Convert any document URL to Markdown format using MarkItDown.
        
        :param url: URL of the document (webpage, PDF, etc.)
        :return: Markdown formatted content or instructions
        """
        try:
            # Check if the input looks like it's just the command without a URL
            if not url or url.lower() in ["convert to markdown", "convert", "markdown", ""]:
                return """Please provide a URL to convert. 

Examples:
- Convert https://github.com to markdown
- Convert https://example.com/document.pdf to markdown
- Convert example.com to markdown

You can provide any webpage URL, PDF link, or supported document URL."""
            
            from markitdown import MarkItDown
            
            # Clean up the URL if it contains extra text
            url = url.strip()
            
            # Add https:// if missing
            if not url.startswith(('http://', 'https://', 'file://')):
                if '.' in url and ' ' not in url:
                    url = f"https://{url}"
                else:
                    return f"""I couldn't parse '{url}' as a valid URL. 

Please provide a valid URL like:
- https://example.com
- example.com
- https://example.com/document.pdf"""
            
            # Create MarkItDown instance
            md = MarkItDown()
            
            # Convert the document
            result = md.convert(url)
            
            if result and result.text_content:
                # Add source attribution
                markdown_output = f"# Content from: {url}\n\n{result.text_content}"
                
                # Truncate if too long
                if len(markdown_output) > 10000:
                    markdown_output = markdown_output[:10000] + "\n\n... (content truncated)"
                
                return markdown_output
            else:
                return f"Could not extract content from {url}. The page might be empty or blocked."
                
        except Exception as e:
            error_msg = str(e)
            if "404" in error_msg:
                return f"Error: The URL {url} was not found (404 error)"
            elif "timeout" in error_msg.lower():
                return f"Error: The request to {url} timed out. The site might be slow or unreachable."
            else:
                return f"Error converting {url}: {error_msg}"
    
    def convert_webpage(self, url: str = "") -> str:
        """
        Convert a webpage to Markdown format.
        
        :param url: The webpage URL
        :return: Webpage content as Markdown
        """
        if not url:
            return "Please provide a webpage URL to convert."
        return self.convert_to_markdown(url)
    
    def extract_pdf_text(self, pdf_url: str = "") -> str:
        """
        Extract text from a PDF and convert to Markdown.
        
        :param pdf_url: URL of the PDF document
        :return: PDF content as Markdown
        """
        if not pdf_url:
            return "Please provide a PDF URL to extract text from."
        return self.convert_to_markdown(pdf_url)