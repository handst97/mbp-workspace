# Open WebUI + MarkItDown MCP Server Integration Guide

This guide explains how to set up and integrate the Microsoft MarkItDown MCP (Model Context Protocol) server with Open WebUI using Docker.

## What is MarkItDown MCP?

MarkItDown MCP is a lightweight server that provides document conversion capabilities. It exposes a tool called `convert_to_markdown(uri)` that can convert various file formats to Markdown from:
- HTTP/HTTPS URLs
- Local files
- Data URIs

## Prerequisites

- Docker and Docker Compose installed
- Your existing Open WebUI data volume (`open-webui-fresh`)
- Port 3001 available for the MCP server
- Port 3002 available for Open WebUI (already in use)

## Setup Instructions

### 1. Stop Current Open WebUI

First, stop your existing Open WebUI container:

```bash
docker stop open-webui
```

### 2. Create Directory Structure

```bash
# Create the necessary directories
mkdir -p markitdown-mcp
mkdir -p shared-documents
mkdir -p uploads
```

### 3. Deploy the Files

Save the following files in your workspace:

- `docker-compose-openwebui-mcp.yml` - The Docker Compose configuration
- `markitdown-mcp/Dockerfile` - Custom Dockerfile for the MCP server

### 4. Start the Integrated Services

```bash
# Start both services
docker-compose -f docker-compose-openwebui-mcp.yml up -d

# Check logs
docker-compose -f docker-compose-openwebui-mcp.yml logs -f
```

### 5. Verify Services are Running

```bash
# Check if both containers are running
docker ps | grep -E "(open-webui|markitdown-mcp)"

# Test the MCP server
curl http://localhost:3001/health
```

## Configuration in Open WebUI

### Option 1: Using Functions (Recommended)

1. Log into Open WebUI at http://localhost:3002
2. Go to **Workspace → Functions**
3. Create a new function:

```python
import requests
import json

def convert_to_markdown(uri: str) -> str:
    """
    Convert a document from a URI to Markdown format using MarkItDown MCP server.
    
    Args:
        uri (str): The URI of the document (http://, https://, file://, or data:)
    
    Returns:
        str: The converted Markdown content
    """
    try:
        # Call the MCP server
        response = requests.post(
            "http://markitdown-mcp:3001/convert",
            json={"uri": uri},
            timeout=30
        )
        
        if response.status_code == 200:
            return response.json().get("markdown", "Conversion failed")
        else:
            return f"Error: {response.status_code} - {response.text}"
    except Exception as e:
        return f"Error connecting to MarkItDown server: {str(e)}"
```

4. Save and enable the function
5. Test it in a chat: "Convert https://example.com/document.pdf to markdown"

### Option 2: Using Tools/Extensions

If Open WebUI supports MCP tools directly:

1. Go to **Settings → Tools** (if available)
2. Add MCP Server:
   - Name: `MarkItDown`
   - URL: `http://markitdown-mcp:3001`
   - Type: `MCP`

### Option 3: Using Pipelines

Create a custom pipeline that integrates with the MCP server for document processing.

## Usage Examples

### Converting Web Pages
```
Convert https://github.com/microsoft/markitdown to markdown
```

### Converting Local Files
Place files in the `shared-documents` directory:
```
Convert file:///workdir/my-document.docx to markdown
```

### Converting Uploaded Files
Files uploaded to Open WebUI can be accessed through the uploads volume:
```
Convert file:///uploads/document.pdf to markdown
```

## Directory Structure

```
mbp-workspace/
├── docker-compose-openwebui-mcp.yml
├── markitdown-mcp/
│   └── Dockerfile
├── shared-documents/     # Place documents here for conversion
│   ├── document1.docx
│   └── document2.pdf
└── uploads/             # Open WebUI uploads directory
```

## Troubleshooting

### Check Service Health

```bash
# Check MCP server logs
docker logs markitdown-mcp

# Test MCP server directly
curl -X POST http://localhost:3001/convert \
  -H "Content-Type: application/json" \
  -d '{"uri": "https://example.com"}'
```

### Connection Issues

If Open WebUI can't connect to the MCP server:
1. Verify both containers are on the same network:
   ```bash
   docker network inspect mbp-workspace_webui-network
   ```
2. Check firewall rules
3. Ensure the MCP server is listening on 0.0.0.0:3001

### File Access Issues

For local file conversion:
- Files must be in mounted volumes
- Use correct paths: `/workdir/filename` for shared documents
- Check file permissions

## Advanced Configuration

### Environment Variables

For the MCP server:
- `MARKITDOWN_ENABLE_PLUGINS=True` - Enable all conversion plugins
- `EXIFTOOL_PATH=/usr/bin/exiftool` - Path to exiftool
- `FFMPEG_PATH=/usr/bin/ffmpeg` - Path to ffmpeg

### Scaling

To handle more requests, you can scale the MCP server:
```bash
docker-compose -f docker-compose-openwebui-mcp.yml up -d --scale markitdown-mcp=3
```

### Security Considerations

1. The MCP server runs as a non-root user (mcpuser)
2. Network isolation between services
3. Limited file system access through volume mounts
4. Consider adding authentication if exposing externally

## Updating Services

### Update Open WebUI
```bash
docker-compose -f docker-compose-openwebui-mcp.yml pull open-webui
docker-compose -f docker-compose-openwebui-mcp.yml up -d open-webui
```

### Update MarkItDown MCP
```bash
docker-compose -f docker-compose-openwebui-mcp.yml build markitdown-mcp
docker-compose -f docker-compose-openwebui-mcp.yml up -d markitdown-mcp
```

## Backup and Restore

Your Open WebUI data is preserved in the `open-webui-fresh` volume. To backup:

```bash
# Backup
docker run --rm -v open-webui-fresh:/data -v $(pwd):/backup alpine tar czf /backup/openwebui-backup.tar.gz -C /data .

# Restore
docker run --rm -v open-webui-fresh:/data -v $(pwd):/backup alpine tar xzf /backup/openwebui-backup.tar.gz -C /data
```

## References

- [MarkItDown GitHub Repository](https://github.com/microsoft/markitdown)
- [MarkItDown MCP Package](https://github.com/microsoft/markitdown/tree/main/packages/markitdown-mcp)
- [Open WebUI Documentation](https://docs.openwebui.com)

---

*Note: This integration assumes Open WebUI has MCP tool support. If not available, use the Functions approach for integration.*