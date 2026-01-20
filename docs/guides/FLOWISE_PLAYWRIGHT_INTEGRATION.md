# Flowise & Playwright MCP Integration Guide

## 🎯 Overview

This guide provides a complete integration of:
1. **Flowise AI** - Low-code AI flow builder running in Docker
2. **Playwright MCP Server** - Browser automation for Claude Desktop
3. **Environment Variables** - Proper API key management

## 📋 Prerequisites

- Docker Desktop installed and running
- Node.js v18+ installed
- Claude Desktop application
- API keys for AI services (OpenAI, Anthropic, etc.)

## 🚀 Quick Start

### Step 1: Setup Flowise with API Keys

```bash
# Navigate to flowise-docker directory
cd flowise-docker

# The .env file has been updated with your API keys:
# - OPENAI_API_KEY
# - ANTHROPIC_API_KEY
# - GEMINI_API_KEY
# - PERPLEXITY_API_KEY

# Start Flowise container
./start-flowise.sh
```

**Access Flowise:**
- URL: http://localhost:3005
- Username: admin
- Password: AdminFlowise2024!

### Step 2: Install Playwright MCP Server

```bash
# Navigate to playwright-mcp directory
cd playwright-mcp

# Run the setup script
./setup-playwright-mcp.sh

# This will:
# - Install @mcp-servers/playwright
# - Install Playwright browsers
# - Create test examples
```

### Step 3: Integrate with Claude Desktop

```bash
# Run the integration script
./integrate-playwright-mcp.sh

# This will:
# - Backup your existing Claude config
# - Add Playwright MCP server to Claude Desktop
# - Enable browser automation in Claude
```

**Important:** Restart Claude Desktop after running the integration script.

### Step 4: Run the Demo

```bash
# Ensure Flowise is running first
cd flowise-docker && ./start-flowise.sh

# Run the interactive demo
cd ../playwright-mcp
node demo-playwright-mcp.js

# Or run the full test suite
node flowise-test-suite.js
```

## 🔧 Configuration Details

### Flowise Environment Variables

Located in `flowise-docker/.env`:

```env
# Authentication
FLOWISE_USERNAME=admin
FLOWISE_PASSWORD=AdminFlowise2024!

# AI API Keys (loaded from your ~/.api_keys)
OPENAI_API_KEY=your-key
ANTHROPIC_API_KEY=your-key
GEMINI_API_KEY=your-key
PERPLEXITY_API_KEY=your-key
```

### Claude Desktop MCP Configuration

Located in `~/Library/Application Support/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["-y", "@mcp-servers/playwright"],
      "env": {
        "HEADLESS": "false"
      }
    }
  }
}
```

## 🎭 Using Playwright MCP in Claude

Once integrated, you can use Playwright commands in Claude Desktop:

### Example Commands

1. **Navigate to a page:**
```javascript
await page.goto('http://localhost:3005')
```

2. **Fill forms:**
```javascript
await page.fill('input[type="text"]', 'admin')
await page.fill('input[type="password"]', 'AdminFlowise2024!')
```

3. **Click elements:**
```javascript
await page.click('button[type="submit"]')
```

4. **Take screenshots:**
```javascript
await page.screenshot({ path: 'screenshot.png' })
```

5. **Extract data:**
```javascript
const title = await page.title()
const buttons = await page.locator('button').count()
```

## 📊 Test Suite Features

The `flowise-test-suite.js` provides:

- ✅ Automated login
- ✅ Chatflow creation testing
- ✅ Node drag-and-drop testing
- ✅ API key configuration verification
- ✅ Screenshot capture
- ✅ Video recording
- ✅ Performance metrics
- ✅ Network monitoring

## 🐛 Troubleshooting

### Issue: Docker not found
**Solution:** Install Docker Desktop from https://www.docker.com/products/docker-desktop

### Issue: Flowise not accessible
**Solution:** 
1. Check Docker is running: `docker ps`
2. Check logs: `docker-compose logs flowise`
3. Verify port 3005 is not in use: `lsof -i :3005`

### Issue: Playwright MCP not showing in Claude
**Solution:**
1. Ensure Claude Desktop is completely quit (Cmd+Q)
2. Verify config file is updated
3. Restart Claude Desktop
4. Check MCP servers list in Claude

### Issue: API keys not working
**Solution:**
1. Verify keys in `flowise-docker/.env`
2. Restart Flowise: `docker-compose restart`
3. Check logs: `docker-compose logs flowise`

## 📁 Project Structure

```
mbp-workspace/
├── flowise-docker/
│   ├── .env                    # API keys and configuration
│   ├── docker-compose.yml      # Docker configuration
│   ├── start-flowise.sh        # Startup script
│   └── flowise_data/           # Persistent data
│
├── playwright-mcp/
│   ├── setup-playwright-mcp.sh      # Installation script
│   ├── integrate-playwright-mcp.sh  # Claude integration
│   ├── demo-playwright-mcp.js       # Interactive demo
│   ├── flowise-test-suite.js        # Comprehensive tests
│   ├── test-flowise.js              # Simple test example
│   └── claude-desktop-config-update.json  # Claude config
│
└── FLOWISE_PLAYWRIGHT_INTEGRATION.md  # This file
```

## 🔍 Monitoring & Logs

### View Flowise logs:
```bash
docker-compose logs -f flowise
```

### View test videos:
```bash
ls -la playwright-mcp/test-videos/
```

### View network traces:
```bash
cat playwright-mcp/network-trace.har | jq
```

## 🚦 Next Steps

1. **Create custom chatflows** in Flowise UI
2. **Write Playwright tests** for your specific workflows
3. **Integrate with CI/CD** for automated testing
4. **Use Claude Desktop** to generate test scripts with Playwright MCP

## 📚 Resources

- [Flowise Documentation](https://docs.flowiseai.com)
- [Playwright Documentation](https://playwright.dev)
- [MCP Protocol Specification](https://modelcontextprotocol.io)
- [Claude Desktop Guide](https://claude.ai/desktop)

## 🤝 Support

For issues or questions:
1. Check the troubleshooting section above
2. Review logs in `docker-compose logs`
3. Verify all services are running correctly
4. Ensure API keys are properly configured

---

**Last Updated:** September 2024
**Version:** 1.0.0