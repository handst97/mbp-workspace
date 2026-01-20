#!/bin/bash

# Warp Terminal Docker MCP Integration Script
# This script sets up Docker MCP Toolkit integration optimized for Warp terminal

echo "🚀 Setting up Warp Terminal Docker MCP Integration..."

# Function to run Docker MCP gateway in background for Warp
start_mcp_gateway() {
    echo "Starting Docker MCP Gateway for Warp Terminal..."
    
    # Start the gateway in background
    docker mcp gateway run &
    MCP_PID=$!
    
    # Wait a moment for startup
    sleep 3
    
    echo "✅ Docker MCP Gateway started (PID: $MCP_PID)"
    echo "🔧 Available tools:"
    docker mcp tools list
    
    return 0
}

# Function to stop MCP gateway
stop_mcp_gateway() {
    echo "Stopping Docker MCP Gateway..."
    pkill -f "docker mcp gateway"
    echo "✅ Gateway stopped"
}

# Function to show current MCP status
show_mcp_status() {
    echo "📊 Docker MCP Status:"
    echo "Enabled servers:"
    docker mcp server list
    echo ""
    echo "Available tools:"
    docker mcp tools list | wc -l | xargs echo "Total tools:"
}

# Function to configure Claude Desktop for MCP
configure_claude_desktop() {
    CLAUDE_CONFIG="$HOME/Library/Application Support/Claude/claude_desktop_config.json"
    
    echo "🔧 Configuring Claude Desktop for Docker MCP..."
    
    # Backup existing config
    if [ -f "$CLAUDE_CONFIG" ]; then
        cp "$CLAUDE_CONFIG" "$CLAUDE_CONFIG.backup.$(date +%Y%m%d_%H%M%S)"
        echo "📋 Backed up existing Claude config"
    fi
    
    # Create Claude Desktop config
    cat > "$CLAUDE_CONFIG" << 'EOF'
{
  "mcpServers": {
    "docker-mcp": {
      "command": "docker",
      "args": ["mcp", "gateway", "run"]
    }
  }
}
EOF
    
    echo "✅ Claude Desktop configured for Docker MCP"
    echo "📍 Config location: $CLAUDE_CONFIG"
}

# Main menu
case "${1:-menu}" in
    "start")
        start_mcp_gateway
        ;;
    "stop")
        stop_mcp_gateway
        ;;
    "status")
        show_mcp_status
        ;;
    "claude")
        configure_claude_desktop
        ;;
    "menu"|*)
        echo "🎯 Warp Terminal Docker MCP Integration"
        echo ""
        echo "Usage: $0 [command]"
        echo ""
        echo "Commands:"
        echo "  start   - Start Docker MCP Gateway"
        echo "  stop    - Stop Docker MCP Gateway"
        echo "  status  - Show current MCP status"
        echo "  claude  - Configure Claude Desktop"
        echo ""
        echo "Current status:"
        show_mcp_status
        ;;
esac