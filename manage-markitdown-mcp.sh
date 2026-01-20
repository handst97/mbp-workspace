#!/bin/bash

# Management script for MarkItDown MCP server

ACTION=${1:-status}

case $ACTION in
    start)
        echo "🚀 Starting MarkItDown MCP server..."
        
        # Check if container exists
        if docker ps -a | grep -q "^markitdown-mcp "; then
            echo "Container exists. Starting it..."
            docker start markitdown-mcp
        else
            echo "Building and starting new container..."
            # Build if image doesn't exist
            if ! docker images | grep -q "^markitdown-mcp "; then
                docker build -t markitdown-mcp:latest ./markitdown-mcp/
            fi
            
            docker run -d \
                --name markitdown-mcp \
                -p 3001:3001 \
                -e MARKITDOWN_ENABLE_PLUGINS=True \
                --restart unless-stopped \
                markitdown-mcp:latest \
                --http --host 0.0.0.0 --port 3001
        fi
        
        sleep 3
        docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E "(NAMES|markitdown-mcp)"
        echo "✅ MarkItDown MCP server is running on http://localhost:3001"
        ;;
        
    stop)
        echo "⏹️ Stopping MarkItDown MCP server..."
        docker stop markitdown-mcp
        ;;
        
    restart)
        echo "🔄 Restarting MarkItDown MCP server..."
        docker restart markitdown-mcp
        ;;
        
    remove)
        echo "🗑️ Removing MarkItDown MCP container..."
        docker stop markitdown-mcp 2>/dev/null
        docker rm markitdown-mcp
        ;;
        
    rebuild)
        echo "🔨 Rebuilding MarkItDown MCP server..."
        docker stop markitdown-mcp 2>/dev/null
        docker rm markitdown-mcp 2>/dev/null
        docker build -t markitdown-mcp:latest ./markitdown-mcp/
        docker run -d \
            --name markitdown-mcp \
            -p 3001:3001 \
            -e MARKITDOWN_ENABLE_PLUGINS=True \
            --restart unless-stopped \
            markitdown-mcp:latest \
            --http --host 0.0.0.0 --port 3001
        ;;
        
    logs)
        echo "📜 Showing MarkItDown MCP logs (Ctrl+C to exit)..."
        docker logs -f markitdown-mcp
        ;;
        
    status)
        echo "📊 MarkItDown MCP Status:"
        docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E "(NAMES|markitdown-mcp)"
        ;;
        
    *)
        echo "Usage: $0 {start|stop|restart|remove|rebuild|logs|status}"
        exit 1
        ;;
esac