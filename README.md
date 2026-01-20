# 💻 MBP Workspace - AI Development Ecosystem

Centralized workspace for all AI development projects and tools.

## 📁 **Project Structure**

```
mbp-workspace/
├── github-mcp-server/          # GitHub MCP Server & AI integrations
├── openmemory/                 # OpenMemory system
├── memory-bank-mcp/            # Memory Bank MCP server
├── mcp-knowledge-graph/        # Knowledge graph MCP
├── mcp-obsidian/              # Obsidian MCP integration
├── context7/                   # Context management
├── phoenix/                    # Phoenix AI observability docs
├── ollama/                     # Ollama integration docs
└── logs/                       # Centralized logging
```

## 🚀 **Active Services**

| Service | Port | Status | URL |
|---------|------|--------|-----|
| **OpenMemory API** | 8765 | ✅ Running | http://localhost:8765 |
| **OpenMemory UI** | 3000 | ✅ Running | http://localhost:3000 |
| **Phoenix AI** | 6006 | ✅ Running | http://localhost:6006 |
| **Open WebUI** | 3002 | ✅ Running | http://localhost:3002 |
| **Ollama** | 11434 | ✅ Running | http://localhost:11434 |

## 🤖 **AI Tools Integration**

### **Local AI**
- **Ollama**: 5 models (llama3.2, gemma3, nikolas-tesla, llama2, longwriter-glm4)
- **Open WebUI**: Web interface for local models

### **Cloud AI**
- **OpenAI**: GPT-4, GPT-3.5 integration
- **Anthropic**: Claude integration
- **Perplexity**: Research capabilities

### **Memory Systems**
- **OpenMemory**: 16 memories stored
- **Memory Bank**: Additional memory system

### **Development Tools**
- **GitHub MCP Server**: Repository and issue management
- **Windsurf**: IDE with MCP integration
- **TypingMind**: AI workflow automation
- **BoltAI**: Menu bar AI assistance

### **Observability**
- **Phoenix**: AI monitoring and tracing
- **Logging**: Centralized log management

## 🔗 **MCP Integrations**

### **Windsurf Configuration**
- GitHub MCP Server (custom)
- OpenMemory integration
- Perplexity research
- Sequential thinking
- Local memory systems

### **Claude Desktop**
- GitHub MCP Server
- Memory systems
- File operations

## 📊 **Current Status**

- ✅ **All services migrated** to mbp-workspace
- ✅ **Configurations updated** for new paths
- ✅ **OpenMemory running** with 16 memories
- ✅ **Phoenix monitoring** active
- ✅ **Windsurf integration** updated
- ✅ **All APIs functional**

## 🎯 **Quick Access**

### **Web Interfaces**
- **OpenMemory Dashboard**: http://localhost:3000
- **Phoenix AI Monitoring**: http://localhost:6006
- **Open WebUI (Ollama)**: http://localhost:3002

### **Documentation**
- **GitHub MCP Server**: `github-mcp-server/README.md`
- **Phoenix Setup**: `phoenix/PHOENIX_SETUP.md`
- **Ollama Integration**: `ollama/OLLAMA_INTEGRATIONS.md`

## 🛠️ **Development Commands**

### **Start Services**
```bash
# OpenMemory
cd mbp-workspace/openmemory/openmemory && docker-compose up -d

# GitHub MCP Server (if needed standalone)
cd mbp-workspace/github-mcp-server && npm start
```

### **Check Status**
```bash
# All containers
docker ps

# OpenMemory API
curl http://localhost:8765/api/v1/stats/?user_id=danielthompson
```

---

## 🎉 **Workspace Ready!**

Your centralized AI development workspace is fully operational with all services migrated and configurations updated.

*Last Updated: June 29, 2025*
