#!/bin/bash

# Start script for MarkItDown MCP Server

echo "🚀 Starting MarkItDown MCP Server..."

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p markitdown-mcp
mkdir -p shared-documents

# Check if docker-compose file exists
if [ ! -f "docker-compose-markitdown-mcp.yml" ]; then
    echo "❌ Error: docker-compose-markitdown-mcp.yml not found!"
    exit 1
fi

# Check if Dockerfile exists
if [ ! -f "markitdown-mcp/Dockerfile" ]; then
    echo "❌ Error: markitdown-mcp/Dockerfile not found!"
    exit 1
fi

# Start the MCP server
echo "🐳 Starting MarkItDown MCP server..."
docker-compose -f docker-compose-markitdown-mcp.yml up -d --build

# Wait for service to start
echo "⏳ Waiting for service to start..."
sleep 5

# Check service status
echo -e "\n📊 Service Status:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E "(NAME|markitdown-mcp)"

# Test MCP server
echo -e "\n🧪 Testing MarkItDown MCP Server..."
if curl -s http://localhost:3001 > /dev/null 2>&1; then
    echo "✅ MCP Server is running!"
else
    echo "❌ MCP Server not responding. Checking logs..."
    docker logs markitdown-mcp --tail 20
fi

echo -e "\n✅ Setup complete!"
echo "📌 MCP Server is running on: http://localhost:3001"
echo -e "\n📝 Next steps:"
echo "1. Open your Open WebUI at http://localhost:3002"
echo "2. Go to Workspace → Functions"
echo "3. Create a new function with the code from openwebui-markitdown-function.py"
echo "4. Save and enable the function"
echo -e "\n💡 Useful commands:"
echo "- View logs: docker logs markitdown-mcp -f"
echo "- Stop server: docker-compose -f docker-compose-markitdown-mcp.yml down"
echo "- Restart: docker-compose -f docker-compose-markitdown-mcp.yml restart"