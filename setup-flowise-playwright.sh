#!/bin/bash

# Master Setup Script for Flowise + Playwright MCP Integration
# This script orchestrates the complete setup process

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "🚀 FLOWISE + PLAYWRIGHT MCP INTEGRATION SETUP"
echo "============================================="
echo ""

# Function to check prerequisites
check_prerequisites() {
    echo "📋 Checking prerequisites..."
    
    # Check Docker
    if command -v docker &> /dev/null; then
        echo "✅ Docker is installed"
    else
        echo "❌ Docker is not installed. Please install Docker Desktop first."
        echo "   Download from: https://www.docker.com/products/docker-desktop"
        exit 1
    fi
    
    # Check Node.js
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node -v)
        echo "✅ Node.js is installed ($NODE_VERSION)"
    else
        echo "❌ Node.js is not installed. Please install Node.js v18 or later."
        echo "   Download from: https://nodejs.org"
        exit 1
    fi
    
    # Check npm
    if command -v npm &> /dev/null; then
        NPM_VERSION=$(npm -v)
        echo "✅ npm is installed (v$NPM_VERSION)"
    else
        echo "❌ npm is not installed."
        exit 1
    fi
    
    echo ""
}

# Function to setup Flowise
setup_flowise() {
    echo "🐳 Setting up Flowise..."
    
    # Check if .env file has API keys
    if [ -f "flowise-docker/.env" ]; then
        if grep -q "OPENAI_API_KEY=sk-" flowise-docker/.env; then
            echo "✅ API keys are configured in .env"
        else
            echo "⚠️  API keys may not be configured in flowise-docker/.env"
            echo "   Please check the file and add your API keys if needed."
        fi
    else
        echo "❌ flowise-docker/.env file not found"
        exit 1
    fi
    
    # Make start script executable
    chmod +x flowise-docker/start-flowise.sh
    echo "✅ Flowise setup complete"
    echo ""
}

# Function to setup Playwright MCP
setup_playwright_mcp() {
    echo "🎭 Setting up Playwright MCP Server..."
    
    # Make scripts executable
    chmod +x playwright-mcp/setup-playwright-mcp.sh
    chmod +x playwright-mcp/integrate-playwright-mcp.sh
    
    # Change to playwright-mcp directory
    cd playwright-mcp
    
    # Run setup
    ./setup-playwright-mcp.sh
    
    cd ..
    echo "✅ Playwright MCP setup complete"
    echo ""
}

# Function to integrate with Claude Desktop
integrate_claude_desktop() {
    echo "🤖 Integrating with Claude Desktop..."
    
    read -p "Do you want to integrate Playwright MCP with Claude Desktop? (y/n): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cd playwright-mcp
        ./integrate-playwright-mcp.sh
        cd ..
        echo "✅ Claude Desktop integration complete"
        echo "⚠️  Please restart Claude Desktop for changes to take effect"
    else
        echo "ℹ️  Skipping Claude Desktop integration"
    fi
    
    echo ""
}

# Function to start services
start_services() {
    echo "🚀 Starting services..."
    
    read -p "Do you want to start Flowise now? (y/n): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Starting Flowise..."
        cd flowise-docker
        ./start-flowise.sh
        cd ..
    else
        echo "ℹ️  You can start Flowise later with: ./flowise-docker/start-flowise.sh"
    fi
    
    echo ""
}

# Function to run demo
run_demo() {
    read -p "Do you want to run the Playwright demo? (y/n): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🎬 Running Playwright demo..."
        cd playwright-mcp
        node demo-playwright-mcp.js
        cd ..
    else
        echo "ℹ️  You can run the demo later with:"
        echo "    cd playwright-mcp && node demo-playwright-mcp.js"
    fi
    
    echo ""
}

# Main execution
main() {
    check_prerequisites
    setup_flowise
    setup_playwright_mcp
    integrate_claude_desktop
    start_services
    run_demo
    
    echo "✨ SETUP COMPLETE!"
    echo "=================="
    echo ""
    echo "📚 Quick Reference:"
    echo "  - Flowise URL: http://localhost:3005"
    echo "  - Username: admin"
    echo "  - Password: AdminFlowise2024!"
    echo ""
    echo "📁 Key Files:"
    echo "  - Start Flowise: ./flowise-docker/start-flowise.sh"
    echo "  - Run Demo: cd playwright-mcp && node demo-playwright-mcp.js"
    echo "  - Run Tests: cd playwright-mcp && node flowise-test-suite.js"
    echo "  - Documentation: FLOWISE_PLAYWRIGHT_INTEGRATION.md"
    echo ""
    echo "🎯 Next Steps:"
    echo "  1. Restart Claude Desktop if you integrated it"
    echo "  2. Access Flowise at http://localhost:3005"
    echo "  3. Create your AI workflows"
    echo "  4. Use Playwright MCP to automate testing"
    echo ""
    echo "Happy automating! 🚀"
}

# Run main function
main