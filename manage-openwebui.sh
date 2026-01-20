#!/bin/bash

# Script to manage Open WebUI container with proper naming and port mapping

ACTION=${1:-status}

case $ACTION in
    start)
        echo "🚀 Starting Open WebUI..."
        
        # Check if container exists
        if docker ps -a | grep -q "open-webui"; then
            echo "Container 'open-webui' exists. Starting it..."
            docker start open-webui
        else
            echo "Creating new container 'open-webui'..."
            docker run -d \
                --name open-webui \
                -p 3002:8080 \
                -v open-webui-fresh:/app/backend/data \
                --restart always \
                ghcr.io/open-webui/open-webui:main
        fi
        
        sleep 3
        docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E "(NAMES|open-webui)"
        echo "✅ Open WebUI is available at: http://localhost:3002"
        ;;
        
    stop)
        echo "⏹️ Stopping Open WebUI..."
        docker stop open-webui
        ;;
        
    restart)
        echo "🔄 Restarting Open WebUI..."
        docker restart open-webui
        sleep 3
        docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E "(NAMES|open-webui)"
        ;;
        
    remove)
        echo "🗑️ Removing Open WebUI container (data will be preserved)..."
        docker stop open-webui 2>/dev/null
        docker rm open-webui
        echo "Container removed. Run './manage-openwebui.sh start' to create a new one."
        ;;
        
    update)
        echo "📥 Updating Open WebUI to latest version..."
        docker stop open-webui
        docker rm open-webui
        docker pull ghcr.io/open-webui/open-webui:main
        docker run -d \
            --name open-webui \
            -p 3002:8080 \
            -v open-webui-fresh:/app/backend/data \
            --restart always \
            ghcr.io/open-webui/open-webui:main
        echo "✅ Update complete!"
        ;;
        
    logs)
        echo "📜 Showing Open WebUI logs (press Ctrl+C to exit)..."
        docker logs -f open-webui
        ;;
        
    status)
        echo "📊 Open WebUI Status:"
        docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E "(NAMES|open-webui)"
        echo ""
        echo "🔍 Container Details:"
        docker inspect open-webui --format='Name: {{.Name}}
State: {{.State.Status}}
Started: {{.State.StartedAt}}
Restart Policy: {{.HostConfig.RestartPolicy.Name}}
Port Mapping: {{range $p, $conf := .NetworkSettings.Ports}}{{$p}} -> {{(index $conf 0).HostPort}} {{end}}
Volume: {{range .Mounts}}{{.Source}} -> {{.Destination}}{{end}}'
        ;;
        
    *)
        echo "Usage: $0 {start|stop|restart|remove|update|logs|status}"
        echo ""
        echo "Commands:"
        echo "  start   - Start Open WebUI container"
        echo "  stop    - Stop Open WebUI container"
        echo "  restart - Restart Open WebUI container"
        echo "  remove  - Remove container (preserves data)"
        echo "  update  - Update to latest version"
        echo "  logs    - Show container logs"
        echo "  status  - Show container status (default)"
        exit 1
        ;;
esac