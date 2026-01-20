# MarkItDown MCP Integration for Open WebUI

This guide shows how to add the MarkItDown MCP server as a tool/function to your existing Open WebUI installation.

## Quick Start

### 1. Start the MarkItDown MCP Server

```bash
# Create directories
mkdir -p markitdown-mcp shared-documents

# Start the MCP server
docker-compose -f docker-compose-markitdown-mcp.yml up -d
```

### 2. Add the Function to Open WebUI

1. Go to http://localhost:3002
2. Navigate to **Workspace → Functions**
3. Click **"+ New Function"**
4. Copy and paste the contents of `openwebui-markitdown-function.py`
5. Name it: `MarkItDown Converter`
6. Save and enable the function

### 3. Test the Function

In any chat, try:
- "Convert https://github.com to markdown"
- "Convert https://example.com/document.pdf to markdown"

## What This Does

The MarkItDown MCP server runs as a separate Docker container on port 3001 and provides document-to-markdown conversion capabilities. The Open WebUI function acts as a bridge, allowing you to use this conversion tool in your chats.

## Supported Formats

MarkItDown can convert:
- Web pages (HTML)
- PDFs
- Word documents (.docx)
- PowerPoint (.pptx)
- Excel spreadsheets (.xlsx)
- Images (extracts text via OCR)
- Audio/Video files (extracts metadata)
- Many other formats

## Docker Commands

```bash
# Start the MCP server
docker-compose -f docker-compose-markitdown-mcp.yml up -d

# View logs
docker logs markitdown-mcp -f

# Stop the server
docker-compose -f docker-compose-markitdown-mcp.yml down

# Restart the server
docker-compose -f docker-compose-markitdown-mcp.yml restart
```

## Troubleshooting

### Function not working?
1. Check if MCP server is running: `docker ps | grep markitdown-mcp`
2. Test the server directly: `curl http://localhost:3001`
3. Check logs: `docker logs markitdown-mcp`

### Connection errors?
- Ensure port 3001 is not in use: `lsof -i :3001`
- Check Docker is running: `docker ps`

## Advanced Usage

### Converting Local Files

To convert local files, place them in the `shared-documents` directory and use:
```
Convert file:///workdir/mydocument.pdf to markdown
```

### Customizing the Function

Edit these values in the function code:
- `self.mcp_server_url` - Change if using different host/port
- `self.timeout` - Increase for large documents

## Files Included

- `docker-compose-markitdown-mcp.yml` - Docker Compose config for MCP server
- `markitdown-mcp/Dockerfile` - Custom Docker image for the server
- `openwebui-markitdown-function.py` - Function code for Open WebUI
- `start-markitdown-mcp.sh` - Quick start script